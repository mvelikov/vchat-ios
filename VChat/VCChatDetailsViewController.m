//
//  VCChatDetailsViewController.m
//  VChat
//
//  Created by mihata on 11/29/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import "VCChatDetailsViewController.h"


@interface VCChatDetailsViewController ()

@end

@implementation VCChatDetailsViewController

@synthesize channelObj;
@synthesize messageFld;
@synthesize sendBtn;
@synthesize messageObj;
@synthesize messagesList;
@synthesize messagesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void) setChannelObj:(VCChannel *)channel {
//    if (channelObj != channel)
//    channelObj = channel;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self
                                                         withBlock:^(PNMessage *message) {

                                                             [self mergePresentMessagesWithNew:message.message ];
//                                                             [VCHelper showAlertMessageWithTitle: messageObj.message andText:channelObj.name ];
                                                         }];
    
    PNChannel* currentChannel = [PNChannel channelWithName:channelObj.uid
                               shouldObservePresence:NO];
    [PubNub subscribeOnChannel:currentChannel withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *subscriptionError) {
        
        NSString *alertMessage = [NSString stringWithFormat:@"Subscribed on channel: %@",
                                  channelObj.name];
        if (state == PNSubscriptionProcessNotSubscribedState) {
            
            alertMessage = [NSString stringWithFormat:@"Failed to subscribe on: %@", channelObj.name];
            
            [VCHelper showAlertMessageWithTitle:@"Subscribe" andText:alertMessage];

        } else if (state == PNSubscriptionProcessSubscribedState) {
//            [self DisplayInLog: alertMessage];
//            [self ShowChannelInLabel: channelObj.name bRemove:FALSE];
            [VCHelper showAlertMessageWithTitle:@"Subscribe" andText:alertMessage];
        }
    }];

//    messageFld.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:messageFld])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    CGRect webRect = self.messagesList.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        
        webRect.origin.y +=kOFFSET_FOR_KEYBOARD;
        webRect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        
        webRect.origin.y -=kOFFSET_FOR_KEYBOARD;
        webRect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    self.messagesList.frame = webRect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textFieldShouldReturn)
//                                                 name:
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(NSString *)JSONString:(NSString *)aString {
	NSMutableString *s = [NSMutableString stringWithString:aString];
	[s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	[s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
	return [NSString stringWithString:s];
}

- (IBAction)sendMsg:(id)sender {
    [self.view endEditing:YES];
    messageObj = [[VCMessage alloc] init];
    //text = '<span class="author">' + userObj.user + '</span> said: <br />' + text;
    
    
    VCUser* user = [VCUser sharedUser];
    NSString* messageString = [NSString stringWithFormat:@"<span class=\"author\">%@</span> said: <br />%@",
                               [user username],
                               messageFld.text];
    [messageObj setUser:user];
    [messageObj setMessage:messageString];
    [messageObj setChannel:channelObj];
    
    [messagesArray addObject:messageObj];
    
    @try {
        [NSURLConnection connectionWithRequest:[VCHelper sendSimpleHTTPRequestForChannel: channelObj.uid WithPassword: user.password andMessage:[self JSONString:[messageObj message]]] delegate:self];
    }
    @catch (NSException *exception) {
        [VCHelper showAlertMessageWithTitle:@"Error" andText:@"There is something wrong with message sending, please try again later!"];
    }
    
    [self.messageFld setText:@""];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    //    [responseData appendData:data];
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    int success = [[jsonData objectForKey:@"success"] intValue];
    if (success == 1) {
        PNChannel *ch = [PNChannel channelWithName:channelObj.uid
                             shouldObservePresence:NO];
        [PubNub sendMessage:[self JSONString:[messageObj message]] toChannel:ch];
        

//        [self mergePresentMessagesWithNew:messageObj.message];
        

//        messagesList.scrollView.contentOffset = CGPointMake(0, [messagesArray count] * 100);
    } else {
        
    }

}

-(void) mergePresentMessagesWithNew : (NSString*) message {
    NSString* htmlContent = message;
    htmlContent = [htmlContent stringByAppendingString:@"<hr /><br />"];
    htmlContent = [htmlContent stringByAppendingString:[messagesList stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]];
    
    [messagesList loadHTMLString:htmlContent baseURL:nil];

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}
@end
