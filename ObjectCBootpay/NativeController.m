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
    
    BootpayRequest *request = [[BootpayRequest alloc] init];
    request.price = 1000;
    request.name = @"블링블링's 마스카라";
    request.order_id = @"1234_1234_1234";
    request.params = customParams;
//    request.pg = BootpayMethod
    request.pg = BootpayPG.DANAL;
    request.method = BootpayMethod.CARD;
    request.ux = BootpayUX.PG_DIALOG;
    
//    // 주문정보 - 실제 결제창에 반영되는 정보
//    vc.price = 1000; // 결제할 금액
//    vc.name = @"블링\"블링's 마스카라"; // 결제할 상품명
//    vc.order_id = @"1234_1234_124"; //고유 주문번호로, 생성하신 값을 보내주셔야 합니다.
//    vc.name = @"블링\"블링's 마스카라";  // 커스텀 변수
//    vc.pg = @"danal"; // 결제할 PG사
//    vc.phone = @"010-1234-5678"; // 구매자 번호
//    vc.method = @"card"; // 결제수단
//    //    vc.account_expire_at = "2018-09-25" // 가상계좌 입금기간 제한 ( yyyy-mm-dd 포멧으로 입력해주세요. 가상계좌만 적용됩니다. 오늘 날짜보다 더 뒤(미래)여야 합니다 )
//    vc.params = customParams;
//    vc.user_info = userInfo;
//    vc.sendable = self; // 이벤트를 처리할 protocol receiver
//
//    [self.navigationController presentViewController: vc animated: YES completion: nil]; // 결제창 modal controller 호출
    //    [self.view addSubview:vc.view];
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
