//
//  Icon.swift
//  PageShare
//
//  Created by cheny on 2016/10/13.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
struct  Icon : Glossy{
    let cmd:String!
    let sicon:Sicon!
    
    // {"sicon":{"ext":{"y1":85.0,"client":"ios","x1":70.0,"y2":85.0,"x2":70.0},"x":70.0,"width":320,"icon":"iVB","y":135.66565,"y2":137.0,"x2":175.0,"rid":105,"height":405},"cmd":"icon"}
    
    init?(json: JSON) {
        self.cmd = "cmd" <~~ json
        self.sicon = "sicon" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "cmd" ~~> self.cmd,
            "sicon"  ~~> self.sicon
            ]);
    }
}
