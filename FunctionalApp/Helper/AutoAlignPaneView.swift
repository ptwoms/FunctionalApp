//
//  AutoAlignPaneView.swift
//
//
//  Created by Pyae Phyo Myint Soe on 17/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

enum AutoAlignPaneAlignment{
    case Left
    case Center
    case Right
    
}

@IBDesignable class AutoAlignPaneView: UIView {
    @IBInspectable var alignment : AutoAlignPaneAlignment = .Center
    @IBInspectable var paddingLeft : CGFloat = 0{
        didSet{
            updateView()
        }
    }
    @IBInspectable var centerY : CGFloat = 0{
        didSet{
            updateView()
        }
    }
    @IBInspectable var paddingRight : CGFloat = 0{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var imageAspectFit : Bool = false{
        didSet{
            for curView in subViewArray{
                if let buttonView = curView as? UIButton where imageAspectFit{
                    buttonView.imageView?.contentMode = .ScaleAspectFit
                }
            }
            updateView()
        }
    }
    
    private var isUpading = false
    private var curWidth : CGFloat = 0
    
    var subViewArray = [UIView]()
    
    override func addSubview(view: UIView) {
        super.addSubview(view)
        if !isUpading && !subViewArray.contains(view){
            subViewArray.append(view)
            if let buttonView = view as? UIButton where imageAspectFit{
                buttonView.imageView?.contentMode = .ScaleAspectFit
            }
        }
    }
    
    override func willRemoveSubview(subview: UIView) {
        super.willRemoveSubview(subview)
        if !isUpading && subViewArray.contains(subview){
            subViewArray.removeAtIndex(subViewArray.indexOf(subview)!)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if curWidth != self.bounds.size.width{
            curWidth = self.bounds.size.width
            updateView()
        }
    }
    
    func updateView(){
//        #if !TARGET_INTERFACE_BUILDER
        isUpading = true
        var totalObjectWidth : CGFloat = 0
        var visibleObjects : CGFloat = 0
        for curView in subViewArray{
            curView.layoutIfNeeded()
            if !curView.hidden{
                totalObjectWidth += curView.bounds.size.width
                visibleObjects++
            }
        }
        for curView in subViewArray{
            //curView contains constraints for width and height and I don't want to touch it.
            //So I only need to remove the constraints from superview (aka self)
            curView.superview?.removeConstraintsForView(curView)
            //cheap trick to remove all constriaints related to the view
//            curView.removeFromSuperview()
        }
        let availSpace : CGFloat = (self.bounds.size.width-paddingLeft-paddingRight-totalObjectWidth)/CGFloat(visibleObjects+1)
        var prevView : UIView? = nil
        for curView in subViewArray{
//            addSubview(curView)
            if curView.hidden{
                continue
            }
//            addWidth(curView.bounds.size.width, andHeight: curView.bounds.size.height, toView: curView)
            centerVerticalSubView(curView,constant: centerY)
            if prevView != nil{
                addPadding(availSpace, betweenLeftView: prevView!, andRightView: curView)
            }else{
                addLeftPadding(availSpace+paddingLeft, withSubView: curView)
            }
            prevView = curView
        }
//            #endif
        isUpading = false
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        #if TARGET_INTERFACE_BUILDER
            updateView()
        #endif
    }
}
