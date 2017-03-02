//
//  File.swift
//  PageShare
//
//  Created by Q.S Wang on 28/02/2016.
//  Copyright © 2016 OnePlus All rights reserved.
//


import Foundation

struct  Path : Glossy{
    
    let path:[Point]
    //  let paths: [Point]?
    init?(path:[Point]) {
        self.path =  path
    }
    init?(json: JSON) {
        self.path =  ("path" <~~ json)!
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "path" ~~> self.path
           // Encoder.encodeArray("path")(self.path)
        ]);
    }
    
}