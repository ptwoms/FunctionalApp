//
//  UIView+P2MSAddition.swift
//  P2MSCircularBreadCrumbView
//
//  Created by Pyae Phyo Myint Soe on 1/9/15.
//  Copyright (c) 2015 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension UIView{
    class func autoLayoutView() -> Self{
        let newView = self.init()
        newView.translatesAutoresizingMaskIntoConstraints = false
        return newView
    }
    
    func roundCorner(cornerRadius : CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    func removeAllSubViews(){
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
    }
    
    func removeConstraintsForView(viewOfInterest : UIView){
        var constraintsToRemove = [NSLayoutConstraint]()
        for curConstraint in constraints{
            if curConstraint.firstItem as? UIView == viewOfInterest || curConstraint.secondItem as? UIView == viewOfInterest{
                constraintsToRemove.append(curConstraint)
            }
        }
        removeConstraints(constraintsToRemove)
        if let myAnsector = superview{
            myAnsector.removeConstraintsForView(viewOfInterest)
        }
    }
    
    func removeConstraints(){
        removeConstraintsForView(self)
    }
    
    func createBotoomPadding(value: CGFloat, withSubView subView: UIView, andRelation relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: relation, toItem: subView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: value)
    }
    
    func addBottomPadding(value: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint {
        let constraint = self .createBotoomPadding(value, withSubView: subView, andRelation: NSLayoutRelation.Equal);
        constraint.priority = priority
        self.addConstraint(constraint)
        return constraint
    }

    func getRelationString(relation : NSLayoutRelation) -> NSString{
        switch(relation){
        case NSLayoutRelation.GreaterThanOrEqual: return ">=";
        case NSLayoutRelation.LessThanOrEqual: return "<=";
        default: return ""
        }
    }

    func createLeftPadding(leftPadding: CGFloat, withSubView subView: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        let view = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let allConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-(leftspace)-[v1]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: ["leftspace": String(format: "%@%f", self.getRelationString(relation), leftPadding)], views: view)
        return allConstraints[0] 
    }

    func addLeftPadding(leftPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let leftConstraint = self.createLeftPadding(leftPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        leftConstraint.priority = priority
        self.addConstraint(leftConstraint)
        return leftConstraint
    }
    
    func createTopPadding(topPadding: CGFloat, withSubView subView: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        let view = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let allConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topspace)-[v1]", options: NSLayoutFormatOptions.AlignAllTop, metrics: ["topspace": String(format: "%@%f", self.getRelationString(relation), topPadding)], views: view)
        return allConstraints[0] 
    }
    
    func addTopPadding(topPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let topConstraint = createTopPadding(topPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        topConstraint.priority = priority
        self.addConstraint(topConstraint)
        return topConstraint
    }
    
    func addPadding(topPadding: CGFloat, betweenTopView topView: UIView, andBottomView bottomView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let topConstraint = NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: topPadding)
        topConstraint.priority = priority
        self.addConstraint(topConstraint)
        return topConstraint
    }
    
    func addPadding(padding: CGFloat, betweenLeftView leftView: UIView, andRightView rightView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let leftConstraint = NSLayoutConstraint(item: rightView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: leftView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
        leftConstraint.priority = priority
        self.addConstraint(leftConstraint)
        return leftConstraint
    }
    
    func addLeftPadding(leftPadding: CGFloat, rightPadding aRightPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> Array<NSLayoutConstraint>{
        let view = Dictionary<String, UIView>.DictionaryOfVariableBindings(subView);
        let constraints : Array<NSLayoutConstraint> = NSLayoutConstraint.constraintsWithVisualFormat("|-(leftspace)-[v1]-(rightspace)-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: ["leftspace":NSNumber(double: Double(leftPadding)), "rightspace":NSNumber(double: Double(aRightPadding))], views: view) 
        for curConstraint in constraints{
            curConstraint.priority = priority
        }
        self.addConstraints(constraints)
        return constraints
    }
    

    func createRightPadding(rightPadding: CGFloat, withSubView subView: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        let view = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let allConstraints = NSLayoutConstraint.constraintsWithVisualFormat("[v1]-(rightspace)-|", options: NSLayoutFormatOptions.AlignAllTop, metrics: ["rightspace": String(format: "%@%f", self.getRelationString(relation), rightPadding)], views: view)
        return allConstraints[0] 
    }

    func addRightPadding(rightPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let rightConstraint = createRightPadding(rightPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        rightConstraint.priority = priority
        self.addConstraint(rightConstraint)
        return rightConstraint
    }
    
    func addLeftPadding(leftPadding : CGFloat, rightPadding aRightPadding: CGFloat, topPadding aTopPadding: CGFloat, withSubView subView: UIView, andPriority priority: UILayoutPriority = 1000) -> Array<NSLayoutConstraint>{
        let views = Dictionary<String,UIView>.DictionaryOfVariableBindings(subView)
        let metrics = [ "leftspace":NSNumber(double: Double(leftPadding)), "rightspace":NSNumber(double: Double(aRightPadding))]
        let lrConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(leftspace)-[v1]-(rightspace)-|", options:[NSLayoutFormatOptions.AlignAllLeading, NSLayoutFormatOptions.AlignAllTrailing], metrics: metrics, views: views)
        for curConstraint in lrConstraints{
            curConstraint.priority = priority
        }
        self.addConstraints(lrConstraints)
        let topConstraint = createTopPadding(aTopPadding, withSubView: subView, relationship: NSLayoutRelation.Equal)
        topConstraint.priority = priority;
        self.addConstraint(topConstraint)
        return [ (lrConstraints[0] ), (lrConstraints[1] ), topConstraint ]
    }

    func setEqualHeightAndWidthToView(view1 : UIView, andView view2 : UIView) -> [NSLayoutConstraint]{
        let width = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        let height = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        self.addConstraints([width, height])
        return [width, height]
    }
    

    
//
//    - (NSArray *)addLeftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding topPadding:(CGFloat)topPadding withSubView:(UIView *)subView{
//    NSDictionary *views = NSDictionaryOfVariableBindings(subView);
//    NSNumber *leftSpacing = [NSNumber numberWithFloat:leftPadding];
//    NSNumber *rightSpacing = [NSNumber numberWithFloat:rightPadding];
//    NSDictionary *metrics = @{@"leftspace": leftSpacing, @"rightspace":rightSpacing, @"topspace":[NSNumber numberWithFloat:topPadding] };
//    NSArray *lrConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftspace)-[subView]-(rightspace)-|" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:views];
//    [self addConstraints:lrConstraints];
//    NSArray *topConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topspace)-[subView]" options:NSLayoutFormatAlignAllTop metrics:metrics views:views];
//    [self addConstraints:topConstraints];
//    return @[[lrConstraints objectAtIndex:0], [lrConstraints objectAtIndex:1], [topConstraints objectAtIndex:0]];
//    }
//    
//    
//    - (NSLayoutConstraint *)createPadding:(CGFloat)value betweenTopView:(UIView *)topView andBottomView:(UIView *)bottomView relationship:(NSLayoutRelation)relation{
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:bottomView attribute:NSLayoutAttributeTop relatedBy:relation toItem:topView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:value];
//    [self addConstraint:constraint];
//    return constraint;
//    }
//    
//    - (NSLayoutConstraint *)addPadding:(CGFloat)value betweenTopView:(UIView *)topView andBottomView:(UIView *)bottomView{
//    NSLayoutConstraint *constraint = [self createPadding:value betweenTopView:topView andBottomView:bottomView relationship:NSLayoutRelationEqual];
//    [self addConstraint:constraint];
//    return constraint;
//    }
//    
//    
//
//    #pragma mark -
//    - (NSLayoutConstraint *)createCorrectedRLPadding:(CGFloat)value betweenView:(UIView *)view1 andView:(UIView *)view2 relationship:(NSLayoutRelation)relation{
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeft relatedBy:relation toItem:view1 attribute:NSLayoutAttributeRight multiplier:1.0f constant:value];
//    return constraint;
//    }
//    
//    - (NSLayoutConstraint *)createRLPadding:(CGFloat)value betweenView:(UIView *)view1 andView:(UIView *)view2 relationship:(NSLayoutRelation)relation{
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:relation toItem:view2 attribute:NSLayoutAttributeLeft multiplier:1.0f constant:value];
//    return constraint;
//    }
//    - (NSLayoutConstraint *)addRLPadding:(CGFloat)value betweenView:(UIView *)view1 andView:(UIView *)view2{
//    NSLayoutConstraint *constraint = [self createRLPadding:value betweenView:view1 andView:view2 relationship:NSLayoutRelationEqual];
//    [self addConstraint:constraint];
//    return constraint;
//    }
//    
//
//    - (NSLayoutConstraint *)createEqualWidthToView:(UIView *)view1 andView:(UIView *)view2 multiplier:(CGFloat)multiplier{
//    NSLayoutConstraint *width =[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0];
//    return width;
//    }
//    
//    - (NSLayoutConstraint *)setEqualWidthToView:(UIView *)view1 andView:(UIView *)view2 multiplier:(CGFloat)multiplier{
//    NSLayoutConstraint *width =[self createEqualWidthToView:view1 andView:view2 multiplier:multiplier];
//    [self addConstraint:width];
//    return width;
//    }
//    
//    - (NSLayoutConstraint *)setEqualWidthToView:(UIView *)view1 andView:(UIView *)view2{
//    return [self setEqualWidthToView:view1 andView:view2 multiplier:1.0];
//    }
    
    
// MARK: - Aligning two views
    func matchSidesForView(view1: UIView, withView view2: UIView){
        let leftConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0)
        let rightConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint =  NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0)
        self.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
