//
//  Response+ObjectMapper.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

// MARK: - Json -> Model
extension Response{
    // 将Json解析为单个Model
    public func mapObject<T:BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    // 将Json解析为多个Model，数组返回
    public func mapArray<T:BaseMappable>(_ type: T.Type) throws -> [T] {
        guard let json = try mapJSON() as? [String:Any] else {
            throw MoyaError.jsonMapping(self)
        }
        
        guard let jsonArr = (json["results"] as? [[String:Any]]) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return Mapper<T>().mapArray(JSONArray: jsonArr)
    }

}


// MARK: - Json -> Observable<Model>
extension ObservableType where E == Response{
    public func mapObject<T:BaseMappable>(_ type: T.Type) -> Observable<T>{
        return flatMap{ response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
    
    public func mapArray<T:BaseMappable>(_ type: T.Type) -> Observable<[T]> {
        return flatMap{  response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self))
        }
    }

}
