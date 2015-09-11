//
//  TDPagedImageScrollView.swift
//  TDPagedImageScrollView.swift
//
//  Created by Nicholas Tian on 10/09/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import SnapKit
import WebImage

extension TDPagedImageScrollView {
    public func configureWithImages(images: [UIImage]) {

    }

    public func configureWithImageURLs(imageURLs: [NSURL]) {

    }
}

extension TDPagedImageScrollView {
    internal func configureWithFakeData() {
        var views: [UIView] = []
        let colors: [UIColor] = [
            .whiteColor(),
            .grayColor(),
            .blackColor(),
        ]

        map(enumerate(colors)) { (index, color) -> Void in
            let view = UIView()
            view.backgroundColor = color

            self.scrollView.addSubview(view)

            view.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(0)
                if let lastView = views.last {
                    make.left.equalTo(lastView.snp_right)
                } else {
                    make.left.equalTo(0)
                }
                make.width.equalTo(self.scrollView.snp_width)
                make.height.equalTo(self.scrollView.snp_height)
            }

            views.append(view)
        }

        if let view = views.last {
            scrollView.snp_makeConstraints { (make) -> Void in
                make.right.equalTo(view)
            }
        }
    }
}

extension TDPagedImageScrollView {
    // MARK: Setup methods
    func setupViews() {
        let superView = self
        let views = [
            scrollView,
            pageControl,
        ]

        views.map { superView.addSubview($0) }

        setupConstaints()
    }

    func setupConstaints() {
        let superView = self

        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(superView)
        }

        pageControl.snp_makeConstraints { (make) -> Void in
            make.centerX.bottom.equalTo(scrollView)
        }
    }
}

public class TDPagedImageScrollView: UIView {
    // MARK: UI vars
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.pagingEnabled = true

        return scrollView
    }()
    public lazy var pageControl = UIPageControl()

    // MARK: `init` funcs
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
}
