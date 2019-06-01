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
                                      @"Alert - Input"]];
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
    
//    [self.view makeToast:@"comming soon..."];
//    return;
//    
//    NSString *string = @"Be sure to run `pod lib lint ATToast.podspec' to ensure this is a valid spec before submitting.";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSRange range = [string rangeOfString:@"pod lib lint ATToast.podspec"];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:range];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:range];
//    [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:range];
//    
//    [self.view makeToastAttributed:attributedString];
//    return;
    
    NSString *message = @"您的班级信息数据已更新完成,请重新刷新列表查看最新数据.";
    NSArray *actions = @[ATAlertNormalActionMake(@"取消", ^(ATAlertAction * _Nonnull action) {
        
    }), ATAlertHilightedActionMake(@"确定", ^(ATAlertAction * _Nonnull action) {
        
    })];
    [[ATAlert alertWithPreferredStyle:ATAlertStyleAlert
                                title:@"提示"
                              message:message
                              actions:actions] showIn:self.view];
}

@end
