//
//  LivePlaybackReader.swift
//  PageShare
//
//  Created by cheny on 16/7/21.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
class LivePlaybackReader : NSObject {
    //    static let EXITKEY = "ThreadShouldExitNow"
    var lastTime:Double?
    var lineNo:Int = 0
    var exitNow = false
    
    var currentPageIndex: Int = 0
    var currentIndex: Int = 0
    var dict: Dictionary<String, [Dictionary<String, Any>]>?
    //是否开启自动回放所有页模式
    var exitAutoModel = false
    
    override init() {
        super.init()
    }
    
    init(_ filePath: String, isRemote: Bool) {
        super.init()
        if isRemote {
            return
        }
        createDictFromJsonFile(filePath)
    }
    
    func exit()  {
        exitNow = true
    }
    
    func start(){
        exitNow = false
    }
    
    func exitAuto()  {
        exitAutoModel = true
    }
    
    func startAuto(){
        exitAutoModel = false
    }
    
    func startPreviousPage(){
        self.currentPageIndex -= 1
        self.currentIndex = 0
    }
    
    func startNextPage(){
        self.currentPageIndex += 1
        self.currentIndex = 0
    }
    
    func clearPageHistory(){
        self.currentPageIndex = 0
        self.currentIndex = 0
    }
    
    func Dispatcher(_ postJson: @escaping () -> ())
    {
        DispatchQueue.main.async(execute: postJson)
    }
    
    //TODO: 新版本liv格式,读取JSON文件
    func createDictFromJsonFile(_ path:String) {
        if dict == nil  {
            do{
                let data=try? Data(contentsOf: URL(fileURLWithPath: path))
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String, [Dictionary<String, Any>]>
                dict = jsonData
            }catch {
                
            }

        }
     
    }
    
    func getPageCountFromLiveJSON() -> Int{
        if dict == nil {
            return 0
        }
        
        return dict!.count
    }
    
    //自动回放所有页
    func readAllPageFromLiveFile(_ livePath:String){
        if dict == nil {
            return
        }
        let count = dict?.count
        while !exitAutoModel && currentPageIndex<count! {
            readJsonAtPageNum(dict: dict!, success: {
                self.startNextPage()
            })
        }
        
    }
    
    //手动回放单页
    func readLiveFileWithPageNumber(_ livePath:String, success:@escaping ()-> Void){
        if dict == nil {
            return
        }
        
        readJsonAtPageNum(dict: dict!, success: success)
    }
    
    func readJsonAtPageNum(dict: Dictionary<String, [Dictionary<String, Any>]>, success:@escaping ()-> Void){
        
        if let jsonObjs:[Dictionary<String, Any>] = dict[String(currentPageIndex+1)] {
            let count = jsonObjs.count
            
            while !exitNow && currentIndex<count {
                let jsonItem = jsonObjs[currentIndex]
                
                if let json = jsonItem["data"] as? JSON {
                    let time = jsonItem["time"] as! Int
                    
                    Dispatcher({
//                        if XMPPConnectionManager.sharedInstance.muc?.isJoined == true {
//                            let msg = self.resolveJSONToString(jsonItem, jsonData: json)
//                            XMPPConnectionManager.sharedInstance.sendMessageToRoom(msg)
//                        }
                        self.postJSON(json)
                    })
                    
                    if self.currentIndex>0  && self.currentIndex<count-1 {
                        let timeInterval = self.getNewMilliSecondsFromLiveJSON(time)/1000
                        Thread.sleep(forTimeInterval: timeInterval)
                    }
                    
                    currentIndex = currentIndex + 1
                }else{
                    currentIndex = currentIndex + 1
                    continue
                }
  
            }
            
            DispatchQueue.main.async { void in
                success()
            }
            
        }
        
    }
    
    func readBackgroundImageAtPageNum(_ livePath:String){
        if dict == nil {
            return
        }
        
        if let jsonObjs:[Dictionary<String, Any>] = dict?[String(currentPageIndex+1)] {
            
            if let item: Dictionary<String, Any>? = jsonObjs[0] {
                if let json = item?["data"] as? JSON {
                    if let cmd : String?  = Decoder.decode(key: "cmd")(json) {
                        if(cmd == "image"){
                            self.postJSON(json)
                        }
                    }
                }
                
            }
         
        }
    }
    
   
    
    
    
    
 
    
    //TODO: 新版本liv格式,JSON
    func resolveJSONToString(_ jsonItem: JSON, jsonData: JSON) ->String {
        var message = ""
        let cmd : String?  = Decoder.decode(key: "cmd")(jsonData)
        
        switch cmd! {
        case "image":
            message = imageJSONToString(jsonItem, jsonData: jsonData)
        case "text":
            message = textJSONToString(jsonItem)
        case "icon":
            message = iconJSONToString(jsonItem)
        case "path":
            message = pathJSONToString(jsonItem, jsonData: jsonData)
        case "erase":
            message = eraserJSONToString(jsonItem, jsonData: jsonData)
        case "voice":
            message = voiceJSONToString(jsonItem, jsonData: jsonData)
        case "urlvoice":
            message = urlVoiceJSONToString(jsonItem)!
        case "video":
            message = videoJSONToString(jsonItem, jsonData: jsonData)
        case "openvideo":
            message = openvideoJSONToString(jsonItem, jsonData: jsonData)
        case "urlvideo":
            message = urlVideoJSONToString(jsonItem)!
            
        default:
            break
        }
        
        return message
    }
    
