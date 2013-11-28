//
//  VCViewController.m
//  VChat
//
//  Created by mihata on 11/27/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import "VCViewController.h"
#import "VCConfig.h"

@interface VCViewController ()

@end

@implementation VCViewController

@synthesize usernameFld;
@synthesize passwordFld;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    usernameFld.delegate = self;
    passwordFld.delegate = self;
    
    [PubNub setConfiguration:[PNConfiguration configurationForOrigin:kOrigin publishKey:kPubKey subscribeKey:kSubKey secretKey:kSecret]];
    
    [PubNub connectWithSuccessBlock:^(NSString *origin) {
        PNLog(PNLogGeneralLevel, self, @"{BLOCK} PubNub client connected to: %@", origin);
    
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [PubNub subscribeOnChannel:[PNChannel channelWithName:@"channel1" shouldObservePresence:YES]]; });
        
    } errorBlock:^(PNError *connectionError) {
        
        if (connectionError.code == kPNClientConnectionFailedOnInternetFailureError) {
            // wait 1 second
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                PNLog(PNLogGeneralLevel, self, @"Connection will be established as soon as internet connection will be restored");
            });
        }
        UIAlertView *connectionErrorAlert = [UIAlertView new]; connectionErrorAlert.title = [NSString stringWithFormat:@"%@(%@)",
        [connectionError localizedDescription],
        NSStringFromClass([self class])];
        connectionErrorAlert.message = [NSString stringWithFormat:@"Reason:\n%@\n\nSuggestion:\n%@",
        [connectionError localizedFailureReason],
        [connectionError localizedRecoverySuggestion]]; [connectionErrorAlert addButtonWithTitle:@"OK"];
        [connectionErrorAlert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(id)sender {
    
    [self.view endEditing:YES];
//    NSURL *url = [NSURL URLWithString:[kBaseHref stringByAppendingString:@"user/index"]];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
//
//    NSString *userString = [@"user=" stringByAppendingString:usernameFld.text];
//    NSString *passwordString = [@"&pass=" stringByAppendingString:passwordFld.text];
//    NSString *postString = [userString stringByAppendingString:passwordString];
//    
//    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    
    @try {
        [NSURLConnection connectionWithRequest:[VCHelper sendSimpleRequestForUser:usernameFld.text withPassword: passwordFld.text] delegate:self];
    } @catch (NSException* e) {
        NSLog(@"Exception");
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"Invalid Credentials"
                                                     message:@"Please provide a valid username and passowrd!"
                                                    delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
//   _responseData  = [[NSMutableData alloc] init];
    NSLog(@"1");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
//    [_responseData appendData:data];
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
    NSLog(@"2");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"3");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"4");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"5");
}
@end
