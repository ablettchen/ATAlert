//
//  ATAlert+Make.h
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import <ATAlert/ATAlert.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATAlert (Make)

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message;

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message
                       actions:(nonnull NSArray *)actions;

+ (instancetype)alertWithMessage:(nonnull NSString *)message
                         actions:(nonnull NSArray *)actions;

@end

NS_INLINE ATAlert *ATAlertMake(NSString *__nullable title,
                               NSString *__nonnull message,
                               NSArray <ATAlertLink *>*__nonnull actions) {
    return [ATAlert alertWithTitle:title message:message actions:actions];
}

NS_ASSUME_NONNULL_END
