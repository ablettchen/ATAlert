//
//  UIView+ATAlertView.m
//  ATAlertView
//  https://github.com/ablettchen/ATAlertView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "UIView+ATAlertView.h"
#import "ATAlertView.h"

@implementation UIView (ATAlertView)

- (void)showAlert:(ATAlertView *)alert {
    [alert showIn:self];
}

- (void)alert_filletedCornerWithRadii:(CGSize)cornerRadii roundingCorners:(UIRectCorner)roundingCorners {
    UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:[self bounds] byRoundingCorners:roundingCorners cornerRadii:cornerRadii];
    CAShapeLayer *fieldLayer = [CAShapeLayer new];
    fieldLayer.frame = [self bounds];
    fieldLayer.path = [fieldPath CGPath];
    self.layer.mask = fieldLayer;
}

@end
