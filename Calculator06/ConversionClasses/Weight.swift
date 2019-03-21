//
//  Weight.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation

class Weight
{
    private var kg:Float?
    private var grams:Float?
    private var ounces:Float?
    private var pounds:Float?
    private var stones:Float?
    
    private var value:Float?
    private var from:String?
    
    func CalculateFrom(value:Float, from:String)
    {
        self.value = value
        self.from = from
    }
    
    func Calculate()->(Float, Float, Float, Float, Float)
    {
        
        if(from == "kg")
        {
            self.kg = value
            grams = (kg!*1000)
            ounces = (kg!*35.274)
            pounds = (kg!*2.20462)
            stones = (kg!*0.157472857135078)
        }
        else if(from == "grams")
        {
            self.grams = value
            kg = (grams!/1000)
            ounces = (kg!*35.274)
            pounds = (kg!*2.20462)
            stones = (kg!*0.157472857135078)
        }
        else if(from == "ounces")
        {
            self.ounces = value
            kg = (ounces!*0.0283495)
            grams = (kg!*1000)
            pounds = (kg!*2.20462)
            stones = (kg!*0.157472857135078)
        }
        else if(from == "pounds")
        {
            self.pounds = value
            kg = (pounds!*0.453592)
            grams = (kg!*1000)
            ounces = (kg!*35.274)
            stones = (kg!*0.157472857135078)
        }
        else if(from == "stones")
        {
            self.stones = value
            kg = (stones!*6.35029)
            grams = (kg!*1000)
            ounces = (kg!*35.274)
            pounds = (kg!*2.20462)
        }
        return (kg!, grams!, ounces!, pounds!, stones!)
    }
    
    
}
