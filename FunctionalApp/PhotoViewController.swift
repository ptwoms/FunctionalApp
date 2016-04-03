//
//  PhotoViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 21/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var imageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    private var imageSize = CGSizeZero;
    
    var image : UIImage!{
        didSet{
            imageSize = image.size
            imageSize.width *= image.scale
            imageSize.height *= image.scale
            if self.imageView != nil{
                self.imageView?.image = image
                initializeZoomScales()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        self.closeButton.title = NSLocalizedString("close", comment: "")
        imageView.image = image
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        initializeZoomScales()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageDoubleTouched(sender: UITapGestureRecognizer) {
        if self.contentScrollView.zoomScale > self.contentScrollView.minimumZoomScale{
            UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .CurveLinear, animations: {
                self.contentScrollView.zoomScale = self.contentScrollView.minimumZoomScale
                }, completion: { (finished) in
                    self.updateImageViewConstraints()
            })
        }else{
            self.contentScrollView.zoomOutToNormalizedCenterPoint(sender.locationInView(self.imageView), normalizedSize: imageSize, forScale: contentScrollView.maximumZoomScale, animated: true, adjustment: CGPointMake(imageViewLeftConstraint.constant, imageViewTopConstraint.constant))
            self.updateImageViewConstraints()
        }
    }
    
    @IBAction func closeButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func  viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateImageViewConstraints()
    }
    
    func initializeZoomScales() {
        if imageSize.width == 0 {
            return
        }
        let scrollViewSize = contentScrollView.bounds.size
        let widthRatio = scrollViewSize.width/imageSize.width
        let heightRatio = scrollViewSize.height/imageSize.height
        if widthRatio >= 1.0 && heightRatio >= 1.0{
            contentScrollView.minimumZoomScale = 1.0
            contentScrollView.maximumZoomScale = 1.2
            contentScrollView.zoomScale = 1.0
        }else
        {
            let minRatio = min(widthRatio, heightRatio)
            contentScrollView.minimumZoomScale = minRatio
            contentScrollView.maximumZoomScale = 1.2
            contentScrollView.zoomScale = contentScrollView.minimumZoomScale
        }
        updateImageViewConstraints()
    }
    
    func updateImageViewConstraints() {
        let scrollViewSize = self.contentScrollView.bounds.size
        let currentSize = CGSizeMake(imageSize.width*contentScrollView.zoomScale, imageSize.height*contentScrollView.zoomScale)
        if currentSize.width < scrollViewSize.width{
            imageViewLeftConstraint.constant = (scrollViewSize.width-currentSize.width)/2.0
        }else{
            imageViewLeftConstraint.constant = 0
        }
        if currentSize.height < scrollViewSize.height{
            imageViewTopConstraint.constant = (scrollViewSize.height-currentSize.height)/2.0
        }else{
            imageViewTopConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }

}
