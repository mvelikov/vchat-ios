//
//  VCViewController.h
//  VChat
//
//  Created by mihata on 11/27/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField* usernameFld;
@property (weak, nonatomic) IBOutlet UITextField* passwordFld;
- (IBAction)loginBtn:(id)sender;

@end
