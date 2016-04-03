//
//  UIColor+P2MSAddition.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 28/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

extension UIColor{
    
    func getRGBAFromColor() -> (r : CGFloat, g: CGFloat, b : CGFloat, a : CGFloat) {
        let numOfCompnents = CGColorGetNumberOfComponents(self.CGColor)
        let colorComps = CGColorGetComponents(self.CGColor)
        if numOfCompnents == 2{
            return (colorComps[0],colorComps[0],colorComps[0],colorComps[1])
        }else if numOfCompnents == 4{
            return (colorComps[0],colorComps[1],colorComps[2],colorComps[3])
        }
        return (0,0,0,1)
    }
}
