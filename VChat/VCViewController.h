//
//  VCViewController.h
//  VChat
//
//  Created by mihata on 11/27/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"

@interface VCViewController : UIViewController <NSURLConnectionDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField* usernameFld;
@property (weak, nonatomic) IBOutlet UITextField* passwordFld;
- (IBAction)loginBtn:(id)sender;

@property (retain, nonatomic) NSMutableData* responseData;
//@property (weak, nonatomic) IBOutlet UIImage* preloadingImg;
@property (weak, nonatomic) IBOutlet UIImageView *preloadingImg;
@property (retain, nonatomic) DACircularProgressView *progressView;

@end
