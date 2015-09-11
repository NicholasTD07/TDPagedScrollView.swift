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
    let controller = UIViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let scrollView = TDPagedImageScrollView()

        controller.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(controller.view)
        }

        controller.view.backgroundColor = .whiteColor()
        scrollView.configureWithFakeData()

        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }
}

