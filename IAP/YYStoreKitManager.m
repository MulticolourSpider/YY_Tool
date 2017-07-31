//
//  CCStoreKitManager.m
//  IAPPaymentDemo
//
//  Created by admin on 13-11-19.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import "YYStoreKitManager.h"
#import "GTMBase64.h"
#import <AdSupport/ASIdentifierManager.h>
static YYStoreKitManager* _sharedInstance = nil;

@implementation YYStoreKitManager

+(YYStoreKitManager*)sharedInstance
{
    
    if (!_sharedInstance) {
        _sharedInstance = [[self alloc] init];
        
    }
    return _sharedInstance;

}

+(id)alloc
{
	@synchronized([YYStoreKitManager class])
	{
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.\n");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
	return self;
}

-(void)initialStore
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
-(void)releaseStore
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)buy:(NSString*)buyProductIDTag
{
    [self requestProductData:buyProductIDTag];
}

-(bool)CanMakePay
{
    return [SKPaymentQueue canMakePayments];
}

-(void)requestProductData:(NSString*)buyProductIDTag{
    NSLog(@"---------Request product information------------\n");
    _buyProductIDTag = buyProductIDTag ;
    NSArray *product = [[NSArray alloc] initWithObjects:buyProductIDTag,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
   
}

#pragma argument 
#pragma argument  SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------Getting product information-------Yp-------%@\n",response);
    NSArray *myProduct = response.products;
    NSLog(@"Product ID:%@\n",response.invalidProductIdentifiers);
    NSLog(@"Product count: %lu\n", (unsigned long)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"Detail product info\n");
        NSLog(@"SKProduct description: %@\n", [product description]);
        NSLog(@"Product localized title: %@\n" , product.localizedTitle);
        NSLog(@"Product localized descitption: %@\n" , product.localizedDescription);
        NSLog(@"Product price: %@\n" , product.price);
        NSLog(@"Product identifier: %@\n" , product.productIdentifier);
    }
    SKPayment *payment = nil;
    payment = [SKPayment paymentWithProduct:[response.products objectAtIndex:0]];
    NSLog(@"---------Request payment------------\n");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
   
    
}
- (void)requestProUpgradeProductData:(NSString*)buyProductIDTag
{
    NSLog(@"------Request to upgrade product data---------\n");
    NSSet *productIdentifiers = [NSSet setWithObject:buyProductIDTag];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"-------Show fail message----------\n");
    NSLog(@"%@",error);
  
   
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------Request finished--------------\n%@",request);
    
}

-(void) purchasedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----Purchased Transaction----\n");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
   
}

#pragma argument
#pragma argument  SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"-----Payment result--------\n");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            {   //购买_成功
                
                self.times = 0;  //向服务器验证的次数
                //创建请求到苹果官方进行购买验证
               
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
                    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                      NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
//                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receiptData options:NSJSONReadingAllowFragments error:nil];

                        self.receipt = receiptString;
                        [self checkReceiptIsValid];
                        [self completeTransaction:transaction];
                      });
                });
                
            }
            
          break;
            case SKPaymentTransactionStateFailed: //购买_失败
                [self failedTransaction:transaction];
                NSLog(@"-----Transaction Failed--------\n");
                 //TODO: 购买失败的提示
               
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                NSLog(@"----- Already buy this product--------\n");
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"-----Transcation puchasing--------\n");
                break;
            default:
                break;
        }
    }
}
/** 验证支付结果 */
-(void) checkReceiptIsValid {
    
    //就是 将本地购买之后 苹果返回的 购买凭证 发给自己后台验证, 数据比较多用post请求
    
    
    
    NSString *strUrl = @"";
    // strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //ios 9之前
    //ios 9 之后
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 系统版本
    NSString  *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSDictionary *Infodic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersionStr = [Infodic objectForKey:@"CFBundleShortVersionString"];
    NSString *appBuildStr = [Infodic objectForKey:@"CFBundleVersion"];
    NSString *uuidStr = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    //platform/platform_version/app_version/app_version_num/uuid/push_id/channel/last_login_ip/lang
    //NSString *valuestr = [NSString stringWithFormat:@"1/%@/%@/%@/%@/%@/1/%@/en",systemVersion,appVersionStr,appBuildStr,uuidStr,tuisongma,networkOutIp];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
   
    NSString *httpbodyString = [NSString stringWithFormat:@"apple_receipt=%@",self.receipt];
    request.HTTPBody = [httpbodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:@"" forHTTPHeaderField:@"AGENT"];
    [mutableRequest addValue:@"" forHTTPHeaderField:@"AUTH"];
    [mutableRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request = [mutableRequest copy];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                NSLog(@"=========== error ==========");
            }  else {
                NSLog(@"=========== Success =========");
            }
        });
        
    }];
    [dataTask resume];
    
    
 
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----completeTransaction--------\n");
 
    
 
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

-(void)recordTransaction:(NSString *)product
{
    NSLog(@"-----Record transcation--------\n");
    // Todo: Maybe you want to save transaction result into plist.
}

-(void)provideContent:(NSString *)product
{
    NSLog(@"-----Download product content--------\n");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Failed\n");
    if (transaction.error.code != SKErrorPaymentCancelled){
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction
{
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-----Restore transaction--------\n");
}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"-------Payment Queue----\n");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@\n",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"test\n");
}   



@end
