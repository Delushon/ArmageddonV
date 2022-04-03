//
//  NetworkManager.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 31.03.2022.
//

import Foundation

class NetworkManager {
    static func getAsteroids(startDate: Date, endDate: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(dateFormatter.string(from: startDate))&end_date=\(dateFormatter.string(from: endDate))&api_key=vhjR20gi9M2iL0liSsaBvaYAIym5MnxLDcyEkCoj") {
                if let data = try? Data(contentsOf: url) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        DataManager.asteroids.append(contentsOf: JSONParsing.getAsteroidsFromJSON(json))
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
