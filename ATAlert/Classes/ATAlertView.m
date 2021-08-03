//
//  ATAlertView.m
//  ATAlertView
//  https://github.com/ablettchen/ATAlertView
//
//  Created by ablett on 2019/5/5.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATAlertView.h"

#if __has_include(<ATCategories/ATCategories.h>)
#import <ATCategories/ATCategories.h>
#else
#import "ATCategories.h"
#endif

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

#if __has_include(<YYText/YYLabel.h>)
#import <YYText/YYText.h>
#else
#import "YYText.h"
#endif

@interface ATAlertAction ()
@property (nullable, copy, nonatomic) void(^handler)(ATAlertAction *action);
@end

@implementation ATAlertAction

+ (instancetype)actonWithTitle:(nonnull NSString *)title style:(enum ATAlertActionStyle)style handler:(void(^__nullable)(ATAlertAction *action))handler {
    ATAlertAction *action = [ATAlertAction new];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}

@end

@interface ATAlertLink ()
@property (nullable, copy, nonatomic) void(^handler)(ATAlertLink *link);
@end
@implementation ATAlertLink

+ (instancetype)linkWithText:(nonnull NSString *)text handler:(void(^__nullable)(ATAlertLink *action))handler {
    ATAlertLink *link = [ATAlertLink new];
    link.text = text;
    link.handler = handler;
    return link;
}

@end


@interface ATAlertView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) BOOL isShowing;

@property (nonatomic, assign, readwrite) enum ATAlertStyle preferredStyle;
@property (nonatomic, strong, readwrite) NSMutableArray<ATAlertAction *> *actions;
@property (nonatomic, strong, readwrite) NSMutableArray<ATAlertLink *> *links;
@property (nonatomic, strong, readwrite) NSMutableArray<UITextField *> *textFields;

@property (nonatomic, strong, readonly) ATAlertConf *conf;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UIView *inputView;
@property (nonatomic, strong, readonly) UIView *actionView;

@property (nonatomic, strong, readonly) UIView *sheetTitleView;
@property (nonatomic, strong, readonly) UIButton *sheetCancelBtn;

@property (nonatomic, strong, readonly) YYLabel *titleLabel;
@property (nonatomic, strong, readonly) YYLabel *messageLabel;

@property (nonatomic, strong, readonly) UIButton *closeButton;

@end

@implementation ATAlertView

@synthesize conf = _conf;
@synthesize backgroundView = _backgroundView;
@synthesize inputView = _inputView;
@synthesize actionView = _actionView;
@synthesize sheetTitleView = _sheetTitleView;
@synthesize sheetCancelBtn = _sheetCancelBtn;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize closeButton = _closeButton;

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.clipsToBounds = YES;
    self.alpha = 0.001f;
    
    _isShowing = NO;
    _actions = [NSMutableArray array];
    _links = [NSMutableArray array];
    _textFields = [NSMutableArray array];
    
    _buttons = [NSMutableArray array];
    
    self.preferredStyle = ATAlertStyleAlert;
    self.update(^(ATAlertConf * _Nonnull conf) {});
    
    return self;
}

#pragma mark - Setter, Getter

- (void)setPreferredStyle:(enum ATAlertStyle)preferredStyle {
    _preferredStyle = preferredStyle;
    self.conf.touchWildToHide = preferredStyle == ATAlertStyleSheet ? : NO;
    if (self.preferredStyle == ATAlertStyleSheet) {
        self.conf.insets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.conf.cornerRadius = self.conf.cornerRadius;
        self.sheetCancelBtn.layer.cornerRadius = self.conf.cornerRadius;
        self.conf.messageColor = UIColorHex(0x666666FF);
        self.backgroundColor = [UIColor clearColor];
        
    }else {
        self.backgroundColor = self.conf.backgroundColor;
    }
}

