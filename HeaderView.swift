//
//  HeaderView.swift
//  imdbClient
//
//  Created by TONY on 18/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    private var headerTitleLabel: UILabel!
    var yearTextField: UITextField!
    var pageTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        
        headerTitleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 60, height: 30))
        headerTitleLabel.text = "Filter"
        self.addSubview(headerTitleLabel)
        
        yearTextField = UITextField(frame: CGRect(x: frame.width - 70, y: 0, width: 60, height: 30))
        yearTextField.backgroundColor = .yellow
        yearTextField.textAlignment = .center
        yearTextField.placeholder = "Year"
        yearTextField.keyboardType = .numberPad
        self.addSubview(yearTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
