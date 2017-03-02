//
//  FileManager.swift
//  PageShare
//
//  Created by Q.S Wang on 31/03/2016.
//  Copyright © 2016 Q.S Wang. All rights reserved.
//

import Foundation

open class FileManager: NSObject {
    func copyFile(_ fileToBeCopied:String, fileExtension:String , overwrite:Bool, docsDir:String) throws -> Bool
    {
        let destPath = (docsDir as NSString).appendingPathComponent( fileToBeCopied + "." + fileExtension)
        
        let fileMgr = Foundation.FileManager.default
        
        if fileMgr.fileExists(atPath: destPath) {
            if overwrite {
                try fileMgr.removeItem(atPath: destPath)
            }else{
                //TODO:
                return false
            }
        }
        
        if let path = Bundle.main.path(forResource: fileToBeCopied, ofType:fileExtension) {
            try fileMgr.copyItem(atPath: path, toPath: destPath)
        }
        
        return fileMgr.fileExists(atPath: destPath)
        
    }
    
    
    
    func filterAllLocalMusic(dirPath:String) -> [String] {
        let fileMgr = Foundation.FileManager.default
        var musicArr:[String] = []
        do{
            let contents = try fileMgr.contentsOfDirectory(atPath: dirPath)
            for fileName in contents {
                let vPrefix = fileName.hasPrefix("V_")
                let mp3 = fileName.hasSuffix(".mp3") || fileName.hasSuffix(".MP3")
                if vPrefix && mp3 {
                    musicArr.append(fileName)
                }
                
            }
        }catch{
            
        }
        
        return musicArr
    }
    
    //返回audio 路径是否是url
    func filterSingleUriAudioPath(_ urlVoice:String)->Bool{
        let http = urlVoice.hasPrefix("http://")
        let mp3 = urlVoice.hasSuffix(".mp3") || urlVoice.hasSuffix(".MP3")
        
        return http && mp3
    }
    
    //返回video 路径是否是url
    func filterSingleUrlVideoPath(_ urlVideo:String)->Bool{
        let http = urlVideo.hasPrefix("http://")
        let mp4 = urlVideo.hasSuffix(".mp4") || urlVideo.hasSuffix(".MP4")
        
        return http && mp4
    }
    

    
   
    
    func readMediaUrlFromUrlFile(_ urlPath:String)->String?{
        if let data=try? Data(contentsOf: URL(fileURLWithPath: urlPath)) {
            do{
                if let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON {
                    let urlValue : String?  = Decoder.decode(key: "url")(jsonData)
                    return urlValue?.trimmingCharacters(in: CharacterSet.whitespaces)
                }
            }catch{
                let path = String(data: data, encoding: String.Encoding.utf8)
                return path?.trimmingCharacters(in: CharacterSet.whitespaces)
            }
        
        }

        return nil
    }
    
    func writeMediaUrlToJson(_ url:String, delayTime: Int32, path:String) ->String? {
        let mediaJson = "{\"url\":\"\(url)\",\"time\":\(delayTime)}"
        let urlPath = path.appending(".uri")
        
        do{
            try mediaJson.write(toFile: urlPath, atomically: true, encoding: String.Encoding.utf8)
            return urlPath
        }catch {
            return nil
        }
        
    }

    func getPublicDocumentPath()->String{
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        let docsDir = dirPaths[0]+"/.*"
        
        let fileManager=Foundation.FileManager.default
        if !fileManager.fileExists(atPath: docsDir) {
            do{
                try fileManager.createDirectory(atPath: docsDir, withIntermediateDirectories: true, attributes: nil)
            }catch _ as NSError{
                
            }
        }
        
        return docsDir
    }
    
    
    
