//
//  ItemViewController.swift
//  imdbClient
//
//  Created by TONY on 17/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit
import Kingfisher

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    private var itemView: ItemView!
    
    var imdbID: String!
    var item: Item! {
        didSet {
            DispatchQueue.main.async {
                self.setUpItemView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setUpItem()
    }
    
    private func setUpItem() {
        let request = imdbRequest(id: imdbID)
        request.makeRequestForItem { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .failure(let error):
                strongSelf.errorHandler(error: error)
            case .success(let gotItem):
                strongSelf.item = gotItem
            }
            
        }
    }
    
    private func setUpItemView() {
        itemView = ItemView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1300))
        
        let url = URL(string: item.Poster)
        itemView.posterImage.kf.setImage(with: url)
            
        itemView.titleLabel.text = item.Title
            
        itemView.topInfoLabel.text = "Year: " + item.Year + ", Runtime: " + item.Runtime + "\nGenre: " + item.Genre
            
        var ratingString = "Ratings:\n"
        for i in 0..<item.Ratings.count {
            ratingString += "\(item.Ratings[i].Source): \(item.Ratings[i].Value)\n"
        }
        itemView.ratingLabel.text = ratingString
            
        itemView.otherInfoLabel.text = "Released: " + item.Released + "\nRated: " + item.Rated + "\n\nPlot: " + item.Plot + "\n\nActors: " + item.Actors + "\n\nDirector: " + item.Director + "\nWriter: " + item.Writer
        
        scrollView.contentInset = .init(top: 0, left: 0, bottom: itemView.contentHeight, right: 0)
        scrollView.addSubview(itemView)
    }
    
}
