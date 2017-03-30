//
//  UIAlertController+JMAlertController.m
//  PageShare
//
//  Created by JM Zhao on 16/7/1.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

#import "UIAlertController+JMAlertController.h"

@implementation UIAlertController (JMAlertController)

+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSArray<NSString *> *)actionTitles preferredStyle:(UIAlertControllerStyle)preferredStyle textFilfPlaceHolders:(NSArray<NSString *> *) placeholders  confirmHandel:(void(^)(NSArray <NSString *>* alterTextFs)) confirmHandel cancelHandel:(void(^)()) canelHander
{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (actionTitles.count==0||actionTitles==nil) {
        actionTitles = @[NSLocalizedString(@"net.pictoshare.pageshare.dialog.button.ok", ""), NSLocalizedString(@"net.pictoshare.pageshare.document.navgationbar.button.alert.cancel", "")];
    }
    
    // 确定
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:actionTitles.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandel) {
            NSMutableArray *temArr = [NSMutableArray array];
            [alertC.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [temArr addObject:obj.text];
            }];
            confirmHandel([temArr copy]);
        }
    }];
    
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitles.lastObject style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (canelHander) {
            canelHander();
        }
    }];
    
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    
    [placeholders enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholders[idx];
//            textField.keyboardType = UIKeyboardTypeASCIICapable;
        }];
        
    }];
    
    return alertC;
}

+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSArray<NSString *> *)actionTitles preferredStyle:(UIAlertControllerStyle)preferredStyle cloudcenter:(void(^)())cloudcenter friendshare:(void(^)())friendshare emailshare:(void(^)())emailshare
{
    
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (actionTitles.count==0||actionTitles==nil) {
        actionTitles = @[NSLocalizedString(@"net.pictoshare.pageshare.view.title.cloud", ""), NSLocalizedString(@"net.pictoshare.pageshare.sharebutton.alert.message", ""),NSLocalizedString(@"net.pictoshare.pageshare.pdfviewcontroller.shareto.email", ""),NSLocalizedString(@"net.pictoshare.pageshare.document.navgationbar.button.alert.cancel", "")];
    }
    
    // 云中心
    UIAlertAction *shureAction = [UIAlertAction actionWithTitle:actionTitles.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cloudcenter) {
            cloudcenter();
        }
    }];
    
    // 好友
    UIAlertAction *friendAction = [UIAlertAction actionWithTitle:actionTitles[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (friendshare) {
            friendshare();
        }
    }];
    
    //邮件
    UIAlertAction *emailAction = [UIAlertAction actionWithTitle:actionTitles[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (emailshare) {
            emailshare();
        }
    }];
    
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitles.lastObject style:UIAlertActionStyleDefault handler:nil];
    
    [alertC addAction:shureAction];
    [alertC addAction:friendAction];
    [alertC addAction:emailAction];
    [alertC addAction:cancelAction];
    return alertC;
}



+(UIAlertController *)alertControllerWithTitle:(NSString *)title preferredStyle:(UIAlertControllerStyle)preferredStyle confirmHandel:(void(^)()) confirmHandel
{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:preferredStyle];
    
    // 确定
    UIAlertAction *shureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"net.pictoshare.pageshare.alert.good.title", "") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandel) {
            
            confirmHandel();
        }
    }];
    
    [alertC addAction:shureAction];
    

    return alertC;
}


@end
