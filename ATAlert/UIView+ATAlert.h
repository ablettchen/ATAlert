//
//  UIView+ATAlert.h
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ATAlert;
@interface UIView (ATAlert)
- (void)showAlert:(ATAlert *)alert;
@end

NS_ASSUME_NONNULL_END
