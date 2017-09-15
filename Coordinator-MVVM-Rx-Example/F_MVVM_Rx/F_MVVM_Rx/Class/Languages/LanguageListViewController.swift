//
//  LanguageListViewController.swift
//  F_MVC-Rx
//
//  Created by Fisland_Z on 2017/9/14.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageListViewController: UIViewController {
    
    // MARK: - ===============  Property   =================
    let disposeBag = DisposeBag()
    var viewModel : LanguageViewModel!
    
    
    // MARK: - ===============  Outlet   =================
    @IBOutlet private weak var tableView: UITableView!
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    // MARK: - ===============  Life circle   ==============
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    // MARK: - ===============  Create UI   ================
    private func setupUI() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Choose a language"
        
        tableView.rowHeight = 48.0
    }

    private func setupBindings(){

        viewModel.languages
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "LanguageCell", cellType: UITableViewCell.self)){
            (_ , language, cell) in
            cell.textLabel?.text = language
            cell.selectionStyle = .none
        }
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: viewModel.cancel)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectLanguage)
            .disposed(by: disposeBag)

    }


}
