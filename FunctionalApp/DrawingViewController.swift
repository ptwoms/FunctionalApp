//
//  DrawingViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 26/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

protocol DrawingViewControllerDelegate : class {
    func drawingViewControllerWillClose(drawingViewController : DrawingViewController)
}

enum DrawingControlType {
    case Pen
    case Eraser
}

class DrawingViewController: UIViewController {
    @IBOutlet weak var penButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var colorChooserButton: UIButton!
    var drawingBounds = CGRectZero
    var prevCanvasSize = CGSizeZero
    var drawingImage : UIImage?
    var drawingImageName : String?
    var attachmentRange : NSRange?
    @IBOutlet weak var drawingPane: DrawingPane!
    weak var delegate : DrawingViewControllerDelegate?
    @IBOutlet weak var closeButton: UIBarButtonItem!
    private var _lastSelectedColor : UIColor?
    var lastSelectedColor : UIColor!{
        get{
            if _lastSelectedColor == nil{
                let stdUserDefaults = NSUserDefaults.standardUserDefaults()
                if let selColor = stdUserDefaults.objectForKey("drawingLastUsedColor") as? UIColor{
                    _lastSelectedColor = selColor
                }else{
                    _lastSelectedColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                }
            }
            return _lastSelectedColor
        }
        set(colorSelected){
            _lastSelectedColor = colorSelected
            NSUserDefaults.standardUserDefaults().setObject(_lastSelectedColor, forKey: "drawingLastUsedColor")
        }
    }
    
    var currentDrawingType : DrawingControlType!{
        didSet{
            drawingPane?.drawingControlType = currentDrawingType
            if self.eraserButton != nil{
                updateDrawingControlAppearances()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        prepareCanvasImage()
    }
    
    func prepareCanvasImage(){
        if let existingImage = drawingImage where drawingPane.canvasImage == nil{
            let screenScale = UIScreen.mainScreen().scale
            let curCanvasSize = CGSizeMake(drawingPane.bounds.size.width*screenScale, drawingPane.bounds.size.height*screenScale)
            if prevCanvasSize.width > 0 && prevCanvasSize.height > 0{
                let widthRatio = curCanvasSize.width/prevCanvasSize.width
                let heightRatio = curCanvasSize.height/prevCanvasSize.height
                drawingPane.canvasImage = UIImage.createImageForSize(curCanvasSize, subImage: existingImage, subImageBounds: CGRectMake(drawingBounds.origin.x*widthRatio, drawingBounds.origin.y*heightRatio, drawingBounds.size.width*widthRatio, drawingBounds.size.height*heightRatio))
                drawingPane.setNeedsDisplay()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        closeButton.title = NSLocalizedString("close", comment: "")
        eraserButton.imageView?.contentMode = .ScaleAspectFit
        penButton.imageView?.contentMode = .ScaleAspectFit
        colorChooserButton.roundCorner(5)
        currentDrawingType = .Pen
    }
    
    private func getTintColorForButtonType(buttonType : DrawingControlType) -> UIColor{
        return currentDrawingType == buttonType ? UIColor.blueColor() : UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 0.9)
    }
    
    private func updateDrawingControlAppearances(){
        eraserButton.tintColor = getTintColorForButtonType(.Eraser)
        penButton.tintColor = getTintColorForButtonType(.Pen)
        colorChooserButton.hidden = currentDrawingType == .Eraser
        colorChooserButton.backgroundColor = lastSelectedColor
        drawingPane.activeColor = lastSelectedColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        drawingBounds = drawingPane.getCanvasBounds()
        if !CGRectEqualToRect(drawingBounds, CGRectZero) {
            drawingImage = drawingPane.canvasImage?.clipToRect(drawingBounds)
        }else{
            drawingImage = nil
        }
        delegate?.drawingViewControllerWillClose(self)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func drawingControlButtonClicked(sender: UIButton) {
        switch sender {
        case penButton:
            currentDrawingType = .Pen
        default:
            currentDrawingType = .Eraser
        }
    }
    
    @IBAction func colorChooserButtonClicked(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
