//
//  Speed.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation

class Speed
{
    private var mps:Float?
    private var kmph:Float?
    private var mph:Float?
    
    private var value:Float?
    private var from:String?
    
    func CalculateFrom(value:Float, from:String)
    {
        self.value = value
        self.from = from
    }
    
    func Calculate()->(Float, Float, Float)
    {
        if(from == "mps")
        {
            self.mps = value
            self.kmph = mps! * 3.6
            self.mph = mps!*2.236936
        }
        else if(from == "kmph")
        {
            self.kmph = value
            self.mps = kmph!/3.6
            self.mph = mps! * 2.236936
        }
        else if(from == "mph")
        {
            self.mph = value
            self.mps = mph! / 2.236936
            self.kmph = mph! * 1.609344
        }
        
        return (mps!, kmph!, mph!)
    }
}
