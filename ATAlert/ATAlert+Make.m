//
//  ATAlert+Make.m
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import "ATAlert+Make.h"
#import "ATAlert.h"

@implementation ATAlert (Make)

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message {
    ATAlertConf *conf = [ATAlertConf new];
    NSArray *actions = @[ATAlertHilightedActionMake(conf.actionOkText, nil)];
    return [ATAlert alertWithPreferredStyle:ATAlertStyleAlert title:title message:message actions:actions];
}

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message
                       actions:(nonnull NSArray *)actions {
    return [ATAlert alertWithPreferredStyle:ATAlertStyleAlert title:title message:message actions:actions];
}

+ (instancetype)alertWithMessage:(nonnull NSString *)message
                         actions:(nonnull NSArray *)actions {
    return [ATAlert alertWithPreferredStyle:ATAlertStyleAlert title:nil message:message actions:actions];
}

+ (instancetype)sheetWithMessage:(nonnull NSString *)message
                         actions:(nonnull NSArray *)actions {
    return [ATAlert alertWithPreferredStyle:ATAlertStyleSheet title:nil message:message actions:actions];
}

+ (instancetype)sheetWithActions:(nonnull NSArray *)actions {
    return [ATAlert alertWithPreferredStyle:ATAlertStyleSheet title:nil message:@"" actions:actions];
}

@end