- (void (^)(void (^ _Nonnull)(ATAlertConf * _Nonnull)))update {
    @weakify(self);
    return ^void(void(^block)(ATAlertConf *config)) {
        @strongify(self);
        if (!self) return;
        if (block) block(self.conf);
        
        self.backgroundView.backgroundColor = self.conf.dimBackgroundColor;
        self.layer.cornerRadius = self.conf.cornerRadius;
        
        if (self.preferredStyle == ATAlertStyleAlert) {
            self.backgroundColor = self.conf.backgroundColor;
            self.layer.borderWidth = self.conf.splitWidth;
            self.layer.borderColor = self.conf.splitColor.CGColor;
            self.closeButton.alpha = self.conf.isShowAlertClose ? 1.0 : 0.0;
        }else {
            self.backgroundColor = [UIColor clearColor];
            self.layer.borderWidth = 0.0;
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.closeButton.alpha = 0.0;
        }
        
        ///titleLabel
        self.titleLabel.backgroundColor = self.conf.backgroundColor;
        self.titleLabel.font = self.conf.titleFont;
        self.titleLabel.textColor = self.conf.titleColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.sheetTitleView.backgroundColor = self.conf.backgroundColor;
        self.sheetCancelBtn.backgroundColor = self.conf.backgroundColor;
        [self.sheetCancelBtn setTitle:self.conf.actionCancelText forState:UIControlStateNormal];
        [self.sheetCancelBtn setTitleColor:self.conf.sheetActionCancelColor forState:UIControlStateNormal];
        [self.sheetCancelBtn setBackgroundImage:[UIImage imageWithColor:self.conf.backgroundColor] forState:UIControlStateNormal];
        [self.sheetCancelBtn setBackgroundImage:[UIImage imageWithColor:self.conf.actionPressBGColor] forState:UIControlStateHighlighted];
        [self.sheetCancelBtn.titleLabel setFont:self.conf.actionFont];
        
        ///messageLabel
        self.messageLabel.backgroundColor = self.conf.backgroundColor;
        self.messageLabel.font = self.conf.messageFont;
        self.messageLabel.textColor = self.conf.messageColor;
        if (self.conf.messageWildAlignmentCenter) self.messageLabel.textAlignment = NSTextAlignmentCenter;
        ///actionView
        self.actionView.backgroundColor = self.conf.backgroundColor;
        
        ///action buttons
        [self.buttons removeAllObjects];
        
        for (int i=0; i<self.actions.count; i++) {
            ATAlertAction *obj = self.actions[i];
            UIButton *button = [UIButton buttonWithTarget:self action:@selector(actionButton:)];
            [button setTitle:obj.title forState:UIControlStateNormal];
            switch (obj.style) {
                case ATAlertActionStyleNormal:
                    [button setTitleColor:self.conf.actionColor forState:UIControlStateNormal];
                    break;
                case ATAlertActionStyleHilighted:
                    [button setTitleColor:self.conf.actionHightedColor forState:UIControlStateNormal];
                    break;
                case ATAlertActionStyleDisabled:
                    [button setTitleColor:UIColorHex(0xccccccFF) forState:UIControlStateNormal];
                    [button setEnabled:NO];
                default:
                    break;
            }
            [button setBackgroundImage:[UIImage imageWithColor:self.conf.backgroundColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:self.conf.actionPressBGColor] forState:UIControlStateHighlighted];
            button.layer.borderWidth = self.conf.splitWidth;
            button.layer.borderColor = self.conf.splitColor.CGColor;
            
            if (self.preferredStyle == ATAlertStyleAlert) {
                [button.titleLabel setFont:((i != 0) && (i == (self.actions.count-1)) && (self.preferredStyle == ATAlertStyleAlert)) ? self.conf.actionBoldFont : self.conf.actionFont];
            }else if (self.preferredStyle == ATAlertStyleSheet) {
                [button.titleLabel setFont:self.conf.sheetActionFont];
            }
            
            [button setTag:i];
            [self.buttons addObject:button];
        }
        
        ///< inputView
        for (UITextField *obj in self.textFields) {
            obj.font = self.conf.messageFont;
            obj.textColor = self.conf.messageColor;
            obj.layer.borderWidth = self.conf.splitWidth;
            obj.layer.borderColor = self.conf.splitColor.CGColor;
        }
    };
}

- (void)setActions:(NSMutableArray<ATAlertAction *> *)actions {
    _actions = actions;
    self.update(^(ATAlertConf * _Nonnull conf) {});
}

- (ATAlertConf *)conf {
    if (_conf) return _conf;
    _conf = [ATAlertConf new];
    return _conf;
}

- (UIView *)backgroundView  {
    if (_backgroundView) return _backgroundView;
    _backgroundView = [UIView new];
    _backgroundView.clipsToBounds = YES;
    _backgroundView.alpha = 0.001f;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    gesture.cancelsTouchesInView = NO;
    gesture.delegate = self;
    [_backgroundView addGestureRecognizer:gesture];
    return _backgroundView;
}

