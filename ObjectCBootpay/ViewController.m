//
//  ViewController.m
//  ObjectCBootpay
//
//  Created by YoonTaesup on 2019. 3. 14..
//  Copyright © 2019년 kr.co.bootpay. All rights reserved.
//

#import "ViewController.h"
#import "NativeController.h"
#import "WebappController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bootpay ObjectC Sample";
    [self setUI];
}

- (void) setUI {
    int max = 2;
    float w = [[UIScreen mainScreen] bounds].size.width;
    float h = [[UIScreen mainScreen] bounds].size.height / max;
    for(int i = 0; i < max; i++ ) {
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        [btn setFrame: CGRectMake(0, i * h, w, h)];
        btn.tag = i;
        [btn setTitle: [self getBtnTitle:i] forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents: UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (NSString*) getBtnTitle:(int)index {
    if(index == 0) return @"Native Sample";
    else if(index == 1) return @"WebApp Sample";
    return @"";
}

- (void) clickBtn:(UIButton*)button {
    if(button.tag == 0) {
        NativeController *vc = [[NativeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(button.tag == 1) {
        WebappController *vc = [[WebappController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
