//
//  Repository.swift
//  F_MVC-Rx
//
//  Created by Fisland_Z on 2017/9/14.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import Foundation

struct Repository {
    let fullName : String
    let description : String
    let starsCount : Int
    let url : String
}

extension Repository{
    init?(from json:[String:Any]) {
        guard
            let fullName = json["full_name"] as? String,
            let description = json["description"] as? String,
            let starsCount = json["stargazers_count"] as? Int,
            let url = json["html_url"] as? String
            else {return nil}
        
        self.init(fullName: fullName, description: description, starsCount: starsCount, url: url)
    }
}
