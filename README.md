WebKit plugin example using MacRuby
===================================

A WebKit plug-in implemented in MacRuby. The plug-in’s view is a NSTextField
subclass, text entered in the textfield is eval'ed as Ruby code. The sample
also illustrates how to use the WebView's UIDelegate to call back to the
application.

The plug-in in action: http://cl.ly/012g3M3B0B3t0h2c423t


Purpose of this example
-----------------------

The main purpose of this example is to show how to use custom NSView classes in
a WebView in a MacRuby application that uses a WebView for its interface.

Theoretically these plugins can be used with any WebKit based application, but
**only** if they **support garbage collection**.


TL;DR, so how do I use it in _[insert favorite browser]_?!
----------------------------------------------------------

Whoa, hold your horses, son. Because this brings us to the most important note,
and will most probably be sad news to you, which is that none of the common
WebKit based browsers support this... This means **no** Safari **nor** Chrome.

The latter _could_ possibly be compiled with garbage collection support, it’s
completely open-source after all, but I was not able to do so in my quick
attempts.

_In case you'd like to have a go, I could not get ‘Chromium Framework.framework’
to support it. Let me know if you are successful._


So there’s no way to play with this in a web browser?
-----------------------------------------------------

Sure there is. In this repo you will find, next to the WebViewBasedApp example,
a simple web browser by [MOApp][1]. Select this ‘executable’ to install the
plugin in the browser instead of WebViewBasedApp.

Alternatively you can install the plugin in one of these following locations:

* ~/Library/Internet Plug-Ins
* /Library/Internet Plug-Ins

[1]: http://moapp.tumblr.com/post/844757101/want-to-build-your-own-browser


Documentation regarding WebKit plugins
--------------------------------------

* http://developer.apple.com/library/mac/#documentation/InternetWeb/Conceptual/WebKit_PluginProgTopic/Tasks/WebKitPlugins.html%23//apple_ref/doc/uid/30001249-BAJGJJAH

* http://developer.apple.com/library/mac/#samplecode/WebKitPluginStarter/Listings/ReadMe_txt.html

* http://developer.apple.com/library/mac/#qa/qa2006/qa1500.html

* API: http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/WebKit/Protocols/WebPlugIn_Protocol/Reference/Reference.html%23//apple_ref/occ/cat/WebPlugIn

