//
//  DrawingToolFactory.swift
//  PageShare
//
//  Created by cheny on 2016/11/8.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation

open class DrawingToolFactory:NSObject {
    
    static func createEraserButton()->UIButton {
        let eraserButton = UIButton(type: UIButtonType.custom)
        eraserButton.setImage(UIImage(named: "navbar_eraser_icon_black"), for: UIControlState.normal)
        eraserButton.setBackgroundImage(UIImage(named: "rw"), for: UIControlState.selected)
        eraserButton.setImage(UIImage(named: "navbar_eraser_icon_selected"), for: UIControlState.selected)
        
        eraserButton.sizeToFit()
        
        return eraserButton
    }
    
    static func createPlayButton()->UIButton {
        let playButton = UIButton(type: UIButtonType.custom)
     
        playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
        playButton.setBackgroundImage(UIImage(named: "self_pause"), for: UIControlState.selected)
        playButton.sizeToFit()
      
        
        return playButton
    }
    
    static func createBackButton()->UIButton {
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.setImage(UIImage(named: "navbar_prev_icon_black"), for: UIControlState.normal)
        backButton.sizeToFit()
   
        return backButton
    }
    
}
