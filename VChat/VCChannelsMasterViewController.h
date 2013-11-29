//
//  VCChannelsMasterViewController.h
//  VChat
//
//  Created by mihata on 11/29/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCChannelsMasterViewController : UITableViewController <UITableViewDataSource, NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableArray* channelsList;
@end
