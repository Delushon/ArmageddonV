//
//  Asteroid.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 31.03.2022.
//

import Foundation

class Asteroid {
    
    let id: Int
    let name: String
    let size: Int
    let dangerous: Bool
    let convergences: [Convergence]
    
    init(id: Int, name: String, size: Int, dangerous: Bool, convergences: [Convergence]) {
        self.id = id
        self.name = name
        self.size = size
        self.dangerous = dangerous
        self.convergences = convergences
    }
    
}
