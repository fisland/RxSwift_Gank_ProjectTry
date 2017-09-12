//
//  GViewModelType.swift
//  RXSwiftDemo
//
//  Created by Fisland_Z on 2017/9/11.
//  Copyright © 2017年 Zehuihong. All rights reserved.
//

import Foundation

protocol GViewModelType {
    associatedtype GWInput
    associatedtype GWOutput
    
    func transform(input: GWInput) -> GWOutput

}
