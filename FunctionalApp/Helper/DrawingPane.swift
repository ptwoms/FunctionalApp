//
//  DrawingPane.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 26/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class DrawingPane: UIView {
    var canvasImage : UIImage?
    var drawingPoints = [CGPoint]()
    var drawingControlType : DrawingControlType!
    var strokeWidth : CGFloat = 5.0
    var eraserWidth : CGFloat = 10
    var activeColor : UIColor!
    var isDirty : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func getCanvasSize() -> CGSize {
        let screenScale = UIScreen.mainScreen().scale
        return CGSizeMake(bounds.size.width*screenScale, bounds.size.height*screenScale)
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let currentContext = UIGraphicsGetCurrentContext();
        if let imgToDraw = canvasImage{
            imgToDraw.drawInRect(rect)
        }
        //CGContextSetStrokeColor don't work with grayscale color space
        if drawingControlType == DrawingControlType.Eraser{
            backgroundColor!.setStroke()
            CGContextSetLineWidth(currentContext,eraserWidth);
        }else{
            activeColor.setStroke()
            CGContextSetLineWidth(currentContext,strokeWidth);
        }
        var curIndex = 0
        for curPt in drawingPoints{
            if curIndex == 0{
                CGContextMoveToPoint(currentContext, curPt.x, curPt.y)
            }else{
                CGContextAddLineToPoint(currentContext, curPt.x, curPt.y)
            }
            curIndex += 1
        }
        CGContextStrokePath(currentContext);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        isDirty = true
        if canvasImage == nil{
            let size = CGSizeMake(bounds.size.width, bounds.size.height);
            UIGraphicsBeginImageContextWithOptions(size, false, 0);
            UIColor.clearColor().setFill()
            UIRectFill(CGRectMake(0, 0, size.width, size.height));
            canvasImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        if let curPos = touches.first?.locationInView(self){
            drawingPoints.append(curPos)
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if let curPos = touches.first?.locationInView(self){
            drawingPoints.append(curPos)
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        updateCanvasImage()
        drawingPoints.removeAll()
        setNeedsDisplay()
    }
    
    func getCanvasBounds() -> CGRect {
        if let image = canvasImage, imageRef = image.CGImage{
            let width = CGImageGetWidth(imageRef)
            let height = CGImageGetHeight(imageRef)
            var contextInfo = createBitmapContextForCGImage(imageRef)
            defer { contextInfo.1?.dealloc(width*height); contextInfo.1?.destroy(width*height) }
            let contextRef = contextInfo.0
            CGContextSetBlendMode(contextRef, .Copy)
            CGContextDrawImage(contextRef, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)

            if let rawData = contextInfo.1{
                var leftTopIndex = -1
                var rightBottomIndex = Int.max
                var reverseCurPixelIndex = (width*height)-1;
                var leftTop = CGPoint(x: -1, y: -1), rightBottom = CGPoint(x: -1, y: -1)
                var isAllDone = false
                var curPixelIndex = 0
                for curY in 0...height-1{
                    for curX in 0...width-1{
                        if leftTop.x == -1 && rawData[curPixelIndex] > 0 {
                            leftTop = CGPointMake(CGFloat(curX), CGFloat(curY))
                            leftTopIndex = curPixelIndex
                        }
                        if rightBottom.x == -1 && rawData[reverseCurPixelIndex] > 0{
                            rightBottom = CGPointMake(CGFloat(curX), CGFloat(height-1-curY))
                            rightBottomIndex = reverseCurPixelIndex
                        }
                        isAllDone = leftTopIndex != -1 && rightBottomIndex != Int.max
                        if isAllDone{
                            break
                        }
                        curPixelIndex += 1
                        reverseCurPixelIndex -= 1
                    }
                    if reverseCurPixelIndex < leftTopIndex || curPixelIndex > rightBottomIndex || isAllDone{
                        break
                    }
                }
                if isAllDone{
                    leftTop.x = 0
                    leftTop.y = max(leftTop.y-10, 0)
                    rightBottom.x = CGFloat(width)
                    rightBottom.y = min(rightBottom.y+10, CGFloat(height-1))
                    return CGRect(origin: leftTop, size: CGSizeMake(rightBottom.x-leftTop.x, rightBottom.y - leftTop.y))
                }
            }
        }
        return CGRectZero
    }
    
    func createBitmapContextForCGImage(image : CGImage) -> (CGContext?, UnsafeMutablePointer<UInt32>?) {
        let width = CGImageGetWidth(image)
        let height = CGImageGetHeight(image)
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let rawData = UnsafeMutablePointer<UInt32>.alloc(width*height)
        return (CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerPixel * width, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue), rawData)
    }
    
    func updateCanvasImage() {
        if let image = canvasImage, imageRef = image.CGImage where drawingPoints.count > 0{
            let width = CGImageGetWidth(imageRef)
            let height = CGImageGetHeight(imageRef)
            let bitsPerComponent = 8
            let bytesPerPixel = 4
            let pixelScale = UIScreen.mainScreen().scale
            let colorSpace = CGColorSpaceCreateDeviceRGB();
            var contextInfo = createBitmapContextForCGImage(imageRef)
            defer{ contextInfo.1?.dealloc(width*height); contextInfo.1?.destroy() }
            let contextRef = contextInfo.0
            CGContextSetBlendMode(contextRef, .Copy)

            CGContextDrawImage(contextRef, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)
            var rgbaColor : (r : CGFloat, g: CGFloat, b : CGFloat, a : CGFloat)!
            if drawingControlType == DrawingControlType.Pen{
                rgbaColor = activeColor.getRGBAFromColor()
                CGContextSetLineWidth(contextRef,strokeWidth*pixelScale);
            }else{
                rgbaColor = UIColor.clearColor().getRGBAFromColor()
                CGContextSetLineWidth(contextRef,eraserWidth*pixelScale);
            }
            CGContextSetRGBStrokeColor(contextRef, rgbaColor.r, rgbaColor.g, rgbaColor.b, rgbaColor.a)
            CGContextTranslateCTM(contextRef, 0, CGFloat(height))
            CGContextScaleCTM(contextRef, 1.0, -1.0);
            var curIndex = 0
            for curPt in drawingPoints{
                if curIndex == 0{
                    CGContextMoveToPoint(contextRef, curPt.x*pixelScale, curPt.y*pixelScale)
                }else{
                    CGContextAddLineToPoint(contextRef, curPt.x*pixelScale, curPt.y*pixelScale)
                }
                curIndex += 1
            }
            CGContextStrokePath(contextRef)
            if let contextImage = CGBitmapContextCreateImage(contextRef){
                canvasImage = UIImage(CGImage: contextImage)
            }
        }
    }

}
