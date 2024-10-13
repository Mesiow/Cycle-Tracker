//
//  RidesViewController.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/4/24.
//

import UIKit
import CoreData

class RidesViewController: UIViewController {
    
    //core data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    var firstLoad : Bool = true;
    var rides: [Ride] = [];
   
    var ridesTableView = UITableView();
    var titleLabelView = UILabel();
    var ridesImageView = UIImageView();
    var startButton = CTButton(color: .systemGreen, title: "Start New Ride");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Core data
        if(firstLoad){
            firstLoad = false;
            fetchRideData();
        }
        
        ridesTableView.delegate = self;
        ridesTableView.dataSource = self;
        ridesTableView.allowsSelection = false;
        
        configUI();
    }
    
    private func fetchRideData(with request: NSFetchRequest<Ride> = Ride.fetchRequest()){
        do {
            rides = try context.fetch(request);
            if(rides.count <= 0){
                print("no rides available");
            }
        }catch{
            print("Error loading rides from core data \(error)");
        }
        ridesTableView.reloadData();
    }
    
    @objc func startButtonPressed(){
        let goalVC = SetRideGoalVC();
        present(goalVC, animated: true);
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
        ridesImageView.tintColor = .systemGreen;
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
        return 15;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ridesTableView.dequeueReusableCell(withIdentifier: Constants.ridesCellIdentifier, for: indexPath);
        
        return cell;
    }
}
