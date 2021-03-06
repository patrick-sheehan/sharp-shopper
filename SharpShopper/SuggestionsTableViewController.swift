//
//  SuggestionsTableViewController.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/8/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class SuggestionsTableViewController: UITableViewController {

    var suggestedGroceries = [Grocery]()
    
    var grocery: Grocery?
    
    let walmartClient = WalmartAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Table View
        self.tableView.registerNib(UINib(nibName: "GroceryTableViewCell", bundle: nil), forCellReuseIdentifier: "GroceryCell")
        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Navigation Bar Title logo
        let image = UIImage(named: "sharp-shopper-logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
        
        // Background legal pad image
        let backgroundImage = UIImage(named: "legal-pad")
        let bImageView = UIImageView(image: backgroundImage)
        bImageView.frame = self.tableView.frame
        self.tableView.backgroundView = bImageView
    }

    override func viewWillAppear(animated: Bool) {
        
        // Remove all old groceries
        self.suggestedGroceries.removeAll(keepCapacity: true)
        self.tableView.reloadData()
        
        // Go fetch suggestions for the term
        if let term = grocery?.title {
            println("SuggestionsViewController calling NetworkManager for search term: \(term)")
            
            NetworkManager.sharedInstance.fetchGroceries(forSearchTerm: term, completionHandler: {
                (groceries) -> Void in
                
                println("Fetched \(groceries.count) suggested groceries")
                dispatch_async(dispatch_get_main_queue(), {
                    self.suggestedGroceries.extend(groceries)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    //MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.suggestedGroceries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryCell") as? GroceryTableViewCell
        
        var grocery = self.suggestedGroceries[indexPath.row]
        cell?.assignGrocery(grocery)
        cell?.disclosureButton.hidden = true
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var selectedGrocery = self.suggestedGroceries[indexPath.row]
        
        grocery?.itemID = selectedGrocery.itemID
        grocery?.itemName = selectedGrocery.itemName
        grocery?.itemDescription = selectedGrocery.itemDescription
        grocery?.itemCategory = selectedGrocery.itemCategory
        grocery?.itemImageURL = selectedGrocery.itemImageURL
        grocery?.price = selectedGrocery.price
        
        grocery?.purchased = false
        println("Selected detailed grocery: \(grocery)")
        
        CoreDataManager.sharedInstance.saveContext()
        if let parent = self.parentViewController as? GroceryListTableViewController {
            parent.tableView.reloadData()
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }


}
