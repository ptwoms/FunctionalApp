//
//  DrawingViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 26/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

protocol DrawingViewControllerDelegate {
    func drawingViewControllerWillClose(drawingViewController : DrawingViewController)
}

class DrawingViewController: UIViewController {
    var drawingBound = CGRectZero
    var drawingImage : UIImage?
    @IBOutlet weak var drawingPane: DrawingPane!

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
