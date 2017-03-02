//
//  WebsocketMessageUIDelegate.swift
//  PageShare
//
//  Created by Q.S Wang on 28/06/2016.
//  Copyright © 2016 Oneplus Smartware. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@objc enum VIDEOCMD : Int{
    case none
    case video
    case openvideo
};

class WebsocketMessageUIDelegate: NSObject,OPAudioMangerToolDelegate {
    var bounds:CGRect?
    var drawer:ViewDrawer?
    var timer:Timer?
    
    var audioTool: OPAudioMangerTool?
    var urlAudioArray:[String]?
    
    var view:UIViewController
    var videoCmd=VIDEOCMD.none
    fileprivate var videoPath:String?
    var opvideovc:OPVideoVC?
    
    var roomState = ROOMSTATE.attendee
    
    var isLoadAudioMeeting = false
    var isLoadVideoMeeting = false
    var lastAudioMeetingId:String?
    
    init(view:UIViewController,roomState:ROOMSTATE,forceQuit:Bool) {
        self.view = view
        self.roomState=roomState
        
        super.init()
    }
    
    func cleanup()  {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.WEBSOCKET_ONMESSAGE), object: nil)
        
       
    
        stopSound()
        if timer != nil {
            //stop timer
            timer!.invalidate()
        }
    }

    
    func handleMessage(_ text:String){
        if let data = text.data(using: String.Encoding.utf8, allowLossyConversion: false){
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON
                
                self.handleMessageWithJson(jsonData)
            } catch {
                //                    log.debug("Failed to handle the message \(text) with Error: \(error)")
            }
        }
        
    }
    
    func handleMessageWithJson(_ jsonData: JSON?){
        do {
            if jsonData==nil {
                return
            }
           
            let cmd : String?  = Decoder.decode(key: "cmd")(jsonData!)
            
            switch cmd! {
            case "image":
                showImage(jsonData!)
            case "text":
                showText(jsonData!)
            case "icon":
                showIcon(jsonData!)
            case "path":
                showPath(jsonData!)
            case "erase":
                erase(jsonData!)
            case "voice":
                try playLocalAudio(jsonData!)
            //try playSound(jsonData!);
            case "urlvoice":
                playUrlAudio(jsonData!)
            //playURLSound(jsonData!);
            case "video":
                playVideo(jsonData!,cmd: "video")
            case "openvideo":
                playVideo(jsonData!,cmd: "openvideo")
            case "urlvideo":
                playUrlVideo(jsonData!)
                //                case "exit":
                //                    let message = "发起者已经退出，关闭共享。"
            //                    showErrorDialog("Error", message: message)
            case "Error":
                showInternationalizationErrorDialog("net.pictoshare.pageshare.dailog.message.error", messageFlag: "net.pictoshare.pageshare.websocketmessage.connect.server.error.text")
            default:
                break
            }
            
        } catch {
            //                    log.debug("Failed to handle the message \(text) with Error: \(error)")
        }
    }
    
    //        //TODO:this func hasn't been tested, and is not called at all. More debug will be needed.
    //        func centerScrollViewContents() {
    //            let boundSize = scrollView!.bounds.size
    //            var contentsFrame = pageView!.frame
    //
    //            if contentsFrame.size.width < boundSize.width {
    //                contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2.0
    //            } else {
    //                contentsFrame.origin.x = 0.0
    //            }
    //
    //            if contentsFrame.size.height < boundSize.height {
    //                contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2.0
    //            } else {
    //                contentsFrame.origin.y = 0.0
    //            }
    //
    //            pageView!.frame = contentsFrame
    //        }
    
    
    //        func scrollViewDidZoom(scrollView: UIScrollView) {
    //
    ////            if(scrollView.zoomScale < scrollView.minimumZoomScale){
    ////                scrollView.zoomScale = scrollView.minimumZoomScale
    ////            }
    ////            centerScrollViewContents()
    //        }
    
    
    func playUrlVideo(_ jsonData:JSON) {
        let urlVideo:String = Decoder.decode(key: "url")(jsonData)!
        if urlVideo == "" {
            return
        }
        if opvideovc != nil {
            opvideovc?.dismiss()
        }
        
        opvideovc=OPMediaManger.getViewByVideoPath(urlVideo)
        
        view.present(opvideovc!, animated: true, completion: nil)
        
    }
    
    
    func playVideo(_ jsonData:JSON,cmd:String) {
        
        let videoStr:String = Decoder.decode(key: "video")(jsonData)!
        let fgr=FileManager()
        let filemgr=Foundation.FileManager.default
        let data  = Data(base64Encoded: videoStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        if data == nil {
            return
        }
        
        _ = fgr.createReceivedVideoDir()
        
        if cmd == "openvideo" {
            videoCmd = .openvideo
            if videoPath == nil {
                videoPath=fgr.getReceivedVideoSavePath()
                _ = filemgr.createFile(atPath: videoPath!,contents: nil, attributes: nil)
            }
            
            let out=OutputStream.init(toFileAtPath: videoPath!, append: true)
            out!.open()
            let content=(data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count)
            out!.write(content, maxLength: data!.count)
            out!.close()
        }
        if cmd == "video" {
            if videoCmd == .none {
                //video一次性接收完
                videoPath=fgr.getReceivedVideoSavePath()
                _ = filemgr.createFile(atPath: videoPath!,contents: nil, attributes: nil)
            }
            
            let out=OutputStream.init(toFileAtPath: videoPath!, append: true)
            out!.open()
            let content=(data! as NSData).bytes.bindMemory(to: UInt8.self, capacity: data!.count)
            out!.write(content, maxLength: data!.count)
            out!.close()
            videoCmd = .none
            
            if opvideovc != nil {
                opvideovc?.dismiss()
            }
            opvideovc=OPMediaManger.getViewByVideoPath(videoPath)
            videoPath=nil
            
            view.present(opvideovc!, animated: true, completion: nil)
        }
        
    }
    
    func playUrlAudio(_ jsonData:JSON){
        if audioTool == nil {
            audioTool=OPAudioMangerTool()
            audioTool?.delegate=self
            urlAudioArray=[]
        }
        
        let url:String = Decoder.decode(key: "url")(jsonData)!
        if urlAudioArray!.isEmpty {
            audioTool?.play(bySource: NSMutableArray(array: [url]))
        }

        urlAudioArray?.append(url)
    }
    
    func playLocalAudio(_ jsonData:JSON)throws{
        let voiceStr:String = Decoder.decode(key: "voice")(jsonData)!
        let data  = Data(base64Encoded: voiceStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        if data == nil {
            return
        }
        
        let path=FileManager().getReceivedVoiceSavePath()
        
        try data!.write(to: URL(fileURLWithPath: path), options: [])
        
        
        if audioTool != nil {
            audioTool?.stop()
        }else{
            audioTool=OPAudioMangerTool()
            audioTool?.delegate=self
        }
        
        audioTool?.play(bySource: NSMutableArray(array: [path]))
    }
    
    func erase (_ jsonData:JSON){
        let model = Polyline(json: jsonData)
        
        if model?.paths != nil && model?.paths.count>0{
            drawer!.erase(model!)
        }
    }
    
    func showPath(_ jsonData:JSON){
        let model = Polyline(json: jsonData)
        
        if model?.paths != nil && model?.paths.count>0{
            drawer!.showPath(model!)
        }
    }
    
    func showIcon(_ jsonData:JSON){
        drawer!.showIcon(jsonData)
    }
    
    func showText(_ jsonData:JSON){
        drawer!.showText(jsonData,roomState: roomState)
    }
    
    func showImage(_ jsonData:JSON){
        if(roomState == .attendee){
            if audioTool != nil {
                audioTool?.stop()
                urlAudioArray?.removeAll()
            }
            drawer!.showBlanckImage()
            drawer!.drawImage(jsonData)
        }
    }
    
    
    func initBackGround()  {
        let welcome = UIImage(named: "welcome.png")
        drawer!.drawBackGroundImage(welcome!)
    }
    
    func showInternationalizationErrorDialog(_ titleFlag:String,messageFlag:String){
        let title = NSLocalizedString(titleFlag, comment: "")
        let msg = NSLocalizedString(messageFlag, comment: "")
        
        showErrorDialog(title, message: msg)
    }
    
    func  showErrorDialog(_ title:String,message:String)  {
        let alertDialog = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let title = "ok"
        alertDialog.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
            self.cleanup()
          
        }))
        view.present(alertDialog, animated: true, completion: nil)
        
    }
    
    
    func playEnd(){
        
        if urlAudioArray != nil {
            if urlAudioArray?.count>1 {
                let url = urlAudioArray![1]
                urlAudioArray?.remove(at: 0)
                audioTool?.play(bySource: NSMutableArray(array: [url]))
            } else {
                urlAudioArray?.removeAll()
            }
        }

    }

    func stopSound()  {
        audioTool?.stop()
        urlAudioArray?.removeAll()

    }
}
