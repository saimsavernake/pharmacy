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
var MedBox = String()






class MedPage: UIViewController {

    
    //MARK: - Variables
    var menuStatus = 0
    
    var nameViewPos0 = CGPoint()
    var nameViewPos1 = CGPoint()
    var menuBtnPos = CGPoint()
    var nameBtnPos = CGPoint()
    var quantityBtnPos = CGPoint()
    var categoryBtnPos = CGPoint()
    var boxBtnPos = CGPoint()
    var deleteBtnPos = CGPoint()

    
    //MARK: - Outlets
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var nameBtn: UIButton!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var boxBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
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
        forMenu()
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
        medQuantity.text = "\(MedQuantity) шт"
        
        bgBlurView.hidden = true
        quantityView.hidden = true
        
        
        
        let newNumber = MedQuantity
        databaseRef.child("Meds List").child(MedName).child("Quantity").setValue(newNumber)
        
    }
    
    
    
//MARK: - Name
    // Name - main button
    @IBAction func changeNameBtn(sender: AnyObject) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Поменять название?", message: "Введите новое название", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let newName = textField.text!
            
            let set = postStruct(name: newName, quantity: MedQuantity, category: MedCategory, box: MedBox)
            databaseRef.child("Meds List").child(newName).setValue(set.toAnyObject())
            
            databaseRef.child("Meds List").child(MedName).removeValue()
            MedName = newName
            self.medName.text = " \(MedName)"
            self.forMenu()
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
//MARK: - Category
    // Category - Main button
    @IBAction func changeCategoryBtn(sender: AnyObject) {
        
        
        
    }
    
    

//MARK: - Box
    // Box - Main Button
    @IBAction func boxChangeBtn(sender: AnyObject) {
        
        if MedBox == "Red" {
            nameView.backgroundColor = colorGreen
            databaseRef.child("Meds List").child(MedName).child("Box").setValue("Green")
            MedBox = "Green"
        } else if MedBox == "Green" {
            nameView.backgroundColor = colorRed
            databaseRef.child("Meds List").child(MedName).child("Box").setValue("Red")
            MedBox = "Red"
        }
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
        forMenu()
    }

    
    
    
    
//MARK: - Default Functions
    override func viewDidAppear(animated: Bool) {
        menuInTheB()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        menuInTheB()
        swipe()
        
        
        medName.text = " \(MedName)"
        medQuantity.text = "\(MedQuantity) шт"
        medCategory.text = " \(MedCategory)"
        if MedBox == "Green" {
            nameView.backgroundColor = colorGreen
        } else if MedBox == "Red" {
            nameView.backgroundColor = colorRed
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    func swipe () {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MedPage.swipeSetup))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeSetup () {
        self.performSegueWithIdentifier("MedToMain", sender: self)
    }
    func menuInTheB () {
        menuBtnPos = menuBtn.center
        nameBtnPos = nameBtn.center
        quantityBtnPos = quantityBtn.center
        categoryBtnPos = categoryBtn.center
        boxBtnPos = boxBtn.center
        deleteBtnPos = deleteBtn.center
        nameViewPos0 = nameView.center
        nameViewPos1 = CGPoint(x: nameViewPos0.x, y: 30)
        
        menuBtn.center = menuBtnPos
        nameBtn.center = menuBtnPos
        quantityBtn.center = menuBtnPos
        categoryBtn.center = menuBtnPos
        boxBtn.center = menuBtnPos
        deleteBtn.center = menuBtnPos
        
        nameBtn.alpha = 0
        quantityBtn.alpha = 0
        categoryBtn.alpha = 0
        boxBtn.alpha = 0
        deleteBtn.alpha = 0
        
    }
    func forMenu () {
        if menuStatus == 0 {
            
            UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7,  initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                
                self.nameBtn.center = self.nameBtnPos
                self.quantityBtn.center = self.quantityBtnPos
                self.categoryBtn.center = self.categoryBtnPos
                self.boxBtn.center = self.boxBtnPos
                self.deleteBtn.center = self.deleteBtnPos
                self.nameView.center = self.nameViewPos1
                
                self.nameBtn.alpha = 1
                self.quantityBtn.alpha = 1
                self.categoryBtn.alpha = 1
                self.boxBtn.alpha = 1
                self.deleteBtn.alpha = 1
                
                self.menuStatus = 1
                
            }, completion: nil)
        } else if menuStatus == 1 {
            
            UIView.animateWithDuration(0.7, animations: {
                self.nameBtn.center = self.menuBtnPos
                self.quantityBtn.center = self.menuBtnPos
                self.categoryBtn.center = self.menuBtnPos
                self.boxBtn.center = self.menuBtnPos
                self.deleteBtn.center = self.menuBtnPos
                self.nameView.center = self.nameViewPos0
                
                self.nameBtn.alpha = 0
                self.quantityBtn.alpha = 0
                self.categoryBtn.alpha = 0
                self.boxBtn.alpha = 0
                self.deleteBtn.alpha = 0
                
                self.menuStatus = 0
            })
            
        }
    }

}
