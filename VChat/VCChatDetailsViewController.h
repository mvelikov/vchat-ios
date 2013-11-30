//
//  VCChatDetailsViewController.h
//  VChat
//
//  Created by mihata on 11/29/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCChatDetailsViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageFld;
- (IBAction)sendMsg:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end
