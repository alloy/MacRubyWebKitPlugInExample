//
//  WebController.m
//  Monitor
//
//  Created by Michael on 3/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WebController.h"

@implementation WebController


#pragma mark -
#pragma mark awakeFromNib

- (void)awakeFromNib 
{
	[NSApp setDelegate: self];
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartUp"])
	{
		[[NSUserDefaults standardUserDefaults] setObject:@"http://moapp.de/" forKey: @"urlStringPrefs"];
		[[NSUserDefaults standardUserDefaults] setInteger:5 forKey: @"webfontSize"];
		[mainWindow center];
	}	
	int webfontSize;
	int tag = [[NSUserDefaults standardUserDefaults] integerForKey: @"webfontSize"];
	switch (tag)
	{
		case 0:
			webfontSize = 10;
			break;			
		case 1:
			webfontSize = 11;
			break;			
		case 2:
			webfontSize = 12;
			break;			
		case 3:
			webfontSize = 13;
			break;			
		case 4:
			webfontSize = 14;
			break;			
		case 5:
			webfontSize = 15;
			break;			
		case 6:
			webfontSize = 16;
			break;				
		case 7:
			webfontSize = 17;
			break;				
		default:
			webfontSize = 15;
			break;				
	}	
	WebPreferences * webPrefs = [[WebPreferences alloc] init];
	[webPrefs setDefaultFontSize:webfontSize];
	[webPrefs setDefaultFixedFontSize:webfontSize];
	[webView setPreferences:webPrefs];
	[webPrefs release];		
	NSString *currVersionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
	// NSLog(@"DEBUG - versionnumber: %@", currVersionNumber);
	NSString *UserAgentString = [NSString stringWithFormat:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_7; en-us) AppleWebKit/526+ (KHTML, like Gecko) Version/3.1 Safari/525.12.", currVersionNumber];
	[webView setCustomUserAgent:UserAgentString];	
	[webView setUIDelegate:self];
	[webView setFrameLoadDelegate:self];
	[webView setResourceLoadDelegate:self];
	[webView setFrameLoadDelegate:self];
	[webView setDownloadDelegate:self];
	[webView setPolicyDelegate:self];	
	NSString *urlStringPrefs = [[NSUserDefaults standardUserDefaults] valueForKey: @"urlStringPrefs"];
	if ([urlStringPrefs length] > 7)
	{
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStringPrefs]]];
	}
}



#pragma mark -
#pragma mark WebFrame

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener
{
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	int result = [openPanel runModal];
	if (result == NSOKButton)
		[resultListener chooseFilename:[openPanel filename]];
	else
		[resultListener cancel];
}


- (IBAction)loadStartpage:(id)sender
{
	NSString *urlStringPrefs = [[NSUserDefaults standardUserDefaults] valueForKey: @"urlStringPrefs"];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStringPrefs]]];
}


- (void)updateWindow
{
	if (url != nil)
		[urlField setStringValue:url];
	
	if (resourceStatus != nil)
		[titleField setStringValue: [NSString stringWithFormat: @"%@:  %@", docTitle, resourceStatus]];
	else if (frameStatus != nil)
		[titleField setStringValue:[NSString stringWithFormat: @"%@:  %@", docTitle, frameStatus]];
	else if (docTitle != nil)
		[titleField setStringValue: [NSString stringWithFormat: @"%@", docTitle]];
	else
		[titleField setStringValue: @""];
}


- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame]) {
		resourceCount = 0;    
		resourceCompletedCount = 0;
		resourceFailedCount = 0;
		[titleField setStringValue:@"Loading..."];
		[self setURL:[[[[frame provisionalDataSource] request] URL] absoluteString]];
		[self updateWindow];		
		[indeterminateProgress setHidden:NO];
		[indeterminateProgress startAnimation: self];
	}
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame]) 
	{
		[self updateWindow];		
		if ( [[NSUserDefaults standardUserDefaults] valueForKey: @"TabIndex"] == @"Mail")		
		{
			[urlField resignFirstResponder];
			[googleField resignFirstResponder];
			[mainWindow makeFirstResponder:webView];
			[mainWindow performSelector:@selector(makeFirstResponder:) withObject: webView afterDelay:0.0];
		}
		[indeterminateProgress stopAnimation:self];
		[indeterminateProgress setHidden:YES];
	}
}
- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame]) 
	{
		[self updateWindow];
		if ( [[NSUserDefaults standardUserDefaults] valueForKey: @"TabIndex"] == @"Mail")		
		{
			[urlField resignFirstResponder];
			[googleField resignFirstResponder];
			[mainWindow makeFirstResponder:webView];
			[mainWindow performSelector:@selector(makeFirstResponder:) withObject: webView afterDelay:0.0];
		}
		[indeterminateProgress stopAnimation:self];
		[indeterminateProgress setHidden:YES];		
		NSString *folder = [[NSBundle mainBundle] bundlePath];
		folder = [folder stringByAppendingPathComponent:@"Contents/Resources/NotFoundErrorPage.html"];
		NSString *finalURL = [@"file://" stringByAppendingString:folder];
		[frame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]]; 
	}
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction: (NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener: (id<WebPolicyDecisionListener>)listener
{
	[listener ignore];
	[[webView mainFrame] loadRequest:request];
}


- (NSString *)url
{
	return url;
}

- (void)setURL: (NSString *)u
{
	[url release];
	url = [u retain];
}

#pragma mark -
#pragma mark Load URL

- (IBAction)connectURL:(id)sender
{
	NSMutableString * myURL = [[NSMutableString alloc] init];
	[myURL appendString:[urlField stringValue]];
	
	if ([myURL hasPrefix:@"http://"])
	{
		[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: myURL]]];
	}
	else
	{
		[myURL insertString:@"http://" atIndex:0];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: myURL]]];	}
	[myURL release];
}

#pragma mark -
#pragma mark Google Search

- (IBAction)searchGoogle:(id)sender;
{
	NSMutableString * searchURL = [[NSMutableString alloc] init];
	[searchURL appendString:[googleField stringValue]];
	[searchURL replaceOccurrencesOfString:@" " withString:@"%90" options:NSCaseInsensitiveSearch range:(NSRange){0,[searchURL length]}]; 
	[searchURL insertString:@"http://www.google.com/search?q=" atIndex:0];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: searchURL]]];
	[searchURL release];
}


- (void)updateResourceStatus
{
	if (resourceFailedCount)
		[self setResourceStatus: [NSString stringWithFormat: @"Loaded %d of %d, %d resource errors", resourceCompletedCount, resourceCount - resourceFailedCount, resourceFailedCount]];
	else
		[self setResourceStatus: [NSString stringWithFormat: @"Loaded %d of %d", resourceCompletedCount, resourceCount]];
	[titleField setStringValue:[NSString stringWithFormat: @"%@:  %@", docTitle, resourceStatus]];
}

//added for below
- (NSString *)docTitle
{
	return docTitle;
}

- (void)setDocTitle: (NSString *)t
{
	[docTitle release];
	docTitle = [t retain];
}

- (NSString *)frameStatus
{
	return frameStatus;
}

- (void)setFrameStatus: (NSString *)s
{
	[frameStatus release];
	frameStatus = [s retain];
}
- (NSString *)resourceStatus
{
	return resourceStatus;
}

- (void)setResourceStatus: (NSString *)s
{
	[resourceStatus release];
	resourceStatus = [s retain];
}


- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame]) {
		[self setDocTitle:title];
		[self updateWindow];
	}
}


#pragma mark -
#pragma mark Requests

- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource
{
	return [NSNumber numberWithInt: resourceCount++];    
}

