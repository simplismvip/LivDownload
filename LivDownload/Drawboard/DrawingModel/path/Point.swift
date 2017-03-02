//
//  File.swift
//  PageShare
//
//  Created by Q.S Wang on 28/02/2016.
//  Copyright © 2016 OnePlus All rights reserved.
//

import Foundation

struct  Point : Glossy{
    
    //TODO: determine the optional factor of the properties.
    let x:Float
    let y:Float
    
    //  let paths: [[Point]]?
    init?(x:Float,y:Float) {
        self.x = x
        self.y = y
    }
    init?(point: CGPoint) {
        self.x = Float(point.x)
        self.y = Float(point.y)
    }
    init?(json: JSON) {
        self.x = ("x" <~~ json)!
        self.y = ("y" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "x" ~~> self.x,
            "y"  ~~> self.y
            ]);
    }
    
}