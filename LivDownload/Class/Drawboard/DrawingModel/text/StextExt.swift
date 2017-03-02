//
//  StextExt.swift
//  PageShare
//
//  Created by cheny on 2016/10/13.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  StextExt : Glossy{
    let x:Float
    let y:Float
    let client:String
    
    init?(json: JSON) {
        self.x = ("x" <~~ json)!
        self.y = ("y" <~~ json)!
        self.client = ("client" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "x" ~~> self.x,
            "y"  ~~> self.y,
            "client"  ~~> self.client
            ]);
    }
}
