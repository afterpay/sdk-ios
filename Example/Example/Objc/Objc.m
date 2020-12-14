//
//  Objc.m
//  Example
//
//  Created by Adam Campbell on 30/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

#import "Objc.h"
#import <Afterpay/Afterpay-Swift.h>

@implementation Objc

+ (void)presentCheckoutModallyOverViewController:(UIViewController *)viewController
                              loadingCheckoutURL:(NSURL * _Nullable)url
                                  successHandler:(SuccessHandler)successHandler
                      userInitiatedCancelHandler:(UserInitiatedCancelHandler)userInitiatedCancelHandler
                       networkErrorCancelHandler:(NetworkErrorCancelHandler)networkErrorCancelHandler
                         invalidURLCancelHandler:(InvalidURLCancelHandler)invalidURLCancelHandler
{
  void (^completion)(APCheckoutResult *) = ^(APCheckoutResult *result) {

    if ([result isKindOfClass:[APCheckoutResultSuccess class]]) {
      successHandler([(APCheckoutResultSuccess *)result token]);
      return;
    }

    APCancellationReason *reason = [(APCheckoutResultCancelled *)result reason];

    if ([reason isKindOfClass:[APCancellationReasonUserInitiated class]]) {
      userInitiatedCancelHandler();
    } else if ([reason isKindOfClass:[APCancellationReasonNetworkError class]]) {
      networkErrorCancelHandler([(APCancellationReasonNetworkError *)reason error]);
    } else if ([reason isKindOfClass:[APCancellationReasonInvalidURL class]]) {
      invalidURLCancelHandler([(APCancellationReasonInvalidURL *)reason url]);
    }

  };

  [APAfterpay presentCheckoutModallyOverViewController:viewController
                                    loadingCheckoutURL:url
                                              animated:true
                                            completion:completion];
}

@end
