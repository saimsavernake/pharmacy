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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.keyboardOff))
        view.addGestureRecognizer(tap)
    }
    
    func keyboardOff() {
        view.endEditing(true)
    }
}


// Firebase Post Structure
struct postStruct {
    let medName : String!
    let medQuantity : String!
    let medCategory : String!
    
    init(name: String, quantity: String, category: String) {
        self.medName = name
        self.medQuantity = quantity
        self.medCategory = category
    }
    init(name: String) {
        self.medName = name
        self.medQuantity = nil
        self.medCategory = nil
    }
    
    
    func toAnyObject() -> AnyObject {
        return ["Name": medName,
                "Quantity": medQuantity,
                "Category": medCategory]
    }
    
}


let databaseRef = FIRDatabase.database().reference()





class Main: UIViewController {
    
    

    
//MARK: - Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    
//MARK: - Variables
    var menuMovementDist : CGFloat = 0
    var menuStatus = 0
    var posts = [postStruct]()
    

    
    
    
    
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
                    self.performSegueWithIdentifier("MainToMed", sender: self)
                    
                }))
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
    
    
    
    
    // Button search
    @IBAction func searchBtn(sender: AnyObject) {
        
        var found = false
        
        for i in posts {
            if searchField.text! == i.medName {
                let alert = UIAlertController(title: "Нашлось!", message: "\(i.medName)\nКоличество: \(i.medQuantity)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.Cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Перейти", style: UIAlertActionStyle.Default, handler: { action in
                    
                    MedName = i.medName
                    MedQuantity = i.medQuantity
                    MedCategory = i.medCategory
                    self.performSegueWithIdentifier("MainToMed", sender: self)
                    
                }))
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
    
    

    
    
//MARK: - Menu Button
    @IBAction func menuBtn(sender: AnyObject) {
        
        if menuStatus == 0 {
            
            UIView.animateWithDuration(0.5, animations: {
                self.menuBtn.center.y = self.menuBtn.center.y - self.menuMovementDist
                self.menuView.center.y = self.menuView.center.y - self.menuMovementDist
                self.menuStatus = 1
                
            })
        } else if menuStatus == 1 {
            
            UIView.animateWithDuration(0.5, animations: {
                self.menuBtn.center.y = self.menuBtn.center.y + self.menuMovementDist
                self.menuView.center.y = self.menuView.center.y + self.menuMovementDist
                self.menuStatus = 0
            })
            
        }
        
    }
    
    
    
    
//MARK: - Default Functions
    override func viewDidAppear(animated: Bool) {
        menuMovementDist = menuView.frame.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboard()
        
        databaseRef.child("Meds List").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            
//            let theTitle = String(snapshot.value!["Name"])
//            let theQuantity = String(snapshot.value!["Quantity"])
//            let theCategory = String(snapshot.value!["Category"])
            
            
            let theTitle = snapshot.value!["Name"] as! String
            let theQuantity = snapshot.value!["Quantity"] as! String
            let theCategory = snapshot.value!["Category"] as! String
            
            
            self.posts.insert(postStruct(name: theTitle, quantity: theQuantity, category: theCategory), atIndex: 0)
            print(self.posts)
        })
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

