//
//  GroceryTableViewCell.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 2/6/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {

    private var myGrocery: Grocery!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let grocery = self.myGrocery {
            self.buyButton.selected = grocery.purchased
            self.nameLabel.text = grocery.itemName
            
            self.gImageView.image = nil
            if let imageURL = NSURL(string: grocery.itemImageURL) {
                
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithURL(imageURL, completionHandler: {data, response, error -> Void in
                    
                    if error != nil {
                        println(error.localizedDescription)
                    }
                    
                    if let image = UIImage(data: data) {
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            self.gImageView.image = image
                        })
                    }
                })
                
                task.resume()
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    
    func assignGrocery(grocery: Grocery) {
        self.myGrocery = grocery
    }
    
    @IBAction func buyButtonPressed(sender: UIButton) {
        
//        sender.selected = !sender.selected
//        self.myGrocery.purchased = sender.selected
        
    }
}
