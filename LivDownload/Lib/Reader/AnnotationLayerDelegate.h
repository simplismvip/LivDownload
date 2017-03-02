//
// Created by: Leslie Godwin (leslie.godwin@gmail.com)
//
// This example demonstrates how to apply implicit animations to additional layers added to your view.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AnnotationLayerDelegate : NSObject

- (instancetype) initWithView:(CALayer *)layer;
+ (BOOL) recognizeNeonWithColor: (UIColor*) color;
+ (BOOL) recognizeNeonWithValues: (CGFloat) redValue greenValue:(CGFloat)greenValue blueValue:(CGFloat)blueValue;
+ (void) drawNeonShadow: (CGContextRef)context color:(CGColorRef) color;
- (void) drawLine: (CGPoint) fromPoint toPoint:(CGPoint) toPoint color:(UIColor*) color width:(int) width;
- (void)startDrawLine;
- (void)endDrawLine;
- (void) drawImage:(UIImage*) image position:(CGPoint) point;
- (void) drawText:(NSString*) text position:(CGPoint) point color:(UIColor*)color textSize:(CGFloat)textSize;
- (void) drawRect: (CGPoint) fromPoint toPoint:(CGPoint) toPoint color:(UIColor*) color linewidth:(int) linewidth;
- (void) drawCircle: (CGPoint) fromPoint toPoint:(CGPoint) toPoint color:(UIColor*) color linewidth:(int) linewidth;
- (void) drawAnnotationImage: (UIImage*) image;
- (UIImage*) drawCustomImage:(CGSize)size;
- (void)showBlanckImage;
- (void)drawImageInRec:(CGSize)viewSize rect:(CGRect)rect image:(UIImage*)image layer:(CALayer*)layer;
- (void)drawReceivedText:(NSString*)text position:(CGPoint)position size:(CGFloat)size color:(UIColor*)color;
- (void)drawReceivedIcon:(UIImage*)icon rect:(CGRect)rect;
- (void)drawReceivedLine:(CGPoint)startPosition endPosition:(CGPoint)endPosition color:(UIColor*) color width:(int) width;
- (void)drawReceivedRect:(CGRect)rectangle;
- (void)drawReceivedCircle:(CGRect)rectangle;


@property (nonatomic, strong) CALayer *layer;
@end
