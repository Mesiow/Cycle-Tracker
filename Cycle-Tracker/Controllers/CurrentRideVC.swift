//
//  CurrentRideVC.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/6/24.
//

import UIKit
import CoreLocation

class CurrentRideVC: UIViewController {

    let locManager = CLLocationManager();
    var distanceTraveled = 0.0;
    
    var infoView = UIView(); //view that holds all the tracking info
    var distBackgroundView = UIView();
    
    var distanceTitleLabel = CTLabel(color: .white, text: "Distance", font: .systemFont(ofSize: 40, weight: .semibold));
    var distanceLabel = CTLabel(color: .white, text: "0 Miles", font: .systemFont(ofSize: 25, weight: .medium));
    
    var timeTitleLabel = CTLabel(color: .white, text: "Time", font: .systemFont(ofSize: 30, weight: .semibold));
    var timeLabel = CTLabel(color: .white, text: "0:00 Min", font: .systemFont(ofSize: 20, weight: .medium));
    
    var altitudeTitleLabel = CTLabel(color: .white, text: "Altitude", font: .systemFont(ofSize: 30, weight: .semibold));
    var altituteLabel = CTLabel(color: .white, text: "0 ft", font: .systemFont(ofSize: 20, weight: .medium));
    
    var caloriesTitleLabel = CTLabel(color: .white, text: "Calories", font: .systemFont(ofSize: 30, weight: .semibold));
    var caloriesLabel = CTLabel(color: .white, text: "0 Cals", font: .systemFont(ofSize: 20, weight: .medium));
    
    var speedTitleLabel = CTLabel(color: .white, text: "Speed", font: .systemFont(ofSize: 30, weight: .semibold));
    var speedLabel = CTLabel(color: .white, text: "0 Mph", font: .systemFont(ofSize: 20, weight: .medium));
    
    var stopButton = CTButton(color: .systemRed, title: "Stop");
    var pauseButton = CTButton(color: .systemYellow, title: "Pause");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        
        //request user permission to use location services while the app is in use
        locManager.requestWhenInUseAuthorization();
        locManager.delegate = self;
        
        configUI();
        configUILabels();
    }
    
    func configUI(){
        view.addSubview(infoView);
        view.addSubview(distBackgroundView);
        view.addSubview(stopButton);
        view.addSubview(pauseButton);
        
        distBackgroundView.translatesAutoresizingMaskIntoConstraints = false;
        distBackgroundView.backgroundColor = UIColor.init(named: "BlueAdaptive");
        distBackgroundView.layer.cornerRadius = 10.0;
        
        infoView.translatesAutoresizingMaskIntoConstraints = false;
        infoView.backgroundColor = UIColor.init(named: "BlueAdaptive");
        infoView.layer.cornerRadius = 10.0;
        
        stopButton.disableTint();
        pauseButton.disableTint();
        
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20),
            infoView.heightAnchor.constraint(equalToConstant: 320),
            infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
        ])
        
        //Constrain relative to info view
        NSLayoutConstraint.activate([
            distBackgroundView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -50),
            distBackgroundView.heightAnchor.constraint(equalToConstant: 150),
            distBackgroundView.centerXAnchor.constraint(equalTo: infoView.centerXAnchor),
            distBackgroundView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -10)
        ])
        
        //Constrain buttons
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 160),
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
        ])
        
        NSLayoutConstraint.activate([
            pauseButton.widthAnchor.constraint(equalToConstant: 160),
            pauseButton.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
        ])
    }
    
    func configUILabels(){
        distBackgroundView.addSubview(distanceTitleLabel);
        distBackgroundView.addSubview(distanceLabel);
       
        //These labels will be inside the info view
        infoView.addSubview(timeTitleLabel);
        infoView.addSubview(timeLabel);
        infoView.addSubview(timeTitleLabel);
        infoView.addSubview(timeLabel);
        infoView.addSubview(altitudeTitleLabel);
        infoView.addSubview(altituteLabel);
        infoView.addSubview(caloriesTitleLabel);
        infoView.addSubview(caloriesLabel);
        infoView.addSubview(speedTitleLabel);
        infoView.addSubview(speedLabel);
        
        //Distance labels
        distanceTitleLabel.addUnderline();
        //Constrain relative to distBackgroundView
        NSLayoutConstraint.activate([
            distanceTitleLabel.centerYAnchor.constraint(equalTo: distBackgroundView.centerYAnchor, constant: -10),
            distanceTitleLabel.centerXAnchor.constraint(equalTo: distBackgroundView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: distanceTitleLabel.bottomAnchor, constant: 10),
            distanceLabel.centerXAnchor.constraint(equalTo: distanceTitleLabel.centerXAnchor)
        ])
        
        //Time labels
        timeTitleLabel.addUnderline();
        NSLayoutConstraint.activate([
            timeTitleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
            timeTitleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: timeTitleLabel.bottomAnchor, constant: 10),
            timeLabel.centerXAnchor.constraint(equalTo: timeTitleLabel.centerXAnchor)
        ])
        
        //Altitude labels
        altitudeTitleLabel.addUnderline();
        NSLayoutConstraint.activate([
            altitudeTitleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 10),
            altitudeTitleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            altituteLabel.topAnchor.constraint(equalTo: altitudeTitleLabel.bottomAnchor, constant: 10),
            altituteLabel.centerXAnchor.constraint(equalTo: altitudeTitleLabel.centerXAnchor)
        ])
        
        //Calories labels
        caloriesTitleLabel.addUnderline();
        NSLayoutConstraint.activate([
            caloriesTitleLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -50),
            caloriesTitleLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            caloriesLabel.topAnchor.constraint(equalTo: caloriesTitleLabel.bottomAnchor, constant: 10),
            caloriesLabel.centerXAnchor.constraint(equalTo: caloriesTitleLabel.centerXAnchor)
        ])
        
        //Speed labels
        speedTitleLabel.addUnderline();
        NSLayoutConstraint.activate([
            speedTitleLabel.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -50),
            speedTitleLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            speedLabel.topAnchor.constraint(equalTo: speedTitleLabel.bottomAnchor, constant: 10),
            speedLabel.centerXAnchor.constraint(equalTo: speedTitleLabel.centerXAnchor)
        ])
    }
}

extension CurrentRideVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {
            print("Location Authorized")
        }
    }
}
