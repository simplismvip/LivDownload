//
//  Properties.swift
//  PageShare
//
//  Created by cheny on 16/6/12.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  Properties : Glossy{
    var weight:Float
    let color:Int
    let width: Float
    let height: Float
    
    init?(weight: Float,color:Int,width: Float,height: Float){
        self.weight=weight
        self.color=color
        self.width=width
        self.height=height
    }
    
    init?(json: JSON) {
        self.width = ("width" <~~ json)!
        self.height = ("height" <~~ json)!
        self.color = ("color" <~~ json)!
        self.weight = ("weight" <~~ json)!
        
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "weight" ~~> self.weight,
            "color"  ~~> self.color,
            "width"  ~~> self.width,
            "height"  ~~> self.height
            ]);
    }
}
