//
//  GViewController.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxDataSources
import Then
import SnapKit
import Moya
import Kingfisher
import MJRefresh

class GViewController: UIViewController {

    let viewModel = GViewModel()
    let tableView = UITableView().then {
        $0.backgroundColor = UIColor.red
        $0.register(cellType: GViewCell.self)
        $0.rowHeight = GViewCell.cellHeigh()
    }

    let dataSource = RxTableViewSectionedReloadDataSource<GSection>()
    var vmOutPut : GViewModel.Output?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
        tableView.mj_header.beginRefreshing()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GViewController{
    fileprivate func setupUI(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(view.snp.top).offset(20)
        }
    }
    
    fileprivate func bindView() {
        dataSource.configureCell = { ds, table, indexPath, item in
            let cell = table.dequeueReusableCell(for: indexPath) as GViewCell
            
            cell.picView.kf.setImage(with: URL(string: item.url))
            cell.descLabel.text = "描述 : \(item.desc)"
            cell.sourceLabel.text = "来源 : \(item.source)"
            return cell
        }
        
        tableView.rx.setDelegate(self).addDisposableTo(rx_disposeBag)
        
        let vmInput = GViewModel.GInput(category: .welfare)
        let vmOutput = viewModel.transform(input: vmInput)
        
        vmOutput.sections.asDriver().drive(tableView.rx.items(dataSource:dataSource)).addDisposableTo(rx_disposeBag)

        
        vmOutput.refreshStatus.asObservable().subscribe(onNext: { [weak self] status in
            switch status {
            case .beingHeaderRefresh:
                self?.tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self?.tableView.mj_header.endRefreshing()
            case .beingFooterRefresh:
                self?.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).addDisposableTo(rx_disposeBag)
        
        tableView.mj_header = MJRefreshNormalHeader{
            vmOutput.requestCommond.onNext(true)
        }
        
        tableView.mj_footer = MJRefreshAutoFooter{
            vmOutput.requestCommond.onNext(false)
        }
    }
}

extension GViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
