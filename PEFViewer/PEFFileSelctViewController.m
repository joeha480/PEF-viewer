//
//  PEFFileSelctViewController.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2014-01-02.
//  Copyright (c) 2014 Joel Håkansson. All rights reserved.
//

#import "PEFFileSelctViewController.h"
#import "PEFRootViewController.h"
#import "PEFModelController.h"
#import "PEFL10N.h"
#import "PEFTableSelectViewController.h"
#import "PEFBrailleTableFactory.h"
#import "PEFAboutViewController.h"


@interface PEFFileSelctViewController ()<PEFTableSelectViewControllerDelegate>
@property (readonly) NSArray *files;
@property (readonly) NSString *inputDir;
@property NSNumber *openIndex;
@property NSString *selectedFile;
@end

@implementation PEFFileSelctViewController
@synthesize files = _files;
@synthesize inputDir = _inputDir;
@synthesize config = _config;

NSString *const TABLE_SELECT_SEGUE_IDENTIFIER = @"tableSelectSegue";
NSString *const VIEW_SEGUE_IDENTIFIER = @"viewerSegue";
NSString *const ABOUT_SEGUE_IDENTIFIER = @"aboutSegue";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(setup:)]];
	self.title = [PEFL10N filesTitle];
	_config = [[PEFBrailleTableFactory alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileListModified:) name:@"PEF-FileListModifiled" object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	cell.textLabel.text = [self.files objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (section == 0) {
		return [NSString stringWithFormat:[PEFL10N filesFooter], self.files.count];
	} else {
		return nil;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section==0) {
		return YES;
	} else {
		return NO;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if ([self.selectedFile isEqualToString:[self.files objectAtIndex:indexPath.row]]) {
			@try {
				[self performSegueWithIdentifier:@"deselectFileSegue" sender:self];
			}
			@catch (NSException *exception) {
				//we're on iPhone
			}
		}

        // Delete the row from the data source
		[[NSFileManager defaultManager] removeItemAtPath:[self.inputDir stringByAppendingPathComponent:[self.files objectAtIndex:indexPath.row]] error:nil];
		_files = nil;

		//update UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
	UIViewController *vc = segue.destinationViewController;
	if ([vc isKindOfClass:[UINavigationController class]]) {
		vc = ((UINavigationController *)vc).viewControllers[0];
	}
	if ([segue.identifier isEqualToString:VIEW_SEGUE_IDENTIFIER]) {
		// Get the new view controller using [segue destinationViewController].
		id<PEFRootViewControllerDelegate> controller = (id<PEFRootViewControllerDelegate>)vc;
		// Pass the selected object to the new view controller.
		id obj;
		if ([sender isKindOfClass:[UITableViewCell class]]) {
			NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
			obj = [self.files objectAtIndex:indexPath.row];
		} else if (self.openIndex) {
			obj = [self.files objectAtIndex:[self.openIndex intValue]];
			self.openIndex = nil;
		}
		self.selectedFile = obj;
		[controller configureWithURL:[NSURL fileURLWithPath:[self.inputDir stringByAppendingPathComponent:obj]] table:self.config];
		
	} else if ([segue.identifier isEqualToString:TABLE_SELECT_SEGUE_IDENTIFIER]) {
		//UINavigationController *v = segue.destinationViewController;
		//[v.viewControllers objectAtIndex:0])
		((PEFTableSelectViewController *)vc).delegate = self;
	} else if ([segue.identifier isEqualToString:ABOUT_SEGUE_IDENTIFIER]) {
		//UINavigationController *v = segue.destinationViewController;
		//((PEFAboutViewController *)[v.viewControllers objectAtIndex:0]).delegate = self;
	}
}

#pragma mark - Getters and setters
- (NSString *)inputDir
{
	if (!_inputDir) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if (paths.count>0) {
			_inputDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Inbox"];
		}
		[[NSFileManager defaultManager] createDirectoryAtPath:_inputDir withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	return _inputDir;
}

- (NSArray *)files
{
	if (!_files) {
		_files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.inputDir error:nil];
	}
	return _files;
}


#pragma mark - Notifications
- (void)fileListModified:(NSNotification *)n
{
	_files = nil;
	[self.tableView reloadData];
	NSURL *url = [[n userInfo] objectForKey:@"File-URL"];
	int i = 0;
	for (NSString *name in self.files) {
		if ([[url lastPathComponent] isEqualToString:name]) {
			self.openIndex = [NSNumber numberWithInt:i];
			break;
		}
		i++;
	}
	[self.navigationController popToViewController:self animated:YES];
	//open new file
	[self performSegueWithIdentifier:VIEW_SEGUE_IDENTIFIER sender:self];
}

#pragma mark - Delegate
- (void)dismiss:(PEFFileSelctViewController *)viewController
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
- (PEFBrailleTableFactory *)config
{
	return _config;
}
@end