- (UIButton *)closeButton {
    if (_closeButton) return _closeButton;
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"button_close" inBundle:[ATAlertView alertBundle]] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.alpha = 0.0;
    return _closeButton;
}

- (UIView *)inputView {
    if (_inputView) return _inputView;
    _inputView = [UIView new];
    return _inputView;
}

- (UIView *)actionView {
    if (_actionView) return _actionView;
    _actionView = [UIView new];
    return _actionView;
}

- (UIView *)sheetTitleView {
    if (_sheetTitleView) return _sheetTitleView;
    _sheetTitleView = [UIView new];
    return _sheetTitleView;
}

- (UIButton *)sheetCancelBtn {
    if (_sheetCancelBtn) return _sheetCancelBtn;
    _sheetCancelBtn = [UIButton buttonWithTarget:self action:@selector(hide)];
    [_sheetCancelBtn setTitle:self.conf.actionCancelText forState:UIControlStateNormal];
    [_sheetCancelBtn setTitleColor:self.conf.sheetActionCancelColor forState:UIControlStateNormal];
    [_sheetCancelBtn setBackgroundImage:[UIImage imageWithColor:self.conf.backgroundColor] forState:UIControlStateNormal];
    [_sheetCancelBtn setBackgroundImage:[UIImage imageWithColor:self.conf.actionPressBGColor] forState:UIControlStateHighlighted];
    [_sheetCancelBtn.titleLabel setFont:self.conf.actionFont];
    _sheetCancelBtn.layer.masksToBounds = true;
    return _sheetCancelBtn;
}

- (YYLabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [YYLabel new];
    _titleLabel.numberOfLines = 0;
    return _titleLabel;
}

- (YYLabel *)messageLabel {
    if (_messageLabel) return _messageLabel;
    _messageLabel = [YYLabel new];
    _messageLabel.numberOfLines = 0;
    return _messageLabel;
}

#pragma mark - Privite

- (void)closeButtonAction:(UIButton *)sender {
    [self hide];
}

- (void)actionTap:(UITapGestureRecognizer *)gesture {
    if (!self.conf.touchWildToHide) {return;}
    [self hide];
}

- (void)actionButton:(UIButton *)button {
    ATAlertAction *action = self.actions[button.tag];
    if (action.style == ATAlertActionStyleDisabled) {return;}
    [self hide];
    if (action.handler) {action.handler(action);}
}

