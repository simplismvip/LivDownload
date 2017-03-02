//
//  UIUtils.swift
//  PageShare
//
//  Created by Q.S Wang on 24/05/2016.
//  Copyright © 2016 Oneplus Smartware. All rights reserved.
//

import UIKit

class  UIUtils: NSObject {
    static func saveImageToFile(_ image:UIImage!, path:String)
    {
        let presentation = UIImagePNGRepresentation(image)
        try? presentation?.write(to: URL(fileURLWithPath: path), options: [.atomic])
    }
    

    static func merge2Image(_ backImage:UIImage, foreImage:UIImage) -> UIImage{
        
        let size = backImage.size

        let scale = UIUtils.getScale();
        if(scale > 1.5){
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
        }else{
            UIGraphicsBeginImageContext(size)
        }
        
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        backImage.draw(in: areaSize)
        
        foreImage.draw(in: areaSize)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func cropImage(_ image:UIImage, size:CGSize) -> UIImage
    {
        var ratio:CGFloat?
        if image.size.width >= size.width {
            ratio  = image.size.width / size.width
        } else {
            ratio  = size.width / image.size.width
        }
        
        let imageHeight = size.height * ratio!
        
        let targetDiff = abs((image.size.height - imageHeight ) / 2)
        
        let drawRect = CGRect(x: 0 , y: targetDiff , width: image.size.width, height: image.size.height - targetDiff * 2  )
        // Create Image Ref on Image
        let imageRef = image.cgImage?.cropping(to: drawRect)
        
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage;
    
    }
    
    static func stretchImage(_ image:UIImage, rect:CGRect) -> UIImage
    {
        let screenSize = UIScreen.main.bounds.size

        var ratio:CGFloat?
        var height:CGFloat?
        if image.size.width >= screenSize.width{
            ratio  = image.size.width / screenSize.width
        } else {
            ratio  = screenSize.width / image.size.width
        }
        
        if image.size.width >= screenSize.width && image.size.height > screenSize.height {
            height = (image.size.height-100) * ratio!
        }else{
            //NOTE: the 100 is for the toolbar on android. Techincally this shouldn't be here, but is a hack work around!!!.
            height = (screenSize.height-100) * ratio!
        }
        
        let diff = abs((height! - image.size.height) / 2)
        
        let targetSize = CGSize(width: image.size.width, height: height!)
        
        let scale = UIUtils.getScale();
        if(scale > 1.5){
            UIGraphicsBeginImageContextWithOptions(targetSize, false, scale)
        }else{
            UIGraphicsBeginImageContext(targetSize)
        }
        
//        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)

        let targetRect = CGRect(x: 0, y: diff, width: image.size.width , height: image.size.height)
        
        image.draw(in: targetRect)
        
        let targetImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return targetImage!
        
    }
    
    static func  printAnnotationLayer(_ forelayer:CALayer?,size:CGSize) -> UIImage
    {
        let scale = UIUtils.getScale();
        if(scale > 1.5){
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
        }else{
            UIGraphicsBeginImageContext(size)
        }
        
        //must set clear color, otherwise the image is not transparent
        forelayer!.backgroundColor = UIColor.clear.cgColor
        forelayer!.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return outputImage!;
    }
    
    static func changePDFViewBounds(_ viewRect: CGRect) -> CGRect{
        var newRect = viewRect
//        if (Constants.IS_IPAD) {
            newRect.origin.y = 64;   //防止navigation挡住PDF
            newRect.size.height -= 64;  //由于PDF往下移动64个单位,不减则底部会伸出去
//        }
        return newRect
    }
    
    static func removeAllViewFromWindow(){
        let window = Constants.appDelegate.window
        for subview in window!.subviews {
            subview.removeFromSuperview()
        }
        
    }
    
//    static func logout(){
//        removeAllViewFromWindow()
//        
//        let registerVC = RegistWebViewController()
//        let window = Constants.appDelegate.window
//        window?.rootViewController=registerVC
//    }
    
    static func PointsToPixel (_ pt:CGFloat,scale:CGFloat) ->CGFloat {
        let pointsPerInch:CGFloat = 72.0
        
        var pixelPerInch : CGFloat
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            pixelPerInch = 132 * scale;
        } else if (UI_USER_INTERFACE_IDIOM() == .phone) {
            pixelPerInch = 163 * scale;
        } else {
            pixelPerInch = 160 * scale;
        }
        
        let px = pt * pixelPerInch / pointsPerInch;
        
        return px;
    }
    
    static func pixelToPoints (_ px:CGFloat,scale:CGFloat) ->CGFloat {
        let pointsPerInch:CGFloat = 72.0
        
        var pixelPerInch : CGFloat
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            pixelPerInch = 132 * scale;
        } else if (UI_USER_INTERFACE_IDIOM() == .phone) {
            pixelPerInch = 163 * scale;
        } else {
            pixelPerInch = 160 * scale;
        }
        let result = px * pointsPerInch / pixelPerInch
        
