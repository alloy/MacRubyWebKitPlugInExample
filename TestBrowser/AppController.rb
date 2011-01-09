class AppController < NSObject
  attr_accessor :webView

  def awakeFromNib
    url = NSBundle.mainBundle.URLForResource("test", withExtension: "html")
    request = NSURLRequest.requestWithURL(url)
    @webView.mainFrame.loadRequest(request)
  end
end
