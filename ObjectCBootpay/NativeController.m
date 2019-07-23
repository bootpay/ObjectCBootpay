//
//  NativeController.m
//  ObjectCBootpay
//
//  Created by YoonTaesup on 2019. 3. 19..
//  Copyright © 2019년 kr.co.bootpay. All rights reserved.
//

#import "NativeController.h"

@interface NativeController () <BootpayRequestProtocol>

@end

@implementation NativeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self sendAnaylticsUserLogin];
    [self sendAnaylticsPageCall];
    [self presentBootpayController];
}


- (void) sendAnaylticsUserLogin {
    BootpayUser *bu = [[Bootpay sharedInstance] user];
    bu.id = @"testUser";
    bu.username = @"홍\"길'동";
    bu.email = @"testUser@gmail.com"; // user email
    bu.gender = 1;
    bu.birth = @"861014";
    bu.phone = @"01040334678";
    bu.area = @"서울";
    
    [BootpayAnalytics postLogin];
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
    [BootpayAnalytics start: @"ItemViewController" :@"ItemDetail" items: items];
}

- (void) presentBootpayController {
//    vc = [[BootpayController alloc] init];
    
    BootpayItem *item1 = [[BootpayItem alloc] init];
    item1.item_name = @"미\"키's 마우스"; // 주문정보에 담길 상품명
    item1.qty = 1; // 해당 상품의 주문 수량
    item1.unique = @"ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    item1.price = 1000; // 상품의 가격
    
    BootpayItem *item2 = [[BootpayItem alloc] init];
    item2.item_name = @"키보드";
    item2.qty = 1; // 해당 상품의 주문 수량
    item2.unique = @"ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    item2.price = 10000; // 상품의 가격
    item2.cat1 = @"패션";
    item2.cat2 = @"여\"성'상의";
    item2.cat3 = @"블라우스";
    
    NSArray *items = @[item1, item2];
    
    // 커스텀 변수로, 서버에서 해당 값을 그대로 리턴 받음
    NSMutableDictionary *customParams = [[NSMutableDictionary alloc] init];
    [customParams setValue: @"value12" forKey: @"callbackParam1"];
    [customParams setValue: @"value34" forKey: @"callbackParam2"];
    
    // 구매자 정보
    BootpayUser *bootUser = [[BootpayUser alloc] init];
    bootUser.username = @"사용자 이름";
    bootUser.email = @"user1234@gmail.com";
    bootUser.area = @"서울";
    bootUser.phone = @"010-1234-5678";
    
    BootpayPayload *payload = [[BootpayPayload alloc] init];
    payload.price = 1000;
    payload.name = @"블링블링's 마스카라";
    payload.order_id = @"1234_1234_1234";
    payload.params = customParams; 
    payload.pg = BootpayPG.DANAL;
    payload.method = BootpayMethod.CARD;
    payload.ux = BootpayUX.PG_DIALOG;
    
    
    BootpayExtra *bootExtra = [[BootpayExtra alloc] init];
    bootExtra.quotas = @[ @0, @2, @3];
    
    [Bootpay request_objc:self :self :payload :bootUser :items :bootExtra :nil :nil :nil];
}

- (void) onError {
    
}


- (void)onCancel:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onCancel %@", data);
}

- (void)onClose {
    NSLog(@"onClose");
    [Bootpay dismiss];
}

- (void)onConfirm:(NSDictionary<NSString *,id> * _Nonnull)data {
    NSLog(@"onConfirm %@", data);
    
    // 재고검사를 하는 로직을 넣으시면 됩니다
    
    //  재고가 있어, 결제를 원할 경우
    if (true) {
        [Bootpay transactionConfirm: data];
    } else {
        [Bootpay dismiss];
    }
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
