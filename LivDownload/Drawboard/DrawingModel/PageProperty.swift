//
//  PageProperty.swift
//  PageShare
//
//  Created by cheny on 16/6/30.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation

//存放画笔的颜色与宽度,以及阅读状态和是否隐藏画布
class PageProperty : NSObject {

    var penColor:UIColor=UIColor.red
    var penWidth:CGFloat=3
    var readState:READSTATE=READSTATE.edit
    var annotationHide = false
    
    override init() {
        super.init()
    }
    
    public func isReadStateShareEnabled()->Bool {
        return self.readState == READSTATE.shareing
    }
    
    public func isReadStateOnlyReadEnabled()->Bool {
        return self.readState == READSTATE.onlyread
    }
    
    public func isReadStateEditEnabled()->Bool {
        return self.readState == READSTATE.edit
    }
    
}
