//
//  SiconExt.swift
//  PageShare
//
//  Created by cheny on 2016/10/13.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  SiconExt : Glossy{
    let x1:Double
    let y1:Double
    let x2: Double
    let y2: Double
    let client:String
    
    init?(json: JSON) {
        self.x1 = ("x1" <~~ json)!
        self.y1 = ("y1" <~~ json)!
        self.x2 = ("x2" <~~ json)!
        self.y2 = ("y2" <~~ json)!
        self.client = ("client" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "x1" ~~> self.x1,
            "y1"  ~~> self.y1,
            "x2"  ~~> self.x2,
            "y2"  ~~> self.y2,
            "client"  ~~> self.client
            ]);
    }
}