- (void)showAlertIn:(__weak UIView *)view completion:(void(^)(BOOL finished))completion {
    
    [view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self.backgroundView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.conf.width);
    }];
    
    [self.backgroundView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.right.equalTo(self).insets(UIEdgeInsetsMake(-15, 0, 0, -15));
    }];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    
    CGFloat labelWidth = self.conf.width-self.conf.insets.left-self.conf.insets.right;
    
    if (self.title.stringByTrim.length > 0) {
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.title];
        attributedText.yy_font = self.titleLabel.font;
        attributedText.yy_color = self.titleLabel.textColor;
        attributedText.yy_alignment = self.titleLabel.textAlignment;
        attributedText.yy_lineSpacing = self.conf.lineSpace;
        
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(labelWidth, CGFLOAT_MAX) text:attributedText];
        self.titleLabel.textLayout = textLayout;
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).insets(self.conf.insets);
            make.left.right.equalTo(self).insets(self.conf.insets);
            make.height.equalTo(@(textLayout.textBoundingSize.height));
        }];
        self.titleLabel.attributedText = attributedText;
        lastAttribute = self.titleLabel.mas_bottom;
    }
    
    if (self.message.stringByTrim.length > 0) {
        
        BOOL titleIsNil = (self.title.stringByTrim.length == 0) ? : NO;
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.message];
        attributedText.yy_font = titleIsNil ? self.conf.messageOnlyFont : self.messageLabel.font;
        attributedText.yy_color = self.messageLabel.textColor;
        attributedText.yy_lineSpacing = self.conf.lineSpace;
        
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(labelWidth, CGFLOAT_MAX) text:attributedText];
        attributedText.yy_alignment = (self.conf.messageWildAlignmentCenter) ? NSTextAlignmentCenter : ((textLayout.lines.count > 1) ? NSTextAlignmentLeft : NSTextAlignmentCenter);
        self.messageLabel.textLayout = textLayout;
        
        [self addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(titleIsNil?self.conf.insets.top:self.conf.messageToTitleInset);
            make.left.right.equalTo(self).insets(self.conf.insets);
            make.height.equalTo(@(textLayout.textBoundingSize.height));
        }];
        
        for (ATAlertLink *obj in self.links) {
            if (![attributedText.string containsString:obj.text]) {continue;}
            NSRange linkRange = [attributedText.string rangeOfString:obj.text];
            @weakify(self);
            [attributedText yy_setTextHighlightRange:linkRange
                                               color:obj.color?:self.conf.linkColor
                                     backgroundColor:obj.backgroundColor?:self.conf.linkBackgroundColor
                                           tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                if (obj.handler) {
                    @strongify(self);
                    [self hide:^(BOOL finished) {
                        if (finished) obj.handler(obj);
                    }];
                }
            }];
        }
        
        self.messageLabel.attributedText = attributedText;
        lastAttribute = self.messageLabel.mas_bottom;
    }
    
    
    if (self.textFields.count > 0) {
        
        [view endEditing:YES];
        
        [self addSubview:self.inputView];
        [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(10);
            make.left.right.equalTo(self);
        }];
        
        MASViewAttribute *lastUnputAttribute = lastAttribute;
        
        for (UITextField *obj in self.textFields) {
            [self.inputView addSubview:obj];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastUnputAttribute).offset(10);
                make.left.right.equalTo(self.inputView).insets(self.conf.insets);
                make.height.mas_equalTo(40);
            }];
            lastUnputAttribute = obj.mas_bottom;
        }
        
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastUnputAttribute);
        }];
        
        lastAttribute = self.inputView.mas_bottom;
    }
    
    if (self.buttons.count > 0) {
        
        [self addSubview:self.actionView];
        [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(self.conf.insets.top);
            make.left.right.equalTo(self);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for (int i=0; i<self.buttons.count; i++) {
            UIButton *obj = self.buttons[i];
            [self.actionView addSubview:obj];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.buttons.count <= 2) {
                    make.top.bottom.equalTo(self.actionView);
                    make.height.mas_equalTo(self.conf.actionHeight);
                    if (!firstButton) {
                        firstButton = obj;
                        make.left.equalTo(self.actionView.mas_left).offset(-self.conf.splitWidth);
                    }else {
                        make.left.equalTo(lastButton.mas_right).offset(-self.conf.splitWidth);
                        make.width.equalTo(firstButton);
                    }
                }else {
                    make.left.right.equalTo(self.actionView);
                    make.height.mas_equalTo(self.conf.actionHeight);
                    if (!firstButton) {
                        firstButton = obj;
                        make.top.equalTo(self.actionView.mas_top).offset(-self.conf.splitWidth);
                    }else {
                        make.top.equalTo(lastButton.mas_bottom).offset(-self.conf.splitWidth);
                        make.width.equalTo(firstButton);
                    }
                }
                lastButton = obj;
            }];
        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.buttons.count <= 2) {
                make.right.equalTo(self.actionView.mas_right).offset(-self.conf.splitWidth);
            }else {
                make.bottom.equalTo(self.actionView.mas_bottom).offset(-self.conf.splitWidth);
            }
        }];
        
        lastAttribute = self.actionView.mas_bottom;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
        make.center.equalTo(self.backgroundView).centerOffset(CGPointMake(0, ((self.textFields.count > 0) ? (-216.f/2.f) : 0)));
    }];
    
    [self bringSubviewToFront:view];
    
    self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    @weakify(self);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        @strongify(self);
        self.backgroundView.alpha = 1.0f;
        self.layer.transform = CATransform3DIdentity;
        self.alpha = 1.0f;
        self.isShowing = YES;
    } completion:completion];
}

