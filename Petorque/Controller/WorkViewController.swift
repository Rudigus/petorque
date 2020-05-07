//
//  WorkViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController, TimerDelegate {
    
    @IBOutlet var emptyBarImage: UIImageView!
    
    @IBOutlet var fullBarImage: UIImageView!
    
    @IBOutlet var timecountLabel: UILabel!
    
    @IBOutlet var timecountPlay: UIButton!
    
    @IBAction func timecountToggle(_ sender: UIButton) {
        taskTimer?.pauseTimer()
    }
    
    var taskTimer : TimerModel?
    
    var currentTask : Int = 0
    
    @IBOutlet var characterImage: UIImageView!
    
    @IBOutlet var taskBackgroundPanel: UIView!
    
    @IBOutlet var taskTextBackground: UIView!
    
    @IBOutlet var taskButtonBackground: UIView!
    
    @IBOutlet var currentTaskLabel: UILabel!
    
    @IBOutlet var nextTask: UIButton!
    
    @IBOutlet var previousTask: UIButton!
    
    @IBOutlet var startTask: UIButton!
    
    @IBOutlet var finishTask: UIButton!
    
    @IBAction func startCurrentTask(_ sender: UIButton) {
        let doingTasks = Database.shared.loadTodayTasks(from: .doing)
        taskButtonBackground.backgroundColor = #colorLiteral(red: 0.9548336864, green: 0.6729211211, blue: 0.6826212406, alpha: 1)
        
        nextTask.isHidden = true
        previousTask.isHidden = true
        startTask.isHidden = true
        finishTask.isHidden = false
        timecountPlay.isHidden = false
        timecountLabel.isHidden = false
        fullBarImage.isHidden = false
        emptyBarImage.isHidden = false
        
        taskTimer = TimerModel(
            count: (UserDefaults.standard.string(forKey: "Atividade"),
                    UserDefaults.standard.string(forKey: "Descanso")
            ),
            cycles: doingTasks[currentTask].numberOfCycles,
            minutes: doingTasks[currentTask].cycleDuration / 10
        )
        taskTimer?.delegate = self
        taskTimer?.startTimer(
            minutes: doingTasks[currentTask].cycleDuration / 10
        )
    }
    
    @IBAction func finishCurrentTask(_ sender: UIButton) {
        finishedTask()
    }
    
    @IBAction func previousTask(_ sender: UIButton) {
        let doingTasks = Database.shared.loadTodayTasks(from: .doing)

        if currentTask == 0 {
            currentTask = doingTasks.count-1
        } else {
            currentTask -= 1
        }
        
        currentTaskLabel.text = doingTasks[currentTask].title
    }
    
    @IBAction func nextTask(_ sender: UIButton) {
        let doingTasks = Database.shared.loadTodayTasks(from: .doing)

        if currentTask == doingTasks.count-1 {
            currentTask = 0
        } else {
            currentTask += 1
        }
        
        currentTaskLabel.text = doingTasks[currentTask].title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskBackgroundPanel.layer.cornerRadius = 15
        taskTextBackground.layer.cornerRadius = 15
        taskButtonBackground.layer.cornerRadius = 15
        
        if taskTimer == nil {
            characterImage.image = UIImage(named: "takeyourtime-char1.png")
        }
        
        currentTask = 0
        let doingTasks = Database.shared.loadTodayTasks(from: .doing)
        
        if doingTasks.isEmpty {
            currentTaskLabel.isHidden = true
            previousTask.isHidden = true
            nextTask.isHidden = true
            taskTextBackground.isHidden = true
            currentTaskLabel.isHidden = true
            let alert = UIAlertController(title: "Nada por aqui!", message: "Você precisa planejar suas tarefas na Agenda antes de começar a trabalhar.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ir para Agenda", style: .default, handler: { action in
                self.tabBarController?.selectedIndex = 1
            }))

            self.present(alert, animated: true)
        } else {
            currentTaskLabel.isHidden = false
            previousTask.isHidden = false
            nextTask.isHidden = false
            taskTextBackground.isHidden = false
            currentTaskLabel.isHidden = false
            currentTaskLabel.text = doingTasks[currentTask].title
        }
        
    }
    
    func giveTimerLabel(_ timeText : String) {
        timecountLabel.text = timeText
    }
    
    func finishedTask() {
        taskTimer?.stopTimer()
        taskTimer = nil
        
        taskButtonBackground.backgroundColor = #colorLiteral(red: 0.3408251405, green: 0.6305707097, blue: 0.718806088, alpha: 1)
        characterImage.image = UIImage(named: "takeyourtime-char1.png")
        
        Database.shared.addToDone(task: Database.shared.deleteDoingTodayTask(at: currentTask))
        
        if Database.shared.loadTodayTasks(from: .doing).isEmpty {
            performSegue(withIdentifier: "goToFeedback", sender: nil)
        } else {
            currentTask = 0
            currentTaskLabel.text = Database.shared.loadTodayTasks(from: .doing)[0].title
        }
        
        fullBarImage.isHidden = true
        emptyBarImage.isHidden = true
        timecountPlay.isHidden = true
        timecountLabel.isHidden = true
        finishTask.isHidden = true
        nextTask.isHidden = false
        previousTask.isHidden = false
        startTask.isHidden = false
    }
    
    func changeCharacterImage(_ working: Bool) {
        if working {
            characterImage.image = UIImage(named: "takeyourtime-char2.png")
        } else {
            characterImage.image = UIImage(named: "takeyourtime-char3.png")
        }
    }
    
    func changePausedButton(_ paused : Bool) {
        if paused {
            timecountPlay.setImage(UIImage(named: "play-30.png"), for: .normal)
            ///timecountPlay.imageView?.image = UIImage(named: "play-30.png")
        } else {
            timecountPlay.setImage(UIImage(named: "pause-30.png"), for: .normal)
            ///timecountPlay.imageView?.image = UIImage(named: "pause-30.png")
        }
    }

    
    func updateProgressBar(frame num : Int, direction dir : String) {
        fullBarImage.image = UIImage(named: "bar\(num)")
        if dir != "Progressiva" {
            fullBarImage.image = fullBarImage.image?.withHorizontallyFlippedOrientation()
        }
    }
    
}
