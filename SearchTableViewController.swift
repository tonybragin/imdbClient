//
//  SearchTableViewController.swift
//  imdbClient
//
//  Created by TONY on 16/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchList = [SearchItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var searchYear: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        
        headerView.yearTextField.delegate = self
        headerView.yearTextField.inputAccessoryView = setUpDoneButton()
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchItemCell", for: indexPath) as! SearchItemCell
        
        cell.titleLabel.text = searchList[indexPath.row].Title
        cell.yearLabel.text = searchList[indexPath.row].Year
        
        let url = URL(string: searchList[indexPath.row].Poster)
        cell.posterImage.kf.setImage(with: url)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SearchToItem", sender: searchList[indexPath.row].imdbID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ScrollViewController else {return}
        guard let id = sender as? String else {return}
        controller.imdbID = id
    }
    
    func makeRequest() {
        guard let searchBarText = searchBar.text else {return}
        
        let request = imdbRequest(title: searchBarText, year: searchYear)
        request.makeRequestForSearch { [weak self] result in
            guard let strongSelf = self else {return}
            switch result {
            case .failure(let error):
                strongSelf.errorHandler(error: error)
            case .success(let searchItems):
                strongSelf.searchList = searchItems
            }
        }
    }
}

extension SearchTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            searchYear = nil
            return
        }
        guard let year = Int(text) else {
            searchYear = nil
            return
        }
        guard year > 0 else {
            searchYear = nil
            return
        }
        
        searchYear = year
        makeRequest()
    }
    
    func setUpDoneButton() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: true)
        
        return toolBar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        makeRequest()
    }
}

extension UIViewController {
    
    func errorHandler(error: imdbError) {
        switch error {
        case .dataError:
            self.alert(title: "Error", message: "Lost Internet connection")
        case .jsonError:
            self.alert(title: "Error", message: "Database Error")
        }
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}