- (void)showSheetIn:(__weak UIView *)view completion:(void(^)(BOOL finished))completion {
    
    [view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self.backgroundView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH - self.conf.sheetContentInsets.left - self.conf.sheetContentInsets.right);
    }];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    
    CGFloat labelWidth = SCREEN_WIDTH-self.conf.insets.left-self.conf.insets.right;
    
    if (self.message.stringByTrim.length > 0) {
        
        [self addSubview:self.sheetTitleView];
        [self.sheetTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.message];
        attributedText.yy_font = self.messageLabel.font;
        attributedText.yy_color = self.messageLabel.textColor;
        attributedText.yy_lineSpacing = self.conf.lineSpace;
        
        YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(labelWidth, CGFLOAT_MAX) text:attributedText];
        attributedText.yy_alignment = (self.conf.messageWildAlignmentCenter) ? NSTextAlignmentCenter : ((textLayout.lines.count > 1) ? NSTextAlignmentLeft : NSTextAlignmentCenter);
        self.messageLabel.textLayout = textLayout;
        
        [self.sheetTitleView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).insets(self.conf.insets);
            make.height.mas_equalTo(textLayout.textBoundingSize.height);
        }];
        
        for (ATAlertLink *obj in self.links) {
            if (![attributedText.string containsString:obj.text]) {continue;}
            NSRange linkRange = [attributedText.string rangeOfString:obj.text];
            @weakify(self);
            [attributedText yy_setTextHighlightRange:linkRange
                                               color:obj.color?:self.conf.linkColor
                                     backgroundColor:obj.backgroundColor?:self.conf.linkBackgroundColor
                                           tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                if (obj.handler) {
                    [self hide:^(BOOL finished) {
                        if (finished) obj.handler(obj);
                    }];
                }
            }];
        }
        
        self.messageLabel.attributedText = attributedText;
        
        [self.sheetTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.messageLabel).offset(self.conf.insets.bottom);
        }];
        
        lastAttribute = self.sheetTitleView.mas_bottom;
    }
    
    if (self.buttons.count > 0) {
        
        [self addSubview:self.actionView];
        [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.right.equalTo(self);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for (int i=0; i<self.buttons.count; i++) {
            UIButton *obj = self.buttons[i];
            [self.actionView addSubview:obj];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.actionView).insets(UIEdgeInsetsMake(0, -self.conf.splitWidth, 0, -self.conf.splitWidth));
                make.height.mas_equalTo(self.conf.actionHeight);
                if (!firstButton) {
                    firstButton = obj;
                    make.top.equalTo(self.actionView.mas_top).offset(-self.conf.splitWidth);
                }else {
                    make.top.equalTo(lastButton.mas_bottom).offset(-self.conf.splitWidth);
                    make.height.equalTo(firstButton);
                }
                lastButton = obj;
            }];
        }
        
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.actionView.mas_bottom);//.offset(-self.conf.splitWidth);
        }];
        
        [self.actionView layoutIfNeeded];
        [self.actionView alert_filletedCornerWithRadii:CGSizeMake(self.conf.cornerRadius, self.conf.cornerRadius) roundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight];
        
        [self addSubview:self.sheetCancelBtn];
        [self.sheetCancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.actionView);
            make.height.mas_equalTo(self.conf.actionHeight);
            make.top.equalTo(self.actionView.mas_bottom).offset(8);
        }];
        
        CGFloat height = IS_IPHONE_X ? (34 + self.conf.sheetContentInsets.bottom) : self.conf.sheetContentInsets.bottom;
        
        UIView *extraView = ({
            UIView *view = [UIView new];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.sheetCancelBtn.mas_bottom);
                make.left.right.mas_equalTo(self);
                make.height.mas_equalTo(height);
            }];
            
            view.backgroundColor = [UIColor clearColor];
            view;
        });
        
        lastAttribute = extraView.mas_bottom;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastAttribute);
        }];
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundView);
        make.bottom.equalTo(self.backgroundView).offset(self.backgroundView.superview.at_height);
    }];
    [self.backgroundView layoutIfNeeded];
    
    self.alpha = 1.0f;
    [self bringSubviewToFront:view];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.backgroundView.alpha = 1.0f;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundView).offset(0);
        }];
        [self.backgroundView layoutIfNeeded];
        self.isShowing = YES;
    } completion:completion];
}

- (void)showIn:(__weak UIView *)view completion:(void(^)(BOOL finished))completion {
    if (self.superview != nil) {return;}
    //NSAssert(self.message.length > 0, @"message could not be nil");
    NSAssert(self.actions.count > 0, @"could not find any actions");
    if (self.preferredStyle == ATAlertStyleAlert) {
        [self showAlertIn:view completion:completion];
    }else if (self.preferredStyle == ATAlertStyleSheet) {
        [self showSheetIn:view completion:completion];
    }
}

