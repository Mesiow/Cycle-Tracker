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
    
    var stopButton = CTButton(color: .systemRed, title: "Stop");
    var pauseButton = CTButton(color: .systemYellow, title: "Pause");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        
        //request user permission to use location services while the app is in use
        locManager.requestWhenInUseAuthorization();
        locManager.delegate = self;
        
        configUI();
    }
    
    func configUI(){
        view.addSubview(stopButton);
        view.addSubview(pauseButton);
        
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 160),
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stopButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
        ])
        
        NSLayoutConstraint.activate([
            pauseButton.widthAnchor.constraint(equalToConstant: 160),
            pauseButton.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor),
            pauseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
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
