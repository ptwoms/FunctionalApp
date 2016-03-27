//
//  UIScrollView+P2MSAddition.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 24/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension UIScrollView{
    func zoomOutToNormalizedCenterPoint(centerPoint : CGPoint, normalizedSize: CGSize, forScale scaleFactor: CGFloat, animated : Bool, adjustment: CGPoint) {
        let halfScrollViewWidth = (bounds.size.width/scaleFactor)/2
        let halfScrollViewHeight = (bounds.size.height/scaleFactor)/2
        var zoomRect = CGRectMake((centerPoint.x / normalizedSize.width) * normalizedSize.width, (centerPoint.y / normalizedSize.height) * normalizedSize.height, halfScrollViewWidth*2, halfScrollViewHeight*2)
        zoomRect.origin.x -= halfScrollViewWidth + adjustment.x
        zoomRect.origin.y -= halfScrollViewHeight + adjustment.y
        if zoomRect.origin.x < 0{
            zoomRect.origin.x = 0
        }
        if zoomRect.origin.y < 0 {
            zoomRect.origin.y = 0
        }
        zoomToRect(zoomRect, animated: animated)
    }
}
