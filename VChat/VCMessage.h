//
//  VCMessage.h
//  VChat
//
//  Created by mihata on 11/27/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCMessage : NSObject {
    @private NSString* message;
    @private NSString* channel;
    @private VCUser* user;
}

@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* channel;
@property (nonatomic, retain) VCUser* user;

@end
