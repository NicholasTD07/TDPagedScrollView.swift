//
//  TDPagedScrollView+SampleData.swift
//  TDPagedImageScrollView.swift
//
//  Created by Nicholas Tian on 13/09/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit

private let colors: [UIColor] = [
    UIColor(red: 0.2302, green: 0.7771, blue: 0.3159, alpha: 1.0),
    .whiteColor(),
    .blackColor(),
    .grayColor(),
    UIColor(red: 0.9862, green: 0.7797, blue: 0.0, alpha: 1.0),
]


extension TDPagedScrollView {
    public func configureWithColoredViews(colors: [UIColor] = colors, infiniteLoop: Bool = false) {
        let colorToView: UIColor -> UIView = { color -> UIView in
            let view = UIView()
            view.backgroundColor = color
            return view
        }

        var views = colors.map(colorToView)

        if let firstColor = colors.first, lastColor = colors.last where infiniteLoop {
            views.insert(colorToView(lastColor), atIndex: 0)
            views.append(colorToView(firstColor))
        }

        configureWithViews(views, infiniteLoop: infiniteLoop)
    }
}

