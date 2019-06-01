//
//  ATAlert.m
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import "ATAlert.h"
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


static UIViewController *_at_get_top_view_controller() {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (  [vc isKindOfClass:[UINavigationController class]] ||
           [vc isKindOfClass:[UITabBarController class]] ||
           vc.presentedViewController ) {
        if ( [vc isKindOfClass:[UINavigationController class]] )
            vc = [(UINavigationController *)vc topViewController];
        if ( [vc isKindOfClass:[UITabBarController class]] )
            vc = [(UITabBarController *)vc selectedViewController];
        if ( vc.presentedViewController )
            vc = vc.presentedViewController;
    }
    return vc;
}

@interface ATAlertAction ()
@property (nullable, copy, nonatomic) void(^handler)(ATAlertAction *action);
@end

@implementation ATAlertAction

+ (instancetype)actonWithTitle:(nonnull NSString *)title
                         style:(enum ATAlertActionStyle)style
                       handler:(void(^__nullable)(ATAlertAction *action))handler {
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

+ (instancetype)linkWithText:(nonnull NSString *)text
                       color:(nonnull UIColor *)color
                     handler:(void(^__nullable)(ATAlertLink *action))handler {
    ATAlertLink *link = [ATAlertLink new];
    link.text = text;
    link.handler = handler;
    return link;
}

@end

@interface ATAlert ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) enum ATAlertStyle preferredStyle;
@property (nonatomic, strong, readwrite) NSMutableArray<ATAlertAction *> *actions;
@property (nonatomic, strong, readwrite) NSMutableArray<ATAlertLink *> *links;
@property (nonatomic, strong, readwrite) NSMutableArray<UITextField *> *textFields;

@property (nonatomic, strong, readonly) ATAlertConf *conf;

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *actionView;

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;

@end

@implementation ATAlert

@synthesize conf = _conf;
@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;
@synthesize actionView = _actionView;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _actions = [NSMutableArray array];
    _links = [NSMutableArray alloc];
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
}

- (void (^)(void (^ _Nonnull)(ATAlertConf * _Nonnull)))update {
    __weak typeof(self) _self = self;
    return ^void(void(^block)(ATAlertConf *config)) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( block ) block(self.conf);
        if (self.preferredStyle == ATAlertStyleAlert) {
            ///backgroundView
            self.backgroundView.backgroundColor = self.conf.dimBackgroundColor;
            ///contentView
            self.contentView.backgroundColor = self.conf.backgroundColor;
            self.contentView.layer.cornerRadius = self.conf.cornerRadius;
            self.contentView.layer.borderWidth = self.conf.splitWidth;
            self.contentView.layer.borderColor = self.conf.splitColor.CGColor;
            ///titleLabel
            self.titleLabel.backgroundColor = self.conf.backgroundColor;
            self.titleLabel.textColor = self.conf.titleColor;
            self.titleLabel.font = self.conf.titleFont;
            ///messageLabel
            self.messageLabel.backgroundColor = self.contentView.backgroundColor;
            self.messageLabel.textColor = self.conf.messageColor;
            self.messageLabel.font = self.conf.messageFont;
        }
    };
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
    _backgroundView.alpha = 0.001;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    gesture.cancelsTouchesInView = NO;
    gesture.delegate = self;
    [_backgroundView addGestureRecognizer:gesture];
    return _backgroundView;
}

- (UIView *)contentView {
    if (_contentView) return _contentView;
    _contentView = [UIView new];
    _contentView.clipsToBounds = YES;
    _contentView.alpha = 0.001;
    return _contentView;
}

- (UIView *)actionView {
    if (_actionView) return _contentView;
    _contentView = [UIView new];
    return _actionView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [UILabel new];
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (_messageLabel) return _messageLabel;
    _messageLabel = [UILabel new];
    return _messageLabel;
}

#pragma mark - Privite

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    //if (!self.conf.touchWildToHide) {return;}
    [self hide];
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
    ATAlert *alert = [ATAlert new];
    alert.preferredStyle = style;
    alert.title = title;
    alert.message = message;
    alert.actions = [NSMutableArray arrayWithArray:actions];
    return alert;
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler {
    if (configurationHandler) {
        UITextField *textField = [UITextField new];
        configurationHandler(textField);
        [self->_textFields addObject:textField];
    }
}

- (void)addMessageLinks:(NSArray <ATAlertLink *>*__nonnull)links {
    [self->_links addObjectsFromArray:links];
    [self.buttons addObject:[UIButton new]];
}

- (void)showIn:(UIView *)view {
    
    NSAssert(self.message.length > 0, @"message could not be nil");
    NSAssert(self.actions.count > 0, @"could not find any actions");

    [view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self.backgroundView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.conf.width);
        make.center.equalTo(self.backgroundView);
    }];

    MASViewAttribute *lastAttribute = self.contentView.mas_top;
    
    if (self.title.stringByTrim.length > 0) {
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).insets(self.conf.insets);
            make.left.right.equalTo(self.contentView).insets(self.conf.insets);
        }];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = self.title;
        lastAttribute = self.titleLabel.mas_bottom;
    }

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute).offset(self.conf.insets.bottom);
        make.center.equalTo(self.backgroundView);
    }];
    
    self.contentView.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.backgroundView.alpha = 1.0f;
                         self.contentView.layer.transform = CATransform3DIdentity;
                         self.contentView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {}];
}

- (void)show {
    [self showIn:[[UIApplication sharedApplication] keyWindow]];
}

- (void)hide {
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.backgroundView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {[self.backgroundView removeFromSuperview];}
                     }];
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
    
    _touchWildToHide    = NO;
    _dimBackgroundColor = UIColorHex(0x0000007F);
    _backgroundColor    = UIColorHex(0xFFFFFFFF);
    _width              = 275.f;
    _insets             = UIEdgeInsetsMake(25, 25, 25, 25);
    _cornerRadius       = 5.f;
    _titleFont          = [UIFont systemFontOfSize:18];
    _titleColor         = UIColorHex(0x333333FF);
    _messageFont        = [UIFont systemFontOfSize:14];
    _messageColor       = UIColorHex(0x333333FF);
    _actionFont         = [UIFont systemFontOfSize:17];
    _actionColor        = UIColorHex(0x333333FF);
    _actionHightedColor = UIColorHex(0xE76153FF);
    _actionPressBGColor = UIColorHex(0xF5F5F5FF);
    _splitColor         = UIColorHex(0xCCCCCCFF);
    _splitWidth         = 1/[UIScreen mainScreen].scale;
    _actionOkText       = @"好";
    _actionConfirmText  = @"确定";
    _actionCancelText   = @"取消";
}

@end
