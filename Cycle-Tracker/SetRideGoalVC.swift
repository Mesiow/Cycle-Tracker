//
//  SetRideGoalVC.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/5/24.
//

import UIKit

class SetRideGoalVC: UIViewController {

    var goButton = CTButton(color: .systemGreen, title: "Go!");
    var distanceMenuButton = CTButtonMenu(color: .systemBlue, title: "Distance");
    var timeMenuButton = CTButtonMenu(color: .systemBlue, title: "Time");
    var caloriesMenuButton = CTButtonMenu(color: .systemBlue, title: "Calories");
    var goalLabel = UILabel();
    
    var distances = [
        3, 5, 10
    ]
    var times = [
        10, 20, 30
    ]
    var cals = [
        100, 200, 300
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground;
        
        configUI();
        configDropDownButtons();
        configLabel();
    }
    
    func configUI(){
        view.addSubview(goButton);
      
        NSLayoutConstraint.activate([
            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
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
            }), at: i)
        }
        distanceMenuButton.menu = UIMenu(title: "Your Options...", children: distanceActions)
        
        //Time Menu Button
        var timeActions: [UIAction] = []
        for i in 0..<times.count {
            timeActions.insert(UIAction(title: "\(self.times[i]) Min", handler: { (action) in
                self.timeMenuButton.setText(title: "\(self.times[i]) Min")
            }), at: i)
        }
        timeMenuButton.menu = UIMenu(title: "Your Options...", children: timeActions)
        
        //Calories Menu Button
        var calsActions: [UIAction] = [];
        for i in 0..<cals.count {
            calsActions.insert(UIAction(title: "\(self.cals[i]) Cals", handler: { (action) in
                self.caloriesMenuButton.setText(title: "\(self.cals[i]) Cals")
            }), at: i)
        }
        caloriesMenuButton.menu = UIMenu(title: "Your Options", children: calsActions)
    }
}