    func isSupportedDocument(_ filePath:String)->Bool {
        let lastComponent=NSString(string: filePath).lastPathComponent
        
        let apf = lastComponent.hasSuffix(".apf") || lastComponent.hasSuffix(".APF")
        
        let pdf = lastComponent.hasSuffix(".pdf") || lastComponent.hasSuffix(".PDF")
        
        let liv = lastComponent.hasSuffix(".liv") || lastComponent.hasSuffix(".LIV")
        
        let png = lastComponent.hasSuffix(".png") || lastComponent.hasSuffix(".PNG")
        
        let jpeg = lastComponent.hasSuffix(".jpeg") || lastComponent.hasSuffix(".JPEG")
        
        let bmp = lastComponent.hasSuffix(".bmp") || lastComponent.hasSuffix(".BMP")
        
        let jpg = lastComponent.hasSuffix(".jpg") || lastComponent.hasSuffix(".JPG")
        
        return apf || pdf || liv || png || jpeg || bmp || jpg
    }
    
    func isSupportDownloadLink(_ url:URL) -> Bool{
        let urlString = url.absoluteString
        if urlString.contains("action=share_download") || urlString.contains("action=books_download") || isSupportedDocument(urlString) {
            return true
        }
        
       return false
    }
    
    

   
    
    func getDocCoverAbsolutePath(_ coverSavePath: String) -> String{
         let name=NSString(string: coverSavePath).lastPathComponent.components(separatedBy: ".")[1]+".png"
         let filePath=coverSavePath + "/" + name
        
         return filePath
    }
    
    
    
    //TODO: PDF 在page停留计算的key
    static func getPDFPageTrackerName(_ documentPath:String,pageNum: Int)->String{
        let docName = NSString(string: documentPath).lastPathComponent
        return docName + "-\(pageNum)"
    }
    
   
    
    //计算单个文件大小
    func calculateFileSize(_ path:String)->Int64{
        let fileMgr = Foundation.FileManager.default
        var size:Int64=0
        do{
            let fileAttributes = try fileMgr.attributesOfItem(atPath: path)
            if fileAttributes.count == 0 {
                return 0
            } else {
                let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
                let fileSize = fileSizeNumber.int64Value
                size=fileSize
            }
        }catch{
            
        }
        return size
    }
    
    /**
     * 计算整个文件夹大小
     */
    func calculateFolderSize(_ folderPath:String)->Int64{
        let fileMgr = Foundation.FileManager.default
        
        let childFilesEnumerator = fileMgr.subpaths(atPath: folderPath)
        var folderSize: Int64 = 0
        
        if (childFilesEnumerator?.count) == 0 {
            return 0
        }
        
        for fileName in childFilesEnumerator! {
            
            let fileAbsolutePath = folderPath + "/" + fileName
            var isDir = ObjCBool(false)
            if(fileMgr.fileExists(atPath: fileAbsolutePath, isDirectory:&isDir)){
                if isDir.boolValue {
                    _ = calculateFolderSize(fileAbsolutePath)
                } else {
                    folderSize = folderSize + calculateFileSize(fileAbsolutePath)
                }
                
            }
            
            
        }
        return folderSize
    }
    
    //TODO:任意文件大小
    func getFileSize(_ folderPath:String)->Double{
        let fileMgr = Foundation.FileManager.default
        
        var folderSize: Int64 = 0
        var isDir = ObjCBool(false)
        if(fileMgr.fileExists(atPath: folderPath, isDirectory:&isDir)){
            if isDir.boolValue {
                folderSize=calculateFolderSize(folderPath)
            } else {
                folderSize=calculateFileSize(folderPath)
            }
            
        }else{
            return 0
        }
        
        return Double(folderSize) / 1024
    }
    
    
   
    
    func getTmpCachesSize()->Double{
        let array=getCachesPathInTmp()
        var fileSize:Double = 0
        for item in array {
            fileSize = fileSize + getFileSize(item)
        }
        return fileSize
        
    }
    
    
    
    func removeFile(filepath:String){
        do{
            try Foundation.FileManager.default.removeItem(atPath: filepath)
        }catch{
            
        }
    }
    
    func getCachesPathInTmp()->[String]{
        let fileMgr = Foundation.FileManager.default
        let tmp = getCachesPath();
        var array=[String]()
        do{
            let fileNames=try fileMgr.contentsOfDirectory(atPath: tmp)
            
            let newitems =  fileNames.filter { (inputElement) -> Bool in
                
                
                let soundFlag = (inputElement == "Soundtrack")
                let videoFlag = (inputElement == "Videotrack")
                let apf = inputElement.hasSuffix(".apf") || inputElement.hasSuffix(".APF")
                
                return soundFlag || videoFlag || apf
            }
            
            for item in newitems {
                array.append(tmp+"/"+item)
            }
            
        }catch _ as NSError{
            
        }
        return array
    }
    
