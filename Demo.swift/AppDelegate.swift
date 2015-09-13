//
//  AppDelegate.swift
//  TDPagedImageScrollView.swift
//
//  Created by Nicholas Tian on 10/09/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import TDPagedScrollView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var buttons: [UIButton] = {
        let titlesAndActions = [
            ("Looping Colored Views", "reloadScrollViewWithColoredViews"),
            ("Image URLs", "reloadWithImageURLs"),
        ]
        let buttons = map(enumerate(titlesAndActions)) { index, titleAndAction -> UIButton in
            let button = UIButton()

            button.setTitle(titleAndAction.0, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.addTarget(
                self,
                action: Selector(titleAndAction.1),
                forControlEvents: UIControlEvents.TouchUpInside
            )

            return button
        }

        return buttons
    }()

    let scrollView = TDPagedScrollView()
    lazy var controller: UIViewController = {
        let controller = UIViewController()

        let superView = controller.view

        var views: [UIView] = [self.scrollView]
        views.extend(self.buttons as [UIView])

        views.map { superView.addSubview($0) }

        var lastButton: UIButton?
        map(enumerate(self.buttons)) { index, button -> Void in
            button.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(superView).offset(20) // statusBar
                make.width.equalTo(superView).dividedBy(self.buttons.count)
                if let lastButton = lastButton {
                    make.left.equalTo(lastButton.snp_right)
                    make.bottom.equalTo(lastButton)
                } else {
                    make.left.equalTo(superView)
                }
                make.height.equalTo(44)
            }
            lastButton = button
        }
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(lastButton!.snp_bottom)
            make.left.right.bottom.equalTo(superView)
        }

        controller.view.backgroundColor = .whiteColor()
        self.scrollView.configureWithColoredViews()

        return controller
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }
}

private let colors: [UIColor] = [
    UIColor(red: 0.9862, green: 0.7797, blue: 0.0, alpha: 1.0),
    .whiteColor(),
    .blackColor(),
    .grayColor(),
    UIColor(red: 0.2302, green: 0.7771, blue: 0.3159, alpha: 1.0),
]


extension AppDelegate {
    func reloadScrollViewWithColoredViews() {
        scrollView.configureWithColoredViews(colors: colors, infiniteLoop: true)
        println("Reloaded scrollView with colored views.")
    }

    func reloadWithImageURLs() {
        let URLs = [
            "http://httpbin.org/image/jpeg",
            "http://httpbin.org/image/png",
            "http://httpbin.org/image/jpeg",
            "http://httpbin.org/image/png",
            "http://httpbin.org/image/jpeg",
        ].map { return NSURL(string: $0)! }
        scrollView.configureWithImageURLs(URLs, infiniteLoop: true)
        println("Reloaded scrollView with image URLs.")
    }
}

