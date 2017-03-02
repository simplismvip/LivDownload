//
//  LivePlaybackDelegate.swift
//  PageShare
//
//  Created by cheny on 16/7/22.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
class LivePlaybackDelegate: WebsocketMessageUIDelegate {
    
    func startLivePlaybackObserver(){
        removeLiveObserver()
        NotificationCenter.default.addObserver(self, selector : #selector(LivePlaybackDelegate.livePlayBackOnMessage(_:)) , name: NSNotification.Name(rawValue: Constants.LIVEPLAYBACK_ONMESSAGE), object: nil)

    }
    
    @objc func livePlayBackOnMessage(_ notification: Notification){
        if let json = notification.object as? JSON{
            handleMessageWithJson(json)
        }else if let text = notification.object as? String {
            handleMessage(text)
        }
    }
    
    func removeLiveObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.LIVEPLAYBACK_ONMESSAGE), object: nil)
    }
    
    override func initBackGround() {
        
    }
}
