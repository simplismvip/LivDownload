//
//  File.swift
//  PageShare
//
//  Created by Q.S Wang on 28/02/2016.
//  Copyright © 2016 OnePlus All rights reserved.
//

import Foundation


struct  Polyline : Glossy{
    
    //TODO: determine the optional factor of the properties.
   
    var properties: Properties
    let cmd: String!
    let paths: [Path]!

    init(properties: Properties,cmd: String,paths: [Path]) {
        self.properties = properties
        self.paths = paths
        self.cmd=cmd
    }
    init?(json: JSON) {
        self.properties = ("properties" <~~ json)!
        self.paths = "paths" <~~ json
        self.cmd = "cmd" <~~ json
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "properties" ~~> self.properties,
            "cmd"  ~~> self.cmd,
            "paths"  ~~> self.paths
            //Encoder.encodeArray("paths")(self.paths)
            ]);
    }
    
}
