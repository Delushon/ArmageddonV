//
//  NetworkManager.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 31.03.2022.
//

import Foundation

class NetworkManager {
    
    static var lastDate = Date()
    
    static func getAsteroids() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(dateFormatter.string(from: lastDate))&end_date=\(dateFormatter.string(from: lastDate))&api_key=vhjR20gi9M2iL0liSsaBvaYAIym5MnxLDcyEkCoj") {
                if let data = try? Data(contentsOf: url) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        DataManager.asteroids.append(contentsOf: JSONParsing.getAsteroidsFromJSON(json))
                        NotificationCenter.default.post(name: NSNotification.Name("ReloadAsteroids"), object: nil)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        lastDate = theCalendar.date(byAdding: dayComponent, to: lastDate) ?? Date()
    }
}
