//
//  ATAlert.h
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ATAlertActionStyle) {
    ATAlertActionStyleNormal,
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

NS_INLINE ATAlertAction *ATAlertNormalActionMake(NSString *title,
                                                 void(^__nullable handler)(ATAlertAction *action)) {
    return ATAlertActionMake(title, ATAlertActionStyleNormal, handler);
}

NS_INLINE ATAlertAction *ATAlertHilightedActionMake(NSString *title,
                                                 void(^__nullable handler)(ATAlertAction *action)) {
    return ATAlertActionMake(title, ATAlertActionStyleHilighted, handler);
}

NS_INLINE ATAlertAction *ATAlertDisabledActionMake(NSString *title,
                                                    void(^__nullable handler)(ATAlertAction *action)) {
    return ATAlertActionMake(title, ATAlertActionStyleDisabled, handler);
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

typedef NS_ENUM(NSUInteger, ATAlertStyle) {
    ATAlertStyleAlert,
    ATAlertStyleSheet,
};

@class ATAlertConf;
@interface ATAlert : NSObject

@property (nonatomic, assign, readonly) enum ATAlertStyle preferredStyle;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonnull, nonatomic, copy) NSString *message;
@property (nonatomic, strong, readonly) NSArray<ATAlertAction *> *actions;
@property (nonatomic, strong, readonly) NSArray<ATAlertLink *> *links;
@property (nonatomic, strong, readonly) NSArray<UITextField *> *textFields;
@property (nonatomic, strong, readonly) void(^update)(void(^block)(ATAlertConf *conf));

+ (instancetype)alertWithPreferredStyle:(enum ATAlertStyle)style
                                  title:(nullable NSString *)title
                                message:(nonnull NSString *)message
                                actions:(nonnull NSArray *)actions;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addMessageLinks:(NSArray <ATAlertLink *>*__nonnull)links;
- (void)showIn:(UIView *)view;
- (void)show;

@end

@interface ATAlertConf : NSObject

@property (nonatomic, assign) BOOL touchWildToHide;         ///< preferredStyle == ATAlertStyleSheet ? : NO;
@property (nonatomic, strong) UIColor *dimBackgroundColor;  ///< default is 0x0000007F
@property (nonatomic, strong) UIColor *backgroundColor;     ///< default is 0xFFFFFFFF.
@property (nonatomic, assign) CGFloat width;                ///< default is 275.
@property (nonatomic, assign) UIEdgeInsets insets;          ///< default is UIEdgeInsetsMake(25, 25, 25, 25).
@property (nonatomic, assign) CGFloat cornerRadius;         ///< default is 5.
@property (nonatomic, strong) UIFont *titleFont;            ///< default is systemFont(18).
@property (nonatomic, strong) UIColor *titleColor;          ///< default is 0x333333FF.
@property (nonatomic, strong) UIFont *messageFont;          ///< default is systemFont(14).
@property (nonatomic, strong) UIColor *messageColor;        ///< default is 0x333333FF.
@property (nonatomic, strong) UIFont *actionFont;           ///< default is systemFont(17).
@property (nonatomic, strong) UIColor *actionColor;         ///< default is 0x333333FF.
@property (nonatomic, strong) UIColor *actionHightedColor;  ///< default is 0xE76153FF.
@property (nonatomic, strong) UIColor *actionPressBGColor;  ///< default is 0xF5F5F5FF.
@property (nonatomic, strong) UIColor *splitColor;          ///< default is 0xCCCCCCFF.
@property (nonatomic, assign) CGFloat splitWidth;           ///< default is 1/[UIScreen mainScreen].scale
@property (nonatomic, strong) NSString *actionOkText;       ///< default is "好".
@property (nonatomic, strong) NSString *actionConfirmText;  ///< default is "确定".
@property (nonatomic, strong) NSString *actionCancelText;   ///< default is "取消".

- (void)reset;

@end

NS_ASSUME_NONNULL_END
