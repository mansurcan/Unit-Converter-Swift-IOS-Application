//
//  VolumeLiquid.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation


class VolumeLiquid
    
{
    private var gallon:Float?
    private var litre:Float?
    private var pint:Float?
    private var fluid:Float?
    
    private var value:Float?
    private var from:String?
    
    func CalculateFrom(value:Float, from:String)
    {
        self.value = value
        self.from = from
    }
    
    func Calculate()->(Float, Float, Float, Float)
    {
        if(from == "gallon")
        {
            self.gallon = value
            self.litre = gallon!/0.21997
            self.pint = gallon!*8.0000
            self.fluid = gallon!*160.00
        }
        else if(from == "litre")
        {
            self.litre = value
            self.gallon = litre!*0.21997
            self.pint = litre!*1.7598
            self.fluid = litre!*35.195
        }
        else if(from == "pint")
        {
            self.pint = value
            self.gallon = pint!*0.12500
            self.litre = gallon!/0.21997
            self.fluid = gallon!*160.00
        }
        else if(from == "fluid")
        {
            self.fluid = value
            self.gallon = fluid!*0.0062500
            self.pint = gallon!*8.0000
            self.litre = gallon!/0.21997
        }
        
        return (gallon!, litre!, pint!, fluid!)
    }
    
    
}


