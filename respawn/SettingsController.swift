//
//  SettingsController.swift
//  respawn
//
//  Created by Ixchel on 17/08/20.
//  Copyright © 2020 flakeystories. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var timeTxt : UITextField!
    var minutes: [Int] = []
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for n in 1...60{
            minutes.append(n)
        }
        
        picker.delegate = self
        timeTxt.inputView = picker
        timeTxt.placeholder = "Select minutes"
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return minutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(minutes[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeTxt.text = String(minutes[row])
        timeTxt.resignFirstResponder()
    }
    
    @IBAction func setValue(){
        
    }
    
}
