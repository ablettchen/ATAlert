# ATAlert

[![CI Status](https://img.shields.io/travis/ablettchen@gmail.com/ATAlert.svg?style=flat)](https://travis-ci.org/ablettchen@gmail.com/ATAlert)
[![Version](https://img.shields.io/cocoapods/v/ATAlert.svg?style=flat)](https://cocoapods.org/pods/ATAlert)
[![License](https://img.shields.io/cocoapods/l/ATAlert.svg?style=flat)](https://cocoapods.org/pods/ATAlert)
[![Platform](https://img.shields.io/cocoapods/p/ATAlert.svg?style=flat)](https://cocoapods.org/pods/ATAlert)

## Example

![](https://github.com/ablettchen/ATAlert/blob/master/Example/images/alert.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objectiveC
#import <ATAlertView/ATAlertView.h>
```

1. Alert - Default

```objectiveC
NSString *message = @"each button take one row if there are more than 2 items";
NSArray *actions = @[ATAlertNormalActionMake(@"Done", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}), ATAlertHilightedActionMake(@"Save", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}), ATAlertNormalActionMake(@"Cacel", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
})];
[[ATAlertView alertWithTitle:title message:message actions:actions] show];
```

2. Alert - Confirm

```objectiveC
[[ATAlertView alertWithTitle:title message:@"Confirm Dialog"] show];
```

3. Alert - Confirm / Without title

```objectiveC
NSString *message = @"您的班级信息数据已更新完成,请重新刷新列表查看最新数据.";
[[ATAlertView alertWithTitle:nil message:message] show];
```

4. Alert - Link

```objectiveC
NSString *message = @"尊敬的用户，为给您提供更好的服务，本应用会使用到一些您的个人信息。不过请放心，我们非常重视您的个人信息和隐私保护，您的信息将仅用于为您提供服务或改善服务体验。请您在使用本应用之前仔细阅读《用户隐私政策》，如同意此政策，请点击“同意”并开始使用我们的产品和服务。";
NSArray *actions = @[ATAlertNormalActionMake(@"退出", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}), ATAlertHilightedActionMake(@"同意", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
})];
NSArray *links = @[ATAlertLinkMake(@"《用户隐私政策》", ^(ATAlertLink * _Nonnull action) {
    NSLog(@"%@", action.text);
})];
ATAlertView *alert = \
[ATAlertView alertWithPreferredStyle:ATAlertStyleAlert
                               title:@"温馨提示"
                             message:message
                             actions:actions];
[alert addMessageLinks:links];
[alert show];
```

5. Alert - Input

```objectiveC
NSString *message = @"您的班级信息数据已更新完成,请重新刷新列表查看最新数据.";
NSArray *actions = @[ATAlertNormalActionMake(@"取消", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}), ATAlertHilightedActionMake(@"确定", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
})];
ATAlertView *alert = \
[ATAlertView alertWithPreferredStyle:ATAlertStyleAlert
                               title:@"提示"
                             message:message
                             actions:actions];
[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"请输入昵称~";
}];
[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"请输入年龄~";
}];
[self.view showAlert:alert];
```

6. Sheet - Default

```objectiveC
NSArray *actions = @[ATAlertNormalActionMake(@"Normal", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}), ATAlertHilightedActionMake(@"Highlighted", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}), ATAlertDisabledActionMake(@"Disabled", ^(ATAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
})];

ATAlertView  *alert = \
[ATAlertView alertWithPreferredStyle:ATAlertStyleSheet
                               title:nil
                             message:@""
                             actions:actions];
[alert show];
```

## Requirements

## Installation

ATAlertView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATAlert'
```

## Author

ablett, ablett.chen@gmail.com

## License

ATAlertView is available under the MIT license. See the LICENSE file for more info.
