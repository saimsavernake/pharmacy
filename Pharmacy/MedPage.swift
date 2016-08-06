//
//  MedPage.swift
//  Pharmacy
//
//  Created by Алёшкина on 02.08.16.
//  Copyright © 2016 slim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase




//MARK: - Global Variables
var MedName = String()
var MedQuantity = String()
var MedCategory = String()






class MedPage: UIViewController {

    
    //MARK: - Variables
    var menuMovementDist : CGFloat = 0
    var menuStatus = 0
    var posts = [postStruct]()
    
    //MARK: - Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menu: UIView!
    
    
    //Main
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var medName: UILabel!
    @IBOutlet weak var medQuantity: UILabel!
    @IBOutlet weak var medCategory: UILabel!
    
    
    //Other
    @IBOutlet weak var bgBlurView: UIView!
    //Quantity
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityCounter: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    
    
    
//MARK: - Quantity
    // Quatity - main button
    @IBAction func changeQuantityBtn(sender: AnyObject) {
        quantityCounter.text = String(MedQuantity)
        stepper.value = Double(MedQuantity)!
        bgBlurView.hidden = false
        quantityView.hidden = false
    }
    // Quantity - stepper
    @IBAction func stepper(sender: UIStepper) {
        self.quantityCounter.text = String(Int(sender.value))
    }
    // Quantity - Save button
    @IBAction func saveQuantity(sender: AnyObject) {
        
        MedQuantity = String(Int(stepper.value))
        medQuantity.text = "Количество: \(MedQuantity) шт."
        
        bgBlurView.hidden = true
        quantityView.hidden = true
        
        
        
        let newNumber = MedQuantity
        databaseRef.child("Meds List").child(MedName).child("Quantity").setValue(newNumber)
        
    }
    
    
    
//MARK: - Name
    // Name - main button
    @IBAction func changeNameBtn(sender: AnyObject) {
        
        
        
    }
    
    
    
//MARK: - Category
    // Category - Main button
    @IBAction func changeCategoryBtn(sender: AnyObject) {
        
        
        
    }
    
    
//MARK: - Delete
    // Delete - Main button
    @IBAction func deleteBtn(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Удаление", message: "Уверены?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.Default, handler: { action in
            
            databaseRef.child("Meds List").child(MedName).removeValue()
            
            self.performSegueWithIdentifier("MedToMain", sender: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
//MARK: - Menu Button
    @IBAction func menuBtn(sender: AnyObject) {
        
        if menuStatus == 0 {
            
            UIView.animateWithDuration(0.5, animations: {
                self.menuBtn.center.y = self.menuBtn.center.y - self.menuMovementDist
                self.menu.center.y = self.menu.center.y - self.menuMovementDist
                self.menuStatus = 1
                
            })
        } else if menuStatus == 1 {
            
            UIView.animateWithDuration(0.5, animations: {
                self.menuBtn.center.y = self.menuBtn.center.y + self.menuMovementDist
                self.menu.center.y = self.menu.center.y + self.menuMovementDist
                self.menuStatus = 0
            })
            
        }
        
    }

    
    
    
    
//MARK: - Default Functions
    override func viewDidAppear(animated: Bool) {
        menuMovementDist = menu.frame.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataRef = FIRDatabase.database().reference()
        dataRef.child("Meds List").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: { snapshot in
            
            let theTitle = String(snapshot.value!["Name"])
            let theQuantity = String(snapshot.value!["Quantity"])
            let theCategory = String(snapshot.value!["Category"])
            
            self.posts.insert(postStruct(name: theTitle, quantity: theQuantity, category: theCategory), atIndex: 0)
        })
        
        
        
        medName.text = MedName
        medQuantity.text = "Количество: \(MedQuantity) шт."
        medCategory.text = "Категория: \(MedCategory)"
    }



}
