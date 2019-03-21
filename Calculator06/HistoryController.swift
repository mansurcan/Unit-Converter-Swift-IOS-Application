//
//  HistoryController.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import UIKit

class HistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var sgConversion: UISegmentedControl!
    
    //@IBOutlet weak var historyTable: UITableView!
    //@IBOutlet weak var sgConversion: UISegmentedControl!
    
    let history = HistoryCoreData()
    var historyRows = Array<Any>()
    
    var ids:Array<Any>?
    var conversions:Array<Any>?
    var values:Array<Any>?
    var conversion = String()
    
    
    @IBAction func sgConversionAction(_ sender: Any)
    {
        let title:String = sgConversion.titleForSegment(at: sgConversion.selectedSegmentIndex)!
        conversion = title.lowercased()
        historyRows = history.getAllRows(conversionValue: conversion)
        print(historyRows)
        ids = historyRows[0] as? Array<Any>
        conversions = historyRows[1] as? Array<Any>
        values = historyRows[2] as? Array<Any>
        self.historyTable.reloadData()
    }
    
    override func viewDidLoad()
    {
        let conversion:String = (sgConversion.titleForSegment(at: sgConversion.selectedSegmentIndex)!).lowercased()
        print(conversion)
        super.viewDidLoad()
        historyRows = history.getAllRows(conversionValue: conversion)
        print(historyRows)
        ids = historyRows[0] as? Array<Any>
        conversions = historyRows[1] as? Array<Any>
        values = historyRows[2] as? Array<Any>
        
        self.historyTable.rowHeight = 135
        self.historyTable.contentMode = UIView.ContentMode.center
        
        historyTable.delegate = self
        historyTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = (ids?.count)!
        if(count > 0)
        {
            return count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let count = (ids?.count)!
        let historyCell = historyTable.dequeueReusableCell(withIdentifier: "historyCell")
        
        if(count > 0)
        {
            historyCell?.textLabel?.attributedText = values?[indexPath.row] as? NSAttributedString
            historyCell?.detailTextLabel?.text = ""
        }
        else
        {
            historyCell?.textLabel?.text = "No History Found"
            historyCell?.detailTextLabel?.text = "There are no records in history for this conversion"
        }
        return historyCell!
    }
}
