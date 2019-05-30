//
//  UIView+ATAlert.m
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import "UIView+ATAlert.h"
#import "ATAlert.h"

@implementation UIView (ATAlert)

- (void)showAlert:(ATAlert *)alert {
    [alert showIn:self];
}

@end
