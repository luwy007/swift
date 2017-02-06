//
//  CounterViewController.swift
//  SwiftCounter
//
//  Created by Jason Li on 6/17/14.
//  Copyright (c) 2014 Swiftist. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {

    ///UI Controls
    var timeLabel: UILabel? //显示剩余时间
    var startStopButton: UIButton? //开始/停止按钮
    var clearButton: UIButton? //复位按钮
    var timeButtons: [UIButton]? //设置时间的按钮数组
    let timeButtonInfos = [("1分", 60), ("3分", 180), ("5分", 300), ("秒", 1)]
    
    var remainingSeconds: Int = 0 {
    willSet(newSeconds) {
        
        let mins = newSeconds / 60
        let seconds = newSeconds % 60

        timeLabel!.text = NSString(format: "%02d:%02d", mins, seconds) as String
        
        if newSeconds <= 0 {
            isCounting = false
            self.startStopButton!.alpha = 0.3
            self.startStopButton!.isEnabled = false
        } else {
            self.startStopButton!.alpha = 1.0
            self.startStopButton!.isEnabled = true
        }

    }
    }
    
    var timer: Timer?
    var isCounting: Bool = false {
    willSet(newValue) {
        if newValue {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CounterViewController.updateTimer(_:)), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
        setSettingButtonsEnabled(!newValue)
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        setupTimeLabel()
        setuptimeButtons()
        setupActionButtons()
     
        remainingSeconds = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLabel!.frame = CGRect(x: 10, y: 40, width: self.view.bounds.size.width-20, height: 120)
        
        let gap = ( self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count - 1)
//        for (index, button) in enumerate(timeButtons!) {
//            let buttonLeft = 10 + (64 + gap) * CGFloat(index)
//            button.frame = CGRect(x: buttonLeft, y: self.view.bounds.size.height-120, width: 64, height: 44)
//        }
        
        startStopButton!.frame = CGRect(x: 10, y: self.view.bounds.size.height-60, width: self.view.bounds.size.width-20-100, height: 44)
        clearButton!.frame = CGRect(x: 10+self.view.bounds.size.width-20-100+20, y: self.view.bounds.size.height-60, width: 80, height: 44)
        
    }
    
    
    //UI Helpers

    func setupTimeLabel() {
        
        timeLabel = UILabel()
        timeLabel!.textColor = UIColor.white
        timeLabel!.font = UIFont(name: "Helvetica", size: 80)
        timeLabel!.backgroundColor = UIColor.black
        timeLabel!.textAlignment = NSTextAlignment.center
        
        self.view.addSubview(timeLabel!)
    }
    
    func setuptimeButtons() {
        
        var buttons: [UIButton] = []
//        for (index, (title, _)) in enumerate(timeButtonInfos) {
//            
//            let button: UIButton = UIButton()
//            button.tag = index //保存按钮的index
//            button.setTitle("\(title)", for: UIControlState())
//            
//            button.backgroundColor = UIColor.orange
//            button.setTitleColor(UIColor.white, for: UIControlState())
//            button.setTitleColor(UIColor.black, for: UIControlState.highlighted)
//            
//            button.addTarget(self, action: "timeButtonTapped:", for: UIControlEvents.touchUpInside)
//            
//            buttons += [button]
//            self.view.addSubview(button)
//            
//        }
        timeButtons = buttons
        
    }
    
    func setupActionButtons() {
        
        //create start/stop button
        startStopButton = UIButton()
        startStopButton!.backgroundColor = UIColor.red
        startStopButton!.setTitleColor(UIColor.white, for: UIControlState())
        startStopButton!.setTitleColor(UIColor.black, for: UIControlState.highlighted)
        startStopButton!.setTitle("启动/停止", for: UIControlState())
        startStopButton!.addTarget(self, action: #selector(CounterViewController.startStopButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(startStopButton!)
        
        clearButton = UIButton()
        clearButton!.backgroundColor = UIColor.red
        clearButton!.setTitleColor(UIColor.white, for: UIControlState())
        clearButton!.setTitleColor(UIColor.black, for: UIControlState.highlighted)
        clearButton!.setTitle("复位", for: UIControlState())
        clearButton!.addTarget(self, action: #selector(CounterViewController.clearButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(clearButton!)
        
    }
    
    func setSettingButtonsEnabled(_ enabled: Bool) {
        for button in self.timeButtons! {
            button.isEnabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        clearButton!.isEnabled = enabled
        clearButton!.alpha = enabled ? 1.0 : 0.3
    }
    
    //Actions
    
    func timeButtonTapped(_ sender: UIButton) {
        let (title, seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    func startStopButtonTapped(_ sender: UIButton) {
        isCounting = !isCounting
        
        if isCounting {
            createAndFireLocalNotificationAfterSeconds(remainingSeconds)
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
    }
    
    func clearButtonTapped(_ sender: UIButton) {
        remainingSeconds = 0
    }
    
    func updateTimer(_ sender: Timer) {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            let alert = UIAlertView()
            alert.title = "计时完成！"
            alert.message = ""
            alert.addButton(withTitle: "OK")
            alert.show()

        }
    }
    
    //Helpers
    
    func createAndFireLocalNotificationAfterSeconds(_ seconds: Int) {
        
        UIApplication.shared.cancelAllLocalNotifications()
        let notification = UILocalNotification()
        
        let timeIntervalSinceNow = Double(seconds)
        notification.fireDate = Date(timeIntervalSinceNow:timeIntervalSinceNow);
        
        notification.timeZone = TimeZone.current;
        notification.alertBody = "计时完成！";
        
        UIApplication.shared.scheduleLocalNotification(notification);
        
    }


}
