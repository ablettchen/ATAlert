//
//  ATAlertView+Make.m
//  ATAlertView
//  https://github.com/ablettchen/ATAlertView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATAlertView+Make.h"
#import "ATAlertView.h"

@implementation ATAlertView (Make)

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message {
    ATAlertConf *conf = [ATAlertConf new];
    NSArray *actions = @[ATAlertHilightedActionMake(conf.actionOkText, nil)];
    return [ATAlertView alertWithPreferredStyle:ATAlertStyleAlert title:title message:message actions:actions];
}

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message
                       actions:(nonnull NSArray *)actions {
    return [ATAlertView alertWithPreferredStyle:ATAlertStyleAlert title:title message:message actions:actions];
}

+ (instancetype)alertWithMessage:(nonnull NSString *)message
                         actions:(nonnull NSArray *)actions {
    return [ATAlertView alertWithPreferredStyle:ATAlertStyleAlert title:nil message:message actions:actions];
}

+ (instancetype)sheetWithMessage:(nonnull NSString *)message
                         actions:(nonnull NSArray *)actions {
    return [ATAlertView alertWithPreferredStyle:ATAlertStyleSheet title:nil message:message actions:actions];
}

+ (instancetype)sheetWithActions:(nonnull NSArray *)actions {
    return [ATAlertView alertWithPreferredStyle:ATAlertStyleSheet title:nil message:@"" actions:actions];
}

@end
