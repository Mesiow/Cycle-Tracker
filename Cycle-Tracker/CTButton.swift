//
//  CTButton.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/5/24.
//

import UIKit

//Generic tinted button
class CTButton : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(color: UIColor, title: String){
        super.init(frame: .zero);
        
        configuration = .tinted();
        configuration?.title = title;
        configuration?.titleAlignment = .center;
        configuration?.baseBackgroundColor = color;
        configuration?.baseForegroundColor = color;
        configuration?.cornerStyle = .medium;
        
        translatesAutoresizingMaskIntoConstraints = false;
        
        //set default width/height
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 260),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//For button dropdown menus
class CTButtonMenu : UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(color: UIColor, title: String){
        super.init(frame: .zero);
        
        configuration = .filled();
        configuration?.title = title;
        configuration?.titleAlignment = .leading
        configuration?.baseBackgroundColor = color;
        configuration?.baseForegroundColor = .white;
        configuration?.cornerStyle = .medium;
        
        configuration?.image = UIImage(systemName: Constants.arrowDownSystemImage);
        configuration?.imagePadding = 10;
        configuration?.imagePlacement = .trailing;
        
        //quick hacky way to give a little bit more space between button and drop down menu
        //configuration?.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 45, trailing: 0)
        
        translatesAutoresizingMaskIntoConstraints = false;
        showsMenuAsPrimaryAction = true; //allows menu to popup
        
        //set default width/height
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 130),
            heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
