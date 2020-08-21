//
//  SettingsController.swift
//  respawn
//
//  Created by Ixchel on 17/08/20.
//  Copyright © 2020 flakeystories. All rights reserved.
//

import UIKit
import Lottie
class SettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var timeTxt : UITextField!
    @IBOutlet var todayTxt: UITextField!
    @IBOutlet var monthTxt: UITextField!
    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var monthLbl: UILabel!
    @IBOutlet var totalLbl: UILabel!
    @IBOutlet var totalTxt: UITextField!
    
    @IBOutlet var minusBtn: UIButton!
    @IBOutlet var plusBtn: UIButton!
    
    var minutes: [Int] = []
    var picker = UIPickerView()
    var tiempo: Int32 = 0

    override open var shouldAutorotate: Bool {
        return false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 251/255, green: 219/255, blue: 140/255, alpha: 1)
        
        
        if let t = UserDefaults.standard.string(forKey: "time") as String? {
            tiempo = Int32(t)!
        }
        else
        {
            tiempo = 25
        }
        
        timeTxt.text = String(tiempo)
        
        for n in 1...60{
            minutes.append(n)
        }
        
        picker.delegate = self
        timeTxt.inputView = picker
        timeTxt.placeholder = "Select minutes"
        
        // get the current date and time
        let currentDateTime = Date()
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        
        var dateStamp = formatter.string(from: currentDateTime)
        dateStamp = dateStamp.replacingOccurrences(of: "/", with: "-", options: NSString.CompareOptions.literal, range:nil)
        
        
        let index = dateStamp.index(dateStamp.startIndex, offsetBy: 2)
        let mon = dateStamp[..<index].map{String($0)}
        var month : String!
        if mon[1] == "-"
        {
            month = mon[0]
        }
        
        // for changing labels from min to hours if more than 60 minutes saved
        if RecordManager.shared.getTotal() < 60
        {
             totalTxt.text = String(RecordManager.shared.getTotal())
             totalLbl.text = "min"
        }
        else{
            let aux: Float = (Float(RecordManager.shared.getTotal()) / 60.0)
             totalTxt.text = String(format: "%.2f", aux)
             totalLbl.text = "hr"
        }
        
        if RecordManager.shared.getTodays(today: dateStamp) < 60
        {
            todayTxt.text = String(RecordManager.shared.getTodays(today: dateStamp))
            dayLbl.text = "min"
        }
        else
        {
            let aux: Float = (Float(RecordManager.shared.getTodays(today: dateStamp)) / 60.0)
            todayTxt.text = String(format: "%.2f", aux)
            dayLbl.text = "hr"
        }
        if RecordManager.shared.getThisMonth(thismonth: month) < 60
        {
            monthTxt.text = String(RecordManager.shared.getThisMonth(thismonth: month))
            monthLbl.text = "min"
        }
        else
        {
            let aux: Float = (Float(RecordManager.shared.getThisMonth(thismonth: month)) / 60.0)
            
            monthTxt.text = String(format: "%.2f", aux)
            monthLbl.text = "hr"
        }
    }
    @IBAction func decreaseTime(_ sender: Any) {
        
        guard let value = timeTxt.text else { return  }
        if var number = Int(value) {
            // number is of type Int
            if ( number > 1)
            {
                number -= 1
                timeTxt.text = String(number)
                UserDefaults.standard.set(String(String(number)),forKey:"time")
            }
        }
        
    }
    
    @IBAction func increaseTime(_ sender: Any) {
        guard let value = timeTxt.text else { return  }
        if var number = Int(value) {
            // number is of type Int
            if ( number <= 60)
            {
                number += 1
                timeTxt.text = String(number)
                UserDefaults.standard.set(String(String(number)),forKey:"time")
            }
        }
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
        UserDefaults.standard.set(String(minutes[row]),forKey:"time")
        timeTxt.resignFirstResponder()
        
    }
    
    
}
