//
//  CCStoreKitManager.h
//  IAPPaymentDemo
//
//  Created by admin on 13-11-19.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface YYStoreKitManager : NSObject<SKRequestDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    int buyType;
    NSString* _buyProductIDTag;
    
}
@property (nonatomic, strong)NSString *receipt;
@property (nonatomic, assign)NSInteger times;
+ (YYStoreKitManager*) sharedInstance;

- (void) buy:(NSString*)buyProductIDTag;
- (bool) CanMakePay;
- (void) initialStore;
- (void) releaseStore;
- (void) requestProductData:(NSString*)buyProductIDTag;
- (void) provideContent:(NSString *)product;
- (void) recordTransaction:(NSString *)product;

- (void) requestProUpgradeProductData:(NSString*)buyProductIDTag;
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) purchasedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;
- (void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

@end