// MARK: - Centering
    func createCenterVerticalSubView(subView: UIView, constant aConstant: CGFloat, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.CenterY, relatedBy: relation, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: aConstant)
    }

    func centerVerticalSubView(subView: UIView, constant aConstant: CGFloat) -> NSLayoutConstraint{
        let constraint = createCenterVerticalSubView(subView, constant: aConstant, relationship: NSLayoutRelation.Equal)
        self.addConstraint(constraint)
        return constraint;
    }
    
    func centerVerticalSubView(subView: UIView) -> NSLayoutConstraint{
        return centerVerticalSubView(subView, constant: 0);
    }

    func createCenterHorizontalSubView(subView: UIView, constant aConstant: CGFloat, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: subView, attribute: NSLayoutAttribute.CenterX, relatedBy: relation, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: aConstant)
    }

    func centerHorizontalSubView(subView : UIView) -> NSLayoutConstraint{
        let constraint = createCenterHorizontalSubView(subView, constant: 0, relationship: NSLayoutRelation.Equal);
        self.addConstraint(constraint)
        return constraint
    }
    
// MARK: - Width & Height
    func createHeight(height: CGFloat, toView view: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height)
    }
    
    func createWidth(width: CGFloat, toView view: UIView, relationship relation: NSLayoutRelation) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: relation, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width)
    }
    
    func addHeight(height: CGFloat, toView view: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let heightConstraint = createHeight(height, toView: view, relationship: NSLayoutRelation.Equal)
        heightConstraint.priority = priority
        self.addConstraint(heightConstraint)
        return heightConstraint
    }
    
    func addWidth(width: CGFloat, toView view: UIView, andPriority priority: UILayoutPriority = 1000) -> NSLayoutConstraint{
        let widthConstraint = createWidth(width, toView: view, relationship: NSLayoutRelation.Equal)
        widthConstraint.priority = priority
        self.addConstraint(widthConstraint)
        return widthConstraint
    }

    func addWidth(width: CGFloat, andHeight height: CGFloat, toView view: UIView, andPriority priority: UILayoutPriority = 1000) -> Array<NSLayoutConstraint>{
        let widthConstraint = self.addWidth(width, toView: view, andPriority: priority)
        let heightConstraint = self.addHeight(height, toView: view, andPriority: priority)
        return [widthConstraint, heightConstraint]
    }
    
}

