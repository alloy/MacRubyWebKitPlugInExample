//
//  WebController.h
//  Monitor
//
//  Created by Michael on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface WebController : NSObject 

{
	IBOutlet  WebView *webView;
	NSURL *URLToLoad;
	IBOutlet NSTextField *urlField;
	IBOutlet NSSearchField *googleField;
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSWindow *prefsWindow;
	NSString *url;	
	int resourceCount;
    int resourceFailedCount;
    int resourceCompletedCount;
	IBOutlet NSProgressIndicator *indeterminateProgress;
	IBOutlet NSTextField *rfrFieldMail;	
	IBOutlet NSTextField *titleField;
	IBOutlet NSTextField *linkField;
	NSString *docTitle;
    NSString *frameStatus;
    NSString *resourceStatus;	
}

- (IBAction)loadStartpage:(id)sender;
- (IBAction)connectURL:(id)sender;
- (IBAction)searchGoogle:(id)sender;
- (IBAction)exportArchive:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)openPrefs:(id)sender;

@end
