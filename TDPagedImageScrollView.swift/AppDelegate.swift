//
//  AppDelegate.swift
//  TDPagedImageScrollView.swift
//
//  Created by Nicholas Tian on 10/09/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let scrollView = TDPagedImageScrollView()
    lazy var controller: UIViewController = {
        let controller = UIViewController()

        let superView = controller.view
        let reloadButton = UIButton()

        reloadButton.setTitle("Reload", forState: .Normal)
        reloadButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        reloadButton.addTarget(
            self,
            action: "reloadScrollViewWithFakeData",
            forControlEvents: .TouchUpInside
        )

        superView.addSubview(reloadButton)
        superView.addSubview(self.scrollView)

        reloadButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(superView).offset(20) // statusBar
            make.left.right.equalTo(superView)
        }
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(reloadButton.snp_bottom)
            make.left.right.bottom.equalTo(superView)
        }

        controller.view.backgroundColor = .whiteColor()
        self.scrollView.configureWithFakeData()

        return controller
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }
}

extension AppDelegate {
    func reloadScrollViewWithFakeData() {
        scrollView.configureWithFakeData()
        println("Reloaded scrollView with fake data.")
    }
}

