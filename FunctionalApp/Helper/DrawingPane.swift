//
//  DrawingPane.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 26/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class DrawingPane: UIView {
    var existingImageToDraw : UIImage?
    var canvasImage : UIImage?
    var drawingPoints = [CGPoint]()
    var strokeWidth : CGFloat = 5.0

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let currentContext = UIGraphicsGetCurrentContext();
        if let imgToDraw = canvasImage{
            imgToDraw.drawInRect(rect)
        }
        CGContextSetStrokeColor(currentContext, CGColorGetComponents(UIColor.brownColor().CGColor))
        CGContextSetLineWidth(currentContext,strokeWidth);
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func updateBounds(){
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
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
            var curPixelIndex = 0
            let width = CGImageGetWidth(imageRef)
            let height = CGImageGetHeight(imageRef)
            var contextInfo = createBitmapContextForCGImage(imageRef)
            defer { contextInfo.1?.dealloc(width*height); contextInfo.1?.destroy() }
            if let rawData = contextInfo.1{
                var reverseCurPixelIndex = (width*height)-1;
                var leftTop = CGPoint(x: -1, y: -1), rightBottom = CGPoint(x: -1, y: -1)
                var isAllDone = false
                for curRow in 0...width{
                    for curCol in 0...height{
                        if leftTop.x == -1 && rawData[curPixelIndex] > 0 {
                            leftTop = CGPointMake(CGFloat(curRow), CGFloat(curCol))
                        }
                        if rightBottom.x == -1 && rawData[reverseCurPixelIndex] > 0{
                            rightBottom = CGPointMake(CGFloat(curRow), CGFloat(curCol))
                        }
                        isAllDone = leftTop.x != -1 && rightBottom.x != -1
                        if isAllDone{
                            break
                        }
                        
                        curPixelIndex += 1
                        reverseCurPixelIndex -= 1
                    }
                    if reverseCurPixelIndex < curPixelIndex || isAllDone{
                        break
                    }
                }
                if isAllDone{
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
        print("update Canvas")
        if let image = canvasImage, imageRef = image.CGImage{
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
            CGContextSetRGBStrokeColor(contextRef, 0.6, 0.4, 0.2, 1.0)
            CGContextTranslateCTM(contextRef, 0, CGFloat(height))
            CGContextScaleCTM(contextRef, 1.0, -1.0);
            CGContextSetLineWidth(contextRef,strokeWidth*pixelScale);
            var curIndex = 0
            print("Drawing pts count \(drawingPoints.count)")
            for curPt in drawingPoints{
                if curIndex == 0{
                    CGContextMoveToPoint(contextRef, curPt.x*pixelScale, curPt.y*pixelScale)
                }else{
                    CGContextAddLineToPoint(contextRef, curPt.x*pixelScale, curPt.y*pixelScale)
                }
                curIndex += 1
            }
            CGContextStrokePath(contextRef)
//            var curPixelIndex = 0
//            var reverseCurPixelIndex = (width*height)-1;
//            var leftTop = CGPoint(x: -1, y: -1), rightBottom = CGPoint(x: -1, y: -1)
//            for curRow in 0...width{
//                for curCol in 0...height{
//                    if leftTop.x == -1 && rawData[curPixelIndex] > 0 {
//                        leftTop = CGPointMake(CGFloat(curRow), CGFloat(curCol))
//                    }
//                    if rightBottom.x == -1 && rawData[reverseCurPixelIndex] > 0{
//                        rightBottom = CGPointMake(CGFloat(curRow), CGFloat(curCol))
//                    }
//                    curPixelIndex += 1
//                    reverseCurPixelIndex -= 1
//                }
//                if reverseCurPixelIndex < curPixelIndex{
//                    break
//                }
//            }
            if let contextImage = CGBitmapContextCreateImage(contextRef){
                canvasImage = UIImage(CGImage: contextImage)
                print("canvas image created")
            }
        }
    }

}
