//
//  HistoryCoreData.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import Foundation

import CoreData
import UIKit

class HistoryCoreData
{
    let string = StringFormat()
    //CoreData
    func getLastID(conversionValue:String) -> Int
    {
        let context = getContext()
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.predicate = NSPredicate(format: "conversion == %@", conversionValue)
        request.entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let keypathExpression = NSExpression(forKeyPath: "id")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])
        
        let key = "maxID"
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = key
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        var maxID: Int32? = nil
        
        do
        {
            
            if let result = try context.fetch(request) as? [[String: Int32]],
                let dict = result.first
            {
                maxID = dict[key]
            }
            
        } catch
        {
            assertionFailure("Failed to fetch max id with error = \(error)")
            return 0
        }
        
        return Int(maxID!)
    }
    
    func getFirstID(conversionValue:String) -> Int
    {
        let context = getContext()
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: "History", in: context)
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        request.predicate = NSPredicate(format: "conversion == %@", conversionValue)
        let keypathExpression = NSExpression(forKeyPath: "id")
        let minExpression = NSExpression(forFunction: "min:", arguments: [keypathExpression])
        
        let key = "minID"
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = key
        expressionDescription.expression = minExpression
        expressionDescription.expressionResultType = .integer32AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        var minID: Int32? = nil
        
        do
        {
            
            if let result = try context.fetch(request) as? [[String: Int32]],
                let dict = result.first
            {
                minID = dict[key]
            }
            
        } catch
        {
            assertionFailure("Failed to fetch max id with error = \(error)")
            return 0
        }
        
        return Int(minID!)
    }
    
    func getRowsCount(conversionValue:String) -> Int
    {
        var count:Int = 0
        
        //let appDelegate = UIApplication.shared.delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        _ = NSEntityDescription.entity(forEntityName: "History", in: context)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        request.predicate = NSPredicate(format: "conversion == %@", conversionValue)
        request.returnsObjectsAsFaults = false
        
        do
        {
            let result = try context.fetch(request)
            for _ in result as! [NSManagedObject]
            {
                count = count + 1
            }
        }
        catch
        {
            print("Failed")
        }
        
        if(String(count) == "")
        {
            count = 0
        }
        
        return count
    }
    
    func deleteRow(conversionValue:String, withID: Int)
    {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"History")
        fetchRequest.predicate = NSPredicate(format: "id = %@ AND conversion == %@", "\(withID)", conversionValue)
        do
        {
            let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
            
            for entity in fetchedResults!
            {
                context.delete(entity)
                print("deleted a row")
            }
        }
        catch _
        {
            print("Could not delete")
        }
    }
    
    func deleteAllRecords()
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func getAllRows(conversionValue:String) -> Array<Any>
    {
        var id = Array<Any>()
        var conversion = Array<Any>()
        var values = Array<Any>()
        
        let context = getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        request.predicate = NSPredicate(format: "conversion == %@", conversionValue)
        print("From getAllRows="+conversionValue)
        request.returnsObjectsAsFaults = false
        
        do
        {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                let i = String(describing: data.value(forKey: "id")!)
                id.append(i)
                print(String(i))
                let c = data.value(forKey: "conversion")!
                conversion.append(c)
                print(c)
                
                if(String(describing: c) == "weight")
                {
                    var array = Array<Any>()
                    var v = NSMutableAttributedString()
                    
                    v.append(NSMutableAttributedString(string: "kg = "))
                    if(String(describing: data.value(forKey: "field1")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field1")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field1")!)))
                    }
                    v.append(NSMutableAttributedString(string: " kg"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "grams = "))
                    
                    if(String(describing: data.value(forKey: "field2")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field2")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field2")!)))
                    }
                    v.append(NSMutableAttributedString(string: " g"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "ounces = "))
                    if(String(describing: data.value(forKey: "field3")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field3")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: " oz"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "pounds = "))
                    if(String(describing: data.value(forKey: "field4")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field4")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field4")!)))
                    }
                    v.append(NSMutableAttributedString(string: " lb"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "stones = "))
                    if(String(describing: data.value(forKey: "field5")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field5")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field5")!)))
                    }
                    v.append(NSMutableAttributedString(string: " st"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    let value = string.concatenateNSAttributedStrings(strings: array)
                    
                    values.append(value)
                    print(value)
                }
                else if(String(describing: c) == "temp")
                {
                    var array = Array<Any>()
                    var v = NSMutableAttributedString()
                    
                    v.append(NSMutableAttributedString(string: "°C = "))
                    if(String(describing: data.value(forKey: "field1")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field1")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field1")!)))
                    }
                    v.append(NSMutableAttributedString(string: " °C"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "°F = "))
                    if(String(describing: data.value(forKey: "field2")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field2")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field2")!)))
                    }
                    v.append(NSMutableAttributedString(string: " °F"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "K = "))
                    if(String(describing: data.value(forKey: "field3")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field3")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: " K"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    let value = string.concatenateNSAttributedStrings(strings: array)
                    values.append(value)
                    print(value)
                }
                else if(String(describing: c) == "distance")
                {
                    var array = Array<Any>()
                    var v = NSMutableAttributedString()
                    
                    v.append(NSMutableAttributedString(string: "centimetre = "))
                    if(String(describing: data.value(forKey: "field1")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field1")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field1")!)))
                    }
                    v.append(NSMutableAttributedString(string: " cm"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "metre = "))
                    if(String(describing: data.value(forKey: "field2")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field2")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field2")!)))
                    }
                    v.append(NSMutableAttributedString(string: " m"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "inch = "))
                    if(String(describing: data.value(forKey: "field3")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field3")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: "\""))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "milimetre = "))
                    if(String(describing: data.value(forKey: "field4")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field4")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field4")!)))
                    }
                    v.append(NSMutableAttributedString(string: " cm"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "yard = "))
                    if(String(describing: data.value(forKey: "field5")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field5")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field5")!)))
                    }
                    v.append(NSMutableAttributedString(string: " yd"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    let value = string.concatenateNSAttributedStrings(strings: array)
                    values.append(value)
                    print(value)
                }
                else if(String(describing: c) == "vol l")
                {
                    var array = Array<Any>()
                    var v = NSMutableAttributedString()
                    
                    v.append(NSMutableAttributedString(string: "gallon = "))
                    if(String(describing: data.value(forKey: "field1")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field1")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field1")!)))
                    }
                    v.append(NSMutableAttributedString(string: " gal"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "litre = "))
                    if(String(describing: data.value(forKey: "field2")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field2")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field2")!)))
                    }
                    v.append(NSMutableAttributedString(string: " l"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "pint = "))
                    if(String(describing: data.value(forKey: "field3")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field3")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: " pint"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "fluid ounce = "))
                    if(String(describing: data.value(forKey: "field4")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field4")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field4")!)))
                    }
                    v.append(NSMutableAttributedString(string: " fl oz"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    let value = string.concatenateNSAttributedStrings(strings: array)
                    values.append(value)
                    print(value)
                }
                else if(String(describing: c) == "vol s")
                {
                    var array = Array<Any>()
                    var v = NSMutableAttributedString()
                    
                    v = NSMutableAttributedString()
                    v.append(string.stringWithSuperScript(string: "metre", scriptString: "3"))
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(NSMutableAttributedString(string: "="))
                    v.append(NSMutableAttributedString(string: " "))
                    if(String(describing: data.value(forKey: "field1")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field1")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field1")!)))
                    }
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(string.stringWithSuperScript(string: "m", scriptString: "3"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(string.stringWithSuperScript(string: "centimetre", scriptString: "3"))
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(NSMutableAttributedString(string: "="))
                    v.append(NSMutableAttributedString(string: " "))
                    if(String(describing: data.value(forKey: "field2")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field2")!)
                        
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(string.stringWithSuperScript(string: "cm", scriptString: "3"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "litre = "))
                    if(String(describing: data.value(forKey: "field3")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field3")!)
                        
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: " l"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    let value = string.concatenateNSAttributedStrings(strings: array)
                    values.append(value)
                    print(value)
                }
                else if(String(describing: c) == "speed")
                {
                    var array = Array<Any>()
                    var v = NSMutableAttributedString()
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "metre/sec = "))
                    if(String(describing: data.value(forKey: "field1")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field1")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field1")!)))
                    }
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(string.stringWithSuperScript(string: "ms", scriptString: "-1"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "kilometre/hour = "))
                    if(String(describing: data.value(forKey: "field2")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field2")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field2")!)))
                    }
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(string.stringWithSuperScript(string: "kmh", scriptString: "-1"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    v = NSMutableAttributedString()
                    v.append(NSMutableAttributedString(string: "miles/hour = "))
                    if(String(describing: data.value(forKey: "field3")!).contains("e"))
                    {
                        let s = String(describing: data.value(forKey: "field3")!)
                        let value = string.separateValueExponent(value: s)
                        v.append(string.stringWithSuperScript(string: value.0, scriptString: value.1))
                    }
                    else
                    {
                        v.append(NSMutableAttributedString(string: String(describing: data.value(forKey: "field3")!)))
                    }
                    v.append(NSMutableAttributedString(string: " "))
                    v.append(string.stringWithSuperScript(string: "mh", scriptString: "-1"))
                    v.append(NSMutableAttributedString(string: "\r\n"))
                    array.append(v)
                    
                    let value = string.concatenateNSAttributedStrings(strings: array)
                    values.append(value)
                    print(value)
                }
            }
            
        } catch
        {
            print("Failed")
        }
        
        let newArray:Array<Any> = [id, conversion, values]
        
        return newArray
    }
    
    func getContext() -> NSManagedObjectContext
    {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext as NSManagedObjectContext
        
        return context
    }
}
