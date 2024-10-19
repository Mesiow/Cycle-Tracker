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
    var locationAuthorized : Bool = false;
    
    var startLocation : CLLocation!
    var lastLocation : CLLocation!
    
    let defaults = UserDefaults.standard;
    var weight : Float!
    
    var baseMET = 8.0; //typical Metabolic equivalent task of cycling (10 - 12mph)
    var currMET = 8.0;
    var restingMET = 3.5;
    //(var used in calculating calories roughly burned)
    var calsPerSec : Float!
    
    var goal : Goal!
    var timer : Timer!
    var date : String!
    
    var distance: Double = 0.0;
    var seconds: Int32 = 0;
    var altitude: Float = 0;
    var calories: Float = 0;
    var speed: Float = 0.0;
    
    var paused : Bool = false;
    
    var infoView = UIView(); //view that holds all the tracking info
    var distBackgroundView = UIView();
    
    var distanceTitleLabel = CTLabel(color: .white, text: "Distance", font: .systemFont(ofSize: 40, weight: .semibold));
    var distanceLabel = CTLabel(color: .white, text: "0.000", font: .systemFont(ofSize: 30, weight: .medium));
    var distUnitLabel = CTLabel(color: .white, text: "Miles", font: .systemFont(ofSize: 30, weight: .medium));
    
    var timeTitleLabel = CTLabel(color: .white, text: "Time", font: .systemFont(ofSize: 30, weight: .semibold));
    var timeLabel = CTLabel(color: .white, text: "0:00", font: .systemFont(ofSize: 24, weight: .medium));
    
    var altitudeTitleLabel = CTLabel(color: .white, text: "Altitude", font: .systemFont(ofSize: 30, weight: .semibold));
    var altituteLabel = CTLabel(color: .white, text: "0.00", font: .systemFont(ofSize: 24, weight: .medium));
    var altitudeUnitLabel = CTLabel(color: .white, text: "ft", font: .systemFont(ofSize: 24, weight: .medium));
    
    var caloriesTitleLabel = CTLabel(color: .white, text: "Calories", font: .systemFont(ofSize: 30, weight: .semibold));
    var caloriesLabel = CTLabel(color: .white, text: "0 Cals", font: .systemFont(ofSize: 24, weight: .medium));
    
    var speedTitleLabel = CTLabel(color: .white, text: "Speed", font: .systemFont(ofSize: 30, weight: .semibold));
    var speedLabel = CTLabel(color: .white, text: "0.0", font: .systemFont(ofSize: 24, weight: .medium));
    var speedUnitLabel = CTLabel(color: .white, text: "Mph", font: .systemFont(ofSize: 24, weight: .medium));
    
    var stopButton = CTButton(color: .systemRed, title: "Stop");
    var pauseButton = CTButton(color: .systemYellow, title: "Pause");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6
        
        //request user permission to use location services while the app is in use
        locManager.requestWhenInUseAuthorization();
        locManager.delegate = self;
        
        weight = defaults.float(forKey: "Weight"); //value must exist if we are able to start a ride
        weight *= 0.453; //convert to kg for formula
        
        //base formula to determine roughly how many calories user burns per second cycling
        //on update we will update MET based on the speed we are going to determine if we are burning more calories
        let met = Float(baseMET * restingMET);
        calsPerSec = (((met * weight) / 200) / 60);
        
        configUI();
        configUILabels();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        let rootVC = self.view.window?.rootViewController;
        rootVC!.beginAppearanceTransition(true, animated: true); //safer function over calling viewWillAppear directly
    }
    
    
    func start(){
        date = Date().formatted(date: .numeric, time: .omitted);
        
        //start updating location
        locManager.startUpdatingLocation();
        locManager.allowsBackgroundLocationUpdates = true;
        locManager.distanceFilter = 1;
        
        timerStart();
    }
    
    func stop(){
        paused = true;
        timer.invalidate();
        locManager.stopUpdatingLocation();
    }
    
    func update(){
        //update labels
        updateLabels();
        
        //check if goal reached
        if goal.type == .distance{
            if (self.distance >= (Double(goal.value))) {
                presentGoalCompletedAlert();
            }
        }else if goal.type == .cals{
            if(Int32(self.calories) >= goal.value){
                presentGoalCompletedAlert();
            }
        }
        
    }
    
    private func presentGoalCompletedAlert(){
        stop();
        
        let alert = UIAlertController(title: "Goal Reached!", message: "Save Ride?", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "Default action"), style: .default, handler: { _ in
            //1. create current ride data
            let newRide = Ride(context: CoreDataContext.context);
            newRide.date = self.date;
            newRide.distance = Float(self.distance);
            newRide.seconds = self.seconds;
            newRide.calories = Int32(self.calories);
            
            //2. append new ride to our rides array in the root view controller then return to it
            if let rootVC = self.view.window?.rootViewController as? RidesViewController {
                rootVC.rides.append(newRide);
                rootVC.dismiss(animated: true);
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Exit", comment: "Default action"), style: .default, handler: {_ in
            self.view.window?.rootViewController?.dismiss(animated: true);
        }))
        
        self.present(alert, animated: true);
    }
    
    func timerStart(){
        //start timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate() {
        seconds += 1;
        
        calculateCalories();
        
        //Check if time goal reached
        if goal.type == .time{
            if(((self.seconds % 3600) / 60) >= goal.value){
                presentGoalCompletedAlert();
            }
        }
            
        //update time label
        let time = secondsToHoursMinutesSeconds(seconds);
        timeLabel.text = createTimeLabel(hours: time.hours, min: time.min, sec: time.sec);
    }
    
    func calculateCalories(){
        //Update MET based on speed
        if speed < 10 {
            currMET = 4.0;
        }
        else if speed > 10.0 && speed <= 12.0 {
            currMET = 8.0;
        }
        else if speed > 12.0 && speed <= 14.0 {
            currMET = 10.0;
        }
        else if speed > 14.0 && speed <= 16.0 {
            currMET = 12.0;
        }
        
        let updatedMET = Float(currMET * restingMET);
        
        calsPerSec = (((Float(updatedMET) * weight) / 200) / 60);
        calories += calsPerSec;
    }
    
    @objc func stopButtonPressed(){
        let alert = UIAlertController(title: "Stop Ride", message: "Are you sure you want to end your ride?", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { _ in
            //return to root view controller and update our ride data from core data if there is any
            self.view.window?.rootViewController?.dismiss(animated: true);
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default));
        
        self.present(alert, animated: true);
    }
    
    @objc func pauseButtonPressed(){
        paused.toggle();
        if paused{
            locManager.stopUpdatingLocation();
            pauseButton.setTitle("Resume", for: .normal);
            
            timer.invalidate();
        }else{
            locManager.startUpdatingLocation();
            pauseButton.setTitle("Pause", for: .normal);
            
            timerStart();
        }
    }
    
    func updateLabels(){
        if !paused{
            distanceLabel.text = String(format: "%.3f", distance);
            altituteLabel.text = String(format: "%.1f", altitude);
            speedLabel.text = String(format: "%.1f", speed);
            caloriesLabel.text = String(format: "%.1f", calories);
        }
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
        
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside);
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside);
        
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
        distBackgroundView.addSubview(distUnitLabel);
       
        //These labels will be inside the info view
        infoView.addSubview(timeTitleLabel);
        infoView.addSubview(timeLabel);
        infoView.addSubview(timeTitleLabel);
        infoView.addSubview(timeLabel);
        infoView.addSubview(altitudeTitleLabel);
        infoView.addSubview(altituteLabel);
        infoView.addSubview(altitudeUnitLabel);
        infoView.addSubview(caloriesTitleLabel);
        infoView.addSubview(caloriesLabel);
        infoView.addSubview(speedTitleLabel);
        infoView.addSubview(speedLabel);
        infoView.addSubview(speedUnitLabel);
        
        //Distance labels
        distanceTitleLabel.addUnderline();
        //Constrain relative to distBackgroundView
        NSLayoutConstraint.activate([
            distanceTitleLabel.centerYAnchor.constraint(equalTo: distBackgroundView.centerYAnchor, constant: -10),
            distanceTitleLabel.centerXAnchor.constraint(equalTo: distBackgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            distUnitLabel.topAnchor.constraint(equalTo: distanceTitleLabel.bottomAnchor, constant: 10),
            distUnitLabel.trailingAnchor.constraint(equalTo: distanceTitleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            distanceLabel.centerYAnchor.constraint(equalTo: distUnitLabel.centerYAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: distanceTitleLabel.leadingAnchor)
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
            altitudeUnitLabel.topAnchor.constraint(equalTo: altitudeTitleLabel.bottomAnchor, constant: 10),
            altitudeUnitLabel.trailingAnchor.constraint(equalTo: altitudeTitleLabel.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            altituteLabel.centerYAnchor.constraint(equalTo: altitudeUnitLabel.centerYAnchor),
            altituteLabel.trailingAnchor.constraint(equalTo: altitudeUnitLabel.leadingAnchor, constant: -5)
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
            speedUnitLabel.topAnchor.constraint(equalTo: speedTitleLabel.bottomAnchor, constant: 10),
            speedUnitLabel.trailingAnchor.constraint(equalTo: speedTitleLabel.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            speedLabel.centerYAnchor.constraint(equalTo: speedUnitLabel.centerYAnchor),
            speedLabel.trailingAnchor.constraint(equalTo: speedUnitLabel.leadingAnchor, constant: -5)
        ])
    }
}

extension CurrentRideVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse {
            locationAuthorized = true;
            start();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first;
        }
        else {
            let lastLocation = locations.last!;
            let dist = startLocation.distance(from: lastLocation);
            startLocation = lastLocation;
            
            //update traveled distance from last update to current update
            distance += dist.convert(from: .meters, to: .miles);
            
            altitude = (Float)(lastLocation.altitude.convert(from: .meters, to: .feet));
            speed = (Float)((lastLocation.speed) * 2.23694) //convert from meters/sec to mph

            update();
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error:\(error)")
    }
}
