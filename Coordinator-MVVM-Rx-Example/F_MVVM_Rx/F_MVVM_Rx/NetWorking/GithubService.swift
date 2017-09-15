//
//  GithubService.swift
//  F_MVC-Rx
//
//  Created by Fisland_Z on 2017/9/14.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa

enum ServiceError :Error {
    case cannotParse
}

class GithubService {
    private let session : URLSession
    
    init(session : URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getLanguageList() -> Observable<[String]> {
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#",
            "JavaScript"
            ])
    }
    
    func getMostPopularRepositories(byLanguage language:String) -> Observable<[Repository]> {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
        
        return session.rx
            .json(url: url)
            .flatMap{ json throws -> Observable<[Repository]> in
                guard
                    let json = json as? [String:Any],
                    let itemJSON = json["items"] as? [[String:Any]]
                else { return Observable.error(ServiceError.cannotParse) }
                
                let repositories = itemJSON.flatMap(Repository.init)
                return Observable.just(repositories)
            }
    }
}
