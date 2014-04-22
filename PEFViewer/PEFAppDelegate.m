//
//  PEFAppDelegate.m
//  PEFViewer
//
//  Created by Joel Håkansson on 2013-09-02.
//  Copyright (c) 2013 Joel Håkansson. All rights reserved.
//

#import "PEFAppDelegate.h"
#import "PEFFileSelctViewController.h"
#import "DetailViewManager.h"

@interface PEFAppDelegate()
@property DetailViewManager *vm;
@end

@implementation PEFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

	 // This code works in the simulator, but not on the device, due to restrictions in the file
	 // system. The inclusion of a default file would be nice, however, it has to be written 
	 // to another folder, which the app scans for files.
	/* 
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *inboxPath = nil;
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if (paths.count>0) {
			inboxPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Inbox"];
		}
	}
	if (![fm fileExistsAtPath:inboxPath]) {
		//assume first use
		[fm createDirectoryAtPath:inboxPath withIntermediateDirectories:YES attributes:nil error:nil];
		NSURL *pef = [[NSBundle mainBundle] URLForResource:@"butterfly" withExtension:@"pef"];
		NSError *error;
		[[NSFileManager defaultManager] copyItemAtURL:pef toURL:[NSURL fileURLWithPath:[inboxPath stringByAppendingPathComponent:@"butterfly.pef"]] error:&error];
		if (error) {
			NSLog(@"%@", [error localizedDescription]);
		}
	}*/

	UIViewController *vc = self.window.rootViewController;
	if ([vc isKindOfClass:[UISplitViewController class]]) {
		NSLog(@"Split view");
		UISplitViewController *svc = (UISplitViewController *)vc;
		self.vm = [[DetailViewManager alloc] init];
		svc.delegate = self.vm;
	}
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - ..
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	NSDictionary *d = [[NSDictionary alloc] initWithObjects:@[url] forKeys:@[@"File-URL"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PEF-FileListModifiled" object:self userInfo:d];
	return YES;
}

@end
