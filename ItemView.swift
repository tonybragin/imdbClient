//
//  ItemViewController.swift
//  imdbClient
//
//  Created by TONY on 17/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class ItemView: UIView {
    
    var posterImage: UIImageView!
    var titleLabel: UILabel!
    var topInfoLabel: UILabel!
    var ratingLabel: UILabel!
    var otherInfoLabel: UILabel!
    
    let lineSize = 25
    var contentHeight: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        posterImage = UIImageView(frame: CGRect(x: frame.midX - 120, y: 10, width: 240, height: 360))
        posterImage.backgroundColor = .black
        self.addSubview(posterImage)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: Int(posterImage.frame.maxY + 10), width: Int(frame.width - 20), height: lineSize*3))
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 2
        titleLabel.text = "Title"
        self.addSubview(titleLabel)
        
        topInfoLabel = UILabel(frame: CGRect(x: 10, y: Int(titleLabel.frame.maxY + 10), width: Int(frame.width - 20), height: lineSize*2))
        topInfoLabel.numberOfLines = 2
        topInfoLabel.text = "Year, Runtime, Genre"
        self.addSubview(topInfoLabel)
        
        ratingLabel = UILabel(frame: CGRect(x: 10, y: Int(topInfoLabel.frame.maxY + 10), width: Int(frame.width - 20), height: lineSize*5))
        ratingLabel.numberOfLines = 5
        ratingLabel.text = "Ratings"
        self.addSubview(ratingLabel)
        
        otherInfoLabel = UILabel(frame: CGRect(x: 10, y: Int(ratingLabel.frame.maxY - 90), width: Int(frame.width - 20), height: lineSize*20))
        otherInfoLabel.numberOfLines = 20
        otherInfoLabel.text = "Released, Rated, Plot, Actors, Director, Writer"
        self.addSubview(otherInfoLabel)
        
        contentHeight = otherInfoLabel.frame.maxY + 10
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