-(NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponsefromDataSource:(WebDataSource *)dataSource
{
	[self updateResourceStatus];
	return request;
}

-(void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
{
	resourceFailedCount++;
	[self updateResourceStatus];
}

-(void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource
{
	resourceCompletedCount++;
	[self updateResourceStatus];    
}



#pragma mark -
#pragma mark WebView Alerts

- (void)webView:(WebView*)sender 
runJavaScriptAlertPanelWithMessage:(NSString*)message
{	
	NSAlert*    alert;
	alert = [[NSAlert alloc] init];
	[alert setMessageText:@"JavaScript"];
	[alert setInformativeText:message];
	[alert addButtonWithTitle:@"OK"];
	
#if 0	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:SREnableJavaScriptDialogAlert]) 
	{
		NSBeep();
	}
#endif
	
	[alert runModal];
	[alert release];
}

- (BOOL)webView:(WebView*)sender 
runJavaScriptConfirmPanelWithMessage:(NSString*)message
{	
	NSAlert*    alert;
	alert = [[NSAlert alloc] init];	
	[alert setMessageText:@"JavaScript"];
	[alert setInformativeText:message];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];	
	int result;
	result = [alert runModal];
	[alert release];	
	return result == NSAlertFirstButtonReturn;
}

#if 0
- (NSString*)webView:(WebView*)sender 
runJavaScriptTextInputPanelWithPrompt:(NSString*)prompt 
		 defaultText:(NSString*)defaultText
{
	SRTextInputPanelManager*    inputMgr;
	inputMgr = [[SRTextInputPanelManager alloc] init];
	[inputMgr autorelease];
	
	[inputMgr setPrompt:prompt];
	[inputMgr setMessage:defaultText];
	
	int result;
	result = [inputMgr runModal];
	
	if (result == SRTextInputOK) {
		return [inputMgr message];
	}
	else {
		return nil;
	}
}
#endif

- (void)webView:(WebView *)sender
decidePolicyForNewWindowByBrowseModeAction:(NSDictionary*)info 
		request:(NSURLRequest*)request 
	  frameName:(NSString*)frameName 
decisionListener:(id<WebPolicyDecisionListener>)listener
{	
	[listener ignore];
	[[webView mainFrame] loadRequest:request];
}


- (void)webView:(WebView *)sender 
decideTabPolicyAction:(NSDictionary*)info 
		request:(NSURLRequest*)request 
	  frameName:(NSString*)frameName 
decisionListener:(id<WebPolicyDecisionListener>)listener
{	
	[listener ignore];
	[[webView mainFrame] loadRequest:request];
}


- (void)webView:(WebView *)sender 
decidePolicyForNavigationByBrowseModeAction:(NSDictionary*)info 
		request:(NSURLRequest*)request 
	  frameName:(NSString*)frameName 
decisionListener:(id<WebPolicyDecisionListener>)listener
{
	[listener ignore];
	[[webView mainFrame] loadRequest:request];
}

- (void)webView:(WebView *)sender mouseDidMoveOverElement:(NSDictionary *)elementInformation modifierFlags:(unsigned int)modifierFlags
{
	NSString *linkURLString = nil;	
	linkURLString = [[elementInformation objectForKey:WebElementLinkURLKey] absoluteString];	
	if ([linkURLString length] > 0)
	{		
		[linkField setStringValue:linkURLString];
	}	
	else
	{
		[linkField setStringValue:@""];
	}
}



- (IBAction)exportArchive:(id)sender
{
	NSSavePanel *theSavePanel = [NSSavePanel savePanel];
    [theSavePanel setRequiredFileType:@"webarchive"];
    [theSavePanel setTitle:@"Export as .webarchive"];
	NSString *theSaveString = docTitle;	
	if ([theSavePanel runModalForDirectory: nil file: theSaveString ] == NSOKButton) 
	{ 
		[[[[[webView mainFrame] DOMDocument] webArchive] data] writeToFile:[theSavePanel filename] atomically:YES];
    }	
}


- (IBAction)print:(id)sender 
{
    NSView *printView = [[[webView mainFrame] frameView] documentView];
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    [printInfo setVerticallyCentered:NO]; 
    [printInfo setHorizontalPagination:NSFitPagination];
    NSPrintOperation *printOperation = [NSPrintOperation printOperationWithView:printView];
    [printOperation runOperationModalForWindow:mainWindow 
                                      delegate:self
                                didRunSelector:@selector(printOperationDidRun:success:contextInfo:)
                                   contextInfo:nil];
}


#pragma mark -
#pragma mark Prefs

- (IBAction)openPrefs:(id)sender
{
	[prefsWindow center];
	[prefsWindow makeKeyAndOrderFront:nil];
}


#pragma mark -
#pragma mark Notifications

- (void) applicationWillTerminate: (NSNotification *)note
{
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStartUp"])
	{
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"firstStartUp"];
	}
}

- (void) applicationDidBecomeActive: (NSNotification *)note
{
	[mainWindow makeKeyAndOrderFront:nil];
}


@end
