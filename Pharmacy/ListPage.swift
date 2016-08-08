//
//  ListPage.swift
//  Pharmacy
//
//  Created by Алёшкина on 07.08.16.
//  Copyright © 2016 slim. All rights reserved.
//

import UIKit

class ListPage: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipe()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = posts[indexPath.row].medName
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        MedName = posts[indexPath.row].medName
        MedCategory = posts[indexPath.row].medCategory
        MedQuantity = posts[indexPath.row].medQuantity
        MedBox = posts[indexPath.row].medBox

        self.performSegueWithIdentifier("ListToMed", sender: nil)
    }
    
    
    func swipe () {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ListPage.swipeSetup))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeSetup () {
        self.performSegueWithIdentifier("ListToMain", sender: self)
    }
    
}
