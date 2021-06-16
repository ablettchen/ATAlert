//
//  UIView+ATAlertView.h
//  ATAlertView
//  https://github.com/ablettchen/ATAlertView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ATAlertView;
@interface UIView (ATAlertView)
- (void)showAlert:(ATAlertView *)alert;

- (void)alert_filletedCornerWithRadii:(CGSize)cornerRadii roundingCorners:(UIRectCorner)roundingCorners;

@end

NS_ASSUME_NONNULL_END
