//
//  GModel.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import UIKit
import RxDataSources
import ObjectMapper
struct GModel:Mappable {
    var _id         = ""
    var createdAt   = ""
    var desc        = ""
    var publishedAt = ""
    var source      = ""
    var type        = ""
    var url         = ""
    var used        = ""
    var who         = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        _id         <- map["_id"]
        createdAt   <- map["createdAt"]
        desc        <- map["desc"]
        publishedAt <- map["publishedAt"]
        source      <- map["source"]
        type        <- map["type"]
        url         <- map["url"]
        used        <- map["used"]
        who         <- map["who"]
    }
}

/* ============================= SectionModel =============================== */
struct GSection {
    var  items : [Item]
}

extension GSection : SectionModelType{
    typealias Item = GModel
    
    init(original: GSection, items: [GSection.Item]) {
        self = original
        self.items = items
    }
}
