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

private let URLToImageView: NSURL -> UIImageView = { URL -> UIImageView in
    let view = UIImageView()
    view.sd_setImageWithURL(URL)
    return view
}

extension TDPagedScrollView {
    public func configureWithImages(images: [UIImage], infiniteLoop: Bool = false) {
        self.infiniteLoop = infiniteLoop

        var views = images.map { return UIImageView(image: $0) }

        configureWithViews(views)
    }

    public func configureWithImageURLs(imageURLs: [NSURL], infiniteLoop: Bool = false) {
        self.infiniteLoop = infiniteLoop

        var views = imageURLs.map(URLToImageView)

        configureWithViews(views)
    }

    internal func configureWithViews(var views: [UIView]) {
        clearSubviewsInScrollView()

        let superView = containerView
        views.map { view -> Void in
            let addedViews = superView.subviews as! [UIView]
            superView.addSubview(view)

            view.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(0)
                if let lastView = addedViews.last {
                    make.left.equalTo(lastView.snp_right)
                } else {
                    make.left.equalTo(0)
                }
                make.width.equalTo(self.scrollView)
                make.height.equalTo(self.scrollView)
            }

        }

        if let view = superView.subviews.last as? UIView {
            superView.snp_makeConstraints { (make) -> Void in
                make.right.equalTo(view)
            }
        }

        if infiniteLoop {
            pageControl.numberOfPages = views.count - 2
            let x = frame.size.width * 1
            let origin = CGPoint(x: x, y: 0)
            scrollView.contentOffset = origin
        } else {
            pageControl.numberOfPages = views.count
        }
    }

    private func clearSubviewsInScrollView() {
        containerView.subviews.map { view -> Void in
            view.removeFromSuperview()
            view.snp_removeConstraints()
        }
    }
}

extension TDPagedScrollView: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let atStartOfPage = scrollView.contentOffset.x % pageWidth == 0

        // TODO: Need a DataSource/Handler class/struct to handle
        //       the whole thinking in this method
        //       A. Scroll to the "first"/"last" view?
        //       B. Get current page for `pageControl`
        // HACK: Super low CPU usage
        if !atStartOfPage {
            return
        }

        let xOffsetRelativeToPageWidth = scrollView.contentOffset.x/pageWidth

        // Update when scrolling to more than 50% of the previous/next page
        let currentPage = Int(floor(xOffsetRelativeToPageWidth + 0.5))
        if infiniteLoop {
            let atStartOfPage = scrollView.contentOffset.x % pageWidth == 0
            if atStartOfPage {
                let size = frame.size
                let superView = containerView
                let viewsCount = superView.subviews.count
                pageControl.currentPage = currentPage - 1

                if currentPage == 0 { // go to last(actual second last) view
                    let rect = superView.subviews[viewsCount - 2].frame
                    scrollView.scrollRectToVisible(rect, animated: false)
                } else if currentPage == viewsCount - 1 { // go to first(actual second) view
                    let rect = superView.subviews[1].frame
                    scrollView.scrollRectToVisible(rect, animated: false)
                }
            }
        } else {
            pageControl.currentPage = currentPage
        }
    }
}

extension TDPagedScrollView {
    // MARK: Setup methods
    internal func setupViews() {
        let superView = self
        let views = [
            scrollView,
            pageControl,
        ]

        views.map { superView.addSubview($0) }

        setupConstaints()
    }

    internal func setupConstaints() {
        let superView = self

        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(superView)
        }

        containerView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }

        pageControl.snp_makeConstraints { (make) -> Void in
            make.centerX.bottom.equalTo(scrollView)
        }
    }
}

public class TDPagedScrollView: UIView {
    public var infiniteLoop = false

    // MARK: UI vars
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.pagingEnabled = true
        scrollView.delegate = self

        scrollView.addSubview(self.containerView)

        return scrollView
    }()
    public lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()

        pageControl.pageIndicatorTintColor = UIColor(white: 0.5, alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = .whiteColor()

        return pageControl
    }()
    private lazy var containerView = UIView()

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
