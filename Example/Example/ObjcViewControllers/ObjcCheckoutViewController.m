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
  self.urlProvider(^(NSURL *url, NSError *error) {
    if (url) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [Afterpay presentCheckoutOverViewController:self loadingURL:url];
      });
    }
  });
}

@end
