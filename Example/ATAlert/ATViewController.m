//
//  ATViewController.m
//  ATAlert
//
//  Created by ablettchen@gmail.com on 05/30/2019.
//  Copyright (c) 2019 ablettchen@gmail.com. All rights reserved.
//

#import "ATViewController.h"
#import <ATCategories.h>
#import <Masonry.h>
#import <ATAlert.h>
#import <ATAlert+Make.h>
#import <UIView+ATAlert.h>

#if __has_include(<ATToast/UIView+ATToast.h>)
#import <ATToast/UIView+ATToast.h>
#else
#import "UIView+ATToast.h"
#endif

@interface ATViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;
@end

@implementation ATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColorHex(0xF5F5F5FF);
    self.title = @"ATAlert";
    [self.view addSubview:self.tableView];
    self.datas = [NSMutableArray array];
    [self.datas addObjectsFromArray:@[@"Alert - Default", \
                                      @"Alert - Confirm", \
                                      @"Alert - Confirm / Without title", \
                                      @"Alert - Link", \
                                      @"Alert - Input", \
                                      @"Sheet - Default"]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter, getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0.f;
        _tableView.estimatedSectionHeaderHeight = 0.f;
        _tableView.estimatedSectionFooterHeight = 0.f;
        _tableView.rowHeight = 50.f;
    }
    return _tableView;
}

#pragma mark - privite

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell"];
    if (!cell) {
        cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.datas[indexPath.row]];
    if ((indexPath.row % 2) == 0) {cell.backgroundColor = UIColorHex(0x1515151A);}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.datas[indexPath.row];
    if ([title isEqualToString:@"Alert - Default"]) {
        
        NSString *message = @"each button take one row if there are more than 2 items";
        NSArray *actions = @[ATAlertNormalActionMake(@"Done", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }), ATAlertHilightedActionMake(@"Save", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }), ATAlertNormalActionMake(@"Cacel", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        })];
        NSArray *links = @[ATAlertLinkMake(@"one row", ^(ATAlertLink * _Nonnull action) {
            NSLog(@"%@", action.text);
        })];
        ATAlert *alert = \
        [ATAlert alertWithTitle:title message:message actions:actions];
        [alert addMessageLinks:links];
        [alert show];
        
    }else if ([title isEqualToString:@"Alert - Confirm"]) {
        
        NSArray *links = @[ATAlertLinkMake(@"Dialog", ^(ATAlertLink * _Nonnull action) {
            NSLog(@"%@", action.text);
        })];
        ATAlert *alert = \
        [ATAlert alertWithTitle:title message:@"Confirm Dialog"];
        [alert addMessageLinks:links];
        [alert show];
        
    }else if ([title isEqualToString:@"Alert - Confirm / Without title"]) {
        
        NSString *message = @"您的班级信息数据已更新完成,请重新刷新列表查看最新数据.";
        NSArray *links = @[ATAlertLinkMake(@"班级信息", ^(ATAlertLink * _Nonnull action) {
            NSLog(@"%@", action.text);
        })];
        ATAlert *alert = \
        [ATAlert alertWithTitle:nil message:message];
        [alert addMessageLinks:links];
        [alert show];
        
    }else if ([title isEqualToString:@"Alert - Link"]) {
        
        NSString *message = @"尊敬的用户，为给您提供更好的服务，本应用会使用到一些您的个人信息。不过请放心，我们非常重视您的个人信息和隐私保护，您的信息将仅用于为您提供服务或改善服务体验。请您在使用本应用之前仔细阅读《用户隐私政策》，如同意此政策，请点击“同意”并开始使用我们的产品和服务。";
        NSArray *actions = @[ATAlertNormalActionMake(@"退出", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }), ATAlertHilightedActionMake(@"同意", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        })];
        NSArray *links = @[ATAlertLinkMake(@"《用户隐私政策》", ^(ATAlertLink * _Nonnull action) {
            NSLog(@"%@", action.text);
        })];
        ATAlert *alert = \
        [ATAlert alertWithPreferredStyle:ATAlertStyleAlert
                                   title:@"温馨提示"
                                 message:message
                                 actions:actions];
        [alert addMessageLinks:links];
        [alert show];
        
    }else if ([title isEqualToString:@"Alert - Input"]) {
        
        NSString *message = @"您的班级信息数据已更新完成,请重新刷新列表查看最新数据.";
        NSArray *actions = @[ATAlertNormalActionMake(@"取消", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }), ATAlertHilightedActionMake(@"确定", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        })];
        NSArray *links = @[ATAlertLinkMake(@"刷新列表", ^(ATAlertLink * _Nonnull action) {
            NSLog(@"%@", action.text);
        })];
        
        ATAlert *alert = \
        [ATAlert alertWithPreferredStyle:ATAlertStyleAlert
                                   title:@"提示"
                                 message:message
                                 actions:actions];
        [alert addMessageLinks:links];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入昵称~";
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入年龄~";
        }];
        
        [self.view showAlert:alert];
        
    }else if ([title isEqualToString:@"Sheet - Default"]) {
        //@"Sheet - Default"
        
        NSArray *actions = @[ATAlertNormalActionMake(@"Normal", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }), ATAlertHilightedActionMake(@"Highlighted", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }), ATAlertDisabledActionMake(@"Disabled", ^(ATAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        })];
        
        NSArray *links = @[ATAlertLinkMake(@"a", ^(ATAlertLink * _Nonnull action) {
            NSLog(@"%@", action.text);
        })];
        
        ATAlert *alert = \
        [ATAlert alertWithPreferredStyle:ATAlertStyleSheet
                                   title:@"提示"
                                 message:@"hahaha"
                                 actions:actions];
        
        [alert addMessageLinks:links];
        [alert show];
    }
}

@end
