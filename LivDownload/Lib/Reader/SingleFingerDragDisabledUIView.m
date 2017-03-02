//
//  SingleFingerDragDisabledUIView.m
//
//  Created by Q.S Wang on 20/05/2016.
//

#import <Foundation/Foundation.h>
#import "SingleFingerDragDisabledUIView.h"

@implementation SingleFingerDragDisabledUIView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if( [event allTouches].count == 1){
        self.scrollEnabled = false;
    }else{
        self.scrollEnabled = true;
    }
    
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.scrollEnabled = false;
    [super touchesEnded:touches withEvent:event];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if( [event allTouches].count == 1){
        self.scrollEnabled = false;
    }else{
        self.scrollEnabled = true;
    }
    
    [super touchesMoved:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.scrollEnabled = false;
    [super touchesCancelled:touches withEvent:event];
}


@end
