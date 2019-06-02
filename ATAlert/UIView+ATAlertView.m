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

@end
