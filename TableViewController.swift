//
//  TableViewController.swift
//  Filterer
//
//  Created by administrator on 12/5/16.
//  Copyright © 2016 administrator. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let filters =
    [
        "Red",
        "Green",
        "Blue",
        "Yellow"
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self //sets tableViewController to tableView class datasource
    }
    
    //https://www.youtube.com/watch?v=NMFzt2H2DjQ&index=20&list=PL6gx4Cwl9DGDgp7nGSUnnXihbTLFZJ79B ; ~7:00
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //1 section
    }
    
    //number of rows in table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        /*if(section ==0) not commented but when used checks to see which section you are in starting with
        0th section include code for that section within the {}; remember to set tableview style to grouped
         for multiple sections; is plain by default
         */
        
        return filters.count //returns number of rows in the section
        
    
    }
    
    //contents of each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Filters Cell", forIndexPath: indexPath) //creates cell object
    
        let cell = UITableViewCell() //alternate way to create cell object
        
        //use indexpath.section == 0 to do similar as above commentary
        
        cell.textLabel?.text = filters[indexPath.row]
        
        
        return cell
    }
    
    //Gives a title for each section curtesy bucky
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Colors"
    }
    
 

}
