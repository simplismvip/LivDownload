//
//  Sicon.swift
//  PageShare
//
//  Created by cheny on 2016/10/13.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  Sicon : Glossy{
    let ext:SiconExt?
    let x:Double
    let y:Double
    let x2:Double
    let y2:Double
    let width: Float
    let height: Float
    let icon:String
    let rid:Int
    
    init?(json: JSON) {
        self.ext = "ext" <~~ json
        self.x = ("x" <~~ json)!
        self.y = ("y" <~~ json)!
        self.x2 = ("x2" <~~ json)!
        self.y2 = ("y2" <~~ json)!
        self.width = ("width" <~~ json)!
        self.height = ("height" <~~ json)!
        self.rid = ("rid" <~~ json)!
        self.icon = ("icon" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ext" ~~> self.ext,
            "x"  ~~> self.x,
            "y"  ~~> self.y,
            "x2"  ~~> self.x2,
            "y2"  ~~> self.y2,
            "width"  ~~> self.width,
            "height"  ~~> self.height,
            "rid"  ~~> self.rid,
            "icon"  ~~> self.icon
            ]);
    }
}
