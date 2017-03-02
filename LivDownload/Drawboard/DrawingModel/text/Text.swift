//
//  Text.swift
//  PageShare
//
//  Created by cheny on 2016/10/13.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  Text : Glossy{
    let cmd:String!
    let stext:Stext!
    
    // {"stext":{"ext":{"x":8.5,"client":"ios","y":146.5},"color":-65536,"line":3,"x":8.5,"width":320,"y":193.833,"text":"发红包","height":240},"cmd":"text"}
    
    init?(json: JSON) {
        self.cmd = "cmd" <~~ json
        self.stext = "stext" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "cmd" ~~> self.cmd,
            "stext"  ~~> self.stext
            ]);
    }
}
