class AppController < NSObject
  attr_accessor :webView

  def awakeFromNib
    # The plugin uses the UIDelegate to notify back when the user entered text
    @webView.setUIDelegate(self)

    url = NSBundle.mainBundle.URLForResource("test", withExtension: "html")
    request = NSURLRequest.requestWithURL(url)
    @webView.mainFrame.loadRequest(request)
  end

  def webView(webView, textField: textField, didReceiveText: text)
    puts "[!] The TestBrowser's AppController instance got notified that the user entered the following text: #{text}"
  end
end
