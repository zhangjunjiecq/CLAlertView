//
//  CLAlertController.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLAlertController;
typedef NS_ENUM(NSInteger, CLAlertControllerStyle) {
    
    CLAlertControllerStyleActionSheet = 0,
    CLAlertControllerStyleAlert,
};


@protocol CLAlertControllerDelegate <NSObject>

@optional
- (void) alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index;

@end


@interface CLAlertController : NSObject

+ (CLAlertController *) alertControllerWithTitle:(NSString*)title message:(NSString*)message style:(CLAlertControllerStyle)style delegate:(id <CLAlertControllerDelegate>)delegate;

@property (nonatomic, strong) NSArray* buttonItems;

@property (nonatomic) NSInteger destructiveButtonIndex;

@property (nonatomic) NSInteger cancelButtonIndex;

@property (nonatomic, weak) id <CLAlertControllerDelegate> delegate;

- (void) show;

@end
