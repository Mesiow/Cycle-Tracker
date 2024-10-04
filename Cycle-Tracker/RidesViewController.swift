//
//  RidesViewController.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/4/24.
//

import UIKit

class RidesViewController: UIViewController {
    
    var ridesTableView = UITableView();
    var titleLabelView = UILabel();
    var ridesImageView = UIImageView();
    var startButton = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground;

        ridesTableView.delegate = self;
        ridesTableView.dataSource = self;
        
        configUI();
    }
    
    
    
    
    func configUI(){
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
        ridesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RideCell"); //register a default cell for use
        
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
        NSLayoutConstraint.activate([
            ridesImageView.widthAnchor.constraint(equalToConstant: 30),
            ridesImageView.heightAnchor.constraint(equalToConstant: 20),
            ridesImageView.leadingAnchor.constraint(equalTo: titleLabelView.trailingAnchor, constant: 5),
            ridesImageView.bottomAnchor.constraint(equalTo: ridesTableView.topAnchor, constant: -30)
        ])
        
        //Configure button below table view
        
        var config = startButton.configuration;
        config = .tinted();
        config?.title = "Start New Ride";
        config?.titleAlignment = .center;
        config?.baseBackgroundColor = .systemGreen;
        config?.baseForegroundColor = .systemGreen;
        config?.cornerStyle = .medium;
        
        startButton.configuration = config;
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 260),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.centerXAnchor.constraint(equalTo: ridesTableView.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: ridesTableView.bottomAnchor, constant: 20)
        ])
    }
}

//Table View
extension RidesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ridesTableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath);
        var config = cell.defaultContentConfiguration();
        config.text = "Ride #\(indexPath.row)";
        cell.contentConfiguration = config;
        
        return cell;
    }
}
