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
    
    
//MARK: - Outlets
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var whatFor: UITextField!
    
    
    
    
    
    
//MARK: - Add Alert
    @IBAction func addBtn(sender: AnyObject) {
        addAlert()
    }
    
    func addAlert () {
        
        let alert = UIAlertController(title: "Добавлено", message: "\(name.text!)\n\(quantity.text!) шт", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: { action in
            if self.name.text != "" || self.quantity.text != "" {
                
                self.post(self.name.text!, medQuantity: self.quantity.text!, medCategory: self.whatFor.text!)
                
            }
            self.performSegueWithIdentifier("AddToMain", sender: self)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
 

    
    
    
    
//MARK: - Firebase new item setup
    func post (medName:String, medQuantity:String, medCategory: String) {
        
        let medTitle = medName
        let quantity = medQuantity
        let category = medCategory
                        
        
        let set = postStruct(name: medTitle, quantity: quantity, category: category)
        
        databaseRef.child("Meds List").child(medTitle).setValue(set.toAnyObject())
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        
        // For Picker
        medsCategoriesPicker.delegate = self
        medsCategoriesPicker.dataSource = self
        whatFor.inputView = medsCategoriesPicker
        
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
    
}