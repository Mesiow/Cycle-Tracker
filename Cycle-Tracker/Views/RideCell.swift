//
//  RideCell.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/9/24.
//

import UIKit

class RideCell : UITableViewCell {
    var timeLabel = CTLabel(color: .label, text: "", font: .systemFont(ofSize: 15, weight: .semibold));
    var distanceLabel = CTLabel(color: .label, text: "", font: .systemFont(ofSize: 15, weight: .semibold));
    var dateLabel = CTLabel(color: .label, text: "", font: .systemFont(ofSize: 20, weight: .bold));
    var caloriesLabel = CTLabel(color: .label, text: "", font: .systemFont(ofSize: 15, weight: .semibold));
    var mapImage = UIImageView();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        
        accessoryType = .disclosureIndicator;
        
        layoutUI();
    }
    
    private func layoutUI(){
        contentView.addSubview(timeLabel);
        contentView.addSubview(distanceLabel);
        contentView.addSubview(dateLabel);
        contentView.addSubview(caloriesLabel);
        contentView.addSubview(mapImage);
        
        mapImage.image = UIImage(systemName: "map.fill");
        mapImage.frame = CGRect(x: 0, y: 0, width: 30, height: 25);
        mapImage.translatesAutoresizingMaskIntoConstraints = false;
        
        
        //Constraints
        
        //Map
        NSLayoutConstraint.activate([
            mapImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mapImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        //Time
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        //Distance
        NSLayoutConstraint.activate([
            distanceLabel.trailingAnchor.constraint(equalTo: mapImage.trailingAnchor, constant: -100),
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