- (void)show:(void(^ __nullable)(BOOL finished))completion {
    [self showIn:[[UIApplication sharedApplication] keyWindow] completion:completion];
}

- (void)hideAlert:(void(^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.backgroundView.alpha = 0.001f;
        self.alpha = 0.001f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self->_backgroundView removeFromSuperview];
            self->_backgroundView = nil;
            self->_isShowing = NO;
        }
        if (completion) {completion(finished);}
    }];
}

- (void)hideSheet:(void(^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.backgroundView.alpha = 0.001f;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundView.mas_bottom).offset(self.backgroundView.superview.at_height);
        }];
        [self.backgroundView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            [self->_backgroundView removeFromSuperview];
            self->_backgroundView = nil;
            self->_isShowing = NO;
        }
        if (completion) {completion(finished);}
    }];
}

- (void)hide:(void(^ __nullable)(BOOL finished))completion {
    if (self.superview == nil) {return;}
    if (self.preferredStyle == ATAlertStyleAlert) {
        [self hideAlert:completion];
    }else if (self.preferredStyle == ATAlertStyleSheet) {
        [self hideSheet:completion];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (touch.view == self.backgroundView);
}

#pragma mark - Public

+ (instancetype)alertWithPreferredStyle:(enum ATAlertStyle)style
                                  title:(nullable NSString *)title
                                message:(nonnull NSString *)message
                                actions:(nonnull NSArray *)actions {
    
    ATAlertView *alert = [ATAlertView new];
    alert.preferredStyle = style;
    alert.title = title;
    alert.message = message;
    alert.actions = [NSMutableArray arrayWithArray:actions];
    return alert;
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    if (configurationHandler) {
        UITextField *textField = [UITextField new];
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        configurationHandler(textField);
        [self->_textFields addObject:textField];
        self.update(^(ATAlertConf * _Nonnull conf) {});
    }
}

- (void)addMessageLinks:(NSArray <ATAlertLink *>*__nonnull)links {
    [self->_links addObjectsFromArray:links];
}

- (void)show {
    [self show:self.didShow];
}

- (void)showIn:(__weak UIView *)view; {
    [self showIn:view completion:self.didShow];
}

- (void)hide {
    [self hide:self.didHide];
}

+ (NSBundle *)alertBundle {
    NSString *bundlePath = [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingPathComponent:@"ATAlert.bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

@end

@implementation ATAlertConf

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self reset];
    return self;
}

- (void)reset {
    
    _isShowAlertClose   = NO;
    _touchWildToHide    = NO;
    
    _width              = 275.f;
    _insets             = UIEdgeInsetsMake(25, 25, 25, 25);
    _cornerRadius       = 10.0f;
    
    _dimBackgroundColor = UIColorHex(0x0000007F);
    _backgroundColor    = UIColorHex(0xFFFFFFFF);
    _sheetContentInsets = UIEdgeInsetsMake(0, 8, 8, 8);
    
    _titleFont          = [UIFont boldSystemFontOfSize:18];
    _titleColor         = UIColorHex(0x333333FF);
    
    _messageToTitleInset        = 10.f;
    _lineSpace                  = 7.f;
    _messageWildAlignmentCenter = NO;
    
    _messageFont        = [UIFont systemFontOfSize:14];
    _messageOnlyFont    = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    _messageColor       = UIColorHex(0x333333FF);
    
    _linkColor           = UIColorHex(0x0067d8FF);
    _linkBackgroundColor = UIColorHex(0xF0FFFFFF);
    
    _actionFont         = [UIFont systemFontOfSize:17];
    _actionBoldFont     = [UIFont systemFontOfSize:17];
    _actionColor        = UIColorHex(0x333333FF);
    _actionHightedColor = UIColorHex(0x00A5FFFF);
    _actionPressBGColor = UIColorHex(0xF5F5F5FF);
    
    _sheetActionCancelColor  = UIColorHex(0x00A5FFFF);
    _sheetActionFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    
    _actionHeight       = 50.f;
    
    _splitColor         = UIColorHex(0xE7E7E7FF);
    _splitWidth         = 1/[UIScreen mainScreen].scale;
    
    _actionOkText       = @"好";
    _actionConfirmText  = @"确定";
    _actionCancelText   = @"取消";
}

@end

