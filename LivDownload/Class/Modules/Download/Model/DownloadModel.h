//
//  DownloadModel.h
//  DownloadTest
//
//  Created by JM Zhao on 2017/2/21.
//  Copyright © 2017年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadModel : NSObject
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *precent;
@property (nonatomic, copy) NSString *netSpeed;
@property (nonatomic, copy) NSString *playOrPause;
@property (nonatomic, copy) NSString *deleteBtn;
@property (nonatomic, assign) BOOL isComplete;
@end
