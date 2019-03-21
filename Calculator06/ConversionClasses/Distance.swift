//
//  Length.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation

class Distance
{
    private var cm:Float?
    private var meter:Float?
    private var inch:Float?
    private var mm:Float?
    private var yard:Float?
    
    private var value:Float?
    private var from:String?
    
    func CalculateFrom(value:Float, from:String)
    {
        self.value = value
        self.from = from
    }
    
    func Calculate()->(Float, Float, Float, Float, Float)
    {
        if(from == "cm")
        {
            self.cm = value
            self.meter = cm!/100
            self.inch = cm!*0.39370
            self.mm  = cm!*10
            self.yard  = cm!*0.010936
        }
        else if(from == "meter")
        {
            self.meter = value
            self.cm = meter!/0.010000
            self.inch = cm!*0.39370
            self.mm = cm!*10
            self.yard = cm!*0.010936
        }
        else if(from == "inch")
        {
            self.inch = value
            self.cm = inch!*2.54
            self.meter = cm!/100
            self.mm = cm!*10
            self.yard = cm!*0.010936
        }
        else if(from == "mm")
        {
            self.mm = value
            self.cm = mm!/10
            self.inch = cm!*0.39370
            self.meter = cm!/100
            self.yard = cm!*0.010936
        }
        else if(from == "yard")
        {
            self.yard = value
            self.cm = yard!/0.010936
            self.inch = cm!*0.39370
            self.mm = cm!*10
            self.meter = cm!/100
        }
        
        return (cm!, meter!, inch!, mm!, yard!)
    }
    
    
}


