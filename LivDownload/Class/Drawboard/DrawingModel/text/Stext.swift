//
//  Stext.swift
//  PageShare
//
//  Created by cheny on 2016/10/13.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  Stext : Glossy{
    let ext:StextExt?
    let x:Float
    let y:Float
    let width: Float
    let height: Float
    let color:Int
    let text:String
    let line:Float
    
    init?(json: JSON) {
        self.ext = "ext" <~~ json
        self.x = ("x" <~~ json)!
        self.y = ("y" <~~ json)!
        self.width = ("width" <~~ json)!
        self.height = ("height" <~~ json)!
        self.color = ("color" <~~ json)!
        self.text = ("text" <~~ json)!
        self.line = ("line" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "ext" ~~> self.ext,
            "x"  ~~> self.x,
            "y"  ~~> self.y,
            "width"  ~~> self.width,
            "height"  ~~> self.height,
            "color"  ~~> self.color,
            "text"  ~~> self.text,
            "line"  ~~> self.line
            ]);
    }
}
