//
//  VCHelper.h
//  VChat
//
//  Created by mihata on 11/28/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCHelper : NSObject

+(NSURLRequest*) sendSimpleHTTPRequestFor: (NSString*)url withStringData: (NSString*)stringData;
+(NSURLRequest*) sendSimpleRequestForUser: (NSString* )user withPassword: (NSString*)pass;
+(void) showAlertMessageWithTitle: (NSString*) title andText: (NSString*) text; 
@end
