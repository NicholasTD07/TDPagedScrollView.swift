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

    internal func configureWithViews(views: [UIView]) {
        clearSubviewsInScrollView()

        views.map { view -> Void in
            let addedViews = self.scrollView.subviews as! [UIView]
            self.scrollView.addSubview(view)

            view.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(0)
                if let lastView = addedViews.last {
                    make.left.equalTo(lastView.snp_right)
                } else {
                    make.left.equalTo(0)
                }
                make.width.equalTo(self.scrollView.snp_width)
                make.height.equalTo(self.scrollView.snp_height)
            }

        }

        if let view = self.scrollView.subviews.last as? UIView {
            scrollView.snp_makeConstraints { (make) -> Void in
                make.right.equalTo(view)
            }
        }

        pageControl.numberOfPages = views.count

    }

    private func clearSubviewsInScrollView() {
        scrollView.subviews.map { $0.removeFromSuperview() }
    }
}

extension TDPagedImageScrollView: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let xOffsetRelativeToPageWidth = scrollView.contentOffset.x/pageWidth

        // Update when scrolling to more than 50% of the previous/next page
        pageControl.currentPage = Int(floor(xOffsetRelativeToPageWidth + 0.5))
    }
}

extension TDPagedImageScrollView {
    internal func configureWithFakeData() {
        let colors: [UIColor] = [
            .blackColor(),
            .whiteColor(),
            .blackColor(),
            .grayColor(),
            .blackColor(),
        ]

        let views = map(colors) { color -> UIView in
            let view = UIView()

            view.backgroundColor = color

            return view
        }

        configureWithViews(views)
    }
}

extension TDPagedImageScrollView {
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
        scrollView.delegate = self

        return scrollView
    }()
    public lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()

        pageControl.pageIndicatorTintColor = UIColor(white: 0.5, alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = .whiteColor()

        return pageControl
    }()

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
