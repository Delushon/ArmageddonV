//
//  JSONParsing.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 01.04.2022.
//

import Foundation

class JSONParsing {
    
    static func getAsteroidsFromJSON(_ json: [String:Any]) -> [Asteroid] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:"
        
        var result: [Asteroid] = []
        
        if let dates = json["near_earth_objects"] as? [String: Any]{
            for date in dates {
                for asteroid in date.value as! [[String: Any]] {
                    
                    let id = Int(asteroid["id"] as! String)!
                    let name = asteroid["name"] as! String
                    let size = (((asteroid["estimated_diameter"] as! [String: Any])["meters"] as! [String: Any])["estimated_diameter_max"] as! NSNumber).intValue
                    let dangerous = asteroid["is_potentially_hazardous_asteroid"] as! Bool
                    
                    var convergences: [Convergence] = []
                    
                    for convergence in asteroid["close_approach_data"] as! [[String: Any]]{
                        let convergenceDateString = convergence["close_approach_date_full"] as! String
                        let convergenceDate = dateFormatter.date(from:convergenceDateString)!
                        let convergenceSpeed = Int(Float((convergence["relative_velocity"] as! [String: Any])["kilometers_per_hour"] as! String)!)
                        let convergenceDistance = Int(Float((convergence["miss_distance"] as! [String: Any])["kilometers"] as! String)!)
                        let convergenceOrbit = convergence["orbiting_body"] as! String
                        
                        convergences.append(Convergence(date: convergenceDate, speed: convergenceSpeed, distance: convergenceDistance, orbit: convergenceOrbit))
                        
                    }
                    
                    result.append(Asteroid(id: id, name: name, size: size,dangerous: dangerous, convergences: convergences))
                    
                }
            }
        }
        
        return result
        
    }
    
}
