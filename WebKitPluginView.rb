# Superclass NSTextField is already defined in WebKitPluginView.h
class WebKitPluginView
  def initWithArguments(dictionary)
    if initWithFrame(NSZeroRect)
      p dictionary
      self
    end
  end
end
