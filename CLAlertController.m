//
//  CLAlertController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAlertController.h"
#import <UIKit/UIKit.h>



#ifdef __IPHONE_8_0

@interface CLAlertController ()
@property (nonatomic, strong) UIAlertController* cAlertViewController;

#else

@interface CLAlertController () <UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UIAlertView* cAlertView;
@property (nonatomic, strong) UIActionSheet* cActionSheet;
#endif

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;
@property (nonatomic) CLAlertControllerStyle style;


@end

@implementation CLAlertController

+ (CLAlertController *) alertControllerWithTitle:(NSString*)title message:(NSString*)message style:(CLAlertControllerStyle)style delegate:(id <CLAlertControllerDelegate>)delegate {
    
    CLAlertController* alertController = [[CLAlertController alloc] init];
    alertController.title = title;
    alertController.message = message;
    alertController.style = style;
    alertController.delegate = delegate;
    
    return alertController;
}

- (void) show {
    
    if (self.cancelButtonIndex < 0 || self.cancelButtonIndex >= self.buttonItems.count ||
        self.destructiveButtonIndex < 0 || self.destructiveButtonIndex >= self.buttonItems.count) {
        NSAssert(true, @"cancel or destructive button idx is valid ");
    }

#ifdef __IPHONE_8_0
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:(UIAlertControllerStyle)self.style];
    
    __weak CLAlertController* __weakSelf = self;
    [self.buttonItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        
        UIAlertActionStyle actionStype = (self.cancelButtonIndex == idx)?UIAlertActionStyleCancel:((self.destructiveButtonIndex == idx)?UIAlertActionStyleDestructive:UIAlertActionStyleDefault);
        UIAlertAction* action = [UIAlertAction actionWithTitle:obj style:actionStype handler:^(UIAlertAction * _Nonnull action) {
            [__weakSelf actionSelectWithIdex:idx];
        }];
        
        [alertController addAction:action];
        
    }];
    
    self.cAlertViewController = alertController;
    alertController = nil;
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        [((UIViewController*)self.delegate) presentViewController:self.cAlertViewController animated:YES completion:nil];
    }
    
    
#else
    
    if (self.style == CLAlertControllerStyleAlert) {
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        
        [self.buttonItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [alertView addButtonWithTitle:obj];
        }];
        
        alertView.cancelButtonIndex = self.cancelButtonIndex;
        
        self.cAlertView = alertView;
        alertView = nil;
        
        [self.cAlertView show];
        
    } else if (self.style == CLAlertControllerStyleActionSheet) {
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:self.title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        [self.buttonItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [actionSheet addButtonWithTitle:obj];
        }];
        
        actionSheet.cancelButtonIndex = self.cancelButtonIndex;
        actionSheet.destructiveButtonIndex = self.destructiveButtonIndex;
        
        self.cActionSheet = actionSheet;
        actionSheet = nil;
        
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [self.cActionSheet showInView:((UIViewController*)self.delegate).view];
        }
    }

#endif
    
}


#ifdef __IPHONE_8_0

- (void) actionSelectWithIdex:(NSInteger)idx {
    if ([self.delegate respondsToSelector:@selector(alertController:SelectIndex:)]) {
        [self.delegate alertController:self SelectIndex:idx];
    }
}

#else

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([self.delegate respondsToSelector:@selector(alertController:SelectIndex:)]) {
        [self.delegate alertController:self SelectIndex:idx];
    }
}
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([self.delegate respondsToSelector:@selector(alertController:SelectIndex:)]) {
        [self.delegate alertController:self SelectIndex:idx];
    }
}

#endif

- (void)dealloc {
    
    self.delegate = nil;

#ifdef __IPHONE_8_0
    self.cAlertViewController = nil;
    
#else
    self.cAlertView = nil;
    self.cActionSheet = nil;
    
#endif
    
    
    
}


@end



