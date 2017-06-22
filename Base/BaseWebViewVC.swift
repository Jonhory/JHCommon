//
//  BaseWebViewVC.swift
//  Webview
//
//  Created by Jonhory on 2017/2/26.
//  Copyright © 2017年 jonhory. All rights reserved.
//

import UIKit
import WebKit
//import SVProgressHUD

class BaseWebViewVC: BaseViewController {

    /// 网页
    var webView: WKWebView!
    /// 网址链接
    var url: String!
    /// 与JS通讯的标志符
    var iOSToJSName: String!
    /// 进度条
    var progressView: UIProgressView?
    
    func create(_ url:String , iOSToJSName: String?) {
        self.url = url
        self.iOSToJSName = iOSToJSName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.leftHelpBtn?.isHidden = true
        
        if !checkUrlIsSafe() {
            return
        }
        loadWebView()
//        loadProgressView()
//        if BWTNetwork.shared.networkStatus == .notReachable || BWTNetwork.shared.networkStatus == .unknown {
//            BWTNetwork.shared.listenNetworkReachabilityStatus { [weak self] (netS) in
//                if netS == .reachable(.ethernetOrWiFi) || netS == .reachable(.wwan) {
//                    self?.webView.reload()
//                }
//            }
//        }
    }
    
    override func loadNav() {
        super.loadNav()
        self.leftHelpBtn?.isHidden = true
    }
    
    override func leftBtnClicked(btn: UIButton) {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        popBack()
    }
    
    override func leftHelpBtnClicked(btn: UIButton) {
        popBack()
    }
    
    func popBack() {
        if iOSToJSName != nil {
            removeWKScriptMessageHandler()
        }
//        SVProgressHUD.dismiss()
        leaveTheWeb()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // 供子类使用，表示离开网页
    func leaveTheWeb() {
        
    }
    
    func checkUrlIsSafe() -> Bool {
        if url == nil  {
            print("当前URL为空，请检查 >>\(url)")
            return false
        }
        WLog("开始访问:\(url)")
//        SVProgressHUD.show()
        return true
    }
    
    func loadWebView() {
        let config = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        if iOSToJSName != nil {
            userContent.add(self, name: iOSToJSName)
//            NotificationCenter.default.addObserver(self, selector: #selector(removeWKScriptMessageHandler), name: NOTI_WEB_Deinit, object: nil)
        }
        config.userContentController = userContent
        
        let h = self.view.bounds.height - 64
        let f = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: h)
        webView = WKWebView(frame: f, configuration: config)
        
        if let requestURL = URL(string: url) {
            let request = URLRequest(url: requestURL)
            webView.load(request)
        } else {
            WLog("可能含有中文,请转码:url:\(url)")
            url = url.urlEncode
            WLog("已转码:url:\(url)")
            let requestURL = URL(string: url)
            let request = URLRequest(url: requestURL!)
            webView.load(request)
        }
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        self.view.addSubview(webView)
    }

    func loadProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView?.frame = CGRect(x: webView.frame.origin.x, y: 0, width: webView.bounds.size.width, height: 10)
        progressView?.progressTintColor = UIColor.red
        progressView?.trackTintColor = UIColor.blue
        progressView?.progress = 0.00
        self.view.addSubview(progressView!)
    }
    
    //MARK: 原生调用JS
    func sendToJS() {
//        webView.evaluateJavaScript("showAlert('奏是一个弹框')") { (item, error) in
//            // 闭包中处理是否通过了或者执行JS错误的代码
//        }
    }
    
    //MARK: JS发送消息到原生
    func jsToSwift(body: Any) {
        WLog("收到web的信息=== \(body)")
    }
    
    /// 记得移除桥接，释放vc ===>>>
    func removeWKScriptMessageHandler() {
        if iOSToJSName != nil {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: iOSToJSName)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("已释放➡️ \(self)")
    }
}


// MARK: - WKNavigationDelegate
extension BaseWebViewVC: WKNavigationDelegate {
    /// 准备加载页面
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("准备加载页面 ",webView.estimatedProgress)
        self.progressView?.isHidden = false
        self.progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    /// 内容开始加载
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("内容开始加载 ",webView.estimatedProgress)
        self.progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
    }
    
    /// 页面加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("页面加载完成 ",webView.estimatedProgress)
        self.progressView?.setProgress(Float(webView.estimatedProgress), animated: true)
        if webView.estimatedProgress >= 1 {
            self.progressView?.isHidden = true
//            SVProgressHUD.dismiss()
        }
        sendToJS()
    }
    
    /// 页面加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败",error)
        self.progressView?.isHidden = true
//        SVProgressHUD.dismiss()
//        SVProgressHUD.showError(withStatus: "页面加载失败,请稍后重试")
    }
    
    /// 页面加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败",error)
        self.progressView?.isHidden = true
//        SVProgressHUD.dismiss()
//        SVProgressHUD.showError(withStatus: "页面加载失败,请稍后重试")
    }
    
    /// 接收到服务器跳转请求
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接收到服务器跳转请求")
    }
    
    /// 在收到响应后，决定是否跳转 (如果设置为不允许响应decisionHandler(.cancel)，web内容就不会传过来)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("在收到响应后，决定是否跳转")
        decisionHandler(.allow)
        if webView.canGoBack {
            leftHelpBtn?.isHidden = false
        }else{
            leftHelpBtn?.isHidden = true
        }
    }
    
    /// 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let host = navigationAction.request.url?.host?.lowercased()
        print("在发送请求之前，决定是否跳转,链接===\(host.orNil)")
        if navigationAction.navigationType == .linkActivated  {
            print("跳转到App Store等链接==>>")
            UIApplication.shared.openURL(navigationAction.request.url!)
            //本地网页不跳转外链
            decisionHandler(.cancel)
//            webView.load(navigationAction.request)
            
        } else {
            decisionHandler(.allow)
        }
    }
}


// MARK: - WKUIDelegate
extension BaseWebViewVC: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
        let alert = UIAlertController(title: "提示", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler:nil))
//        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - WKScriptMessageHandler JS调用原生
extension BaseWebViewVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if iOSToJSName == message.name {
            jsToSwift(body: message.body)
        }
    }
}
