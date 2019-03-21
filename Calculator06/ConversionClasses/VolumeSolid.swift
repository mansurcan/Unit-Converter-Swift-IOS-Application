//
//  VolumeSolid.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation

class VolumeSolid
{
    private var meter:Float?
    private var cm:Float?
    private var litre:Float?
    
    private var value:Float?
    private var from:String?
    
    func CalculateFrom(value:Float, from:String)
    {
        self.value = value
        self.from = from
    }
    
    func Calculate()->(Float, Float, Float)
    {
        if(from == "meter")
        {
            self.meter = value
            self.cm = meter!*1000000
            self.litre = meter!*1000
        }
        else if(from == "cm")
        {
            self.cm = value
            self.meter = cm!/1000000
            self.litre = meter!/1000
        }
        else if(from == "litre")
        {
            self.litre = value
            self.meter = litre!/1000
            self.cm = meter!/1000000
        }
        
        return (meter!, cm!, litre!)
    }
}
