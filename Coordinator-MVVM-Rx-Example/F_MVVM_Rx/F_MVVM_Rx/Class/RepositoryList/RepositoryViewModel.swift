//
//  RepositoryViewModel.swift
//  F_MVVM_Rx
//
//  Created by Fisland_Z on 2017/9/15.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import Foundation

class RepositoryViewModel{
    let name : String
    let description : String
    let starsCountText : String
    let url : URL
    
    init(repository : Repository) {
        self.name = repository.fullName
        self.description = repository.description
        self.starsCountText = "⭐️ \(repository.starsCount)"
        self.url = URL(string: repository.url)!
    }
}
