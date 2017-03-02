    //
    //  ViewDrawer.swift
    //  PageShare
    //
    //  Created by Q.S Wang on 11/03/2016.
    //  Copyright © 2016 OnePlus All rights reserved.
    //
    
    import Foundation
    import UIKit

    class ViewDrawer : NSObject {
        //        let mainView:UIView
        let backGroundLayer :CALayer?
        //let foreGroundLayer :CALayer
        var receivedImage:UIImage?
        var scaledRect:CGRect?
        //TODO: this is alwasy main screen size now.
        var bounds:CGRect
        var hasBackground=false
        var drawer:AnnotationLayerDelegate?
        
        init(backLayer:CALayer?,foreLayer:CALayer, bounds:CGRect){
            
            backGroundLayer = backLayer
            //foreGroundLayer = foreLayer
            
            self.bounds = bounds
            
            self.drawer  =  AnnotationLayerDelegate(view:foreLayer)
            
            super.init();
            setupLayer()
        }
        
        func setupLayer(){
            drawer?.layer.contentsGravity = kCAGravityResizeAspectFill
            
        }
        
        func hideForeground(){
            drawer?.layer.isHidden = !(drawer!.layer.isHidden)
        }
        
//        func clearForeGround(){
////            foreGroundImage = drawCustomImage(CGSize(width:  bounds.width, height:  bounds.width))
////            foreGroundLayer.contentsScale =  UIScreen.mainScreen().scale
//            
////            foreGroundLayer.contents = foreGroundImage!.CGImage
//////            foreGroundLayer.frame = bounds;
////            foreGroundLayer.opaque = false
////            drawLine(CGPointMake(2, 8), toPoint: CGPointMake(200, 8), color: UIColor.blackColor(), width: 3)
//           
//            
////             drawLine( CGPointMake(2 ,  8), toPoint: CGPointMake(200,  8), color: UIColor.blackColor(), width: 3)
//            
//        }
        
//        
        func endForeGroundImageDraw() {
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
//            foreGroundImage = newImage
            
//            let image = UIUtils.cropImage(newImage, size: foreGroundLayer.frame.size)
//            foreGroundLayer.contents = image.CGImage
            drawer!.layer.contents = newImage?.cgImage
            
        }
        
        func prepareForeGroundImageDraw() -> CGContext{
        
            let rect = CGRect(x: 0, y: 0, width: drawer!.layer.frame.width, height: drawer!.layer.frame.height)
            let image = UIImage(cgImage: drawer!.layer.contents as! CGImage)
            
            let scale = UIUtils.getScale();
            if(scale > 1.5){
                UIGraphicsBeginImageContextWithOptions(drawer!.layer.frame.size, false, scale)
            }else{
                UIGraphicsBeginImageContext(drawer!.layer.frame.size)
            }
            
//            UIGraphicsBeginImageContextWithOptions(foreGroundLayer.frame.size, false, UIUtils.getScale())
            let context = UIGraphicsGetCurrentContext()
            image.draw(in: rect)
//            foreGroundImage!.drawInRect(rect)
            //foreGroundLayer.contents = nil
            return context!
        }
        
//        func drawCustomImage(size: CGSize) -> UIImage {
//            let scale = UIUtils.getScale();
//            if(scale > 1.5){
//                UIGraphicsBeginImageContextWithOptions(size, false, scale)
//            }else{
//                UIGraphicsBeginImageContext(size)
//            }
//            // Setup our context
////            UIGraphicsBeginImageContextWithOptions(size, false, 0)
//            
//            // Drawing complete, retrieve the blank image and cleanup
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return image
//        }
        
        func showBlanckImage()  {
            drawer?.showBlanckImage()
//            let image = drawer!.drawCustomImage(foreGroundLayer.frame.size)
//            foreGroundLayer.contents = image.CGImage
        }
        
        func drawImage(_ jsonData:JSON){
            if let imageStr: String  = Decoder.decode(key: "image")(jsonData){
                drawBase64Image(imageStr)
            }
        }
        
        func drawBase64Image(_ image:String){
//            clearForeGround()
            let image = UIUtils.base64ToImage(image)
            
            if image != nil{
                drawBackGroundImage(image!)
            }
            
        }
        
        
        func scaleBackGroundImage(_ rect:CGRect)->ScaleRatio{
            let screenSize: CGRect = bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            let orgWidth = UIUtils.pixelToPoints( rect.width,scale: UIScreen.main.scale)
            let orgHeight = UIUtils.pixelToPoints(rect.height,scale: UIScreen.main.scale)
            
            //try fit width at first
            var ratio = orgHeight / orgWidth
            
            let newHeight = screenWidth * ratio
            let ratioModel = ScaleRatio();

            
            //if height is good enough
            if(newHeight <= screenHeight){
                ratioModel.xRatio = 1
                ratioModel.yRatio = newHeight / screenHeight
//                return CGRectMake(0, 0, screenWidth, newHeight)
            }else{
                //try fit height here
                ratioModel.yRatio = 1
                
                
                ratio = orgWidth / orgHeight
                let newWidth = screenHeight * ratio
                
                ratioModel.xRatio = newWidth / screenWidth
//                return CGRectMake(0, 0, newWidth, screenHeight)
            }
            
            return ratioModel
        }
        
        
        func showText(_ jsonData:JSON,roomState:ROOMSTATE){
            let textModel = Text(json: jsonData)
            let height:Float = textModel!.stext.height
            let width:Float = textModel!.stext.width
            var x:CGFloat = 0
            var y:CGFloat = 0
            var isFromIos = false
            
            if  let ext: StextExt = textModel!.stext.ext {
                let client:String = ext.client
                if(client == "ios"){
                    x = CGFloat(ext.x)
                    y = CGFloat(ext.y)
                    isFromIos = true
                }
            }else{
                x = CGFloat(textModel!.stext.x)
                y = CGFloat(textModel!.stext.y)
            }
            
            let rgbValue:Int = textModel!.stext.color
            let color = UIUtils.intToRGB(rgbValue)
            
            let text:NSString = textModel!.stext.text as NSString
            var line:CGFloat = CGFloat(textModel!.stext.line)
            
            let point = UIUtils.pixelPostionToPoints(CGPoint(x: x, y: y), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
            
            let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
            
            var ponitWithToolbar:CGPoint
            if isFromIos {
                ponitWithToolbar = point
            }else{
                ponitWithToolbar = tuneYPositionForAndroidToolbar(point, factor: 10,height: CGFloat(height),yRatio: ratio.yRatio)
            }
            
            
            //TODO: why we need shift twice.
            let tunedPosition  = tunePosition(ponitWithToolbar, height: CGFloat(height),xRatio: ratio.xRatio,yRatio: ratio.yRatio)
            if roomState == ROOMSTATE.attendee {
                line = line*4
            }else{
                line = line*8
            }
            drawer?.drawReceivedText(text as String, position: tunedPosition, size: line, color: color)
            //            text.drawAtPoint(tunedPosition, withAttributes: attributes as? [String: AnyObject])
            //
            //            endForeGroundImageDraw()
        }
        
        func tunePosition(_ orgPoint:CGPoint,height:CGFloat,xRatio:CGFloat,yRatio:CGFloat) -> CGPoint{
            var localRatio = (drawer!.layer.frame.width / bounds.size.width)
            if(yRatio == 1)
            {
                localRatio = (drawer!.layer.frame.height / bounds.size.height)
            }
            
            return CGPoint(x: orgPoint.x * xRatio * localRatio , y: orgPoint.y * yRatio * localRatio )
            
        }
        
        func erase(_ path:Polyline){
            let context = prepareForeGroundImageDraw()
            
            UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.clear)
            
            
            for index in 0...path.paths.count-1{
                drawPath(path.paths[index], width: (path.properties.width), height: (path.properties.height), context: context,color: UIColor.clear.cgColor, lineWidth: 30)
            }
            
            endForeGroundImageDraw()
        }
        
        func showPath(_ path:Polyline){
            let context = prepareForeGroundImageDraw()
            for index in 0...path.paths.count-1{
                if path.properties.color == 0 {
                    UIGraphicsGetCurrentContext()?.setBlendMode(CGBlendMode.clear)
                }
                let color = UIUtils.intToRGB(path.properties.color).cgColor
                
                drawPath(path.paths[index], width: (path.properties.width), height: (path.properties.height), context: context,color:color,lineWidth: CGFloat(path.properties.weight))
            }
            
            endForeGroundImageDraw()
        }
        
        func showIcon(_ jsonData:JSON){
            let iconModel = Icon(json: jsonData)
            let height:Float = iconModel!.sicon.height
            let width:Float = iconModel!.sicon.width
            let x:Double = iconModel!.sicon.x
            let y:Double = iconModel!.sicon.y
            let x2:Double = iconModel!.sicon.x2
            let y2:Double = iconModel!.sicon.y2
            let rid:Int = iconModel!.sicon.rid
            
            
            //ID 21 is vertical line
            if rid == 21 {
                if x <= x2 {
                    drawTransverseLine(x,y: y,x2: x2,y2: y,width:width,height: height)
                }else{
                    drawTransverseLine(x2,y: y2,x2: x,y2: y2,width:width,height: height)
                }
                return
            }
            
            //ID 22 is rectangle
            if rid == 22 {
                drawRect(x,y: y,x2: x2,y2: y2,width:width,height: height)
                return
            }
            
            //ID 24 is circle/ellipse
            if rid == 24 {
                drawCircle(x,y: y,x2: x2,y2: y2,width:width,height: height)
                return
            }
            
            //if let s: String  = Decoder.decode(key: "sicon.icon")(jsonData){
            if let s: String  = iconModel!.sicon.icon {
                let icon = UIUtils.base64ToImage(String(s))
                if icon == nil{
                    return
                }
                
                var point:CGPoint
                if  let ext: SiconExt = iconModel!.sicon.ext {
                    let client:String = ext.client
                    if(client == "ios"){
                        let px:Double = ext.x1
                        let py:Double = ext.y1
                        point = CGPoint(x: CGFloat(px), y: CGFloat(py))
                        point = UIUtils.pixelPostionToPoints(point, orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
                    }else{
                        //TODO: we may not want to do this.
                        point = UIUtils.pixelPostionToPoints(CGPoint( x: CGFloat(x), y: CGFloat(y) ), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
                        
                        let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
                        point = tuneYPositionForAndroidToolbar(point, factor: 16,height: CGFloat(height),yRatio:ratio.yRatio)
                    }
                }else{
                    point = UIUtils.pixelPostionToPoints(CGPoint( x: CGFloat(x), y: CGFloat(y) ), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
                    let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
                    point = tuneYPositionForAndroidToolbar(point, factor: 16,height: CGFloat(height),yRatio: ratio.yRatio)
                }
                
                let size = icon!.size;
                
                let newWidth = size.width * bounds.width / CGFloat(width)
                let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
                
                //TODO: adjust the y position for the buttons on the top??? Fixe me!
                let tunedPosition  = tunePosition(point, height: CGFloat(height),xRatio: ratio.xRatio,yRatio: ratio.yRatio)
                
                //TODO: not really sure why we need adjust the x positio for icon. Work around for now.  Fixe me!
                drawer?.drawReceivedIcon(icon!, rect: CGRect(x: tunedPosition.x-7, y: tunedPosition.y, width: newWidth, height: newWidth))
                //icon!.drawInRect(CGRectMake(tunedPosition.x-7, tunedPosition.y, newWidth, newWidth))
            }
        }
        
        func drawCircle(_ x:Double,y:Double,x2:Double,y2:Double,width:Float,height:Float){
//            let context = prepareForeGroundImageDraw()
//            CGContextSetLineWidth(context, 1)
//            CGContextSetStrokeColorWithColor(context,
//                                             UIColor.redColor().CGColor)
            
            let rectangle = calcRect(x,y: y,x2: x2,y2: y2,width: width,height: height)
            drawer?.drawReceivedCircle(rectangle)
//            CGContextAddEllipseInRect(context, rectangle)
//            CGContextStrokePath(context)
//            
//            endForeGroundImageDraw()
        }
        
        func drawRect(_ x:Double,y:Double,x2:Double,y2:Double,width:Float,height:Float){
//            let context = prepareForeGroundImageDraw()
//            CGContextSetLineWidth(context, 1)
//            CGContextSetStrokeColorWithColor(context,
//                                             UIColor.redColor().CGColor)
            
            let rectangle = calcRect(x,y: y,x2: x2,y2: y2,width: width,height: height)
            drawer?.drawReceivedRect(rectangle)
//            CGContextAddRect(context, rectangle)
//            CGContextStrokePath(context)
//            
//            endForeGroundImageDraw()
        }
        
        func calcRect(_ x:Double,y:Double,x2:Double,y2:Double,width:Float,height:Float) -> CGRect{
            
            
            let point = UIUtils.pixelPostionToPoints(CGPoint( x: CGFloat(x), y: CGFloat(y) ), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
            let point2 = UIUtils.pixelPostionToPoints(CGPoint( x: CGFloat(x2), y: CGFloat(y2) ), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
           
            let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
            
            let tunedPoint = tunePosition(point, height: CGFloat(height), xRatio:ratio.xRatio, yRatio: ratio.yRatio)
            
            let tunedPoint2 = tunePosition(point2, height: CGFloat(height), xRatio:ratio.xRatio, yRatio: ratio.yRatio)
            
            let width =  tunedPoint2.x - tunedPoint.x
            let height = tunedPoint2.y - tunedPoint.y
            
            
            
            return  CGRect(x: CGFloat(tunedPoint.x ), y: CGFloat(tunedPoint.y), width: CGFloat(width), height: CGFloat(height))
        }
        
        func drawTransverseLine(_ x:Double,y:Double,x2:Double,y2:Double,width:Float,height:Float){
//            let context = prepareForeGroundImageDraw()
//            
//            CGContextSetLineWidth(context, 1);
//            
//            CGContextSetStrokeColorWithColor(context,
//                                             UIColor.redColor().CGColor)
//            CGContextSetLineWidth(context, 1)
            
            let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
            
            let point = UIUtils.pixelPostionToPoints(CGPoint( x: CGFloat(x), y: CGFloat(y) ), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
            let tunedPoint = tunePosition(point, height: CGFloat(height), xRatio: ratio.xRatio, yRatio: ratio.yRatio)
            
            //CGContextMoveToPoint(context, CGFloat(tunedPoint.x ),CGFloat(tunedPoint.y));
            
            let point2 = UIUtils.pixelPostionToPoints(CGPoint( x: CGFloat(x2), y: CGFloat(y2) ), orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
            let tunedPoint2 = tunePosition(point2, height: CGFloat(height), xRatio: ratio.xRatio, yRatio: ratio.yRatio)
            drawer?.drawReceivedLine(tunedPoint, endPosition: tunedPoint2, color: UIColor.red, width: 1)
//            
//            CGContextAddLineToPoint(context,CGFloat(tunedPoint2.x), CGFloat(tunedPoint2.y));
//            
//            CGContextStrokePath(context);
//            
//            endForeGroundImageDraw()
            
        }
        
        func tuneYPositionForAndroidToolbar(_ point:CGPoint, factor:CGFloat, height:CGFloat,yRatio:CGFloat) ->CGPoint{
//            let ratio = scaleBackGroundImage(CGRectMake(0, 0, CGFloat(width), CGFloat(height)))
            let newY = point.y -  factor * ( bounds.height * UIScreen.main.scale / CGFloat (height)) * yRatio
            
            return CGPoint(x: point.x, y: newY )
            
        }
        
        func detuneYPositionForAndroidToolbar(_ point:CGPoint, factor:CGFloat, height:CGFloat,yRatio:CGFloat) ->CGPoint{
            let newY = point.y +  factor * ( bounds.height * UIScreen.main.scale / CGFloat (height)) * yRatio
            
            return CGPoint(x: point.x, y: newY )
            
        }
        
        
        func drawPath(_ path:Path,width:Float,height:Float,context:CGContext, color:CGColor,lineWidth:CGFloat){
            if path.path.count>0{
                
                context.setLineWidth(lineWidth);
                context.setLineCap(CGLineCap.round)
                context.setShouldAntialias(true)
                context.setAllowsAntialiasing(true)
                
                let rect = CGPoint(x: CGFloat(path.path[0].x), y: CGFloat(path.path[0].y))
                
                let newPoint = UIUtils.pixelPostionToPoints(rect, orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
                let ratio = scaleBackGroundImage(CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

                let tunedPosition  = tunePosition(newPoint, height: CGFloat(height),xRatio: ratio.xRatio,yRatio: ratio.yRatio)

                
                context.move(to: CGPoint(x: tunedPosition.x, y: tunedPosition.y))
                if path.path.count > 1{
                    
                    for index in 1...path.path.count-1{
                        
                        let rect = CGPoint(x: CGFloat(path.path[index].x), y: CGFloat(path.path[index].y))
                        
                        let newPoint = UIUtils.pixelPostionToPoints(rect, orgSize: CGSize(width: CGFloat(width), height: CGFloat(height)),bounds: bounds)
                        //let ratio = scaleBackGroundImage(CGRectMake(0, 0, CGFloat(width), CGFloat(height)))
                        let tunedPosition  = tunePosition(newPoint, height: CGFloat(height),xRatio: ratio.xRatio,yRatio: ratio.yRatio)
                        
                        
                        context.addLine(to: CGPoint(x: tunedPosition.x, y: tunedPosition.y))
                        
                    }
                }
                let isNeon = AnnotationLayerDelegate.recognizeNeon(with: UIColor(cgColor: color))
                if isNeon {
                    AnnotationLayerDelegate.drawNeonShadow(context, color: color)
                }
                
                context.setStrokeColor(color);
                context.strokePath();
                
            }
        }
        
        func drawBackGroundImage(_ image:UIImage){
            receivedImage = image
            
            backgroundToScaledRect(image)

            hasBackground=true

            drawer!.drawImage(inRec: bounds.size,rect: scaledRect!, image: image, layer: backGroundLayer!)
            
        }
        
        func drawAnnotationLayer(_ image:UIImage){
            backgroundToScaledRect(image)
            
            drawer!.drawImage(inRec: bounds.size,rect: scaledRect!, image: image, layer: drawer?.layer)
        }
        
        func backgroundToScaledRect(_ image:UIImage) {
            let screenSize: CGRect = bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            
            let ratio = scaleBackGroundImage(CGRect(x: 0,y: 0, width: image.size.width,height: image.size.height))
            scaledRect = CGRect(x: 0, y: 0, width: screenWidth * ratio.xRatio, height: screenHeight * ratio.yRatio)
        }
        
        //        //TODO:this func hasn't been tested. We're using default zoom from scroll view now.
        //        func redrawLayers(rect:CGRect){
        //            let backGroundImage = backGroundLayer.contents as! CGImage
        //
        //            let newImage = UIImage(CGImage: backGroundImage)
        //            backGroundLayer.frame = rect
        //
        //            drawImageInRec(rect.size,rect: rect, image: newImage, layer: backGroundLayer)
        //
        //        }
        
    }
