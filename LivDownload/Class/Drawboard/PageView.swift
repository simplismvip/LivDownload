//
//  PageView.swift
//  PageShare
//
//  Created by Q.S Wang on 21/04/2016.
//  Copyright © 2016 Q.S Wang. All rights reserved.
//

import UIKit
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


class PageView :UIView {
    var delegate:ViewDrawer!
    var toolBarStatusDelegate:ToolBarStatusDelegate!
    
    var lastPoint = CGPoint.zero
    var firstPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var is2F = false
    var pointArray: [Point]?
    //var drawingtool:DRAWTOOLS? = .PATH
//    var iconIdx:Int32 = -1
//    var textString:String? = nil
    var color:UIColor = UIColor.red
    var message: PageShareViewDelegate?
    
    
//    func startDrawIcon(_ index:Int)
//    {
//        //drawingtool = DRAWTOOLS.ICON
//        iconIdx = Int32(index);
//    }
//    
//    func startDrawText(_ text:String)  {
//        //drawingtool = DRAWTOOLS.TEXT
//        textString = text
//    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if(event?.allTouches?.count != 1){
            next?.touchesMoved(touches, with: event)
            return
        }
        message?.contentView(self, touchesBegan: touches)
        
        pointArray=[]
        
        swiped = false
        if let touch = touches.first as UITouch? {
            lastPoint = touch.location(in: self)
            firstPoint = touch.location(in: self)
            pointArray?.append(Point(point: firstPoint)!)
        }
        
//        if toolBarStatusDelegate.isMuteEnabled!() {
//            textString = nil
//            iconIdx = -1;
//        }
        
//        if(iconIdx != -1 && iconIdx != 21 && iconIdx != 22 && iconIdx != 24){
//            let imageName = PageShareBridgingUtils.getEmojiName(iconIdx)
//            let image = UIImage(named: imageName!)
//            delegate.drawer?.draw(image!, position: firstPoint)
//            return
//        }
        
//        if(textString != nil && textString != ""){
//            delegate.drawer?.drawText(textString!, position: firstPoint, color: color, textSize: brushWidth*4)
//            return
//        }
        //开启画path时的上下文,即UIGraphicsGetCurrentContext
        if toolBarStatusDelegate.isDrawingEnabled() || toolBarStatusDelegate.isEraseEnabled() {
            delegate.drawer?.startDrawLine()
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if(event?.allTouches?.count != 1){
            return
        }
        
        swiped = true
        if let touch = touches.first as UITouch? {
//            if (iconIdx == -1 && (textString == nil || textString == "")){
                if toolBarStatusDelegate.isDrawingEnabled() || toolBarStatusDelegate.isEraseEnabled() {
                    let currentPoint = touch.location(in: self)
                    
                    drawLine(lastPoint, currentPoint: currentPoint)
                    pointArray?.append(Point(point: currentPoint)!)
                    lastPoint = currentPoint
                }
                
//            }
            
        }
        
    }
    
    func drawTransverseLine(_ lastPoint:CGPoint, currentPoint:CGPoint) {
        let startPoint:CGPoint?
        let endPoint:CGPoint?
        if lastPoint.x <= currentPoint.x{
            startPoint=lastPoint
            endPoint=CGPoint(x: currentPoint.x,y: lastPoint.y)
        }else{
            startPoint=CGPoint(x: currentPoint.x,y: currentPoint.y)
            endPoint=CGPoint(x: lastPoint.x,y: currentPoint.y)
        }
        delegate.drawer?.drawReceivedLine(startPoint!, endPosition: endPoint!, color: self.color, width: Int32(brushWidth))
    }
    
    func drawLine(_ lastPoint:CGPoint, currentPoint:CGPoint)  {
        var color = self.color
        var width = brushWidth
        if(toolBarStatusDelegate.isEraseEnabled()){
            color = UIColor.clear
            width = 20
        }
        delegate.drawer?.drawLine(lastPoint, to: currentPoint, color: color, width: Int32(width))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        //        if(event?.allTouches()?.count != 1){
        //            return
        //        }
        
        message?.contentView(self, touchesEnded: touches)
        //        if !swiped {
        //            //            if(drawingtool == .PATH){
        //            // draw a single point
        //            drawLine(lastPoint, currentPoint: lastPoint)
        //            //            }
        //
        //        }
        
        if let touch = touches.first as UITouch? {
            let currentPoint = touch.location(in: self)
            
            //关闭画path时的上下文,即UIGraphicsEndImageContext
            if toolBarStatusDelegate.isDrawingEnabled() || toolBarStatusDelegate.isEraseEnabled() {
                delegate.drawer?.endDrawLine()
            }
            
//            //idx 21 is line.
//            if(iconIdx == 21)
//            {
//                drawTransverseLine(lastPoint, currentPoint: currentPoint)
//            }
//            
//            //idx 22 is rect.
//            if(iconIdx == 22)
//            {
//                let fromPoint=CGPoint(x: min(lastPoint.x, currentPoint.x),y: min(lastPoint.y,currentPoint.y))
//                let toPoint=CGPoint(x: max(lastPoint.x, currentPoint.x),y: max(lastPoint.y,currentPoint.y))
//                delegate.drawer?.drawRect(fromPoint, to: toPoint, color: color, linewidth: Int32(brushWidth))
//            }
//            
//            //idx 24 is circle.
//            if(iconIdx == 24)
//            {
//                let fromPoint=CGPoint(x: min(lastPoint.x, currentPoint.x),y: min(lastPoint.y,currentPoint.y))
//                let toPoint=CGPoint(x: max(lastPoint.x, currentPoint.x),y: max(lastPoint.y,currentPoint.y))
//                delegate.drawer?.drawCircle(fromPoint, to: toPoint, color: self.color, linewidth: Int32(brushWidth))
//            }
            
            lastPoint=currentPoint
        }

//        textString = nil
//        iconIdx = -1;
        pointArray?.removeAll()
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesCancelled(touches, with: event)
        if(event?.allTouches?.count != 1){
            return
        }
    }
}
