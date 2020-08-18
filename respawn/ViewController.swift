//
//  ViewController.swift
//  respawn
//
//  Created by Ixchel on 17/08/20.
//  Copyright © 2020 flakeystories. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer : Timer!
    var seconds: Int32 = 0
    var minutes: Int32 = 0
    var status : Bool = false

    @IBOutlet var startBtn: UIButton!
    @IBOutlet var timerLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
      /*  NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        */
    }
    
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        status = false
    }
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        status = false
    }
    
    @objc func appMovedToBackground(notification: NSNotification) {
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
        timerLabel.text = String(time)
    }
    func reset(){
        if timer != nil {
            timer.invalidate()
        }
        timerLabel.text = "00 : 00"
        startBtn.setTitle("Start", for: .normal)
        seconds = 0
        minutes = 0
    }
    @IBAction func startTime(_ sender: Any) {
        if(startBtn.title(for: .normal) == "Give up")
        {
            timer.invalidate()
            timerLabel.text = "00 : 00"
            startBtn.setTitle("Start", for: .normal)
            seconds = 0
            minutes = 0
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(ViewController.action), userInfo: nil, repeats: true)
            startBtn.setTitle("Give up", for: .normal)
            
        }
    }

}

