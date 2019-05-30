//
//  ATAlert.h
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ATAlertActionStyle) {
    ATAlertActionStyleDefault,
    ATAlertActionStyleHilighted,
    ATAlertActionStyleDisabled,
};

@interface ATAlertAction : NSObject

@property (nonnull, copy, nonatomic) NSString *title;
@property (assign, nonatomic) enum ATAlertActionStyle style;

+ (instancetype)actonWithTitle:(nonnull NSString *)title
                         style:(enum ATAlertActionStyle)style
                       handler:(void(^__nullable)(ATAlertAction *action))handler;

@end

NS_INLINE ATAlertAction *ATAlertActionMake(NSString *title,
                                           enum ATAlertActionStyle style,
                                           void(^__nullable handler)(ATAlertAction *action)) {
    return [ATAlertAction actonWithTitle:title style:style handler:handler];
}

@interface ATAlertLink : NSObject

@property (nonnull, copy, nonatomic) NSString *text;
@property (nonnull, strong, nonatomic) UIColor *color;

+ (instancetype)linkWithText:(nonnull NSString *)text
                       color:(nonnull UIColor *)color
                     handler:(void(^__nullable)(ATAlertLink *action))handler;

@end

NS_INLINE ATAlertLink *ATAlertLinkMake(NSString *text,
                                       UIColor *color,
                                       void(^__nullable handler)(ATAlertLink *action)) {
    return [ATAlertLink linkWithText:text color:color handler:handler];
}

@interface ATAlert : NSObject

@property (nullable, nonatomic, copy) NSString *title;
@property (nonnull, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) NSArray<ATAlertAction *> *actions;
@property (nonatomic, readonly) NSArray<ATAlertLink *> *links;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message;

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message
                       actions:(nonnull NSArray *)actions;

+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nonnull NSString *)message
                       actions:(nonnull NSArray *)actions
                     textField:(void (^ __nullable)(UITextField *textField))textField;

+ (instancetype)alertWithMessage:(nonnull NSString *)message
                         actions:(nonnull NSArray *)actions;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addMessageLinks:(NSArray <ATAlertLink *>*__nonnull)links;
- (void)showIn:(UIView *)view;
- (void)show;

@end

NS_INLINE ATAlert *ATAlertMake(NSString *__nullable title,
                               NSString *__nonnull message,
                               NSArray <ATAlertLink *>*__nonnull actions) {
    return [ATAlert alertWithTitle:title message:message actions:actions];
}

NS_ASSUME_NONNULL_END
