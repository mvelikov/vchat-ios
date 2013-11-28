//
//  VCUser.m
//  VChat
//
//  Created by mihata on 11/27/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import "VCUser.h"

@implementation VCUser
@synthesize username;
@synthesize password;

+(VCUser*) sharedUser {
    static VCUser* sharedMyUser = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        sharedMyUser = [[self alloc] init];
    });
    
    return sharedMyUser;
}

-(id) init {
    if (self = [super init]) {
        username = [[NSString alloc] init];
        password = [[NSString alloc] init];
    }
    
    return self;
}

-(void)dealloc {
    
}
@end
