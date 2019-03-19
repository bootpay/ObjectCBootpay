//
//  WebappController.m
//  ObjectCBootpay
//
//  Created by YoonTaesup on 2019. 3. 19..
//  Copyright © 2019년 kr.co.bootpay. All rights reserved.
//

#import "WebappController.h"

@interface WebappController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@end

@implementation WebappController

#pragma mark - ViewControllerDelegate
- (void)viewDidLoad {
    [super viewDidLoad];
    bridgeName = @"Bootpay_iOS";
    ios_application_id = @"5a52cc39396fa6449880c0f0";
    [self setUI];
}

- (void) setUI {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [[config userContentController] addScriptMessageHandler:self name:bridgeName];
    wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    [wkWebView setNavigationDelegate:self];
    [wkWebView setUIDelegate:self];
    [self.view addSubview: wkWebView];
    
//    NSString *url = @"https://g-cdn.bootpay.co.kr/test/payment/index.html";
    NSString *url = @"https://test-shop.bootpay.co.kr";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
    [wkWebView loadRequest:request];
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    [self registerAppId]; //필요시 App ID를 아이폰 값으로 바꿉니다
    [self setDevice]; //기기환경을 IOS로 등록합니다. 이 작업을 수행해야 통계에 iOS로 잡히며, iOS Application ID 값을 호출하여 결제를 사용할 수 있습니다.
    [self startTrace]; // 통계 - 페이지 방문
}

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    NSString *scheme = navigationAction.request.URL.scheme; 
    
    if ([self isiTunesURL: url]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options: @{} completionHandler: nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if (!([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"])) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options: @{} completionHandler: nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - WKScriptMessageHandler
- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message body = %@", message.body);
    if ([[message name] isEqualToString: bridgeName]) {
        if([[NSString stringWithFormat:@"%@", message.body] isEqualToString:@"close"]) {
            return;
        }
        NSString *action = [message.body objectForKey:@"action"];
        if([@"BootpayCancel" isEqualToString:action]) {
            [self onCancel:message.body];
        } else if([@"BootpayError" isEqualToString:action]) {
            [self onError:message.body];
        } else if([@"BootpayBankReady" isEqualToString:action]) {
            [self onReady:message.body];
        } else if([@"BootpayConfirm" isEqualToString:action]) {
            [self onConfirm:message.body];
        } else if([@"BootpayDone" isEqualToString:action]) {
            [self onDone:message.body];
        }
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {

    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    } else {
        completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
    }
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSURL *url = navigationAction.request.URL;
    if(url != nil) {
           [[UIApplication sharedApplication] openURL:navigationAction.request.URL options: @{} completionHandler: nil];
    }
    return nil;
}

//- (void) webvie


#pragma mark - Bootpay Sample Function
- (void) registerAppId {
    [self doJavascript:[NSString stringWithFormat:@"BootPay.setApplicationId('%@');", ios_application_id]];
}

- (void) setDevice {
    [self doJavascript:@"window.BootPay.setDevice('IOS');"];
}

- (void) startTrace {
    [self doJavascript:@"BootPay.startTrace();"];
}

- (void) doJavascript:(NSString*) script {
    [wkWebView evaluateJavaScript:script completionHandler:nil];
}

- (NSString*) dicToJsonString:(NSDictionary*) dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (BOOL)isMatch:(NSString *)url pattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        return NO;
    }
    
    NSTextCheckingResult *res = [regex firstMatchInString:url options:0 range:NSMakeRange(0, url.length)];
    return res != nil;
}

- (BOOL)isiTunesURL:(NSString *)url {
    return [self isMatch:url pattern:@"\\/\\/itunes\\.apple\\.com\\/"];
}

- (void) onError:(NSDictionary*) data {
    NSLog(@"onError %@", data);
}

- (void) onReady:(NSDictionary*) data {
    NSLog(@"onReady %@", data);
}

- (void) onConfirm:(NSDictionary*) data {
    NSLog(@"onConfirm %@", data);
    
    // 재고가 있을경우, 결제를 원할 경우
    if(true) {
        NSString *json = [[self dicToJsonString:data] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
        [self doJavascript: [NSString stringWithFormat:@"BootPay.transactionConfirm(%@);", json]];
    } else {
        [self doJavascript:@"BootPay.removePaymentWindow();"];
    }
}

- (void) onCancel:(NSDictionary*) data {
    NSLog(@"onCancel %@", data);
}

- (void) onDone:(NSDictionary*) data {
    NSLog(@"onDone %@", data);
}

- (void) onClose {
    NSLog(@"onClose");
}
@end
