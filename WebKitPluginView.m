#import "WebKitPluginView.h"
#import <MacRuby/MacRuby.h>

@implementation WebKitPluginView

// WebPlugInViewFactory protocol
// The principal class of the plug-in bundle must implement this protocol.

+ (NSView *)plugInViewWithArguments:(NSDictionary *)newArguments
{
  // TODO Loading the Ruby source file probably only needs to happen once.
  NSBundle *bundle = [NSBundle bundleForClass:[WebKitPluginView class]];
  NSURL *url = [bundle URLForResource:@"WebKitPluginView" withExtension:@"rb"];
  [[MacRuby sharedRuntime] evaluateFileAtURL:url];
  return [[self alloc] performSelector:@selector(initWithArguments:) withObject:newArguments];
}

@end
