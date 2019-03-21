//
//  Temperature.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation


class Temperature
{
    private var celcius:Float?
    private var fahrenheit:Float?
    private var kelvin:Float?
    
    private var value:Float?
    private var from:String?
    
    func CalculateFrom(value:Float, from:String)
    {
        self.value = value
        self.from = from
    }
    
    func Calculate()->(Float, Float, Float)
    {
        if(from == "celcius")
        {
            self.celcius = value
            self.fahrenheit = (celcius! * 1.8) + 32
            self.kelvin = celcius! + 273.15
        }
        else if(from == "fahrenheit")
        {
            self.fahrenheit = value
            self.celcius = (fahrenheit! - 32) * (5/9)
            self.kelvin = celcius! + 273.15
        }
        else if(from == "kelvin")
        {
            self.kelvin = value
            self.celcius = kelvin! - 273.15
            self.fahrenheit = celcius! * (9/6) + 32
        }
        
        return (celcius!, fahrenheit!, kelvin!)
    }
    
    
}

