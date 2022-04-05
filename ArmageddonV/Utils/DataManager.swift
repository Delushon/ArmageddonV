//
//  DataManager.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 03.04.2022.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    
    static var asteroids: [Asteroid] = []
    private static var asteroidsForDestroy: [Asteroid] = []
    
    static func initAsteroidsForDestroy() {
        var asteroidsFromCoreData = [AsteroidEntity]()
        
        //DispatchQueue???
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<AsteroidEntity> = AsteroidEntity.fetchRequest()
        
        do {
            asteroidsFromCoreData = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("USER ERROR \(error.localizedDescription)")
        }
        
        for asteroidFromCoreData in asteroidsFromCoreData {
            
            var convergences: [Convergence] = []
            for convergence in asteroidFromCoreData.convergences!.sorted(by: { value1, value2 in
                let convergence1 = value1 as! ConvergenceEntity
                let convergence2 = value2 as! ConvergenceEntity
                return convergence1.date! < convergence2.date!
            }) {
                let oneConvergence = convergence as! ConvergenceEntity
                convergences.append(Convergence(date: oneConvergence.date ?? Date(), speed: Int(oneConvergence.speed), distance: Int(oneConvergence.distance), orbit: oneConvergence.orbit ?? "Earth"))
            }
            let newAsteroid = Asteroid(id: Int(asteroidFromCoreData.id), name: asteroidFromCoreData.name ?? "NONE", size: Int(asteroidFromCoreData.size), dangerous: asteroidFromCoreData.dangerous, convergences: convergences)
            if asteroidsForDestroy.contains(newAsteroid) {
                return
            }
            asteroidsForDestroy.append(newAsteroid)
        }
        NotificationCenter.default.post(name: NSNotification.Name("ReloadAsteroids"), object: nil)
    }
    
    static func getAsteroidsForDestroy() -> [Asteroid] {
        return asteroidsForDestroy
    }
    
    static func addAsteroidForDestroy(_ asteroid: Asteroid) {
        if asteroidsForDestroy.contains(asteroid) { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityForAsteroid = NSEntityDescription.entity(forEntityName: "AsteroidEntity", in: context) else { return }
        guard let entityForConvergence = NSEntityDescription.entity(forEntityName: "ConvergenceEntity", in: context) else { return }
        let newAsteroid = AsteroidEntity(entity: entityForAsteroid, insertInto: context)
        
        do {
            newAsteroid.id = Int64(asteroid.id)
            newAsteroid.name = asteroid.name
            newAsteroid.size = Int64(asteroid.size)
            newAsteroid.dangerous = asteroid.dangerous
            for convergence in asteroid.convergences {
                let convergenceEntity = ConvergenceEntity(entity: entityForConvergence, insertInto: context)
                convergenceEntity.date = convergence.date
                convergenceEntity.speed = Int64(convergence.speed)
                convergenceEntity.distance = Int64(convergence.distance)
                convergenceEntity.orbit = convergence.orbit
                newAsteroid.addToConvergences(convergenceEntity)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("SAVE INSTRUCTION ERROR \(error.localizedDescription)")
        }
        
        asteroidsForDestroy.append(asteroid)
        NotificationCenter.default.post(name: NSNotification.Name("ReloadAsteroids"), object: nil)
    }
    
}
