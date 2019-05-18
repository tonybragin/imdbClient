//
//  imdb.swift
//  imdbClient
//
//  Created by TONY on 16/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import Foundation
import UIKit

struct imdb: Decodable {
    var Search: [SearchItem]
}

struct SearchItem: Decodable {
    var Title: String
    var Year: String
    var imdbID: String
    var Poster: String
}


struct Item: Decodable {
    var imdbID: String
    
    var Title: String
    var Year: String
    var Rated: String
    var Released: String
    var Runtime: String
    var Genre: String
    var Director: String
    var Writer: String
    var Actors: String
    var Plot: String
    var Poster: String
    var Ratings: [Rating]
    var DVD: String
    var BoxOffice: String
}

struct Rating: Decodable {
    var Source: String
    var Value: String
}

struct imdbRequest {
    private let API_KEY = "5998c213"
    private let resourceURL: URL
    private var supportingResourceURL: URL?
    
    init(title: String, year: Int?) {
        let rightTitle = title.replacingOccurrences(of: " ", with: "+")
        
        var resourceString = "http://www.omdbapi.com/?apikey=\(API_KEY)&s=\(rightTitle)"
        if let yearNotOptional = year {
            resourceString += "&y=\(yearNotOptional)"
        }
        guard let url = URL(string: resourceString) else { fatalError() }
        self.resourceURL = url
        
        var supportingString = "http://www.omdbapi.com/?apikey=\(API_KEY)&t=\(rightTitle)"
        if let yearNotOptional = year {
            supportingString += "&y=\(yearNotOptional)"
        }
        guard let supportingURL = URL(string: supportingString) else { fatalError() }
        self.supportingResourceURL = supportingURL

    }
    
    init(id: String) {
        let resourceString = "http://www.omdbapi.com/?apikey=\(API_KEY)&i=\(id)"
        guard let url = URL(string: resourceString) else { fatalError() }
        self.resourceURL = url
    }
    
    func makeRequestForSearch(completion: @escaping(Result<[SearchItem], imdbError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.dataError))
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let responce = try decoder.decode(imdb.self, from: jsonData)
                let items = responce.Search
                completion(.success(items))
            } catch {
                let supportingDataTask = URLSession.shared.dataTask(with: self.supportingResourceURL!) { data, _, _ in
                    guard let supportingjsonData = data else {
                        completion(.failure(.dataError))
                        return
                    }
                    
                    do {
                        let supportingResponce = try decoder.decode(SearchItem.self, from: supportingjsonData)
                        completion(.success([supportingResponce]))
                    } catch {
                        completion(.failure(.jsonError))
                    }
                }
                supportingDataTask.resume()
            }
            
        }
        dataTask.resume()
    }
    
    func makeRequestForItem(completion: @escaping(Result<Item, imdbError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responce = try decoder.decode(Item.self, from: jsonData)
                completion(.success(responce))
            } catch {
                completion(.failure(.jsonError))
            }
            
        }
        dataTask.resume()
    }
}

enum imdbError: Error {
    case dataError
    case jsonError
}
