//
//  RidesViewController.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/4/24.
//

import UIKit
import CoreData

class RidesViewController: UIViewController {
    let defaults = UserDefaults.standard;
    
    var firstLoad : Bool = true;
    var rides: [Ride] = [];
    var noDataViewEnabled : Bool = true;
   
    var ridesTableView = UITableView();
    var titleLabelView = UILabel();
    var ridesImageView = UIImageView();
    var noDataView = UIView();
    var noDataLabelView = CTLabel(color: .white, text: "No Rides Yet", font: .systemFont(ofSize: 40, weight: .regular));
    var noDataImageView = UIImageView();
    var startButton = CTButton(color: .systemGreen, title: "Start New Ride");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI();
        
        //Core data load
        if(firstLoad){
            firstLoad = false;
            fetchRideData();
        }

        ridesTableView.delegate = self;
        ridesTableView.dataSource = self;
        ridesTableView.allowsSelection = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);

    }
    
    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated);
        
        if !firstLoad {
            //refresh data and table
            reloadRideData();
            ridesTableView.reloadData();
        }
    }
    
    
    @objc func startButtonPressed(){
        //check user defaults if there is already weight data stored
        let weight = defaults.object(forKey: "Weight");
        if weight == nil{
            //ask user for weight (to be able to calculate calories burned
            presentWeightAlert();
        }else{
            //weight already saved so continue
            presentNextView();
        }
    }
    
    func presentNextView(){
        let goalVC = SetRideGoalVC();
        present(goalVC, animated: true);
    }
    
    func presentWeightAlert(){
        let alert = UIAlertController(title: "Please enter your weight", message: "Weight in lbs", preferredStyle: .alert);
        
        alert.addTextField(configurationHandler: { textField in
            textField.keyboardType = .numberPad;
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .default, handler: { _ in
            let weight = Float(alert.textFields![0].text!);
            
            //save weight to user defaults
            self.defaults.set(weight, forKey: "Weight");
            
            //continue and present the next view
            self.presentNextView();
        }));
        
       
        self.present(alert, animated: true);
    }
    
    func presentNoDataView(){
        noDataViewEnabled = true;
        
        view.addSubview(noDataView);
        noDataView.addSubview(noDataImageView);
        noDataView.addSubview(noDataLabelView);
        
        noDataView.translatesAutoresizingMaskIntoConstraints = false;
        noDataImageView.translatesAutoresizingMaskIntoConstraints = false;
        noDataLabelView.translatesAutoresizingMaskIntoConstraints = false;
        
        noDataView.backgroundColor = UIColor(named: "BlueAdaptive");
        noDataView.layer.cornerRadius = 10;
        
        NSLayoutConstraint.activate([
            noDataView.widthAnchor.constraint(equalTo: view.widthAnchor),
            noDataView.heightAnchor.constraint(equalTo: ridesTableView.heightAnchor),
            noDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        noDataImageView.image = UIImage(systemName: "widget.extralarge");
        noDataImageView.tintColor = .white;
        NSLayoutConstraint.activate([
            noDataImageView.widthAnchor.constraint(equalToConstant: 120),
            noDataImageView.heightAnchor.constraint(equalToConstant: 80),
            noDataImageView.centerXAnchor.constraint(equalTo: noDataView.centerXAnchor),
            noDataImageView.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            noDataLabelView.topAnchor.constraint(equalTo: noDataImageView.bottomAnchor, constant: 10),
            noDataLabelView.centerXAnchor.constraint(equalTo: noDataImageView.centerXAnchor)
        ])
    }
    
    func disableNoDataView(){
        noDataViewEnabled = false;
        
        noDataLabelView.removeFromSuperview();
        noDataImageView.removeFromSuperview();
        noDataView.removeFromSuperview();
    }
    
    
    private func configUI(){
        view.backgroundColor = .systemBackground;
        
        //add subviews
        view.addSubview(ridesTableView); //necessary to see this view on screen
        view.addSubview(titleLabelView);
        view.addSubview(ridesImageView);
        view.addSubview(startButton);
        
        //enable autolayout to affect all UI elements
        ridesTableView.translatesAutoresizingMaskIntoConstraints = false;
        titleLabelView.translatesAutoresizingMaskIntoConstraints = false;
        ridesImageView.translatesAutoresizingMaskIntoConstraints = false;
        startButton.translatesAutoresizingMaskIntoConstraints = false;
        
        //configure table view
        ridesTableView.register(RideCell.self, forCellReuseIdentifier: Constants.ridesCellIdentifier); //register a default cell for use
        
        //Table view constraints
        NSLayoutConstraint.activate([
            ridesTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ridesTableView.heightAnchor.constraint(equalToConstant: 500),
            ridesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ridesTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        //Configure title
        titleLabelView.text = "Rides";
        titleLabelView.font = .systemFont(ofSize: 40, weight: .bold);
        titleLabelView.textAlignment = .left;
        
        //Title Label Constraints
        NSLayoutConstraint.activate([
            titleLabelView.bottomAnchor.constraint(equalTo: ridesTableView.topAnchor, constant: -20),
            titleLabelView.leadingAnchor.constraint(equalTo: ridesTableView.leadingAnchor, constant: 20),
        ])
        
        //Configure constraints for simple system image
        ridesImageView.image = UIImage(systemName: "bicycle");
        ridesImageView.tintColor = .systemBlue;
        NSLayoutConstraint.activate([
            ridesImageView.widthAnchor.constraint(equalToConstant: 30),
            ridesImageView.heightAnchor.constraint(equalToConstant: 22),
            ridesImageView.leadingAnchor.constraint(equalTo: titleLabelView.trailingAnchor, constant: 5),
            ridesImageView.bottomAnchor.constraint(equalTo: ridesTableView.topAnchor, constant: -30)
        ])
        
        //Configure button below table view
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside); //add callback function to fire when button is pressed
        
        NSLayoutConstraint.activate([
            //width/height constraints already set in CTButton class by default
            startButton.centerXAnchor.constraint(equalTo: ridesTableView.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: ridesTableView.bottomAnchor, constant: 20)
        ])
    }
}

//Table View
extension RidesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ridesTableView.dequeueReusableCell(withIdentifier: Constants.ridesCellIdentifier, for: indexPath) as! RideCell;
        
        let ride = rides[indexPath.row];
        
        let time = secondsToHoursMinutesSeconds(ride.seconds);
        let timeText = createTimeLabel(hours: time.hours, min: time.min, sec: time.sec);
        cell.timeLabel.text = timeText
        
        let distFormat = String(format: "%.1f", ride.distance);
        cell.distanceLabel.text = "\(distFormat) Miles";
        
        cell.dateLabel.text = ride.date;
        cell.caloriesLabel.text = "\(ride.calories) Cals";
        
        return cell;
    }
}
