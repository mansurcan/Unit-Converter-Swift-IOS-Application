//
//  StringFormat.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation
import UIKit

class StringFormat
{
    func stringWithSuperScript(string:String, scriptString:String) -> NSMutableAttributedString
    {
        var newString:NSMutableAttributedString?
        let baseLine = 10
        if let largeFont = UIFont(name: "Helvetica", size: 20), let scriptFont = UIFont(name: "Helvetica", size:10)
        {
            newString = NSMutableAttributedString(string: string, attributes: [.font: largeFont])
            newString?.append(NSAttributedString(string: scriptString, attributes: [.font: scriptFont, .baselineOffset: baseLine]))
        }
        return newString!
    }
    
    func stringWithSubScript(string:String, scriptString:String) -> NSMutableAttributedString
    {
        var newString:NSMutableAttributedString?
        let baseLine = -10
        if let largeFont = UIFont(name: "Helvetica", size: 17), let scriptFont = UIFont(name: "Helvetica", size:10)
        {
            newString = NSMutableAttributedString(string: string, attributes: [.font: largeFont])
            newString?.append(NSAttributedString(string: scriptString, attributes: [.font: scriptFont, .baselineOffset: baseLine]))
        }
        return newString!
    }
    
    func concatenateNSAttributedStrings (strings:Array<Any>) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        
        for s in strings
        {
            let v = s
            result.append(v as! NSAttributedString)
        }
        return result as NSAttributedString
    }
    
    func separateValueExponent(value: String) -> (String, String)
    {
        let s = value
        let exp = "0e"
        let fP = "0"
        
        if let range = s.range(of: "e")
        {
            let exponential = s[range.upperBound...]
            let range2 = s.range(of: "e")
            let firstPart = s[s.startIndex..<(range2)!.lowerBound] + "e"
            
            return (String(firstPart), String(exponential))
        }
        
        return (fP, exp)
    }
}

