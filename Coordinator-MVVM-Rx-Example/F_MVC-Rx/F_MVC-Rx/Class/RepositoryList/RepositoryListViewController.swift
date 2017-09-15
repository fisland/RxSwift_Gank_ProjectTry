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
    
    private let githubService = GithubService()
    
    private let disposeBag = DisposeBag()
    
    fileprivate var currentLanguage = BehaviorSubject(value: "Swift")

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
        let reload = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        
        let repositories = Observable.combineLatest(reload.startWith().debug(), currentLanguage.debug()) { (_ , language) -> String in
            return language
        }
        .debug()
        .flatMap{[unowned self] in
            self.githubService.getMostPopularRepositories(byLanguage: $0)
            .observeOn(MainScheduler.instance)
            .catchError{ error in
                self.presentAlert(message: error.localizedDescription)
                return .empty()
            }
        }
        .do(onNext:{[unowned self] _ in
            self.refreshControl.endRefreshing()
        })
        
        repositories.bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)){  [weak self] (_ , repo, cell) in
            self?.setupRepositoryCell(cell, repository: repo)
        }
        .disposed(by: disposeBag)
        
        currentLanguage.bind(to: navigationItem.rx.title).disposed(by: disposeBag)

        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: { [weak self] in
                self?.openRepository($0)
            })
            .disposed(by: disposeBag)
        
        
        chooseLanguageButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.openLanguageList() })
            .disposed(by: disposeBag)
    }
    
    private func setupRepositoryCell(_ cell: RepositoryCell, repository: Repository) {
        cell.selectionStyle = .none
        cell.setName(repository.fullName)
        cell.setDescription(repository.description)
        cell.setStarsCountTest("⭐️ \(repository.starsCount)")
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
    private func openRepository(_ repository: Repository) {
        let url = URL(string: repository.url)!
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
        let dismiss = Observable.merge([viewController.didCancel, viewController.didSelectLanguage.map{ _ in }])
        
        dismiss.subscribe(onNext: {[weak self] in self?.dismiss(animated: true, completion: nil)})
            .disposed(by: disposeBag)
        
        viewController.didSelectLanguage
            .bind(to: currentLanguage)
            .disposed(by: viewController.disposeBag)
    }

    


}
