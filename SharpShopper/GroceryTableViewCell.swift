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
    
    var delegate: GroceryCellDelegate?
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    
    private let imageViewWidth = 80 as CGFloat
    @IBOutlet weak var imageViewWidthContstraint: NSLayoutConstraint!
    
    var imageURL: String {
        get {
            return self.imageURL
        }
        set {
            // Appropriately update content and constraints of the Image View

            self.gImageView.image = nil
            self.imageViewWidthContstraint.constant = 0
            
            if let imageURL = NSURL(string: newValue) {
                
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithURL(imageURL, completionHandler: {data, response, error -> Void in
                    
                    if error != nil {
                        println(error.localizedDescription)
                    }
                    
                    if let image = UIImage(data: data) {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            // Image was successfully found
                            self.imageViewWidthContstraint.constant = self.imageViewWidth
                            self.gImageView.image = image
                        })
                    }
                })
                
                task.resume()
            }
        
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = UIColor.clearColor()
        
        if let grocery = self.myGrocery {
            
            self.checkBoxButton.selected = grocery.purchased
            self.nameLabel.text = grocery.title
            self.descriptionLabel.text = grocery.subtitle
            
            if let url = grocery.itemImageURL {
                self.imageURL = url
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
    
    @IBAction func checkBoxButtonPressed() {

        // Toggle the checkbox
        var oldSelected = self.checkBoxButton.selected
        self.checkBoxButton.selected = !oldSelected

        self.delegate?.didUpdatePurchaseValueForGrocery(self.myGrocery, newValue: !oldSelected)
    }
    
    @IBAction func disclosureButtonPressed() {
        
        // Call a delegate/completion handler
        self.delegate?.didSelectDisclosure(forGrocery: self.myGrocery)
        
    }
}
