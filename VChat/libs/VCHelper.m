//
//  VCHelper.m
//  VChat
//
//  Created by mihata on 11/28/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import "VCHelper.h"

@implementation VCHelper

+(NSURLRequest*) sendSimpleHTTPRequestFor: (NSString*)url withStringData: (NSString*)stringData {
    NSURL *fullUrl = [NSURL URLWithString:[kBaseHref stringByAppendingString:url]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fullUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSData *data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    return request;
}

+(NSURLRequest*) sendSimpleHTTPREquestForChannelsWithPassword: (NSString*) pass {
    if ([pass length] == 0) {
        [NSException raise:@"Invalid user and pass string provided" format:@"Fill in user and pass strings"];
    }
    NSString *passwordString = [@"pass=" stringByAppendingString:pass];
    
    return [self sendSimpleHTTPRequestFor:@"channel/index" withStringData:passwordString];
}

+(NSURLRequest*) sendSimpleRequestForUser: (NSString* )user withPassword: (NSString*)pass {

    if ([user length] == 0 && [pass length] == 0) {
        [NSException raise:@"Invalid user and pass string provided" format:@"Fill in user and pass strings"];
    }
    NSString *userString = [@"user=" stringByAppendingString:user];
    NSString *passwordString = [@"&pass=" stringByAppendingString:pass];
    NSString *postString = [userString stringByAppendingString:passwordString];
    
    return [self sendSimpleHTTPRequestFor:@"user/index" withStringData:postString];
}

+(void) showAlertMessageWithTitle:(NSString *)title andText:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:title
                                                         message:text
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    
    [alertView show];
}

@end
