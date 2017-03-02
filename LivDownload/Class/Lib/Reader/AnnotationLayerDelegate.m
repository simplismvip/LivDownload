//
// Created by: Q.S.
//
//

#import "AnnotationLayerDelegate.h"

@implementation AnnotationLayerDelegate
{
    CGContextRef lineContext;
}

- (instancetype) initWithView:(CALayer *)layer
{
    self = [super init];
    if (!self) return nil;
    
    _layer = layer;
    
    return self;
}

- (CGContextRef)drawOriginalImage
{
    CGFloat scale = [UIUtils getScale];
    //TODO:不注释以下 if scale代码,解决PDF上画text时有点模糊,但有可能周晓丽的手机崩溃
    if(scale > 1.5){
        UIGraphicsBeginImageContextWithOptions(_layer.frame.size, false, scale);
    }else{
        UIGraphicsBeginImageContext(_layer.frame.size);
    }
    
    //UIGraphicsBeginImageContext(_layer.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image = (__bridge CGImageRef)(_layer.contents);
    
    if(image != nil){
        UIImage *uimage = [[UIImage alloc] initWithCGImage:image];
        
        [uimage drawInRect:CGRectMake(0, 0, _layer.frame.size.width, _layer.frame.size.height)];
        
    }
    
    return context;
}

- (void)mergeNewImage
{
    UIImage* newforeGroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _layer.contents = (__bridge id _Nullable)(newforeGroundImage.CGImage);
}

+ (BOOL) recognizeNeonWithColor: (UIColor*) color
{
    CGFloat red, green, blue, alpha;
    [color getRed: &red green: &green blue: &blue  alpha: &alpha];
    return [self recognizeNeonWithValues:red greenValue:green blueValue:blue];
}

+ (BOOL) recognizeNeonWithValues: (CGFloat) redValue greenValue:(CGFloat)greenValue blueValue:(CGFloat)blueValue
{
    if(redValue>=1 && greenValue<=0.3 && blueValue>=0.55){
        return YES;
    }
    
    return NO;
}

+ (void) drawNeonShadow: (CGContextRef)context color:(CGColorRef) color
{
    CGContextSetShadowWithColor(context, CGSizeMake(3.0, 3.0), 6.0, color);
}

//TODO need move these logic out
-(void) drawImage:(UIImage*) image position:(CGPoint) point
{
    [self drawOriginalImage];
    
    int scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(point.x, point.y, image.size.width/scale, image.size.height/scale);

    [image drawInRect:rect];
    
    [self mergeNewImage];
    
}

- (void) drawAnnotationImage: (UIImage*) image
{
   [self drawOriginalImage];
    

    CGRect rect =  CGRectMake(0, 0, image.size.width,image.size.height);
    
    [image drawInRect:rect];
//    CGContextTranslateCTM(context, 0.0f, _view.bounds.size.height); CGContextScaleCTM(context, 1.0f, -1.0f);
//    CGContextDrawImage(context, , newImage.CGImage);
    [self mergeNewImage];
    
}

//end TODO

- (UIImage*) drawCustomImage:(CGSize)size
{
    CGFloat scale = [UIUtils getScale];
    if(scale > 1.5){
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    
    // Setup our context
    //            UIGraphicsBeginImageContextWithOptions(size, false, 0)
    
    // Drawing complete, retrieve the blank image and cleanup
    UIImage* newforeGroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newforeGroundImage;
    
}

- (void)showBlanckImage
{
    UIImage* newforeGroundImage = [self drawCustomImage:_layer.frame.size];
    _layer.contents = (__bridge id _Nullable)(newforeGroundImage.CGImage);
}

- (void)drawImageInRec:(CGSize)viewSize rect:(CGRect)rect image:(UIImage*)image layer:(CALayer*)layer
{
    CGFloat scale = [UIUtils getScale];
    if(scale > 1.5){
        UIGraphicsBeginImageContextWithOptions(viewSize, false, scale);
    }else{
        UIGraphicsBeginImageContext(viewSize);
    }
    //UIGraphicsBeginImageContextWithOptions(viewSize, false, 0)
    [image drawInRect:rect];
    UIImage* newforeGroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    layer.contents = (__bridge id _Nullable)(newforeGroundImage.CGImage);
    
}

- (void)drawReceivedText:(NSString*)text position:(CGPoint)position size:(CGFloat)size color:(UIColor*)color {
    [self drawText:text position:position color:color textSize:size];
}

- (void)drawReceivedIcon:(UIImage*)icon rect:(CGRect)rect {
    [self drawOriginalImage];
    [icon drawInRect:rect];
    [self mergeNewImage];
}

- (void)drawReceivedLine:(CGPoint)startPosition endPosition:(CGPoint)endPosition color:(UIColor*) color width:(int) width
{
    CGContextRef context = [self drawOriginalImage];
    
    CGContextMoveToPoint(context, startPosition.x, startPosition.y);
    CGContextAddLineToPoint(context, endPosition.x, endPosition.y);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, width);
    
    CGFloat red, green, blue, alpha;
    [color getRed: &red green: &green blue: &blue  alpha: &alpha];
    CGContextSetRGBStrokeColor(context, red, green,blue, alpha);
    
    CGContextStrokePath(context);
    [self mergeNewImage];
}

