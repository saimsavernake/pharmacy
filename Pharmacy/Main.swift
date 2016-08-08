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





class Main: UIViewController {
    
    

    
//MARK: - Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
    
    
//MARK: - Variables
    var menuStatus = 0
    
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
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        menuInTheB()
        self.hideKeyboard()
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

