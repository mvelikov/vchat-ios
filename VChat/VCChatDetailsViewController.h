//
//  VCChatDetailsViewController.h
//  VChat
//
//  Created by mihata on 11/29/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCChannel.h"
#import "VCMessage.h"
@interface VCChatDetailsViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>

@property (retain, nonatomic) VCMessage* messageObj;
@property (retain, nonatomic) NSMutableArray* messagesArray;
@property (retain, nonatomic) VCChannel* channelObj;
@property (weak, nonatomic) IBOutlet UITextField *messageFld;
- (IBAction)sendMsg:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIWebView *messagesList;

//-(void)setChannelObj:(VCChannel *)channel;
@end