        return result;
    }
    
    static func pixelPostionToPoints(_ pt:CGPoint,orgSize:CGSize,bounds:CGRect) -> CGPoint{
        
        let screenSize = bounds
        let widthpx = screenSize.width * UIScreen.main.scale
        let heightPx = screenSize.height * UIScreen.main.scale
        
        let orgWidth = orgSize.width
        let orgHeight = orgSize.height
        
        let scalex = widthpx / orgWidth
        let scaley = heightPx / orgHeight
        
        let x = pt.x * scalex / UIScreen.main.scale
        let y = pt.y * scaley / UIScreen.main.scale
        
        return CGPoint(x: x, y: y)
        
        
    }
    
    static func intToRGB(_ rgbValue:Int) -> UIColor{
        return UIColor(
            red: CGFloat((rgbValue >> 16)  & 0xff) / 255.0,
            green: CGFloat((rgbValue >> 8 ) &  0xff) / 255.0,
            blue: CGFloat(rgbValue & 0xff) / 255.0,
            alpha: CGFloat((rgbValue>>24) & 0xff))
    }
    
    
    static func RGBToInt(_ color:UIColor)->Int32{
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let iRed = Int32(r * 255.0)
        let iGreen = Int32(g * 255.0)
        let iBlue = Int32(b * 255.0)
        let iAlpha = Int32(a * 255.0)

        
        //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
        let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
        return rgb
    }
    
    
    //    static func scaleToCurrentScreen(rect:CGRect,orgWidth:Float,orgHeight:Float,xRatio:CGFloat,yRatio:CGFloat) -> CGRect{
    //        //let screenSize: CGRect = UIScreen.mainScreen().bounds
    //
    //        let pointX = pixelToPoints(rect.origin.x,scale: 2)
    //        let pointY = pixelToPoints(rect.origin.y,scale: 2)
    //
    //        let width = pixelToPoints(CGFloat(orgWidth),scale: 2)
    //        let height = pixelToPoints(CGFloat(orgHeight),scale:1)
    //
    //
    //
    //        //TODO: still need research on the scale factor of different iOS devices.
    ////        let sc = UIScreen.mainScreen().scale
    //
    ////         let screenSize = mainView.bounds
    ////
    ////        let screenWidth = CGFloat(screenSize.width / CGFloat(sc))
    ////
    ////        let screenHeight = CGFloat(screenSize.height / CGFloat(sc))
    //
    ////        let scalex = Double(screenSize.width) / Double( width)
    ////        let scaley = Double(screenSize.height) / Double( height )
    ////
    ////         pointX = CGFloat(pointX * CGFloat(scalex))
    ////         pointY = CGFloat(pointY * CGFloat(scaley))
    ////         width = CGFloat(width * CGFloat(scalex))
    ////         height = CGFloat(height * CGFloat(scalex))
    //
    //        return CGRectMake(pointX, pointY,width,height)
    //    }
    
    static func resizeImage( _ image:UIImage, size:CGSize) -> UIImage
    {
        let width = size.width;
        let ratio =  image.size.height / image.size.width;
        let height = width * ratio;
        
        UIGraphicsBeginImageContext( CGSize(width: width, height: height));
        image.draw(in: CGRect(x: 0,y: 0,width: width,height: height));
        let realfrontImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return realfrontImage!;
    }
    
    
    static func base64ToImage(_ imageStr : String) ->UIImage?{
        let data  = Data(base64Encoded: imageStr, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        if(data != nil && data!.count != 0){
            let  image: UIImage = UIImage(data: data!)!
            return image
        }
        return nil
    }
    
    static func getScale() -> CGFloat{
        var scale:CGFloat = 1.0;
        let tmp = UIScreen.main.scale
        
        
        if (tmp > 1.5) {
            scale = 2.0;
        }
        return scale;
    }
    
    static func shareImage(_ image:UIImage) -> UIImage{
        return shareImage(image, valve: 2.304e+06)
    }
    
    static func reduceSize(_ originSize:CGSize)->CGSize
    {
        var size =  originSize
        
        let total = size.height * size.width
        
        if ( total > 2.304e+06){
            let ratio = total / 2.304e+06
            let width = size.width / ratio
            let height = size.height / ratio
            size =  CGSize(width: width,height: height)
        }
        
        return size
    }
    
    static func shareImage(_ image:UIImage,valve:CGFloat ) -> UIImage
    {
        var newImage = image
        let size = image.size
        
        let total = size.height * size.width
        
        if ( total > valve){
            let ratio = total / valve
            let width = image.size.width / ratio
            let height = image.size.height / ratio
            let newSize = CGSize(width: width, height: height)
            
            newImage = resizeImage(image, size: newSize)
        }
        
        return newImage

    }
    
    static func stretchAnnotation(_ image:UIImage,size:CGSize) -> UIImage{
        let  newimage = cropImage(image, size: size)
        let resizedimage = resizeImage(newimage, size:size)
        return resizedimage

    }
    
//    func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
//        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
//        let imageRef = image.CGImage
//        
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        
//        // Set the quality level to use when rescaling
//        CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
//        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
//        
//        CGContextConcatCTM(context, flipVertical)
//        // Draw into the context; this scales the image
//        CGContextDrawImage(context, newRect, imageRef)
//        
//        let newImageRef = CGBitmapContextCreateImage(context)! as CGImage
//        let newImage = UIImage(CGImage: newImageRef)
//        
//        // Get the resized image from the context and a UIImage
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }

    
    static func getSelectedTabbaritemNav(_ number :Int)->UINavigationController{

        let vc = UIApplication.shared.keyWindow?.rootViewController
        
        let view = vc?.view.subviews[0]
        
        let tabbar = view?.next as! UITabBarController
        
        let navArr = tabbar.childViewControllers
     
        return navArr[number] as! UINavigationController
    }
    
   
    
}
