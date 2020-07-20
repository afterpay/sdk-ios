//
//  Objc.h
//  Example
//
//  Created by Adam Campbell on 30/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Objc : NSObject

typedef void (^ SuccessHandler)(NSString *);
typedef void (^ UserInitiatedCancelHandler)(void);
typedef void (^ NetworkErrorCancelHandler)(NSError *);
typedef void (^ InvalidURLCancelHandler)(NSURL *);

+ (void)presentCheckoutModallyOverViewController:(UIViewController *)viewController
                              loadingCheckoutURL:(NSURL *)url
                                  successHandler:(SuccessHandler)successHandler
                      userInitiatedCancelHandler:(UserInitiatedCancelHandler)userInitiatedCancelHandler
                       networkErrorCancelHandler:(NetworkErrorCancelHandler)networkErrorCancelHandler
                         invalidURLCancelHandler:(InvalidURLCancelHandler)invalidURLCancelHandler
NS_SWIFT_NAME(presentCheckoutModally(over:loading:successHandler:userInitiatedCancelHandler:networkErrorCancelHandler:invalidURLCancelHandler:));

@end

NS_ASSUME_NONNULL_END
