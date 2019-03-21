//
//  ConstantController.swift
//  Calculator06
//
//  Created by Mansur Can on 19/03/2019.
//  Copyright © 2019 Mansur Can. All rights reserved.
//

import UIKit

class ConstantController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var constantTable: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    let str = StringFormat()
    let constants:Array<String> = ["Electron Mass", "Proton Mass", "Neutron Mass", "Electric Permittivity", "Magnetic Permeability"]
    var values = Array<Any>()
    let units:Array<String> = ["1", "1", "1", "1", "1", "1"]
    var symbols = Array<Any>()
    let equals = NSAttributedString(string: "=")
    let postSymbols:Array<String> = ["g", "g", "g", "Farad/metre", "henries/metre"]
    let space = NSAttributedString(string: " ")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        symbols = [
            str.stringWithSubScript(string: "m", scriptString: "e"), str.stringWithSubScript(string: "m", scriptString: "p"), str.stringWithSubScript(string: "m", scriptString: "n"), str.stringWithSubScript(string: "ε", scriptString: "o"), str.stringWithSubScript(string: "μ", scriptString: "p")
        ]
        
        values = [
            str.stringWithSuperScript(string: "9.110e", scriptString: "-22"),
            str.stringWithSuperScript(string: "1.6727e", scriptString: "-28"),
            str.stringWithSuperScript(string: "1.6750e", scriptString: "-24"),
            str.stringWithSuperScript(string: "8.85e", scriptString: "-12"),
            str.stringWithSuperScript(string: "1.257e", scriptString: "-6")
        ]
        constantTable.delegate = self
        constantTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return constants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let constantCell = constantTable.dequeueReusableCell(withIdentifier: "constantCell")
        
        constantCell?.detailTextLabel?.text = (constants[indexPath.row]).uppercased()
        
        let u = NSMutableAttributedString(string: units[indexPath.row])
        let s = symbols[indexPath.row] as! NSMutableAttributedString
        let v = values[indexPath.row] as! NSMutableAttributedString
        let ps = NSMutableAttributedString(string: postSymbols[indexPath.row])
        let arr:Array<Any> = [u,space,s,space,equals,space,v,space,ps]
        let string = str.concatenateNSAttributedStrings(strings: arr)
        constantCell?.textLabel?.attributedText = string as NSAttributedString
        
        return constantCell!
    }
}

