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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

@end
