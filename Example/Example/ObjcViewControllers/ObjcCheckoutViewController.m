//
//  ObjcCheckoutViewController.m
//  Example
//
//  Created by Adam Campbell on 24/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

#import "ObjcCheckoutViewController.h"
#import "Example-Swift.h"
#import <Afterpay/Afterpay-Swift.h>

@interface ObjcCheckoutViewController ()

@property (nonatomic, readonly) CheckoutView *checkoutView;
@property (nonatomic, readonly, strong) URLProvider urlProvider;

@end

@implementation ObjcCheckoutViewController

- (instancetype)initWithURLProvider:(URLProvider)urlProvider {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _urlProvider = urlProvider;
  }

  return self;
}

- (void)loadView {
  self.view = [[CheckoutView alloc] init];
}

- (CheckoutView *)checkoutView {
  return (CheckoutView *)self.view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Objc Checkout";

  UIButton *payButton = self.checkoutView.payButton;

  [payButton addTarget:self
                action:@selector(didTapPay)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapPay {
  __weak __typeof__(self) weakSelf = self;

  void (^presentCheckout)(NSURL *) = ^(NSURL *url) {
    __typeof__(self) strongSelf = weakSelf;

    void (^completion)(APCheckoutResult *) = ^(APCheckoutResult *result) {
      if ([result isKindOfClass:[APCheckoutResultSuccess class]]) {
        NSLog(@"Checkout Token: %@", [(APCheckoutResultSuccess *)result token]);
      } else if ([result isKindOfClass:[APCheckoutResultCancelled class]]) {
        NSLog(@"Checkout Cancelled");
      }
    };

    if (strongSelf) {
      [APAfterpay presentCheckoutModallyOverViewController:strongSelf
                                                loadingURL:url
                                                completion:completion];
    }
  };

  void (^presentError)(NSError *) = ^(NSError *error) {
    __typeof__(self) strongSelf = weakSelf;

    UIAlertController *alert = [AlertFactory alertFor:error];
    [strongSelf presentViewController:alert animated:YES completion:nil];
  };

  self.urlProvider(^(NSURL *url, NSError *error) {
    void (^action)(void) = ^{};

    if (url) {
      action = ^{
        presentCheckout(url);
      };
    } else if (error) {
      action = ^{
        presentError(error);
      };
    }

    dispatch_async(dispatch_get_main_queue(), action);
  });
}

@end
