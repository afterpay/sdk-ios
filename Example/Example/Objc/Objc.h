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

+ (void)presentCheckoutModallyOverViewController:(UIViewController *)viewController
                              loadingCheckoutURL:(NSURL *)url
                                  successHandler:(SuccessHandler)successHandler NS_SWIFT_NAME(presentCheckoutModally(over:loading:successHandler:));

@end

NS_ASSUME_NONNULL_END
