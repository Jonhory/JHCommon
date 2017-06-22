//
//  BaseViewController.swift
//  JHWebview
//
//  Created by Jonhory on 2017/2/26.
//  Copyright © 2017年 jonhory. All rights reserved.
//

import UIKit

enum BaseNavType: Int {
    case Left = 350
    case LeftHelper
    case Center
    case RightHelper
    case Right
}

class BaseViewController: UIViewController {

    /// 导航栏控件,想要修改属性请在viewDidLoad()之后
    var leftBtn: UIButton?
    var leftHelpBtn: UIButton?
    var titleLabel: UILabel?
    var rightHelpBtn: UIButton?
    var rightBtn: UIButton?
    /// 初始化赋值请使用以下参数
    var leftStr: Any?//可以是String 或者 Image
    var leftHelpStr: Any?//可以是String 或者 Image
    var titleStr: String?
    var rightStr: Any?//可以是String 或者 Image
    var rightHelpStr: Any?//可以是String 或者 Image
    
    func config(leftStr: Any?, leftHelpStr: Any?, titleStr: String?, rightHelpStr:Any?, rightStr: Any?) {
        self.leftStr = leftStr
        self.leftHelpStr = leftHelpStr
        self.titleStr = titleStr
        self.rightHelpStr = rightHelpStr
        self.rightStr = rightStr
        loadNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configBase()
        
        loadNav()
        addBaseNoti()
    }
    
    private func configBase() {
        view.backgroundColor = UIColor.gray
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func addBaseNoti() {

    }
    
    var isTokenError = false
    func tokenError() {
        if isTokenError { return }
        isTokenError = true
        _ = navigationController?.popToRootViewController(animated: false)
        // 这句代码会让登录的vc dismiss 待改进。加一个dispatch_after?
//        dismiss(animated: false, completion: nil)
        // token失效第二步 发送退出通知
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.68, execute: {
//            NotificationCenter.default.post(name: NOTI_LOGOUT, object: nil)
//        })
    }
    
    //MARK:所有按钮点击事件
    func navBtnClicked(btn: UIButton) {

        let tag: BaseNavType = BaseNavType(rawValue: btn.tag)!
        switch tag {
        case .Left:
            leftBtnClicked(btn: btn)
            break
        case .LeftHelper:
            leftHelpBtnClicked(btn: btn)
            break
        case .RightHelper:
            rightHelpBtnClicked(btn: btn)
            break
        case .Right:
            rightBtnClicked(btn: btn)
            break
        default: break
            
        }
    }
    
    func leftBtnClicked(btn: UIButton) {
        if (self.navigationController?.viewControllers.count)! > 0 {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func leftHelpBtnClicked(btn: UIButton) {
        
    }
    
    func rightHelpBtnClicked(btn: UIButton) {
        
    }
    
    func rightBtnClicked(btn: UIButton) {
        
    }
    
    func loadNav() {
        var leftBar: UIBarButtonItem? = nil
        var leftHelpBar: UIBarButtonItem? = nil
        var rightBar: UIBarButtonItem? = nil
        var rightHelpBar: UIBarButtonItem? = nil
        
        if leftStr != nil && (leftStr is String || leftStr is UIImage) {
            leftBtn = createBtn(tag: .Left)
            if leftStr is String {
                handleBtnWithString(btn: leftBtn!, str: leftStr as! String)
            }else{
                handleBtnWithImage(btn: leftBtn!, image: leftStr as! UIImage)
            }
            leftBar = UIBarButtonItem(customView: leftBtn!)
        }
        
        if leftHelpStr != nil && (leftHelpStr is String || leftHelpStr is UIImage) {
            leftHelpBtn = createBtn(tag: .LeftHelper)
            if leftHelpStr is String {
                handleBtnWithString(btn: leftHelpBtn!, str: leftHelpStr as! String)
            }else{
                handleBtnWithImage(btn: leftHelpBtn!, image: leftHelpStr as! UIImage)
            }
            leftHelpBar = UIBarButtonItem(customView: leftHelpBtn!)
        }
        
        if titleStr != nil {
            titleLabel = UILabel()
            titleLabel?.text = titleStr!
            titleLabel?.font = UIFont.systemFont(ofSize: 17)
            titleLabel?.textColor = UIColor.black
            titleLabel?.sizeToFit()
            self.navigationItem.titleView = titleLabel
        }
        
        if rightHelpStr != nil && (rightHelpStr is String || rightHelpStr is UIImage) {
            rightHelpBtn = createBtn(tag: .RightHelper)
            if rightHelpStr is String {
                handleBtnWithString(btn: rightHelpBtn!, str: rightHelpStr as! String)
            }else{
                handleBtnWithImage(btn: rightHelpBtn!, image: rightHelpStr as! UIImage)
            }
            rightHelpBar = UIBarButtonItem(customView: rightHelpBtn!)
        }
        
        if rightStr != nil && (rightStr is String || rightStr is UIImage) {
            rightBtn = createBtn(tag: .Right)
            if rightStr is String {
                handleBtnWithString(btn: rightBtn!, str: rightStr as! String)
            }else{
                handleBtnWithImage(btn: rightBtn!, image: rightStr as! UIImage)
            }
            rightBar = UIBarButtonItem(customView: rightBtn!)
        }

        
        if leftBar != nil && leftHelpBar != nil {
            self.navigationItem.leftBarButtonItems = [leftBar!, leftHelpBar!]
        } else if leftBar != nil {
            self.navigationItem.leftBarButtonItem = leftBar!
        } else if leftHelpBar != nil {
            self.navigationItem.leftBarButtonItem = leftHelpBar!
        }
        
        if rightBar != nil && rightHelpBar != nil {
            self.navigationItem.rightBarButtonItems = [rightBar!, rightHelpBar!]
        } else if rightBar != nil {
            self.navigationItem.rightBarButtonItem = rightBar!
        } else if rightHelpBar != nil {
            self.navigationItem.rightBarButtonItem = rightHelpBar!
        }
    }
    
    private func handleBtnWithString(btn: UIButton, str:String) {
        btn.setTitle(str, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: str.sizeWidth(btn: btn) + 10, height: 40)
    }
    
    private func handleBtnWithImage(btn: UIButton, image: UIImage) {
        btn.setBackgroundImage(image, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    }
    
    private func createBtn(tag: BaseNavType) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.tag = tag.rawValue
        btn.addTarget(self, action: #selector(navBtnClicked(btn:)), for: .touchUpInside)
        return btn
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        WLog("释放了 \(self)")
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
}
