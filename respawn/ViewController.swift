//
//  ViewController.swift
//  respawn
//
//  Created by Ixchel on 17/08/20.
//  Copyright © 2020 flakeystories. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    var timer : Timer!
    var seconds: Int32 = 0
    var minutes: Int32 = 0
    var status : Bool = false
    var tiempo : Int64 = 0
   
    
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet weak var animationView: AnimationView!

    override open var shouldAutorotate: Bool {
        return false
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.isIdleTimerDisabled = true
        
        // changing colors and style
        startBtn.backgroundColor = UIColor.init(red: 248/255, green: 166/255, blue: 69/255, alpha: 1)
        startBtn.layer.cornerRadius = startBtn.frame.height / 2
        startBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        startBtn.layer.shadowColor = UIColor.init(red: 253/255, green: 221/255, blue: 139/255, alpha: 1).cgColor
        startBtn.layer.shadowOpacity = 3
        
        view.backgroundColor = UIColor.white
        
        // Storing the default time the user has set in the application in user defaults,
        // the default for my pomodoro is 25 minutes
        if let t = UserDefaults.standard.string(forKey: "time") as String? {
            tiempo = Int64(t) ?? 25
        }
        else
        {
            tiempo = 25
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        // lottie code needed to play the animation
        // Set animation content mode
        animationView.contentMode = .scaleAspectFill
        // Set animation loop mode
        animationView.loopMode = .loop
        // Adjust animation speed
        animationView.animationSpeed = 0.5
        
        /** below code is for testing purposes
         
         // get the current date and time
         let currentDateTime = Date()
         // initialize the date formatter and set the style
         let formatter = DateFormatter()
         formatter.timeStyle = .none
         formatter.dateStyle = .short
         
         var dateStamp = formatter.string(from: currentDateTime)
         dateStamp = dateStamp.replacingOccurrences(of: "/", with: "-", options: NSString.CompareOptions.literal, range:nil)
         
         var record = Record(id: 1,date: dateStamp, duration: 20)
         
         // Save dummy records into the database
         RecordManager.shared.create(record : record)
         record = Record(id: 1,date: "8-01-2020", duration: 5)
         RecordManager.shared.create(record : record)
         
         record = Record(id: 1,date: "7-30-2020", duration: 10)
         RecordManager.shared.create(record : record)
         
         **/
        
    }
    
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        status = false
    }
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        status = false
    }
    
    @objc func appMovedToBackground(notification: NSNotification) {
        // if user leaves the screen no minutes are recorded - penalty
        reset()
    }
    
    @objc func action(){
        timerLabel.text = "00 : 00"
        var fs = "0"
        var fm = "0"
        seconds += 1
        if(seconds > 9)
        {
            fs = ""
        }
        if (seconds > 59)
        {
            minutes += 1
            seconds = 0
            fs = "0"
        }
        if (minutes > 9)
        {
            fm = ""
        }
        
        let time = "\(fm)\(minutes) : \(fs)\(seconds)"
        // play animation
        animationView.play()
        
        
        if (minutes < tiempo)
        {
            timerLabel.text = String(time)
        }
        else
        {
            let alert = UIAlertController(title: "You did it!", message: "The world didn't end without you using your phone.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            // get the current date and time
            let currentDateTime = Date()
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .short
            var dateStamp = formatter.string(from: currentDateTime)
            dateStamp = dateStamp.replacingOccurrences(of: "/", with: "-", options: NSString.CompareOptions.literal, range:nil)
            
            let record = Record(id: 1,date: dateStamp, duration: tiempo)
            
            // we only save a record in the database if user waited until the time goes off
            // Save into database
            RecordManager.shared.create(record : record)
            reset()
        }
        
    }
    func reset(){
        if timer != nil {
            timer.invalidate()
        }
        timerLabel.text = "00 : 00"
        startBtn.setTitle("Start", for: .normal)
        seconds = 0
        minutes = 0
        
        // Stop animation
        animationView.stop()
    }
    @IBAction func startTime(_ sender: Any) {
        if(startBtn.title(for: .normal) == "Give up")
        {
            timer.invalidate()
            timerLabel.text = "00 : 00"
            startBtn.setTitle("Start", for: .normal)
            seconds = 0
            minutes = 0
            // stop playing animation
            animationView.stop()
        }
        else
        {
            animationView.play(fromFrame: 0, toFrame: 270, loopMode: nil, completion: nil)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(ViewController.action), userInfo: nil, repeats: true)
            startBtn.setTitle("Give up", for: .normal)
        }
    }
}
