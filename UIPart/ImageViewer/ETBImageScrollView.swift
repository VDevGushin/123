//
//  ETBImageScrollView.swift
//  UIPart
//
//  Created by Vladislav Gushin on 19/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

struct ImageScrollViewConfigurator {
    enum ImageContentMode: Int {
        case aspectFill
        case aspectFit
        case widthFill
        case heightFill
    }

    enum Offset: Int {
        case begining
        case center
    }

    var imageStartSize: CGSize = CGSize.zero
    var kZoomInFactorFromMinWhenDoubleTap: CGFloat = 2
    var imageContentMode: ImageContentMode = .widthFill
    var initialOffset: Offset = .begining
    var imageSize: CGSize = CGSize.zero
    fileprivate var pointToCenterAfterResize: CGPoint = CGPoint.zero
    fileprivate var scaleToRestoreAfterResize: CGFloat = 1.0
    var maxScaleFromMinScale: CGFloat = 3.0
}

open class ImageScrollView: UIScrollView {
    private var configurator = ImageScrollViewConfigurator()
    private(set) var zoomView: UIImageView? = nil
    override open var frame: CGRect {
        willSet {
            if frame.equalTo(newValue) == false && newValue.equalTo(CGRect.zero) == false && configurator.imageSize.equalTo(CGSize.zero) == false {
                prepareToResize()
            }
        }
        didSet {
            if frame.equalTo(oldValue) == false && frame.equalTo(CGRect.zero) == false && configurator.imageSize.equalTo(CGSize.zero) == false {
                recoverFromResizing()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
    }

    func adjustFrameToCenter() {
        guard let unwrappedZoomView = zoomView else { return }
        var frameToCenter = unwrappedZoomView.frame
        // center horizontally
        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        // center vertically
        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        unwrappedZoomView.frame = frameToCenter
    }

    func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        configurator.pointToCenterAfterResize = convert(boundsCenter, to: zoomView)
        configurator.scaleToRestoreAfterResize = zoomScale
        // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
        // allowable scale when the scale is restored.
        if configurator.scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            configurator.scaleToRestoreAfterResize = 0
        }
    }

    fileprivate func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()
        // restore zoom scale, first making sure it is within the allowable range.
        let maxZoomScale = max(minimumZoomScale, configurator.scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)
        // restore center point, first making sure it is within the allowable range.
        // convert our desired center point back to our own coordinate space
        let boundsCenter = convert(configurator.pointToCenterAfterResize, to: zoomView)
        // calculate the content offset that would yield that center point
        var offset = CGPoint(x: boundsCenter.x - bounds.size.width / 2.0, y: boundsCenter.y - bounds.size.height / 2.0)
        // restore offset, adjusted to be within the allowable range
        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()
        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)
        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)
        contentOffset = offset
    }

    fileprivate func maximumContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.width, y: contentSize.height - bounds.height)
    }

    fileprivate func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }

    // MARK: - Display image

    @objc open func display(image: UIImage, firstTime: Bool = true) {
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
        }

        zoomView = UIImageView(image: image)
        zoomView!.isUserInteractionEnabled = true
        addSubview(zoomView!)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageScrollView.doubleTapGestureRecognizer(_:)))
        tapGesture.numberOfTapsRequired = 2
        zoomView!.addGestureRecognizer(tapGesture)
        if firstTime {
            configurator.imageStartSize = image.size
        }
        print(image.size)
        configureImageForSize(configurator.imageStartSize)
    }

    fileprivate func configureImageForSize(_ size: CGSize) {
        configurator.imageSize = size
        contentSize = configurator.imageSize
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale

        switch configurator.initialOffset {
        case .begining:
            contentOffset = CGPoint.zero
        case .center:
            let xOffset = contentSize.width < bounds.width ? 0 : (contentSize.width - bounds.width) / 2
            let yOffset = contentSize.height < bounds.height ? 0 : (contentSize.height - bounds.height) / 2

            switch configurator.imageContentMode {
            case .aspectFit:
                contentOffset = CGPoint.zero
            case .aspectFill:
                contentOffset = CGPoint(x: xOffset, y: yOffset)
            case .heightFill:
                contentOffset = CGPoint(x: xOffset, y: 0)
            case .widthFill:
                contentOffset = CGPoint(x: 0, y: yOffset)
            }
        }
    }

    fileprivate func setMaxMinZoomScalesForCurrentBounds() {
        // calculate min/max zoomscale
        let xScale = bounds.width / configurator.imageSize.width // the scale needed to perfectly fit the image width-wise
        let yScale = bounds.height / configurator.imageSize.height // the scale needed to perfectly fit the image height-wise

        var minScale: CGFloat = 1

        switch configurator.imageContentMode {
        case .aspectFill:
            minScale = max(xScale, yScale)
        case .aspectFit:
            minScale = min(xScale, yScale)
        case .widthFill:
            minScale = xScale
        case .heightFill:
            minScale = yScale
        }


        let maxScale = configurator.maxScaleFromMinScale * minScale

        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }

        maximumZoomScale = maxScale
        minimumZoomScale = minScale * 0.999 // the multiply factor to prevent user cannot scroll page while they use this control in UIPageViewController
    }

    // MARK: - Gesture

    @objc func doubleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // zoom out if it bigger than middle scale point. Else, zoom in
        if zoomScale >= maximumZoomScale / 2.0 {
            setZoomScale(minimumZoomScale, animated: true)
        }
            else {
                let center = gestureRecognizer.location(in: gestureRecognizer.view)
                let zoomRect = zoomRectForScale(configurator.kZoomInFactorFromMinWhenDoubleTap * minimumZoomScale, center: center)
                zoom(to: zoomRect, animated: true)
        }
    }

    fileprivate func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero

        // the zoom rect is in the content view's coordinates.
        // at a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
        // as the zoom scale decreases, so more content is visible, the size of the rect grows.
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width / scale

        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)

        return zoomRect
    }

    open func refresh() {
        if let image = zoomView?.image {
            display(image: image, firstTime: false)
        }
    }

    //MARK - Settings
    func setImageContentMode(_ mode: ImageScrollViewConfigurator.ImageContentMode) {
        configurator.imageContentMode = mode
    }

    func setInitialOffset(_ offset: ImageScrollViewConfigurator.Offset) {
        configurator.initialOffset = offset
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
    }
}
