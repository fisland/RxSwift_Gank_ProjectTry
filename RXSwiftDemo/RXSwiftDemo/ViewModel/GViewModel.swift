//
//  GViewModel.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

enum GRefreshStatus{
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class GViewModel: NSObject {
    // 存放着解析完成的模型数组
    let models = Variable<[GModel]>([])
    // 记录当前的索引值
    var index : Int = 1
}

extension GViewModel : GViewModelType{
    typealias Input = GInput
    typealias Output = GOutput
    
    struct GInput {
        let category : GNetworkTool.GNteworkCategory
        init(category : GNetworkTool.GNteworkCategory) {
            self.category = category
        }
    }
    
    struct GOutput {
        // tableView的sections数据
        let sections : Driver<[GSection]>
        // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
        let requestCommond = PublishSubject<Bool>()
        // 告诉外界的tableView当前的刷新状态
        let refreshStatus = Variable<GRefreshStatus>(.none)
        
        init(sections : Driver<[GSection]> ) {
            self.sections = sections
        }
    }
    
    
    func transform(input: GViewModel.GInput) -> GViewModel.GOutput {
        let section = models.asObservable().map { models -> [GSection] in
            return [GSection(items:models)]
        }.asDriver(onErrorJustReturn: [])
        
        let output = GOutput(sections: section)

        output.requestCommond.subscribe(onNext:{ [unowned self] isReloadData in
            self.index = isReloadData ? 1 : self.index + 1
            
            GNetTool.request(.data(type:input.category, size:10, index: self.index)).mapArray(GModel.self).subscribe({
            [weak self] (event) in
                switch event {
                case let .next(modelArray):
                    self?.models.value = isReloadData ? modelArray  : (self?.models.value ?? []) + modelArray
                    LXFProgressHUD.showSuccess("加载成功")
                case let .error(error):
                    LXFProgressHUD.showError(error.localizedDescription)
                case .completed:
                    output.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                }
            }).addDisposableTo(self.rx_disposeBag)
            
        }).addDisposableTo(rx_disposeBag)
        return output
    }
}
