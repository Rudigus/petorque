//
//  WorkViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController, TimerDelegate {
    
    @IBOutlet var currentTaskLabel: UILabel!
    
    @IBOutlet var nextTask: UIButton!
    
    @IBOutlet var previousTask: UIButton!
    
    @IBOutlet var startTask: UIButton!
    
    @IBOutlet var finishTask: UIButton!
    
    @IBOutlet var timecountLabel: UILabel!
    
    @IBOutlet var timecountPlay: UIButton!
    
    var flagForAnimation: Bool?
    
    @IBAction func timecountToggle(_ sender: UIButton) {
        taskTimer?.pauseTimer()
        guard flagForAnimation != nil else {
            flagForAnimation = true
            stopAnimationForView(arco)
            stopAnimationForView(pontoDoArco)
            return
        }
        if flagForAnimation! {
            rotateProgressBar()
        } else {
            stopAnimationForView(arco)
            stopAnimationForView(pontoDoArco)
        }
        flagForAnimation!.toggle()
    }
    
    var taskTimer : TimerModel?
    
    var currentTask : Int = 0
    
    @IBOutlet var characterImage: UIImageView!
    
    @IBOutlet weak var pontoDoArco: UIImageView!
    
    @IBOutlet weak var arco: UIImageView!
    @IBOutlet weak var arcoTracejado: UIImageView!
    
    @IBAction func startCurrentTask(_ sender: UIButton) {
        
        //usado muitas vezes
        let allTasks = Database.shared.loadData(from: .doing)
        let doingTasks = allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })
        
        nextTask.isHidden = true
        previousTask.isHidden = true
        startTask.isHidden = true
        finishTask.isHidden = false
        timecountLabel.isHidden = false
        timecountPlay.isHidden = false
        
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
        arcoTracejado.isHidden = false
        arco.isHidden = false
        pontoDoArco.isHidden = false
        rotateProgressBar()
    }
    
    @IBAction func finishCurrentTask(_ sender: UIButton) {
        finishedTask()
    }
    
    @IBAction func changeTask(_ sender: UIButton) {
        let senderName = sender.titleLabel?.text ?? "None"
   
        //usado muitas vezes
        let allTasks = Database.shared.loadData(from: .doing)
        let doingTasks = allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })
        
        if senderName == "PLOM" {
           if currentTask == doingTasks.count-1 {
               currentTask = 0
           } else {
               currentTask += 1
           }
        }

        if senderName == "PLIM" {
           if currentTask == 0 {
               currentTask = doingTasks.count-1
           } else {
               currentTask -= 1
           }
        }

        currentTaskLabel.text = doingTasks[currentTask].title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if taskTimer == nil {
            characterImage.image = UIImage(named: "takeyourtime-char1.png")
        }
        
        currentTask = 0
        //usado de novo
        let allTasks = Database.shared.loadData(from: .doing)
        let doingTasks = allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })
        
        if doingTasks.isEmpty {
            currentTaskLabel.text = "Texto placeholder"
            let alert = UIAlertController(title: "Nada por aqui!", message: "Você precisa planejar suas tarefas na Agenda antes de começar a trabalhar.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ir para Agenda", style: .default, handler: { action in
                self.tabBarController?.selectedIndex = 1
            }))

            self.present(alert, animated: true)
        } else {
            currentTaskLabel.text = doingTasks[currentTask].title
        }
        
    }
    
    func giveTimerLabel(_ timeText : String) {
        timecountLabel.text = timeText
    }
    
    func finishedTask() {
        taskTimer?.stopTimer()
        taskTimer = nil
        arcoTracejado.isHidden = true
        arco.isHidden = true
        pontoDoArco.isHidden = true
        
        characterImage.image = UIImage(named: "takeyourtime-char1.png")
        
        Database.shared.addToDone(task: Database.shared.deleteData(from: .doing, at: currentTask))
        
        //usado de novo
        let allTasks = Database.shared.loadData(from: .doing)
        
        let doingTasks = allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })
        
        print(Database.shared.loadData(from: .doing))
        
        if doingTasks.isEmpty {
            performSegue(withIdentifier: "goToFeedback", sender: nil)
        } else {
            currentTask = 0
            currentTaskLabel.text = doingTasks[0].title
        }
        
        timecountLabel.isHidden = true
        timecountPlay.isHidden = true
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
    
    func rotateProgressBar() {
        
        //usado outra vez
        let allTasks = Database.shared.loadData(from: .doing)
        
        let doingTasks = allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })
        
        arco.rotate(doingTasks[currentTask].cycleDuration)
        pontoDoArco.rotate(doingTasks[currentTask].cycleDuration)
    }
    
    func getDate(of day: TodayOrTomorrow) -> Date{
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        
        switch day {
        case .today:
            let today = DateComponents(year: now.year, month: now.month, day: now.day)
            let dateToday = Calendar.current.date(from: today)!
            
            return dateToday
            
        case .tomorrow:
            let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
            let dateTomorrow = Calendar.current.date(from: tomorrow)!
            
            return dateTomorrow
        }
    }
    
}

func stopAnimationForView(_ myView: UIView) {
    let transform = myView.layer.presentation()!.transform
    myView.layer.transform = transform
    myView.layer.removeAllAnimations()
}

extension UIView{
    func rotate(_ duration: Int) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        rotation.toValue = NSNumber(value: Double.pi)
        rotation.duration = CFTimeInterval(duration)
        rotation.isCumulative = true
        rotation.repeatCount = 1
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}


