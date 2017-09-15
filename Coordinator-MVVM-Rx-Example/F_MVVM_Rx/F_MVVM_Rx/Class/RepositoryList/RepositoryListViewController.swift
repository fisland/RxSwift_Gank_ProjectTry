//
//  RepositoryListViewController.swift
//  F_MVC-Rx
//
//  Created by Fisland_Z on 2017/9/14.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices
class RepositoryListViewController: UIViewController {

    // MARK: - ===============  Property   =================
    private enum SegueType: String {
        case languageList = "Show Language List"
    }
    
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
    private let refreshControl = UIRefreshControl()
    
    private let disposeBag = DisposeBag()

    private let viewModel = RepositoryListViewModel(initialLanguage: "Swift")

    
    // MARK: - ===============  IBOutlet   =================
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - ===============  Life circle   ==============
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        refreshControl.sendActions(for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    // MARK: - ===============  Create UI   ================
    private func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refreshControl, at: 0)
    }

    
    // MARK: - ===============  Config Data   ==============
    private func setupBindings(){
        
        viewModel.repositories
            .observeOn(MainScheduler.instance)
            .do(onNext: {[weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)){  [weak self] (_ , repo, cell) in
            self?.setupRepositoryCell(cell, repository: repo)
        }
        .disposed(by: disposeBag)
        
        viewModel.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)

        viewModel.showRepository
            .subscribe(onNext: { [weak self] in
                self?.openRepository(by: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.showLanguageList
            .subscribe(onNext: { [weak self] in
                self?.openLanguageList()
            })
            .disposed(by: disposeBag)
        
        viewModel.alertMessage
            .subscribe(onNext:{[weak self] in
                self?.presentAlert(message: $0)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RepositoryViewModel.self)
            .bind(to: viewModel.selectRepository)
            .disposed(by: disposeBag)
        
        
        chooseLanguageButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.openLanguageList() })
            .disposed(by: disposeBag)
    }
    
    private func setupRepositoryCell(_ cell: RepositoryCell, repository: RepositoryViewModel) {
        cell.selectionStyle = .none
        cell.setName(repository.name)
        cell.setDescription(repository.description)
        cell.setStarsCountTest(repository.starsCountText)
    }
    // MARK: - ===============  Event handle   =============
    private func openLanguageList() {
        performSegue(withIdentifier: SegueType.languageList.rawValue, sender: self)
    }
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    // MARK: - ===============  Http request   =============
    
    // MARK: - =============== Table view data source  =====
    
    
    // MARK: - ===============  Navigation   ===============
    private func openRepository(by url:URL) {
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC: UIViewController? = segue.destination
        
        if let nvc = destinationVC as? UINavigationController {
            destinationVC = nvc.viewControllers.first
        }
        
        if let viewController = destinationVC as? LanguageListViewController, segue.identifier == SegueType.languageList.rawValue {
            prepareLanguageListViewController(viewController)
        }
    }

    private func prepareLanguageListViewController(_ viewController: LanguageListViewController) {
        
        let ListViewModel = LanguageViewModel()
        
        let dismiss = Observable.merge([ListViewModel.didCancel, ListViewModel.didSelectLanguage.map{ _ in }])
        
        dismiss.subscribe(onNext: {[weak self] in self?.dismiss(animated: true, completion: nil)})
            .disposed(by: disposeBag)
        
        ListViewModel.didSelectLanguage
            .bind(to: viewModel.setCurrentLanguage)
            .disposed(by: viewController.disposeBag)
        
        viewController.viewModel = ListViewModel

    }
}
