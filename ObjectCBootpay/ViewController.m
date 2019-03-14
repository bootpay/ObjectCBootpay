//
//  ViewController.m
//  ObjectCBootpay
//
//  Created by YoonTaesup on 2019. 3. 14..
//  Copyright © 2019년 kr.co.bootpay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <BootpayRequestProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendAnaylticsUserLogin];
    [self sendAnaylticsPageCall];
    [self presentBootpayController];
}


- (void) sendAnaylticsUserLogin {
    BootpayUser *bu = [[BootpayAnalytics sharedInstance] user];
    bu.id = @"testUser";
    bu.username = @"홍\"길'동";
    bu.email = @"testUser@gmail.com"; // user email
    bu.gender = 1;
    bu.birth = @"861014";
    bu.phone = @"01040334678";
    bu.area = @"서울";

    [[BootpayAnalytics sharedInstance] postLogin];
}

- (void) sendAnaylticsPageCall {
    BootpayStatItem *item1 = [[BootpayStatItem alloc] init];
    item1.item_name = @"마\"우'스";
    item1.item_img = @"https://image.mouse.com/1234";
    item1.unique = @"ITEM_CODE_MOUSE";

    BootpayStatItem *item2 = [[BootpayStatItem alloc] init];
    item2.item_name = @"키보드";
    item2.item_img = @"https://image.keyboard.com/12345";
    item2.unique = @"ITEM_CODE_KEYBOARD";
    item2.cat1 = @"패션";
    item2.cat2 = @"여성상의";
    item2.cat3 = @"블라우스";

    NSArray *items = [NSArray arrayWithObjects: item1, item2, nil];
    [[BootpayAnalytics sharedInstance] start: @"ItemViewController" :@"ItemDetail" items: items];
}

- (void) presentBootpayController {
    BootpayController *vc = [[BootpayController alloc] init];

    BootpayItem *item1 = [[BootpayItem alloc] init];
    item1.item_name = @"미\"키's 마우스";
    item1.qty = 1;
    item1.unique = @"ITEM_CODE_MOUSE";
    item1.price = 1000;

    BootpayItem *item2 = [[BootpayItem alloc] init];
    item2.item_name = @"키보드";
    item2.qty = 1; // 해당 상품의 주문 수량
    item2.unique = @"ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    item2.price = 10000; // 상품의 가격
    item2.cat1 = @"패션";
    item2.cat2 = @"여\"성'상의";
    item2.cat3 = @"블라우스";

    NSMutableDictionary *customParams = [[NSMutableDictionary alloc] init];
    [customParams setValue: @"value12" forKey: @"callbackParam1"];
    [customParams setValue: @"value34" forKey: @"callbackParam2"];

    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setValue: @"사용자 이름" forKey: @"username"];
    [userInfo setValue: @"user1234@gmail.com" forKey: @"email"];
    [userInfo setValue: @"사용자 주소@gmail.com" forKey: @"addr"];
    [userInfo setValue: @"010-1234-4567" forKey: @"phone"];

    [vc addItem: item1];
    [vc addItem: item2];

    vc.price = 1000;
    vc.name = @"블링\"블링's 마스카라";
    vc.order_id = @"1234_1234_124";
    vc.name = @"블링\"블링's 마스카라";
    vc.pg = @"nice";
    vc.method = @"card";
    vc.params = customParams;
    vc.user_info = userInfo;
    vc.sendable = self;


    [self.view addSubview:vc.view];

}

- (void) onError {

}


- (void)onCancel:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onCancel %@", data);
}

- (void)onClose {
    NSLog(@"onClose");
}

- (void)onConfirm:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onConfirm %@", data);
}

- (void)onDone:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onDone %@", data);
}

- (void)onError:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onError %@", data);
}

- (void)onReady:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onReady %@", data);
}

@end
