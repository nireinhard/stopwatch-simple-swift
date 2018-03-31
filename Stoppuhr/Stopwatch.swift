//
//  Stopwatch.swift
//  Stoppuhr
//
//  Created by Niklas Reinhard on 31.03.18.
//  Copyright © 2018 Niklas Reinhard. All rights reserved.
//

import Foundation
import UIKit

class Stopwatch{
    var seconds: Double
    var running: Bool
    var timer: Timer
    var roundTimes: [String]
    var refreshElements: [UIView]
    
    let formatter: DateComponentsFormatter = DateComponentsFormatter()
    
    static let instance: Stopwatch = Stopwatch()
    
    private init(){
        self.seconds = 0.0
        self.running = false
        self.timer = Timer()
        self.roundTimes = [String]()
        self.refreshElements = [UIView]()
        initializeFormatter()
    }
    
    func registerUIElement(_ element: UIView){
        refreshElements.append(element)
        refreshUI()
    }
    
    static func getInstance() -> Stopwatch{
        return instance
    }
    
    func startTimer(){
        if running{
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(increase), userInfo: nil , repeats: true)
        running = true
    }
    
    func stopTimer(){
        if running{
            timer.invalidate()
            running = false
        }
    }
    
    func resetTimer(){
        stopTimer()
        seconds = 0
        refreshUI()
    }
    
    func resetRoundTimes(){
        roundTimes.removeAll()
        refreshUI()
    }
    
    func addRoundTime(_ roundTime: String?){
        if let time = roundTime{
         roundTimes.append(time)
         refreshUI()
        }
    }
    
    func getElapsedTime() -> String{
        if let formattedString = formatter.string(from: TimeInterval(seconds)){
            return formattedString
        }else{
            return "\(seconds)"
        }
    }
    
    // private helper methods
    fileprivate func initializeFormatter(){
        formatter.allowedUnits = [.hour, .minute, .second]
        //This behavior pads values with zeroes as appropriate
        formatter.zeroFormattingBehavior = .pad
    }
    
    // simple method that runs through an array of uiView elements
    // and refreshes them according to their type
    fileprivate func refreshUI(){
        for element in refreshElements{
            if element is UILabel{
                (element as! UILabel).text = getElapsedTime();
            }else if element is UITableView{
                (element as! UITableView).reloadData()
            }
        }
    }
    
    // increase elapsed seconds by 1
    @objc fileprivate func increase(){
        seconds += 1
        refreshUI()
    }
    
}
