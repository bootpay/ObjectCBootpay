//
//  WebappController.h
//  ObjectCBootpay
//
//  Created by YoonTaesup on 2019. 3. 19..
//  Copyright © 2019년 kr.co.bootpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebappController : UIViewController {
    NSString *bridgeName;
    NSString *ios_application_id;
    WKWebView *wkWebView;
}

@end

NS_ASSUME_NONNULL_END
