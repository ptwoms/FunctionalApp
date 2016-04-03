//
//  NSDate+P2MSAddition.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 29/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import Foundation

extension NSDate{
    func isSameDate(dateToTest : NSDate?) -> Bool{
        guard let otherDate = dateToTest else{
            return false
        }
        let currentCalender = NSCalendar.currentCalendar()
        let calUnits = NSCalendarUnit(rawValue: NSCalendarUnit.Day.rawValue|NSCalendarUnit.Month.rawValue|NSCalendarUnit.Year.rawValue|NSCalendarUnit.Era.rawValue)
        let otherDateComponents = currentCalender.components(calUnits, fromDate: otherDate)
        let selfComponents = currentCalender.components(calUnits, fromDate: self)
        return (otherDateComponents.day == selfComponents.day) &&
            (otherDateComponents.month == selfComponents.month) &&
            (otherDateComponents.year == selfComponents.year) &&
            (otherDateComponents.era == selfComponents.era)
    }
    
    func addDays(numOfDay : Int) -> NSDate? {
        let daysComp = NSDateComponents()
        daysComp.day = numOfDay
        return NSCalendar.currentCalendar().dateByAddingComponents(daysComp, toDate: self, options: [])
    }
    
    func isToday() -> Bool {
        return isSameDate(NSDate())
    }
    
    func isYesterday() -> Bool {
        return isSameDate(NSDate().addDays(1))
    }
    
    func getPastDateString() -> String {
        let currentCalender = NSCalendar.currentCalendar()
        let calUnits = NSCalendarUnit(rawValue: NSCalendarUnit.Day.rawValue|NSCalendarUnit.Month.rawValue|NSCalendarUnit.Year.rawValue|NSCalendarUnit.Era.rawValue)
        let todayComponents = currentCalender.components(calUnits, fromDate: NSDate())
        let selfComponents = currentCalender.components(calUnits, fromDate: self)
        if let todayDateOnly = currentCalender.dateFromComponents(todayComponents), selfDateOnly = currentCalender.dateFromComponents(selfComponents){
            let intervalDiff = todayDateOnly.timeIntervalSinceDate(selfDateOnly)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            if intervalDiff >= 0{
                let numOfDays = floor(intervalDiff/86400)
                if numOfDays == 1{
                    return NSLocalizedString("yesterday", comment: "")
                }
                if numOfDays == 0{
                    dateFormatter.dateFormat = "hh:mm a"
                }else if numOfDays < 7{
                    dateFormatter.dateFormat = "EEEE"
                }
                return dateFormatter.stringFromDate(self)
            }
        }
        return ""
    }
    
}
