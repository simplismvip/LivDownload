    //
    //  ViewController.swift
    //  PageShare
    //
    //  Created by Q.S Wang on 23/02/2016.
    //  Copyright © 2016 OnePlus All rights reserved.
    //
    
    import UIKit
    import AVFoundation
    import AVKit
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

    @objc  enum CLICKBTNTYPE : Int {
        case btnTypeCancle
        case btnTypeSave
        case btnTypeEraser
        case btnTypeKeyboard
        case btnTypeEmoticon
        case btnTypePalette
        case btnTypeShare
        case btnTypeDelete
        case btnTypeVideo
        case btnTypeDone
        case btnTypePlay
        case btnTypeRecored
        case btnTypeVisible
        case btnTypeAudioManger
        case btnTypeVideoMetting
    };
    
    @objc enum DRAWTOOLS : Int{
        case icon
        case text
        case image
        case video
        case none
        //TODO: remove
        case path
        case eraser
        case voice
        
    };
    @objc enum READSTATE : Int{
        case edit
        case shareing
        case onlyread
    };
    
    @objc enum ROOMSTATE : Int{
        case owner
        case attendee
    };
    
    protocol PageShareViewDelegate {
        func contentView(_ contentView: PageView!, touchesBegan touches: Set<NSObject>!)
        func contentView(_ contentView: PageView!, touchesEnded touches: Set<NSObject>!)
    }
    
    class PageViewController: UIViewController , UIScrollViewDelegate ,PageShareViewDelegate,ToolBarStatusDelegate{
        var mainView: UIView!
        
        
        var webscoektDelegate : WebsocketMessageUIDelegate?
        
        var scrollView:SingleFingerDragDisabledUIView?
        var pageView:PageView?
        var lastHideTime:Date?
        
//        var audioTool: OPAudioMangerTool?

        var eraserBT:UIButton?
        var annotationImage:UIImage?
        var foreGroundLayer:CALayer?
        
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            webscoektDelegate = createMessageDelegate()
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func createMessageDelegate()->WebsocketMessageUIDelegate{
            return WebsocketMessageUIDelegate(view: self,roomState: ROOMSTATE.attendee,forceQuit: true)
        }
        
        func contentView(_ contentView: PageView!, touchesBegan touches: Set<NSObject>!) {
            lastHideTime = Date()
        }
        
        func contentView(_ contentView: PageView!, touchesEnded touches: Set<NSObject>!) {
        
        }
        
        override func viewWillAppear(_ animated: Bool) {
            //Try to connect to the websocket server only after view is loaded.
            //Close the connection in AppDelegate.
            super.viewWillAppear(animated)
            pageView!.delegate.showBlanckImage()
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)

        }
        
        override func viewDidLoad() {
            super.viewDidLoad();
            //work around for lower version of ios
            mainView=UIView()

            //disable auto lock
            UIApplication.shared.isIdleTimerDisabled = true
        
            self.tabBarController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
 
            
            addOrientationChangeObserver()
            
//            audioTool=OPAudioMangerTool()
//            audioTool?.delegate = self
            
            let currentBounds = getCurrentViewBounds()
           
            mainView.bounds = currentBounds
            self.view.addSubview(mainView)
            
            scrollView = SingleFingerDragDisabledUIView()
            scrollView!.bounds = mainView.bounds
            scrollView!.frame = mainView.bounds
            scrollView!.delegate = self
            
            pageView  = PageView()
            pageView!.bounds = scrollView!.bounds
            pageView!.frame = scrollView!.frame
            pageView!.message = self
            
            scrollView!.addSubview(pageView!)
            
            
            mainView.addSubview(scrollView!)

            scrollView!.minimumZoomScale = 1
            
            scrollView!.maximumZoomScale = 5
            scrollView!.zoomScale = 1
            scrollView!.delaysContentTouches = false;
            
            //Add layers to the page view.
            let  backGroundLayer = CALayer()
            backGroundLayer.contentsScale = UIScreen.main.scale
            backGroundLayer.frame = pageView!.bounds
            //TODO: need this or not.
            //layer.contentsGravity = kCAGravityResizeAspectFill
            pageView!.layer.addSublayer(backGroundLayer)
            
            foreGroundLayer = CALayer()
            foreGroundLayer!.frame = pageView!.frame
            foreGroundLayer!.setNeedsDisplay()
            
            pageView!.layer.addSublayer(foreGroundLayer!)
            
            //            let offsetPoint = pageView!.convertPoint(pageView!.frame.origin,toView: nil)
            webscoektDelegate!.drawer = ViewDrawer(backLayer: backGroundLayer,foreLayer: foreGroundLayer!,bounds: currentBounds)
            
            pageView!.delegate = webscoektDelegate!.drawer;
            pageView!.toolBarStatusDelegate=self;
            
            self.createTopBar()
        }
        
      
        
        func addOrientationChangeObserver(){
            NotificationCenter.default.addObserver(self, selector : #selector(willChangeRotate) , name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
            NotificationCenter.default.addObserver(self, selector : #selector(didChangeRotate) , name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
        }
        
        func removeOrientationChangeObserver(){
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: nil)
        }
        
//        override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//            willChangeRotate()
////            pageView!.delegate.backGroundLayer?.hidden = true
////            pageView!.delegate.drawer?.layer.hidden = true
//        }
//        
//        override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//            didChangeRotate()
////            pageView!.delegate.backGroundLayer?.hidden = false
////            pageView!.delegate.drawer?.layer.hidden = false
//            
//        }
        
        func willChangeRotate(){
            if pageView!.delegate.hasBackground {
                annotationImage = UIUtils.printAnnotationLayer(pageView!.delegate.drawer?.layer, size: pageView!.delegate.scaledRect!.size)
            }
            
        }
        
        func didChangeRotate(){
            //let offsetX =  scrollView!.bounds.origin.x + (mainView.bounds.size.width - lastScrollViewWidth!)/2
            
            // let newRect = CGRect(x: offsetX, y: mainView.bounds.origin.y, width: mainView.bounds.size.width, height: mainView.bounds.size.height)
            let currentBounds = getCurrentViewBounds()
            mainView.bounds = currentBounds
            scrollView!.bounds = mainView.bounds
            scrollView!.frame = mainView.bounds
            //                let boundsRect = CGRect(x: 0, y: scrollView!.bounds.origin.y, width: scrollView!.bounds.size.width, height: scrollView!.bounds.size.height)
            //                let frameRect = CGRect(x: 0, y: scrollView!.frame.origin.y, width: scrollView!.frame.size.width, height: scrollView!.frame.size.height)
            
            pageView!.bounds = scrollView!.bounds
            pageView!.frame = scrollView!.frame
            
            pageView!.delegate.bounds = currentBounds
            pageView!.delegate.backGroundLayer?.frame = pageView!.bounds
            pageView!.delegate.drawer?.layer.frame = pageView!.frame
            
            if pageView!.delegate.hasBackground {
                pageView!.delegate.drawBackGroundImage(pageView!.delegate.receivedImage!)
                if(annotationImage != nil){
                    pageView!.delegate.drawAnnotationLayer(annotationImage!)
                }
            }
            
        }
        
        func getCurrentViewBounds()->CGRect {
            var newBounds:CGRect?
            let screenBounds = UIScreen.main.bounds
            
            newBounds = screenBounds
            
            return newBounds!
        }
        
        func createTopBar(){
            let eraseritem = createEraserBT()
           
            let backitem = createBackBT()
            self.navigationItem.rightBarButtonItem = eraseritem;
            self.navigationItem.leftBarButtonItems = [backitem];
            
        }
        
        func createEraserBT()->UIBarButtonItem {
            eraserBT = DrawingToolFactory.createEraserButton()
            eraserBT!.addTarget(self, action: #selector(PageViewController.eraserbarButton), for: UIControlEvents.touchUpInside)
           
            let eraseritem = UIBarButtonItem(customView: eraserBT!)
            return eraseritem
        }
        
        
        func createBackBT()->UIBarButtonItem{
            let backButton = DrawingToolFactory.createBackButton()
            backButton.addTarget(self, action: #selector(backbarButton), for: UIControlEvents.touchUpInside)
            let backitem = UIBarButtonItem(customView: backButton)
            return backitem
        }
        
        //橡皮擦
        func eraserbarButton(_ btn : UIButton)  {
            
            btn.isSelected = !btn.isSelected
        }
        //返回
        func backbarButton(){
             self.closeRoom()
             self.tabBarController?.navigationController!.popViewController(animated: true)
        }
        
        
 
//        
//        //TODO: 长按弹出底部菜单
//        func longtapmenu(_ gesture:UILongPressGestureRecognizer)  {
//            if gesture.state == UIGestureRecognizerState.began {
//                for itemView in self.view.subviews {
//                    if itemView.isKind(of: MenuView.self) {
//                        return
//                    }
//                }
//                
//                var iconTagArr = [Int32(CLICKBTNTYPE.btnTypeCancle.rawValue), Int32(CLICKBTNTYPE.btnTypeVideo.rawValue), Int32(CLICKBTNTYPE.btnTypeKeyboard.rawValue), Int32(CLICKBTNTYPE.btnTypeEmoticon.rawValue), Int32(CLICKBTNTYPE.btnTypePalette.rawValue)]
//                
//                var iconNameArr = ["self_navbar_close_icon_white","videoMetting","navbar_keyboard_icon_white","navbar_emoticon_icon_white","navbar_palette_icon_white"]
//                
//                if !MeetingUtils.isStartMeeting(){
//                    iconTagArr.insert(Int32(CLICKBTNTYPE.btnTypeRecored.rawValue), at: 1)
//                    iconNameArr.insert("navbar_record_icon_white", at: 1)
//                }
//                
//                let copyTagArray = UnsafeMutablePointer<Int32>(mutating: iconTagArr)
//                MenuView.initMenu(withIcon: self.view, delegate: self, iconTagArr: copyTagArray, iconNameArr: iconNameArr)
//                
//            }
//            
//        }
//
//        //menu
//        public func clickBtn(_ btntype: Int) {
//            switch btntype {
//            case CLICKBTNTYPE.btnTypeRecored.rawValue:
//                recordAction()
//                break
//            case CLICKBTNTYPE.btnTypeVideo.rawValue:
//                videoAction()
//                break
//            case CLICKBTNTYPE.btnTypeKeyboard.rawValue:
//                textAction()
//                break
//            case CLICKBTNTYPE.btnTypeEmoticon.rawValue:
//                emotionAction()
//                break
//            case CLICKBTNTYPE.btnTypePalette.rawValue:
//                colorAction()
//                break
//          
//            default:
//                break
//            }
//        }
        
            
       
        
        
        func  showDialog(_ title:String,message:String,confirm:(()-> Void)?)  {
            let alertDialog = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            let title = NSLocalizedString("net.pictoshare.pageshare.dialog.button.ok",comment:"")
            alertDialog.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
                confirm?()
                //                self.cleanup()
                //                self.backToLoginPage()
            }))
            
            DispatchQueue.main.async { void in
                self.present(alertDialog, animated: true, completion: nil)
                
            }
        }
        
        
        func closeRoom(){
            removeOrientationChangeObserver()
            
//            XMPPConnectionManager.sharedInstance.connectMessageDelegate=nil
//            NetworkUtil.defaultmanager().netWorkStateDelegate = nil
//            
//            Meeting.exitAll(nil, fail: nil)
//            
            webscoektDelegate!.cleanup()
//            XMPPConnectionManager.sharedInstance.disconnect()
        }
        
        public func `return`(_ mp3String: String!) {
//            let fileMgr = FileManager()
//            MBProgressHUDHelper.hudProgressAdd(to: Constants.appDelegate.window, message: NSLocalizedString("net.pictoshare.pageshare.dialog.message.downloading", comment: ""))
//           
//            fileMgr.uploadBackupFile(mp3String, success: {
//                MBProgressHUDHelper.hudHide(Constants.appDelegate.window)
//                let urlPath = NetworkAddressManager.shareInstance.createBackupFileUrl(NSString(string:mp3String).lastPathComponent)
//                
//                XMPPDispatchManager.xmppDispatchManager.handleUrlVoiceToSend(urlPath)
//                
//                fileMgr.removeFile(filepath: mp3String)
//            }, failure: { (reason) in
//                MBProgressHUDHelper.hudHide(Constants.appDelegate.window)
//                fileMgr.removeFile(filepath: mp3String)
//            })
            
        }
        
        func scrollViewTapped(_ recognizer: UILongPressGestureRecognizer){
            //            switchNavigator()
        }
        
        
        
        override func viewDidDisappear(_ animated: Bool) {
            //如果断开连接,那么当退出video播放界面,会重连,导致服务器发送最后一次video,
            //接收到cmd为video的json,由于video文件不完整,程序退出video播放界面后无法退出
            //webscoektDelegate!.cleanup()
            webscoektDelegate?.stopSound()
        }
        
        
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return pageView
        }
        
        func refreshAction() {
            //            NSNotificationCenter.defaultCenter().removeObserver(self)
//            webscoektDelegate!.reconnect()
            //            connectWebsocket()
        }
        
        
        // 状态栏隐藏
        override var preferredStatusBarStyle : UIStatusBarStyle {
            
            return UIStatusBarStyle.default
        }
        
        override var prefersStatusBarHidden : Bool {
            
            return true
        }
        
        func isDrawingEnabled()->Bool{
          
            if eraserBT!.isSelected {
                return false
            }
            return true && eraserBT!.isEnabled
        }
   
        
        func isEraseEnabled()->Bool{
            
            return eraserBT!.isSelected && eraserBT!.isEnabled
        }
    
        
     
        
   
        
        
        
       

        
        //文字
        func textAction()  {
           
//            TextInputView.initWithKeyBoardViewAndAddDelegate(self)
        }
        // 代理回调
        func textInputFinished(_ text:String){
//            pageView?.startDrawText(text)
//            topToolbar?.hide()
//            bottomToolBar?.hide()
        }
        
        
        //表情
        func emotionAction()  {
          
//            EmojiCollectionView.initWithView(withDelegate: self)
        }
        func emojiSelected(_ index: Int) {
//            pageView?.startDrawIcon(index)
//            topToolbar?.hide()
//            bottomToolBar?.hide()
        }
        
        
        //颜色选择
        func colorAction()  {
            
            
        }
//        func colorPickerViewController(_ colorPicker: OPColorPickerView, didSelect color: UIColor, selectWidth width: CGFloat) {
//            pageView?.color=color
//            pageView?.brushWidth=width
//        }
    }
