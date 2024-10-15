//
//  SetRideGoalVC.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/5/24.
//

import UIKit


struct Goal{
    enum GoalType {
        case distance
        case time
        case cals
    }
    var type: GoalType
    var value: Int
}

class SetRideGoalVC: UIViewController {

    var goButton = CTButton(color: .systemGreen, title: "Go!");
    var distanceMenuButton = CTButtonMenu(color: .systemBlue, title: "Distance");
    var timeMenuButton = CTButtonMenu(color: .systemBlue, title: "Time");
    var caloriesMenuButton = CTButtonMenu(color: .systemBlue, title: "Calories");
    var goalLabel = UILabel();
    
    var goal : Goal!
    var distances = [
        3, 5, 10, 15
    ]
    var times = [
        1, 20, 30, 40
    ]
    var cals = [
        100, 200, 300, 400
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground;
        
        configUI();
        configDropDownButtons();
        configLabel();
    }
    
    @objc func goButtonPressed(){
        let vc = CurrentRideVC();
        vc.goal = self.goal;
        vc.modalPresentationStyle = .fullScreen;
        
        present(vc, animated: true);
    }
    
    func configUI(){
        view.addSubview(goButton);
      
        NSLayoutConstraint.activate([
            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside);
    }
    
    func configLabel(){
        view.addSubview(goalLabel);
        goalLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        goalLabel.text = "Goals";
        goalLabel.textAlignment = .left;
        goalLabel.font = .systemFont(ofSize: 40, weight: .bold);
        
        //Constraints
        NSLayoutConstraint.activate([
            goalLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            goalLabel.leadingAnchor.constraint(equalTo: goButton.leadingAnchor, constant: -25),
            goalLabel.trailingAnchor.constraint(equalTo: goButton.trailingAnchor)
        ])
    }
    
    func configDropDownButtons(){
        view.addSubview(distanceMenuButton);
        view.addSubview(timeMenuButton);
        view.addSubview(caloriesMenuButton);
    
        NSLayoutConstraint.activate([
            distanceMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            distanceMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeMenuButton.topAnchor.constraint(equalTo: distanceMenuButton.bottomAnchor, constant: 100),
            timeMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            caloriesMenuButton.topAnchor.constraint(equalTo: timeMenuButton.bottomAnchor, constant: 100),
            caloriesMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //Button Menu Action Setup
        configDropDownMenuActions();
    }
    
    func configDropDownMenuActions(){
        //Distance Menu Button
        var distanceActions: [UIAction] = []
        for i in 0..<distances.count {
            distanceActions.insert(UIAction(title: "\(self.distances[i]) Miles", handler: { (action) in
                self.distanceMenuButton.setText(title: "\(self.distances[i]) Miles")
                self.clearButtonMenusExcept(button: self.distanceMenuButton);
                
                self.goal = Goal(type: Goal.GoalType.distance, value: self.distances[i]);
            }), at: i)
        }
        distanceMenuButton.menu = UIMenu(title: "Your Options...", children: distanceActions)
        
        //Time Menu Button
        var timeActions: [UIAction] = []
        for i in 0..<times.count {
            timeActions.insert(UIAction(title: "\(self.times[i]) Min", handler: { (action) in
                self.timeMenuButton.setText(title: "\(self.times[i]) Min")
                self.clearButtonMenusExcept(button: self.timeMenuButton);
                
                self.goal = Goal(type: Goal.GoalType.time, value: self.times[i]);
            }), at: i)
        }
        timeMenuButton.menu = UIMenu(title: "Your Options...", children: timeActions)
        
        //Calories Menu Button
        var calsActions: [UIAction] = [];
        for i in 0..<cals.count {
            calsActions.insert(UIAction(title: "\(self.cals[i]) Cals", handler: { (action) in
                self.caloriesMenuButton.setText(title: "\(self.cals[i]) Cals")
                self.clearButtonMenusExcept(button: self.caloriesMenuButton);
                
                self.goal = Goal(type: Goal.GoalType.cals, value: self.cals[i]);
            }), at: i)
        }
        caloriesMenuButton.menu = UIMenu(title: "Your Options", children: calsActions)
    }
    
    func clearButtonMenusExcept(button: CTButtonMenu){
        if distanceMenuButton != button {
            distanceMenuButton.setText(title: "Distance");
        }
        if timeMenuButton != button {
            timeMenuButton.setText(title: "Time");
        }
        if(caloriesMenuButton != button){
            caloriesMenuButton.setText(title: "Calories");
        }
    }
}
