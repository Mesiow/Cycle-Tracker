//
//  RideCell.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/9/24.
//

import UIKit

class RideCell : UITableViewCell {
    var title = CTLabel(color: .label, text: "Ride", font: .systemFont(ofSize: 25, weight: .semibold));
    var timeLabel = CTLabel(color: .label, text: "Time: ", font: .systemFont(ofSize: 15, weight: .medium));
    var distanceLabel = CTLabel(color: .label, text: "Distance: ", font: .systemFont(ofSize: 15, weight: .medium));
    var dateLabel = CTLabel(color: .label, text: "Date: ", font: .systemFont(ofSize: 15, weight: .medium));
    var caloriesLabel = CTLabel(color: .label, text: "Calories: ", font: .systemFont(ofSize: 15, weight: .medium));
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        layoutUI();
    }
    
    private func layoutUI(){
        contentView.addSubview(title);
        contentView.addSubview(timeLabel);
        contentView.addSubview(distanceLabel);
        contentView.addSubview(dateLabel);
        contentView.addSubview(caloriesLabel);
        
        //Constraints
        
        //Title
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
        ])
        
        //Time
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        //Distance
        NSLayoutConstraint.activate([
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            distanceLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor)
        ])
        
        //Date
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: distanceLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: -10)
        ])
        
        //Calories
        NSLayoutConstraint.activate([
            caloriesLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            caloriesLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -10)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
