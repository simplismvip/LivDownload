//
//  LivePlaybackViewController.swift
//  PageShare
//
//  Created by cheny on 16/7/22.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

import Foundation
class LivePlaybackViewController: PageViewController {
    
    var livePlayDelegate: LivePlaybackDelegate?
    var liveFilePath: String?
    var sessionID: String?
    var liveThread:Thread?

    
    var pageLabel: UILabel?
    var reader: LivePlaybackReader?
    
    var closeConnectFlag=false

    var communicationBT : UIButton!
    var playBT : UIButton!
    var playitem: UIBarButtonItem?
    
    init(liveFilePath:String){
        super.init(nibName: nil, bundle: nil);
        self.liveFilePath = liveFilePath
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func decreasePage(_ sender:UIButton){
        if reader!.currentPageIndex > 0 {
            if isPlayEnabled() {
                stopLivePlayback()
                livePlayDelegate?.stopSound()
                reader!.startPreviousPage()
                startLivePlayback()
            }else{
                reader!.startPreviousPage()
                reader!.readBackgroundImageAtPageNum(liveFilePath!)
            }
            pageLabel?.text = "\(reader!.currentPageIndex+1)/\(reader!.getPageCountFromLiveJSON())"
        }
        
    }
    
    func increasePage(_ sender:UIButton){
        let pageCount = reader!.getPageCountFromLiveJSON()
        if(reader!.currentPageIndex < pageCount - 1){
            if isPlayEnabled() {
                stopLivePlayback()
                livePlayDelegate?.stopSound()
                reader!.startNextPage()
                startLivePlayback()
            }else{
                reader!.startNextPage()
                reader!.readBackgroundImageAtPageNum(liveFilePath!)
            }
            
            pageLabel?.text = "\(reader!.currentPageIndex+1)/\(pageCount)"
        }
    }
  
    func createTurnPageButton(titleId: String) -> UIButton{
        let pageButton = UIButton()
        pageButton.setTitle(titleId, for: UIControlState.normal)
        pageButton.setTitleColor(UIColor(red: 90.0/255.0, green: 171.0/255.0, blue: 225.0/255.0, alpha: 1.0), for: UIControlState.normal)
        
      
        
        return pageButton
    }
    
    func createTurnPageView() {
        pageLabel = UILabel()
        pageLabel?.textAlignment = .center
        pageLabel?.backgroundColor = UIColor(red: 106/255.0, green: 116/255.0, blue: 98/255.0, alpha: 0.5)
        pageLabel?.textColor = UIColor.white
        self.view.addSubview(pageLabel!)
        
        pageLabel!.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view.mas_right)?.multipliedBy()(0.5)?.setOffset(-38)
            make?.top.equalTo()(self.view.mas_bottom)?.multipliedBy()(0.95)?.setOffset(-30)
            _=make?.width.equalTo()(76)
            _=make?.height.equalTo()(30)
        }
        
        let leftbutton = createTurnPageButton(titleId: "上一页")
        let rightbutton = createTurnPageButton(titleId: "下一页")
        leftbutton.addTarget(self, action: #selector(LivePlaybackViewController.decreasePage), for: UIControlEvents.touchUpInside)
        rightbutton.addTarget(self, action: #selector(LivePlaybackViewController.increasePage), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(leftbutton)
        self.view.addSubview(rightbutton)
        
        leftbutton.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.setOffset(5)
            make?.top.equalTo()(self.view.mas_bottom)?.multipliedBy()(0.95)?.setOffset(-30)
            _=make?.width.equalTo()(80)
            _=make?.height.equalTo()(30)
            
        }
        
        rightbutton.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.right.equalTo()(self.view)?.setOffset(-5)
            make?.top.equalTo()(self.view.mas_bottom)?.multipliedBy()(0.95)?.setOffset(-30)
            _=make?.width.equalTo()(80)
            _=make?.height.equalTo()(30)
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBtn()
        let isRemote = isRemotePlayEnabled()
        reader = LivePlaybackReader(liveFilePath!, isRemote: isRemote)
        startFirstReadBackgroundImage()
        
        let pageCount = reader!.getPageCountFromLiveJSON()
        if pageCount > 1 {
            createTurnPageView()
            pageLabel?.text = "1/\(pageCount)"
        }
        
        
    }

    override func createTopBar() {}

    func createNavigationBtn() {

        let space =  UIBarButtonItem.init(barButtonSystemItem:UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        space.width = 20;

        let backitem = createBackBT()
        playitem = createPlayBT()
        let eraseritem = createEraserBT()
        
        if isRemotePlayEnabled() {
            playitem?.isEnabled = false
        }
        self.navigationItem.leftBarButtonItems=[backitem,space,playitem!,space,eraseritem]
        
    }
    
    func createPlayBT()->UIBarButtonItem {
        playBT = DrawingToolFactory.createPlayButton()
        playBT.addTarget(self, action: #selector(LivePlaybackViewController.playbarButton), for: UIControlEvents.touchUpInside)
        let playitem = UIBarButtonItem(customView: playBT)
        
        return playitem
    }
    
  
    
    //返回
    override func backbarButton()  {
        closeRoom()
        resizeLivePlay()
        reader!.dict?.removeAll()
        reader = nil
        livePlayDelegate?.removeLiveObserver()
        self.navigationController!.popViewController(animated: true)
    }
    
    //回放
    func playbarButton(_ btn : UIButton)  {
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            startLivePlayback()
        }else {
            stopLivePlayback()
            livePlayDelegate?.stopSound()
        }

    }

    func resizeLivePlay(){
        stopLivePlayback()
    }
    
    override func createMessageDelegate() -> WebsocketMessageUIDelegate {
        livePlayDelegate=LivePlaybackDelegate(view: self,roomState: ROOMSTATE.attendee,forceQuit: false)
        return livePlayDelegate!
    }
    
    
    //超越权限
   func handleReplay(_ id: AnyObject) {
        if isPlayEnabled() {
            startLivePlayback()
        }else if !isPlayEnabled(){
            stopLivePlayback()
            livePlayDelegate?.stopSound()
        }
    }

    func runLive(){
        reader?.start()
        reader?.readLiveFileWithPageNumber(liveFilePath!, success: {
            
        })

    }
    
    
    func startLivePlayback(){

        liveThread=Thread(target: self, selector: #selector(LivePlaybackViewController.runLive), object: nil)
        liveThread!.start()
        
        
    }
    
    func startFirstReadBackgroundImage(){
        if isRemotePlayEnabled() {
            return
        }
        livePlayDelegate?.startLivePlaybackObserver()
        reader!.readBackgroundImageAtPageNum(liveFilePath!)
    }
    
    func stopLivePlayback(){
        if(liveThread != nil){
            reader!.exit()
            liveThread?.cancel()
            liveThread=nil
        }
    }
    
    func isRemotePlayEnabled()->Bool {
        let isRemote = (self.sessionID != nil && !Foundation.FileManager.default.fileExists(atPath: liveFilePath!))
        return isRemote
    }
    
    func isPlayEnabled()->Bool {
        return playBT.isSelected
    }
    
}

