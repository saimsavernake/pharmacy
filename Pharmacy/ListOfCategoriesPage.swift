//
//  ListOfCategoriesPage.swift
//  Pharmacy
//
//  Created by Алёшкина on 18.08.16.
//  Copyright © 2016 slim. All rights reserved.
//

import UIKit


class ListOfCategoriesPage : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    
    
    
//MARK: - Variables and Outlets
    
    var medsArray = [String]()
    var filteredMedsArray = [String]()
    var categoriesArray = medsCategories
    var filteredCategoriesArray = [String]()
    var searchActive = false
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    
    
    
    
    
//MARK: - Default Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack()
        
        for i in posts {
            medsArray.append(i.medName)
        }
        self.tableView.reloadData()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
    
    
    
    
    
    
    
    
    
//MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            var smth = [String]()
            for fc in filteredCategoriesArray {
                for p in posts {
                    if fc == p.medCategory {
                        smth.append(p.medName)
                    }
                }
            }
            filteredMedsArray = smth
            return filteredMedsArray.count
        } else {
            return medsArray.count
        }
    }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if(searchActive){
            var smth = [String]()
            for fc in filteredCategoriesArray {
                for p in posts {
                    if fc == p.medCategory {
                        smth.append(p.medName)
                    }
                }
            }
            filteredMedsArray = smth
            cell.textLabel?.text = filteredMedsArray[indexPath.row]
        } else {
            cell.textLabel?.text = medsArray[indexPath.row];
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        MedName = posts[indexPath.row].medName
        MedCategory = posts[indexPath.row].medCategory
        MedQuantity = posts[indexPath.row].medQuantity
        MedBox = posts[indexPath.row].medBox
        
        self.performSegueWithIdentifier("ListCatToMed", sender: nil)
        
    }
    
    
    
    
    
    
    
    
//MARK: - Search
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCategoriesArray = categoriesArray.filter({  (movie) -> Bool in
            let tmp : NSString = movie
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredCategoriesArray.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    
    
    
//MARK: - Functions
    func swipeBack () {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ListOfCategoriesPage.swipeBackSetup))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeBackSetup () {
        self.performSegueWithIdentifier("ListCatToList", sender: self)
    }
    
    
    
}
