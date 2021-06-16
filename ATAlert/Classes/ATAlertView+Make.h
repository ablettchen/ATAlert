//
//  ATAlertView+Make.h
//  ATAlertView
//  https://github.com/ablettchen/ATAlertView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <ATAlert/ATAlertView.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATAlertView (Make)

+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nonnull NSString *)message;
+ (instancetype)alertWithTitle:(nullable NSString *)title message:(nonnull NSString *)message actions:(nonnull NSArray *)actions;
+ (instancetype)alertWithMessage:(nonnull NSString *)message actions:(nonnull NSArray *)actions;

+ (instancetype)sheetWithMessage:(nonnull NSString *)message actions:(nonnull NSArray *)actions;
+ (instancetype)sheetWithActions:(nonnull NSArray *)actions;

@end

NS_INLINE ATAlertView *ATAlertMake(NSString *__nullable title, NSString *__nonnull message, NSArray <ATAlertLink *>*__nonnull actions) {
    return [ATAlertView alertWithTitle:title message:message actions:actions];
}

NS_INLINE ATAlertAction *ATAlertActionMake(NSString *title, enum ATAlertActionStyle style, void(^__nullable handler)(ATAlertAction *action)) {
    return [ATAlertAction actonWithTitle:title style:style handler:handler];
}

NS_INLINE ATAlertAction *ATAlertNormalActionMake(NSString *title, void(^__nullable handler)(ATAlertAction *action)) {
    return ATAlertActionMake(title, ATAlertActionStyleNormal, handler);
}

NS_INLINE ATAlertAction *ATAlertHilightedActionMake(NSString *title, void(^__nullable handler)(ATAlertAction *action)) {
    return ATAlertActionMake(title, ATAlertActionStyleHilighted, handler);
}

NS_INLINE ATAlertAction *ATAlertDisabledActionMake(NSString *title, void(^__nullable handler)(ATAlertAction *action)) {
    return ATAlertActionMake(title, ATAlertActionStyleDisabled, handler);
}

NS_ASSUME_NONNULL_END
