//
//  AddNewMedicine.swift
//  Pharmacy
//
//  Created by Алёшкина on 02.08.16.
//  Copyright © 2016 slim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase





var medList = [("test",1,"Антибактериальное")]


//MARK: - Categories Array
let medsCategories = ["Антибактериальное","Антибиотик","Витамины","Для Почек","Для Сна","Жаропонижающее","Железо","Исусья мазь","От Курения","От микробов","Обезболивающее","От аллергии","От Боли в Горле","От дисбактериоза","От изжоги","От Кашля","От Кровотечений","От Панических Атак","От Пятен при Угрях","От Рвоты","От Укачивания","Противовирусное","Противовосполительное","Противомикробное","Противоязвенное","Слабительное","Успокаивающее","Другое"]





class AddNew: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
//MARK: - Variables
    let medsCategoriesPicker = UIPickerView()
    var boxColor = ""
    
    
    
    
//MARK: - Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var whatFor: UITextField!
    @IBOutlet weak var boxBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var checkImg: UIImageView!
    
    
    
    @IBAction func boxBtn(sender: AnyObject) {
        
        if boxColor == "Green" {
            boxBtn.backgroundColor = colorRed
            boxBtn.titleLabel?.textColor = colorWhite
            boxColor = "Red"
        } else {
            boxBtn.backgroundColor = colorGreen
            boxBtn.titleLabel?.textColor = colorWhite
            boxColor = "Green"
        }        
    }
    
    
    
//MARK: - Add Alert
    @IBAction func addBtn(sender: AnyObject) {
        addAlert()
    }

    
    
    
    
//MARK: - Firebase new item setup
    func post (medName:String, medQuantity:String, medCategory: String, medBox: String) {
        
        let medTitle = medName
        let quantity = medQuantity
        let category = medCategory
        let box = medBox
        
        
        let set = postStruct(name: medTitle, quantity: quantity, category: category, box: box)
        
        databaseRef.child("Meds List").child(medTitle).setValue(set.toAnyObject())
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipe()
        self.addBtn.enabled = false
        self.hideKeyboard()
        self.checkImg.alpha = 0
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AddNew.fillCheck), userInfo: nil, repeats: true)
        
        
        // For Picker
        medsCategoriesPicker.delegate = self
        medsCategoriesPicker.dataSource = self
        whatFor.inputView = medsCategoriesPicker
        toolBar()
        
        roundCornersBtn(addBtn)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    

    
    
//MARK: - Picker Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return medsCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whatFor.text = medsCategories[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return medsCategories[row]
    }
    
    
    
    func addAlert () {
        
        let alert = UIAlertController(title: "Добавлено", message: "\(name.text!)\n\(quantity.text!) шт", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: { action in
            
            self.post(self.name.text!, medQuantity: self.quantity.text!, medCategory: self.whatFor.text!, medBox: self.boxColor)
            
            self.performSegueWithIdentifier("AddToMain", sender: self)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    
    func fillCheck () {
        if self.name.text != "" && self.quantity.text != "" && self.whatFor.text != "" && self.whatFor.text != nil && self.boxColor != "" {
            addBtn.backgroundColor = colorBlue
            addBtn.enabled = true
            UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.3,  initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                self.checkImg.alpha = 1
                }, completion: nil)
        } else {
            addBtn.backgroundColor = colorGrey
            addBtn.enabled = false
            self.checkImg.alpha = 0
        }
    }
    func swipe () {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AddNew.swipeSetup))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
    }
    func swipeSetup () {
        self.performSegueWithIdentifier("AddToMain", sender: self)
    }
    func toolBar () {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = colorBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Save", style: .Plain, target: nil, action: #selector(AddNew.doneButtonSetup))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(AddNew.cancelButtonSetup))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        whatFor.inputAccessoryView = toolBar
    }
    func doneButtonSetup () {
        view.endEditing(true)
    }
    func cancelButtonSetup () {
        view.endEditing(true)
        whatFor.text = nil
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
}