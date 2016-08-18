//
//  ListPage.swift
//  Pharmacy
//
//  Created by Алёшкина on 07.08.16.
//  Copyright © 2016 slim. All rights reserved.
//

import UIKit

class ListOfMedsPage: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var medsArray = [String]()
    var filteredMedsArray = [String]()
    var searchActive = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
//MARK: - Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack()
        swipeToCategoies()
        
        for i in posts {
            medsArray.append(i.medName)
        }
        self.tableView.reloadData()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
//MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredMedsArray.count
        } else {
            return medsArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if(searchActive){
            cell.textLabel?.text = filteredMedsArray[indexPath.row]
            cell.textLabel?.textColor = colorWhite
        } else {
            cell.textLabel?.text = medsArray[indexPath.row]
            cell.textLabel?.textColor = colorWhite
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        MedName = posts[indexPath.row].medName
        MedCategory = posts[indexPath.row].medCategory
        MedQuantity = posts[indexPath.row].medQuantity
        MedBox = posts[indexPath.row].medBox

        self.performSegueWithIdentifier("ListToMed", sender: nil)
    }
    

//MARK: - SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMedsArray = medsArray.filter({  (med) -> Bool in
            let tmp : NSString = med
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredMedsArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
//MARK: - Functions
    func swipeBack () {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ListOfMedsPage.swipeBackSetup))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeBackSetup () {
        self.performSegueWithIdentifier("ListToMain", sender: self)
    }
    func swipeToCategoies () {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ListOfMedsPage.swipeToCategoiesSetup))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
    }
    func swipeToCategoiesSetup () {
        self.performSegueWithIdentifier("ListToListCat", sender: self)
    }
    
}
