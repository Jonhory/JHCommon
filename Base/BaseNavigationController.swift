//
//  BaseNavigationController.swift
//  BWT_iOS
//
//  Created by Jonhory on 2017/3/2.
//  Copyright © 2017年 jonhory. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 5, height: 5)
        navigationBar.layer.shadowRadius = 10
        navigationBar.layer.shadowOpacity = 0.3
        navigationBar.backgroundColor = UIColor.white
        navigationBar.isTranslucent = false
        
    }

    deinit {
        WLog("dealloc nav === \(self)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
