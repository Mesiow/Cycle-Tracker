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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground;
        
        configUI();
        configDropDownButtons();
    }
    
    func configUI(){
        view.addSubview(goButton);
      
        NSLayoutConstraint.activate([
            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
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
        
        //Button Menu Setup
        distanceMenuButton.menu = UIMenu(title: "Your options...", children: [
            UIAction(title: "3 Miles", handler: { (action) in
                print("Option 1 was selected")
            }), UIAction(title: "5 Miles", handler: { (action) in
                print("Option 2 was selected")
            }), UIAction(title: "10 Miles", handler: { (action) in
                print("Option 3 was selected")
            })])
        
        timeMenuButton.menu = UIMenu(title: "Your options...", children: [
            UIAction(title: "10 Min", handler: { (action) in
                print("Option 1 was selected")
            }), UIAction(title: "20 Min", handler: { (action) in
                print("Option 2 was selected")
            }), UIAction(title: "30 Min", handler: { (action) in
                print("Option 3 was selected")
            })])
        
        caloriesMenuButton.menu = UIMenu(title: "Your options...", children: [
            UIAction(title: "100 Calories", handler: { (action) in
                print("Option 1 was selected")
            }), UIAction(title: "200 Calories", handler: { (action) in
                print("Option 2 was selected")
            }), UIAction(title: "300 Calories", handler: { (action) in
                print("Option 3 was selected")
            })])
    }
}
