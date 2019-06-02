//
//  ATAlertView.h
//  ATAlertView
//  https://github.com/ablettchen/ATAlertView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

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

@interface ATAlertLink : NSObject

@property (nonnull, copy, nonatomic) NSString *text;
@property (nullable, strong, nonatomic) UIColor *color;
@property (nullable, strong, nonatomic) UIColor *backgroundColor;

+ (instancetype)linkWithText:(nonnull NSString *)text
                     handler:(void(^__nullable)(ATAlertLink *action))handler;

@end

NS_INLINE ATAlertLink *ATAlertLinkMake(NSString *text,
                                       void(^__nullable handler)(ATAlertLink *action)) {
    return [ATAlertLink linkWithText:text handler:handler];
}

typedef NS_ENUM(NSUInteger, ATAlertStyle) {
    ATAlertStyleAlert,
    ATAlertStyleSheet,
};

@class ATAlertConf;

@interface ATAlertView : UIView

@property (nonatomic, assign, readonly) enum ATAlertStyle preferredStyle;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonnull, nonatomic, copy) NSString *message;
@property (nonatomic, strong, readonly) NSArray<ATAlertAction *> *actions;
@property (nonatomic, strong, readonly) NSArray<ATAlertLink *> *links;
@property (nonatomic, strong, readonly) NSArray<UITextField *> *textFields;
@property (nonatomic, copy, readonly) void(^update)(void(^block)(ATAlertConf *conf));

@property (nullable, nonatomic, copy) void(^didShow)(BOOL finished);
@property (nullable, nonatomic, copy) void(^didHide)(BOOL finished);

+ (instancetype)alertWithPreferredStyle:(enum ATAlertStyle)style
                                  title:(nullable NSString *)title
                                message:(nonnull NSString *)message
                                actions:(nonnull NSArray *)actions;

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
- (void)addMessageLinks:(NSArray <ATAlertLink *>*__nonnull)links;
- (void)showIn:(__weak UIView *)view;
- (void)show;
- (void)hide;

@end

@interface ATAlertConf : NSObject

@property (nonatomic, assign) BOOL touchWildToHide;             ///< preferredStyle == ATAlertStyleSheet ? : NO;
@property (nonatomic, assign) CGFloat width;                    ///< default is 275.
@property (nonatomic, assign) UIEdgeInsets insets;              ///< default is UIEdgeInsetsMake(25, 25, 25, 25).
@property (nonatomic, assign) CGFloat cornerRadius;             ///< default is 10.0f.
@property (nonatomic, strong) UIColor *dimBackgroundColor;      ///< default is 0x0000007F
@property (nonatomic, strong) UIColor *backgroundColor;         ///< default is 0xFFFFFFFF.
@property (nonatomic, strong) UIColor *sheetBackgroundColor;    ///< default is 0xE7E7E7FF.
@property (nonatomic, strong) UIFont *titleFont;                ///< default is systemFont(18).
@property (nonatomic, strong) UIColor *titleColor;              ///< default is 0x333333FF.
@property (nonatomic, assign) CGFloat messageToTitleInset;      ///< Default is 10.
@property (nonatomic, assign) CGFloat lineSpace;                ///< default is 7.
/** 默认NO, 即：一行为：NSTextAlignmentCenter，两行为：NSTextAlignmentLeft，若为YES, 即 NSTextAlignmentCenter */
@property (nonatomic, assign) BOOL messageWildAlignmentCenter;
@property (nonatomic, strong) UIFont *messageFont;              ///< default is systemFont(14).
@property (nonatomic, strong) UIFont *messageOnlyFont;          ///< default is systemFont(14).
@property (nonatomic, strong) UIColor *messageColor;            ///< default is 0x333333FF.
@property (nonatomic, strong) UIColor *linkColor;               ///< default is 0x0067d8FF.
@property (nonatomic, strong) UIColor *linkBackgroundColor;     ///< default is 0xF0FFFFFF.
@property (nonatomic, strong) UIFont *actionFont;               ///< default is systemFont(17).
@property (nonatomic, strong) UIFont *actionBoldFont;           ///< default is systemFont(17).
@property (nonatomic, strong) UIColor *actionColor;             ///< default is 0x333333FF.
@property (nonatomic, strong) UIColor *actionHightedColor;      ///< default is 0xEE873AFF.
@property (nonatomic, strong) UIColor *actionPressBGColor;      ///< default is 0xF5F5F5FF.
@property (nonatomic, assign) CGFloat actionHeight;             ///< Default is 50.
@property (nonatomic, strong) UIColor *splitColor;              ///< default is 0xE7E7E7FF.
@property (nonatomic, assign) CGFloat splitWidth;               ///< default is 1/[UIScreen mainScreen].scale
@property (nonatomic, strong) NSString *actionOkText;           ///< default is "好".
@property (nonatomic, strong) NSString *actionConfirmText;      ///< default is "确定".
@property (nonatomic, strong) NSString *actionCancelText;       ///< default is "取消".

- (void)reset;

@end

NS_ASSUME_NONNULL_END

#import "ATAlertView+Make.h"
#import "UIView+ATAlertView.h"

