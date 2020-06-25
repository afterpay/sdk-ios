//
//  ObjcCheckoutViewController.m
//  Example
//
//  Created by Adam Campbell on 24/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

#import "ObjcCheckoutViewController.h"
#import "Example-Swift.h"

@interface ObjcCheckoutViewController ()

@property (nonatomic, readonly) CheckoutView *checkoutView;

@end

@implementation ObjcCheckoutViewController

- (CheckoutView *)checkoutView {
  return (CheckoutView *)self.view;
}

- (void)loadView {
  self.view = [[CheckoutView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.checkoutView.payButton addTarget:self
                                  action:@selector(didTapPay)
                        forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapPay {

}

@end
