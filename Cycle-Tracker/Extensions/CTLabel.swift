//
//  CTLabel.swift
//  Cycle-Tracker
//
//  Created by Chris W on 10/7/24.
//

import UIKit


class CTLabel : UILabel {
    /*var hasUnderline : Bool {
        set(value){
            self.hasUnderline = value;
            if value{
                addUnderline();
            }
        }
        get{
            return self.hasUnderline;
        }
    }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(color: UIColor, text: String, font: UIFont){
        super.init(frame: .zero);
        
        translatesAutoresizingMaskIntoConstraints = false;
        
        self.text = text;
        textColor = color;
        self.font = font;
        textAlignment = .center;
    }
    
    func addUnderline(){
        //Add underline to label text
        let textRange = NSRange(location: 0, length: self.text!.count)
        let attributedText = NSMutableAttributedString(string: self.text!);
        attributedText.addAttribute(.underlineStyle,
                                            value: NSUnderlineStyle.single.rawValue,
                                            range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
