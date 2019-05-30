//
//  ATAlert.m
//  ATAlert
//
//  Created by ablett on 2019/5/30.
//

#import "ATAlert.h"

@implementation ATAlert

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    
    return self;
}

@end
