#import "WebKitPluginView.h"
#import <MacRuby/MacRuby.h>

//@interface WebKitPluginView (Internal)
//- (id)_initWithArguments:(NSDictionary *)arguments;
//@end

@implementation WebKitPluginView

// WebPlugInViewFactory protocol
// The principal class of the plug-in bundle must implement this protocol.

+ (NSView *)plugInViewWithArguments:(NSDictionary *)newArguments
{
  NSBundle *bundle = [NSBundle bundleForClass:[WebKitPluginView class]];
  NSURL *url = [bundle URLForResource:@"WebKitPluginView" withExtension:@"rb"];
  [[MacRuby sharedRuntime] evaluateFileAtURL:url];
  return [[self alloc] performSelector:@selector(initWithArguments:)];
}

// WebPlugIn informal protocol

//- (void)webPlugInInitialize
//{
    //// This method will be only called once per instance of the plug-in object, and will be called
    //// before any other methods in the WebPlugIn protocol.
    //// You are not required to implement this method.  It may safely be removed.
//}

//- (void)webPlugInStart
//{
    //// The plug-in usually begins drawing, playing sounds and/or animation in this method.
    //// You are not required to implement this method.  It may safely be removed.
//}

//- (void)webPlugInStop
//{
    //// The plug-in normally stop animations/sounds in this method.
    //// You are not required to implement this method.  It may safely be removed.
//}

//- (void)webPlugInDestroy
//{
    //// Perform cleanup and prepare to be deallocated.
    //// You are not required to implement this method.  It may safely be removed.
//}

//- (void)webPlugInSetIsSelected:(BOOL)isSelected
//{
    //// This is typically used to allow the plug-in to alter its appearance when selected.
    //// You are not required to implement this method.  It may safely be removed.
//}

//- (id)objectForWebScript
//{
    //// Returns the object that exposes the plug-in's interface.  The class of this object can implement
    //// methods from the WebScripting informal protocol.
    //// You are not required to implement this method.  It may safely be removed.
    //return self;
//}

@end

//@implementation WebKitPluginView (Internal)

//- (id)_initWithArguments:(NSDictionary *)newArguments
//{
    //if (!(self = [super initWithFrame:NSZeroRect]))
        //return nil;
    
    //return self;
//}

//@end
