//
//  VCChannel.h
//  VChat
//
//  Created by mihata on 11/27/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCChannel : NSObject {
    @private NSString* name;
}

@property (nonatomic, retain) NSString* name;

@end