    func clearAllCachesInTmp(){
        let fileMgr = Foundation.FileManager.default
        let array=getCachesPathInTmp()
        do{
            for item in array {
                try fileMgr.removeItem(atPath: item)
            }
        }catch{
            
        }
        
    }
    
  
    
    
    
    func createDirectory(_ dirPath:String)->Bool{
        let fileMgr = Foundation.FileManager.default
        if(!fileMgr.fileExists(atPath: dirPath)){
            do{
                try fileMgr.createDirectory(atPath: dirPath, withIntermediateDirectories: false, attributes: nil)
            }catch _ as NSError{
                return false
            }
        }
        return true
    }
    
  
    
    func getCachesPath() -> String {
        let cachePaths = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.cachesDirectory,Foundation.FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return cachePaths[0]
    }
    //TODO:room界面创建发送的音频目录路径
    func createSendedSoundDir()->String{
        let path = getCachesPath() + "/Soundtrack"
        let fileMgr = Foundation.FileManager.default
        if !fileMgr.fileExists(atPath: path) {
            try! fileMgr.createDirectory(atPath: path,withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
    //TODO: 这里是针对video/Voice的操作
    //共享状态下,在tmp目录下创建Videotrack目录,存放websocket接收的video
    func createReceivedVideoDir()->String{
        let videoTrack = getCachesPath() + "/Videotrack"
        //
        let fileMgr = Foundation.FileManager.default
        if !fileMgr.fileExists(atPath: videoTrack) {
            try! fileMgr.createDirectory(atPath: videoTrack,withIntermediateDirectories: false, attributes: nil)
        }
        return videoTrack
    }
    
    
    /*
     选择video添加到目录中,得到该目录当前video编号
     */
    func getVideoCountInDirectory(_ directory:String,pageNumber:Int)->Int?{
        let fileMgr=Foundation.FileManager.default
        var videoArray:[String]
        
        do{
            videoArray = try fileMgr.contentsOfDirectory(atPath: directory)
            let videoitems =  videoArray.filter { (inputElement) -> Bool in
                let prefixM = inputElement.hasPrefix("M_\(pageNumber)")
                
                let mp4 = inputElement.hasSuffix(".mp4") || inputElement.hasSuffix(".MP4")
                let uri = inputElement.hasSuffix(".uri")
                
                let threegp = inputElement.hasSuffix(".3gp")
                let mov = inputElement.hasSuffix(".mov")
                let mpv = inputElement.hasSuffix(".mpv")
                return prefixM && (mp4 || uri || threegp || mov || mpv)
            }
            
            var indexs=[Int]()
            for item in videoitems {
                let cut=item.replacingOccurrences(of: ".", with: "_")
                let array=cut.components(separatedBy: "_")
                indexs.append(Int(array[2])!)
            }
            
            return indexs.isEmpty ? 1 : indexs[indexs.count-1]+1
            
        }catch _ as NSError{
            return nil
        }
        
        
    }
    
    
    
    
    func getVideoPathByCurrentTime(_ videoDir:String,pageNumber:String)->String{
        let time=Int64(Date().timeIntervalSince1970*1000)
        let videoPath=videoDir+"/M_"+pageNumber+"\(time).mp4"
        return videoPath
    }
    
    func createVoicePathByCurrentTime(_ voiceDir:String,pageNumber:String)->String{
        let time=Date().timeIntervalSince1970.description
        let voicePath=(voiceDir+"/V_"+pageNumber).appendingFormat("%lld",time)+".caf"
        return voicePath
    }
    
    
    //加入者复制video到cache
    func copyVideoToCache(_ srcPath:String?)->String?{
        if srcPath == nil {
            return nil
        }
        
        let fileMgr=Foundation.FileManager.default
        let toPath=getReceivedVideoSavePath()
        do{
            try fileMgr.copyItem(atPath: srcPath!, toPath: toPath)
            return toPath
        }catch _ as NSError{
            
        }

        return nil
    }
    
    // cache目录下的Videotrack目录的video文件路径
    func getReceivedVideoSavePath()->String{
        let videoDir=createReceivedVideoDir()
        return getVideoPathByCurrentTime(videoDir,pageNumber: "0_")
    }
    
    // cache目录下的Soundtrack目录的voice文件路径
    func getReceivedVoiceSavePath()->String{
        let voiceDir=createSendedSoundDir()
        return createVoicePathByCurrentTime(voiceDir,pageNumber: "0_")
    }
    
 
  
    
//    func isValidAccount(_ success:@escaping ()->Void,failure:@escaping (_ reason:String?)->Void){
//        
//        let tokenKey = UserDefaults.standard.string(forKey: Constants.LOGIN_TOKEN)
//        
//        if(tokenKey == nil){
//            failure(nil)
//            return
//        }
//        let dictParams = ["tokenkey":tokenKey!]
//        //网络请求
//        let manager = AFHTTPSessionManager()
//        
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        let url = NetworkAddressManager.shareInstance.getMemberInfoUrl()
//        manager.post(url, parameters: dictParams, progress: nil, success: { (operation:URLSessionDataTask!, responseObject:Any?) in
//            do{
//                let responseDict = try JSONSerialization.jsonObject(with: responseObject as! Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary
//                
//                let result = responseDict!.value(forKey: "status") as! String
//                if(result == "success" || result == "true"){
//                    success()
//                }else{
//                    let message = responseDict!.value(forKey: "error") as? String
//                    failure(message)
//                }
//                
//            }catch{
//                
//            }
//            
//        }, failure: { (operation: URLSessionDataTask?,error: Error?) in
//            failure(error?.localizedDescription)
//        })
//        
//    }
    
//    func downloadFromURLWithProgress(_ url:URL, changeProgress:((_ progress:CGFloat)-> Void)?, success:@escaping (String)-> Void, failure:@escaping (_ reason:String?)->Void) {
//        
//        isValidAccount({
//            let filterUrlString = NetworkAddressManager.shareInstance.convertNetworkAddress(url.absoluteString)
//            
//            let manager = AFHTTPSessionManager();
//            manager.responseSerializer = AFHTTPResponseSerializer()
//            
//            manager.get(filterUrlString, parameters: nil, progress:{ (downloadProgress) in
//                if changeProgress != nil {
//                    let progressValue=floor(downloadProgress.fractionCompleted*100)
//                    changeProgress!(CGFloat(progressValue))
//                }
//                
//            }, success: { (operation: URLSessionDataTask,responseObject: Any?) in
//                            
//                            var utfFileName:NSString=""
//                            
//                            if self.isSupportedDocument(filterUrlString) {
//                                
//                                utfFileName = NSString(string: url.lastPathComponent)
//                                
//                            }else{
//                                
//                                let fileName = operation.response!.suggestedFilename?.cString(using: String.Encoding.isoLatin1)
//                                utfFileName = NSString(cString: fileName!, encoding:String.Encoding.utf8.rawValue)!
//                            }
//                            
//                            if self.isExistSameNameApf(docName: utfFileName as String) {
//                                utfFileName = self.modifySameNameApf(docName: utfFileName)
//                            }
//                            
//                            let fileMgr = FileManager()
//                            let docPath = fileMgr.getDocumentPath()
//                            let targetFileName = docPath + "/" + (utfFileName as String)
//                            
//                            let data = responseObject as! Data
//                            
//                            let resString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
//                            if (resString == "找不到文件"){
//                                failure(nil)
//                                return
//                            }
//                            self.deleteDocumentCoverInCache(targetFileName)
//                            try? data.write(to: URL(fileURLWithPath: targetFileName), options: [])
//                            success(targetFileName)
//                            
//            },
//                        failure: { (operation: URLSessionDataTask?,error: Error?) in
//                            failure(error?.localizedDescription)
//                            
//            })
//            
//        }) { (reason) in
//            failure(reason)
//        }
//        
//    }
    
    
    fileprivate func getMimeType(_ fileExtension:String) -> String {
        return "application/octet-stream"
    }
    
    
}
