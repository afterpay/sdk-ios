//
//  ObjcCheckoutViewController.h
//  Example
//
//  Created by Adam Campbell on 24/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcCheckoutViewController : UIViewController

typedef void (^ URLCallback)(NSURL* _Nullable, NSError* _Nullable);
typedef void (^ URLProvider)(URLCallback);

- (instancetype)init __unavailable;
- (instancetype)initWithURLProvider:(URLProvider)urlProvider NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil __unavailable;
- (instancetype)initWithCoder:(NSCoder *)coder __unavailable;

@end

NS_ASSUME_NONNULL_END