    func postJSON(_ json: JSON){
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.LIVEPLAYBACK_ONMESSAGE), object: json)
    }
    
    func imageJSONToString(_ jsonItem: JSON, jsonData: JSON)->String{
        let head : String  = Decoder.decode(key: "head")(jsonItem)!
        let image : String  = Decoder.decode(key: "image")(jsonData)!
        let imageString = head + image
        
        return imageString
    }
    
    func pathJSONToString(_ jsonItem: JSON, jsonData: JSON)->String{
        return getMessageByPolylineJson(jsonData)
        
        
//        let head : String  = Decoder.decode(key: "head")(jsonItem)!
//        
//        let data : Data! = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
//        let message = Base64.encode(data)
//        let pathString = head + message
//        
//        return pathString
    }
    
    func eraserJSONToString(_ jsonItem: JSON, jsonData: JSON)->String{
        return pathJSONToString(jsonItem, jsonData: jsonData)
    }
    
    func textJSONToString(_ jsonItem: JSON)->String{
        let textString : String  = Decoder.decode(key: "head")(jsonItem)!
        
        return textString
    }
    
    func iconJSONToString(_ jsonItem: JSON)->String{
        let iconString : String  = Decoder.decode(key: "head")(jsonItem)!
        
        return iconString
    }
    
    func voiceJSONToString(_ jsonItem: JSON, jsonData: JSON)->String{
        let head : String  = Decoder.decode(key: "head")(jsonItem)!
        let voice : String  = Decoder.decode(key: "voice")(jsonData)!
        let voiceString = head + voice
        
        return voiceString
    }
    
    func urlVoiceJSONToString(_ jsonItem: JSON)->String?{
        let voiceString : String  = Decoder.decode(key: "head")(jsonItem)!

        return voiceString
    }
    
    func videoJSONToString(_ jsonItem: JSON, jsonData: JSON)->String{
        let head : String  = Decoder.decode(key: "head")(jsonItem)!
        let video : String  = Decoder.decode(key: "video")(jsonData)!
        let videoString = head + video
        
        return videoString
    }
    
    func openvideoJSONToString(_ jsonItem: JSON, jsonData: JSON)->String{
        return  videoJSONToString(jsonItem, jsonData: jsonData)
    }
    
    
    func urlVideoJSONToString(_ jsonItem: JSON)->String?{
        let videoString : String  = Decoder.decode(key: "head")(jsonItem)!
        
        return videoString
    }
    
    
    func trimWhitespace(_ text:String)->String{
        return text.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    
    //TODO: 新版本liv JSON格式获取时间戳
    func getNewMilliSecondsFromLiveJSON(_ text:Int)->Double{
        let number=Double(text)
        
        return number
    }
    
    func getTextAboutTime(_ text:String)->String{
        let startRange=text.range(of: "====")
        let result=trimWhitespace(text.substring(from: (startRange?.upperBound)!)).components(separatedBy: " ")
        
        let time=result[0]+" "+result[2]
        return time
    }
    
    
    func dateToNumber(_ time:String)->Double{
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat="YYYY/MM/dd HH:mm:ss"
        let inputDate=inputFormatter.date(from: time)
        let dateText=((inputDate?.timeIntervalSince1970)!*1000).description
        
        return Double(dateText)!
    }
    
    func iconImageToBase64(_ index:Int32)->String?{
        let imageName = PageShareBridgingUtils.getEmojiName(index)
        let image = UIImage(named: imageName!)
        
        guard let imageData = UIImageJPEGRepresentation(image!,0.8) else {
            return nil
        }
        
        //根据二进制编码得到对应的base64字符串
        let base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
        return base64String
    }
    
    func getMessageByPolylineJson(_ jsonobj: JSON?)->String{
        let line=Polyline(json: jsonobj!)
        let properties = line!.properties
        
        if (JSONSerialization.isValidJSONObject(jsonobj!)) {
            //利用OC的json库转换成OC的NSData
            let data : Data! = try? JSONSerialization.data(withJSONObject: jsonobj!, options: [])
            
            //NSData转换成NSString
            // let  str = NSString(data:data, encoding: String.Encoding.utf8.rawValue)
            //官方这样也行
            let message = data.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
//            let message = Base64.encode(data)
            
            let result="!!##"+line!.cmd+"[\(properties.color),\(Int(properties.weight)),\(Int(properties.width)),\(Int(properties.height))]##!!\(message)"
            
            return result
            
        }
        return ""
    }
    
}