- (void)drawReceivedRect:(CGRect)rectangle {
    CGContextRef context = [self drawOriginalImage];
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    
    [self mergeNewImage];
}

- (void)drawReceivedCircle:(CGRect)rectangle {
    CGContextRef context = [self drawOriginalImage];
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context,[UIColor redColor].CGColor);
    
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
    
   [self mergeNewImage];
}

-(void) drawText:(NSString *)text position:(CGPoint)point color:(UIColor *)color textSize:(CGFloat)textSize

{
    [self drawOriginalImage];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont systemFontOfSize:textSize],NSFontAttributeName, nil];
    [text drawAtPoint:point withAttributes:attributes];
    
    [self mergeNewImage];
    
}

- (void)startDrawLine
{
    lineContext = [self drawOriginalImage];
}

- (void)endDrawLine
{
    UIGraphicsEndImageContext();
}

- (void) drawLine: (CGPoint) fromPoint toPoint:(CGPoint) toPoint color:(UIColor*) color width:(int) width
{
    //TODO: 触摸移动时不频繁调用drawOriginalImage似乎响应的点多了
//    CGContextRef context = [self drawOriginalImage];
    [self drawLine:lineContext fromPoint:fromPoint toPoint:toPoint color:color width:width];
//    [self mergeNewImage];
    UIImage* newforeGroundImage = UIGraphicsGetImageFromCurrentImageContext();
    _layer.contents = (__bridge id _Nullable)(newforeGroundImage.CGImage);
}

- (void)drawLine:(CGContextRef) context fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint color:(UIColor *)color width:(int)width
{
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetShouldAntialias(context, YES);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, width);
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    
    CGFloat red, green, blue, alpha;
    
    [color getRed: &red green: &green blue: &blue  alpha: &alpha];
    
    BOOL isNeon = [AnnotationLayerDelegate recognizeNeonWithValues:red greenValue:green blueValue:blue];
    if(isNeon){
        [AnnotationLayerDelegate drawNeonShadow:context color:color.CGColor];
    }
    
    CGContextSetRGBStrokeColor(context, red, green,blue, alpha);
    
    if(color == [UIColor clearColor]){
        CGContextSetBlendMode(UIGraphicsGetCurrentContext( ),kCGBlendModeClear);
    }
    
    CGContextStrokePath(context);
}

-(void) drawCircle: (CGPoint) fromPoint toPoint:(CGPoint) toPoint color:(UIColor*) color linewidth:(int) linewidth
{
    CGContextRef context = [self drawOriginalImage];
    
    
    CGContextSetLineWidth(context, linewidth);
    
    CGFloat red, green, blue, alpha;
    
    [color getRed: &red green: &green blue: &blue  alpha: &alpha];
    CGContextSetRGBStrokeColor(context, red, green,blue, alpha);
    
    double width = fabs(fromPoint.x - toPoint.x);
    double height = fabs(fromPoint.y - toPoint.y);
    CGRect rectangle = CGRectMake(fromPoint.x,fromPoint.y,width,height);
    
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);
    
    [self mergeNewImage];
}

-(void) drawRect: (CGPoint) fromPoint toPoint:(CGPoint) toPoint color:(UIColor*) color linewidth:(int) linewidth
{
    CGContextRef context = [self drawOriginalImage];
    
    
    CGContextSetLineWidth(context, linewidth);
    
    CGFloat red, green, blue, alpha;
    
    [color getRed: &red green: &green blue: &blue  alpha: &alpha];
    
    CGContextSetRGBStrokeColor(context, red, green,blue, alpha);
    
    double width = fabs(fromPoint.x - toPoint.x);
    double height = fabs(fromPoint.y - toPoint.y);
    CGRect rectangle = CGRectMake(fromPoint.x,fromPoint.y,width,height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    
    [self mergeNewImage];
}

- (void)drawLayer:(CALayer *)layer
        inContext:(CGContextRef)context
{
    //    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // White
    
    //    CGContextFillRect(context, CGContextGetClipBoundingBox(context)); // Fill
    
    //NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(CGContextGetClipBoundingBox(context)));
    
    //    CGContextTranslateCTM(context, 0.0f, _view.bounds.size.height);
    
    // CGContextScaleCTM(context, 1.0f, 1.0f);
    
    //    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_view.PDFPageRef, kCGPDFCropBox, _view.bounds, 0, true));
    
    //    CGContextBeginPath (context);
    //
    //        CGContextMoveToPoint(context, 0,0);
    //        CGContextAddLineToPoint(context, layer.frame.size.width-10 ,layer.frame.size.height-10);
    //
    //    CGContextStrokePath(context);
    
}

@end
