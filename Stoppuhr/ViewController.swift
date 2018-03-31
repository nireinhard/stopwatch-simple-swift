//
//  ViewController.swift
//  Stoppuhr
//
//  Created by Niklas Reinhard on 30.03.18.
//  Copyright © 2018 Niklas Reinhard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var stopwatchButtons: [UIButton]!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var stopwatch = Stopwatch.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopwatch.registerUIElement(timeLabel)
        stopwatch.registerUIElement(tableView)
        tableView.dataSource = self
        stopwatchButtons = stopwatchButtons.sorted { $0.tag < $1.tag } // trailing closure
    }
    
    
    
    func set(title: String, for buttonIndex: Int){
        stopwatchButtons[buttonIndex].setTitle(title, for: .normal)
    }
    
    
    @IBAction func buttonHandler(_ sender: UIButton) {
        if let title = sender.titleLabel?.text{
            switch title{
            case "Start":
                stopwatch.startTimer()
                set(title: "Round", for: 0)
                set(title: "Stop", for: 1)
                break
            case "Stop":
                stopwatch.stopTimer()
                set(title: "Start", for: 0)
                set(title: "Reset", for: 1)
                break
            case "Reset":
                stopwatch.resetTimer()
                set(title: "Start", for: 0)
                set(title: "Stop", for: 1)
                stopwatch.resetRoundTimes()
            case "Round":
                stopwatch.addRoundTime(timeLabel.text)
            default:
                break
            }
            
        }
    }
}

extension ViewController: UITableViewDelegate{
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return stopwatch.roundTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoundTableViewCell", for: indexPath)
        cell.textLabel?.text = stopwatch.roundTimes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            stopwatch.roundTimes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}


