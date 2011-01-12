# Superclass NSTextField is already defined in WebKitPluginView.h
class WebKitPluginView
  def initWithArguments(attributes)
    if initWithFrame(NSZeroRect)
      puts "Initialized with attributes: #{attributes.description}"

      # This is how you access the enclosing WebView instance
      @webView = attributes[WebPlugInContainerKey].webFrame.webView

      # This makes the textfield call evalRubyCode when the user hits enter in the textfield
      self.target = self
      self.action = "evalRubyCode:"

      self
    end
  end

  # sender is actually self in this case...
  def evalRubyCode(sender)
    eval sender.stringValue

    # Notify the WebView's UIDelegate, normally you'd have to check if the UIDelegate actually
    # responds to the message, but in this case it is known that the TestBrowser's AppController
    # instance does in fact do so
    if @webView.UIDelegate.respond_to?("webView:textField:didReceiveText:")
      @webView.UIDelegate.webView(@webView, textField: self, didReceiveText: self.stringValue)
    end
  end

  # WebPlugIn informal protocol
  #
  # All these methods are not required and can safely be removed.

  # This method will be only called once per instance of the plug-in object, and will be called
  # before any other methods in the WebPlugIn protocol.
  def webPlugInInitialize
    puts "[!] webPlugInInitialize called"
  end

  # The plug-in usually begins drawing, playing sounds and/or animation in this method.
  def webPlugInStart
    puts "[!] webPlugInStart called"
  end

  # The plug-in normally stop animations/sounds in this method.
  def webPlugInStop
    puts "[!] webPlugInStop called"
  end

  # Perform cleanup and prepare to be deallocated.
  def webPlugInDestroy
    puts "[!] webPlugInDestroy called"
  end

  # This is typically used to allow the plug-in to alter its appearance when selected
  def webPlugInSetIsSelected(selected)
    puts "[!] webPlugInSetIsSelected called: #{selected}"
  end

  # Returns the object that exposes the plug-in's interface.  The class of this object can implement
  # methods from the WebScripting informal protocol.
  def objectForWebScript
    puts "[!] objectForWebScript called"
    self
  end

end
