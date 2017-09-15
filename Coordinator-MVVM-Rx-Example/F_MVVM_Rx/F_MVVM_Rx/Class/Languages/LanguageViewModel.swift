//
//  LanguageViewModel.swift
//  F_MVVM_Rx
//
//  Created by Fisland_Z on 2017/9/15.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import RxSwift

class LanguageViewModel {
    let selectLanguage : AnyObserver<String>
    let cancel : AnyObserver<Void>

    let languages : Observable<[String]>
    let didSelectLanguage : Observable<String>
    let didCancel : Observable<Void>
    
    init(githubService : GithubService = GithubService()) {
        self.languages = githubService.getLanguageList()
        
        let _selectLanguage = PublishSubject<String>()
        self.selectLanguage = _selectLanguage.asObserver()
        self.didSelectLanguage = _selectLanguage.asObservable()
        
        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.didCancel = _cancel.asObservable()
    }
}
