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
                              loadingCheckoutURL:(NSURL *)url
                                  successHandler:(SuccessHandler)successHandler
{
  void (^completion)(APCheckoutResult *) = ^(APCheckoutResult *result) {
    if ([result isKindOfClass:[APCheckoutResultSuccess class]]) {
      successHandler([(APCheckoutResultSuccess *)result token]);
    }
  };

  [APAfterpay presentCheckoutModallyOverViewController:viewController
                                    loadingCheckoutURL:url
                                              animated:true
                                            completion:completion];
}

@end
