//
//  ViewController.swift
//  Pharmacy
//
//  Created by Алёшкина on 02.08.16.
//  Copyright © 2016 slim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



//Extensions
extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboardSetup))
        view.addGestureRecognizer(tap)
    }
    
    func hideKeyboardSetup() {
        view.endEditing(true)
    }
}


// Firebase Post Structure
struct postStruct {
    let medName : String!
    let medQuantity : String!
    let medCategory : String!
    let medBox : String!
    
    init(name: String, quantity: String, category: String, box: String) {
        self.medName = name
        self.medQuantity = quantity
        self.medCategory = category
        self.medBox = box
    }
    init(name: String) {
        self.medName = name
        self.medQuantity = nil
        self.medCategory = nil
        self.medBox = nil
    }
    
    
    func toAnyObject() -> AnyObject {
        return ["Name": medName,
                "Quantity": medQuantity,
                "Category": medCategory,
                "Box": medBox]
    }
    
}


let databaseRef = FIRDatabase.database().reference()
var posts = [postStruct]()





class Main: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    

    
//MARK: - Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
//MARK: - Variables
    var menuStatus = 0
    var medsArray = [String]()
    var filteredMedsArray = [String]()
    var searchActive = false
    
    var menuBtnPos = CGPoint()
    var addBtnPos = CGPoint()
    var listBtnPos = CGPoint()
    
    
    
    
//MARK: - Search
    
    // Keyboard search
    @IBAction func s(sender: AnyObject) {
        
        var found = false

        
        for i in posts {
            
            
            if searchField.text! == i.medName {
                
                let alert = UIAlertController(title: "Нашлось!", message: "\(i.medName)\nКоличество: \(i.medQuantity)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Перейти", style: UIAlertActionStyle.Default, handler: { action in
                    
                    MedName = i.medName
                    MedQuantity = i.medQuantity
                    MedCategory = i.medCategory
                    MedBox = i.medBox
                    self.performSegueWithIdentifier("MainToMed", sender: self)
                    
                }))
//                alert.addAction(UIAlertAction(title: "Съесть одну", style: UIAlertActionStyle.Default, handler: { action in
//                    
//                    var newNumber = Int(i.medQuantity)!
//                    newNumber -= 1
//                    
//                    databaseRef.child("Meds List").child(MedName).child("Quantity").setValue(newNumber)
//                    
//                }))
                self.presentViewController(alert, animated: true, completion: nil)
                found = true
            }
        }
    
        
        if found == false {
            let alert = UIAlertController(title: "Упс!", message: "\(searchField.text!) не нашли", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            searchField.text = ""
        }

        
    }
    

    
    
    
    
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredMedsArray.count
        } else {
            return 0//medsArray.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if(searchActive){
            cell.textLabel?.text = filteredMedsArray[indexPath.row]
            cell.textLabel?.textColor = colorWhite
        } else {
            cell.textLabel?.text = ""
//            cell.textLabel?.text = medsArray[indexPath.row]
//            cell.textLabel?.textColor = colorWhite
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var selectedMed = (n: String(), c: String(), q: String(), b: String())
        
        if searchActive {
            for i in posts {
                if filteredMedsArray[indexPath.row] == i.medName {
                    selectedMed.n = i.medName
                    selectedMed.c = i.medCategory
                    selectedMed.q = i.medQuantity
                    selectedMed.b = i.medBox
                }
            }
        } /*else {
            for i in posts {
                if medsArray[indexPath.row] == i.medName {
                    selectedMed.n = i.medName
                    selectedMed.c = i.medCategory
                    selectedMed.q = i.medQuantity
                    selectedMed.b = i.medBox
                }
            }
        }*/
        
        MedName = selectedMed.n
        MedCategory = selectedMed.c
        MedQuantity = selectedMed.q
        MedBox = selectedMed.b
        
        self.performSegueWithIdentifier("MainToMed", sender: nil)
    }
    
    
    //MARK: - SearchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
        tableView.hidden = false
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        tableView.hidden = true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        tableView.hidden = true
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        tableView.hidden = true
        view.endEditing(true)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//MARK: - Menu Button
    @IBAction func menuBtn(sender: AnyObject) {
        
        
        if menuStatus == 0 {
            
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7,  initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                
                self.addBtn.center = self.addBtnPos
                self.listBtn.center = self.listBtnPos
                self.addBtn.alpha = 1
                self.listBtn.alpha = 1
                
                self.menuStatus = 1
                
                }, completion: nil)

        } else if menuStatus == 1 {
            
            UIView.animateWithDuration(0.7, animations: {
                self.addBtn.center = self.menuBtnPos
                self.listBtn.center = self.menuBtnPos
                self.addBtn.alpha = 0
                self.listBtn.alpha = 0
                
                self.menuStatus = 0
            })
            
        }
        
    }
    
    
    
    
//MARK: - Default Functions
    override func viewDidAppear(animated: Bool) {
        menuInTheB()
        postsFill()
        for i in posts {
            medsArray.append(i.medName)
        }
        self.tableView.reloadData()
        tableView.hidden = true
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        menuInTheB()
        self.hideKeyboard()
        
        
        
        roundCornersBtn(menuBtn)
        roundCornersBtn(addBtn)
        roundCornersBtn(listBtn)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
//MARK: - Functions
    
    
    func postsFill () {
        posts.removeAll()
        databaseRef.child("Meds List").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            
            
            let theTitle = snapshot.value!["Name"] as! String
            let theQuantity = snapshot.value!["Quantity"] as! String
            let theCategory = snapshot.value!["Category"] as! String
            let theBox = snapshot.value!["Box"] as! String
            
            
            posts.insert(postStruct(name: theTitle, quantity: theQuantity, category: theCategory, box: theBox), atIndex: 0)
        })
    }
    func menuInTheB () {
        menuBtnPos = menuBtn.center
        addBtnPos = addBtn.center
        listBtnPos = listBtn.center
        
        addBtn.center = menuBtnPos
        listBtn.center = menuBtnPos
        
        addBtn.alpha = 0
        listBtn.alpha = 0
    }

}

