//
//  VCChannelsMasterViewController.m
//  VChat
//
//  Created by mihata on 11/29/13.
//  Copyright (c) 2013 mihata. All rights reserved.
//

#import "VCChannelsMasterViewController.h"
#import "VCViewController.h"
#import "VCChannel.h"
#import "VCChatDetailsViewController.h"
@interface VCChannelsMasterViewController ()

@end


@implementation VCChannelsMasterViewController

@synthesize channelsList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) loadSiginInFormModalView {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITableViewController* channelsViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginFormView"];
    
    [self presentViewController:channelsViewController animated:YES completion:nil];
}

-(void) loadChannels {
    @try {
        [NSURLConnection connectionWithRequest:[VCHelper sendSimpleHTTPREquestForChannelsWithPassword:[[VCUser sharedUser] password]] delegate:self];
        ;
    }
    @catch (NSException *exception) {
        [VCHelper showAlertMessageWithTitle:@"Error" andText:@"There is something wrong with the system, please try again later!"];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    channelsList = [[NSMutableArray alloc] init];

    if (![[VCUser sharedUser] loggedin]) {
        [self loadSiginInFormModalView];
    } else {
        [self loadChannels];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL logged = [[VCUser sharedUser] loggedin];
    if (!logged) {
        [self loadSiginInFormModalView];
    } else {
        [self loadChannels];
    }
//    [userObj loggedin];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [channelsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    VCChannel* channel = [channelsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [channel name];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showMessagesView"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        VCChannel* channelObj = channelsList[indexPath.row];
        
        [[segue destinationViewController] setChannelObj:channelObj];
     }
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
//    int success = [[jsonData objectForKey:@"success"] intValue];
//    NSArray* allKeys = [jsonData allKeys];
    
    if (1 > 0) {
        for (NSDictionary* dummyChannel in jsonData) {
            VCChannel* channel = [[VCChannel alloc] init];
            [channel setUid:[dummyChannel objectForKey:@"_id"]];
            [channel setName:[dummyChannel objectForKey:@"name"]];
            
            [channelsList addObject:channel];
        }
        
        [self.tableView reloadData];
    } else {
        [VCHelper showAlertMessageWithTitle:@"No Channels" andText:@"No channels are present, please try again later!"];
    }
//    [self stopAnimation];
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
