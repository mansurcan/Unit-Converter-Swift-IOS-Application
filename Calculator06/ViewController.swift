//
//  ViewController.swift
//  Calculator06
//
//  Created by Mansur Can on 17/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //Segmented Control for Image Sections
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Headline Label
    @IBOutlet weak var labelHeading: UILabel!
    
    //Labels
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    //Textfields Outlets
    @IBOutlet weak var textfield01: UITextField!
    @IBOutlet weak var textfield02: UITextField!
    @IBOutlet weak var textfield03: UITextField!
    @IBOutlet weak var textfield04: UITextField!
    @IBOutlet weak var textfield05: UITextField!
    
    //Outlets
    @IBOutlet weak var didPressNegative: UIButton!
    @IBOutlet weak var didPressSave: UIButton!
    
    //didPressSave
    @IBOutlet weak var btnConstants: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    
    
    //Textfields Actions
    @IBAction func textfield1(_ sender: UITextField) {
        
        
    }
    
    
    @IBAction func textfield2(_ sender: UITextField) {
        
       
    }
    
    
    @IBAction func textfield3(_ sender: UITextField) {
        
        
    }
    
    @IBAction func textfield4(_ sender: UITextField) {
        
        
    }
    
    @IBAction func textfield5(_ sender: UITextField) {
        
        
    }
    
    
    
    var textField = UITextField()
    var conversion:String = ""
    var isNegate:Bool = false
    let defaults = UserDefaults.standard
    
    let history = HistoryCoreData()
    let string = StringFormat()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.selectedSegmentIndex = defaults.integer(forKey: "current_conversion")
        let title:String = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        
        conversion = title.lowercased()
        SetupConversionEnvironment(conversion: conversion)
        DisplayUserDefaults()
        view.endEditing(false)
        
    }
    
    //Hide the keyboard
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    
    //All the number buttons
    @IBAction func didPressNumber(_ sender: UIButton) {
        
        let val:String = String(sender.titleLabel!.text!)
        do
        {
            let activeField = view.getSelectedTextField()
            let str:String = (activeField?.text)!
            let newStr:String = str + val
            activeField?.text = newStr
            DisplayConversion(textField: activeField!, newStr: newStr)
            print(DisplayConversion(textField: activeField!, newStr: newStr))
            SetupUserDefaults()
        }    }

        
    //The clear button
    @IBAction func didPressClear(_ sender: UIButton) {
        
        textfield01.text = ""
        textfield02.text = ""
        textfield03.text = ""
        textfield04.text = ""
        textfield05.text = ""
    
    }
    
    //Backspace button
    @IBAction func didPressBackspace(_ sender: UIButton) {
        
        do
        {
            let activeField = view.getSelectedTextField()
            let str:String = (activeField?.text)!
            if(str != "")
            {
                let newStr:String = str.substring(to: str.index(before: str.endIndex))
                //let newStr = String(str.prefix(upTo: index))
                activeField?.text = newStr
                DisplayConversion(textField: activeField!, newStr: newStr)
                SetupUserDefaults()
            }
        }
        
    }
    
    //Negative (-) button
    @IBAction func didPressNegative(_ sender: UIButton) {
        
        if (conversion == "temp"){
            
        if(isNegate == false)
        {
            isNegate = true
            didPressNegative.setTitle("+", for: .normal)
        }
        else
        {
            isNegate = false
            didPressNegative.setTitle("-", for: .normal)
        }
        let activeField:UITextField = textfield01
        let str = activeField.text!
        var value:String?
        if(isNegate == true)
        {
            value = "-"+str
        }
        else if(isNegate == false)
        {
            value = str.replacingOccurrences(of: "-", with: "")
            //value = str.replace(target: "-", withString: "")
        }
        textfield01.text = value
        DisplayConversion(textField: activeField, newStr: value!)
        }else
        {
            didPressNegative.isEnabled = false
        }
        
    }
    
    //Decimal point
    @IBAction func didPressDecimal(_ sender: UIButton) {
        
        let activeField = view.getSelectedTextField()
        let str:String = (activeField?.text!)!
        if(!str.contains("."))
        {
            let newStr:String = str + "."
            activeField?.text = newStr
            DisplayConversion(textField: activeField!, newStr: newStr)
        }
        SetupUserDefaults()
    }
    
    //Save button
    @IBAction func didPressSave(_ sender: UIButton) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        
        let newLine = NSManagedObject(entity: entity!, insertInto: context)
        let lastID = history.getLastID(conversionValue: conversion)
        let rowsCount:Int = history.getRowsCount(conversionValue: conversion)
        let ID = lastID + 1
        newLine.setValue(conversion, forKey: "conversion")
        
        if(conversion == "weight")
        {
            newLine.setValue(ID, forKey: "id")
            newLine.setValue(textfield01.text, forKey: "field1")
            newLine.setValue(textfield02.text, forKey: "field2")
            newLine.setValue(textfield03.text, forKey: "field3")
            newLine.setValue(textfield04.text, forKey: "field4")
            newLine.setValue(textfield05.text, forKey: "field5")
        }
        else if(conversion == "temp")
        {
            newLine.setValue(ID, forKey: "id")
            newLine.setValue(textfield01.text, forKey: "field1")
            newLine.setValue(textfield02.text, forKey: "field2")
            newLine.setValue(textfield03.text, forKey: "field3")
        }
        else if(conversion == "distance")
        {
            newLine.setValue(ID, forKey: "id")
            newLine.setValue(textfield01.text, forKey: "field1")
            newLine.setValue(textfield02.text, forKey: "field2")
            newLine.setValue(textfield03.text, forKey: "field3")
            newLine.setValue(textfield04.text, forKey: "field4")
            newLine.setValue(textfield05.text, forKey: "field5")
        }
        else if(conversion == "vol l")
        {
            newLine.setValue(ID, forKey: "id")
            newLine.setValue(textfield01.text, forKey: "field1")
            newLine.setValue(textfield02.text, forKey: "field2")
            newLine.setValue(textfield03.text, forKey: "field3")
            newLine.setValue(textfield04.text, forKey: "field4")
        }
        else if(conversion == "vol s")
        {
            newLine.setValue(ID, forKey: "id")
            newLine.setValue(textfield01.text, forKey: "field1")
            newLine.setValue(textfield02.text, forKey: "field2")
            newLine.setValue(textfield03.text, forKey: "field3")
        }
        else if(conversion == "speed")
        {
            newLine.setValue(ID, forKey: "id")
            newLine.setValue(textfield01.text, forKey: "field1")
            newLine.setValue(textfield02.text, forKey: "field2")
            newLine.setValue(textfield03.text, forKey: "field3")
        }
        
        do
        {
            let firstID = history.getFirstID(conversionValue: conversion)
            
            if(rowsCount < 6)
            {
                try context.save()
                print("Saved at less than 5")
            }
            else
            {
                history.deleteRow(conversionValue: conversion, withID: firstID)
                try context.save()
                print("Saved after deleting 5")
            }
        }
        catch
        {
            print("failed")
        }
        print("LAST ID = "+String(history.getLastID(conversionValue: conversion)))
        print("FIRST ID = "+String(history.getFirstID(conversionValue: conversion)))
        
    }
    
    //Segmented Control
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        //let conversion = String(segmentedControl.selectedSegmentIndex)
        let title:String = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        conversion = title.lowercased()
        SetupConversionEnvironment(conversion: conversion)
        
        let current_conversion:Int = segmentedControl.selectedSegmentIndex
        defaults.set(current_conversion, forKey:"current_conversion")
        DisplayUserDefaults()
        
    }
    
    func SetupConversionEnvironment(conversion:String)
    {
        label1.isHidden = false
        label2.isHidden = false
        label3.isHidden = false
        label4.isHidden = false
        label5.isHidden = false
        
        textfield01.isHidden = false
        textfield02.isHidden = false
        textfield03.isHidden = false
        textfield04.isHidden = false
        textfield05.isHidden = false

        if(conversion == "weight")
        {
            label1!.text = "kg"
            label2!.text = "grams"
            label3!.text = "ounces"
            label4!.text = "pounds"
            label5!.text = "stones"
        }
        else if(conversion == "temp")
        {
            didPressNegative.isEnabled = true
            label1!.text = "Celsius"
            label2!.text = "Fahrenheit"
            label3!.text = "Kelvin"
            
            label4.isHidden = true;
            label5.isHidden = true;
            textfield04.isHidden = true;
            textfield05.isHidden = true;
        }
        else if(conversion == "distance")
        {
            label4.isHidden = false
            label5.isHidden = false
            textfield04.isHidden = false
            textfield05.isHidden = false
            
            label1!.text = "cm"
            label2!.text = "metre"
            label3!.text = "inch"
            label4!.text = "mm"
            label5!.text = "yard"
        }
        else if(conversion == "vol l")
        {
            label1!.text = "gallon"
            label2!.text = "litre"
            label3!.text = "pint"
            label4!.text = "f.ounce"
            
            label5.isHidden = true
            textfield05.isHidden = true
        }
        else if(conversion == "vol s")
        {
            label1!.attributedText = string.stringWithSuperScript(string: "m", scriptString: "3") as NSAttributedString
            label2!.attributedText = string.stringWithSuperScript(string: "cm", scriptString: "3") as NSAttributedString
            label3!.text = "litre"
            
            label4.isHidden = true
            label5.isHidden = true
            textfield04.isHidden = true
            textfield05.isHidden = true
            
        }
        else if(conversion == "speed")
        {
            label1!.text = "metres/s"
            label2!.text = "km/h"
            label3!.text = "miles/h"
            
            label4.isHidden = true
            label5.isHidden = true
            textfield04.isHidden = true
            textfield05.isHidden = true
        }
    }
    
    //User Defaults
    func SetupUserDefaults()
    {
        if(conversion == "weight")
        {
            defaults.set(textfield01.text, forKey: conversion+".1")
            defaults.set(textfield02.text, forKey: conversion+".2")
            defaults.set(textfield03.text, forKey: conversion+".3")
            defaults.set(textfield04.text, forKey: conversion+".4")
            defaults.set(textfield05.text, forKey: conversion+".5")
        }
        else if(conversion == "temp")
        {
            defaults.set(textfield01.text, forKey: conversion+".1")
            defaults.set(textfield02.text, forKey: conversion+".2")
            defaults.set(textfield03.text, forKey: conversion+".3")
        }
        else if(conversion == "distance")
        {
            defaults.set(textfield01.text, forKey: conversion+".1")
            print("1="+defaults.string(forKey: conversion+".1")!)
            
            defaults.set(textfield02.text, forKey: conversion+".2")
            print("2="+defaults.string(forKey: conversion+".2")!)
            
            defaults.set(textfield03.text, forKey: conversion+".3")
            print("3="+defaults.string(forKey: conversion+".3")!)
            
            defaults.set(textfield04.text, forKey: conversion+".4")
            print("4="+defaults.string(forKey: conversion+".4")!)
            
            defaults.set(textfield05.text, forKey: conversion+".5")
            print("5="+defaults.string(forKey: conversion+".5")!)
        }
        else if(conversion == "vol l")
        {
            defaults.set(textfield01.text, forKey: conversion+".1")
            defaults.set(textfield02.text, forKey: conversion+".2")
            defaults.set(textfield03.text, forKey: conversion+".3")
            defaults.set(textfield04.text, forKey: conversion+".4")
        }
        else if(conversion == "vol s")
        {
            defaults.set(textfield01.text, forKey: conversion+".1")
            defaults.set(textfield02.text, forKey: conversion+".2")
            defaults.set(textfield03.text, forKey: conversion+".3")
        }
        else if(conversion == "speed")
        {
            defaults.set(textfield01.text, forKey: conversion+".1")
            defaults.set(textfield02.text, forKey: conversion+".2")
            defaults.set(textfield03.text, forKey: conversion+".3")
        }
        defaults.synchronize()
    }
    
    //Display User Defaults
    func DisplayUserDefaults()
    {
        
        if(conversion == "weight")
        {
            labelHeading.text = "Weight"
            textfield01.text = defaults.string(forKey: conversion+".1")
            textfield02.text = defaults.string(forKey: conversion+".2")
            textfield03.text = defaults.string(forKey: conversion+".3")
            textfield04.text = defaults.string(forKey: conversion+".4")
            textfield05.text = defaults.string(forKey: conversion+".5")
        }
        else if(conversion == "temp")
        {
            labelHeading.text = "Temperature"
            textfield01.text = defaults.string(forKey: conversion+".1")
            textfield02.text = defaults.string(forKey: conversion+".2")
            textfield03.text = defaults.string(forKey: conversion+".3")
        }
        else if(conversion == "distance")
        {
            labelHeading.text = "Length"
            textfield01.text = defaults.string(forKey: conversion+".1")
            textfield02.text = defaults.string(forKey: conversion+".2")
            textfield03.text = defaults.string(forKey: conversion+".3")
            textfield04.text = defaults.string(forKey: conversion+".4")
            textfield05.text = defaults.string(forKey: conversion+".5")
        }
        else if(conversion == "vol l")
        {
            labelHeading.text = "Volume for Liquid"
            textfield01.text = defaults.string(forKey: conversion+".1")
            textfield02.text = defaults.string(forKey: conversion+".2")
            textfield03.text = defaults.string(forKey: conversion+".3")
            textfield04.text = defaults.string(forKey: conversion+".4")
        }
        else if(conversion == "vol s")
        {
            labelHeading.text = "Volume for Solid"
            textfield01.text = defaults.string(forKey: conversion+".1")
            textfield02.text = defaults.string(forKey: conversion+".2")
            textfield03.text = defaults.string(forKey: conversion+".3")
        }
        else if(conversion == "speed")
        {
            labelHeading.text = "Speed"
            textfield01.text = defaults.string(forKey: conversion+".1")
            textfield02.text = defaults.string(forKey: conversion+".2")
            textfield03.text = defaults.string(forKey: conversion+".3")
        }
    }
    
    //Display the Conversions
    func DisplayConversion(textField: UITextField, newStr:String)
    {
        var newStr:String = newStr
        if(newStr == "")
        {
            newStr = "0"
        }
        if(conversion == "weight")
        {
            let weight = Weight()
            var newFloat:Float?
            if let isFloat = Float(newStr)
            {
                newFloat = isFloat
            }
            else
            {
                newFloat = 0.00
            }
            
            if(textField.tag == 1)
            {
                weight.CalculateFrom(value: newFloat!, from: "kg")
                print(weight)
                let values = (weight.Calculate())
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 2)
            {
                weight.CalculateFrom(value: newFloat!, from: "grams")
                print(weight)
                let values = (weight.Calculate())
                textfield01.text = String(values.0)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 3)
            {
                weight.CalculateFrom(value: newFloat!, from: "ounces")
                print(weight)
                let values = (weight.Calculate())
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
                textfield04.text = String(values.3)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 4)
            {
                weight.CalculateFrom(value: newFloat!, from: "pounds")
                print(weight)
                let values = (weight.Calculate())
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 5)
            {
                weight.CalculateFrom(value: newFloat!, from: "stones")
                print(weight)
                let values = (weight.Calculate())
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
            }
        }
        else if(conversion == "temp")
        {
            let temperature = Temperature()
            var newFloat:Float?
            if let isFloat = Float(newStr)
            {
                newFloat = isFloat
            }
            else
            {
                newFloat = 0.00
            }
            
            if(textField.tag == 1)
            {
                temperature.CalculateFrom(value: newFloat!, from: "celcius")
                let values = temperature.Calculate()
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
            }
            else if(textField.tag == 2)
            {
                temperature.CalculateFrom(value: newFloat!, from: "fahrenheit")
                let values = temperature.Calculate()
                textfield01.text = String(values.0)
                textfield03.text = String(values.2)
            }
            else if(textField.tag == 3)
            {
                temperature.CalculateFrom(value: newFloat!, from: "kelvin")
                let values = temperature.Calculate()
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
            }
        }
        else if(conversion == "distance")
        {
            let distance = Distance()
            var newFloat:Float?
            if let isFloat = Float(newStr)
            {
                newFloat = isFloat
            }
            else
            {
                newFloat = 0.00
            }
            
            if(textField.tag == 1)
            {
                distance.CalculateFrom(value: newFloat!, from: "cm")
                let values = distance.Calculate()
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 2)
            {
                distance.CalculateFrom(value: newFloat!, from: "meter")
                let values = distance.Calculate()
                textfield01.text = String(values.0)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 3)
            {
                distance.CalculateFrom(value: newFloat!, from: "inch")
                let values = distance.Calculate()
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
                textfield04.text = String(values.3)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 4)
            {
                distance.CalculateFrom(value: newFloat!, from: "mm")
                let values = distance.Calculate()
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield05.text = String(values.4)
            }
            else if(textField.tag == 5)
            {
                distance.CalculateFrom(value: newFloat!, from: "yard")
                let values = distance.Calculate()
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
                textfield04.text = String(values.3)
                textfield03.text = String(values.2)
            }
        }
        else if(conversion == "vol l")
        {
            let liquid = VolumeLiquid()
            var newFloat:Float?
            if let isFloat = Float(newStr)
            {
                newFloat = isFloat
            }
            else
            {
                newFloat = 0.00
            }
            
            if(textField.tag == 1)
            {
                liquid.CalculateFrom(value: newFloat!, from: "gallon")
                let values = liquid.Calculate()
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
            }
            else if(textField.tag == 2)
            {
                liquid.CalculateFrom(value: newFloat!, from: "litre")
                let values = liquid.Calculate()
                textfield01.text = String(values.0)
                textfield03.text = String(values.2)
                textfield04.text = String(values.3)
            }
            else if(textField.tag == 3)
            {
                liquid.CalculateFrom(value: newFloat!, from: "pint")
                let values = liquid.Calculate()
                textfield02.text = String(values.1)
                textfield01.text = String(values.0)
                textfield04.text = String(values.3)
            }
            else if(textField.tag == 4)
            {
                liquid.CalculateFrom(value: Float(newStr)!, from: "fluid")
                let values = liquid.Calculate()
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
                textfield01.text = String(values.0)
            }
        }
        else if(conversion == "vol s")
        {
            let solid = VolumeSolid()
            var newFloat:Float?
            if let isFloat = Float(newStr)
            {
                newFloat = isFloat
            }
            else
            {
                newFloat = 0.00
            }
            
            if(textField.tag == 1)
            {
                solid.CalculateFrom(value: newFloat!, from: "meter")
                let values = solid.Calculate()
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
            }
            else if(textField.tag == 2)
            {
                solid.CalculateFrom(value: newFloat!, from: "cm")
                let values = solid.Calculate()
                textfield01.text = String(values.0)
                textfield03.text = String(values.2)
            }
            else if(textField.tag == 3)
            {
                solid.CalculateFrom(value: newFloat!, from: "litre")
                let values = solid.Calculate()
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
            }
        }
        else if(conversion == "speed")
        {
            let speed = Speed()
            var newFloat:Float?
            if let isFloat = Float(newStr)
            {
                newFloat = isFloat
            }
            else
            {
                newFloat = 0.00
            }
            
            if(textField.tag == 1)
            {
                speed.CalculateFrom(value: newFloat!, from: "mps")
                let values = speed.Calculate()
                
                textfield02.text = String(values.1)
                textfield03.text = String(values.2)
            }
            else if(textField.tag == 2)
            {
                speed.CalculateFrom(value: newFloat!, from: "kmph")
                let values = speed.Calculate()
                
                textfield01.text = String(values.0)
                textfield03.text = String(values.2)
            }
            else if(textField.tag == 3)
            {
                speed.CalculateFrom(value: newFloat!, from: "mph")
                let values = speed.Calculate()
                
                textfield01.text = String(values.0)
                textfield02.text = String(values.1)
            }
        }
    }
    

}

extension UIView
{

    func getSelectedTextField() -> UITextField?
    {
        let defaultTextField = UITextField()
        defaultTextField.viewWithTag(1)
        
        let totalTextFields = getTextFieldsInView(view: self)
        do
        {
            for textField in totalTextFields
            {
                if textField.isFirstResponder
                {
                    return textField
                }
            }
        }
        return defaultTextField
    }
    
    
    func getTextFieldsInView(view: UIView) -> [UITextField]
    {
        var totalTextFields = [UITextField]()
        
        for subview in view.subviews as [UIView]
        {
            if let textField = subview as? UITextField
            {
                totalTextFields += [textField]
            }
            else
            {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        return totalTextFields
    }

}
