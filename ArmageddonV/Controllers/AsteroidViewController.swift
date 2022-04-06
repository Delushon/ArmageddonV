//
//  AsteroidViewController.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 06.04.2022.
//

import UIKit

class AsteroidViewController: UIViewController {

    @IBOutlet weak var convergencesCollectionView: UICollectionView!
    
    var asteroid: Asteroid!
    
    var typeOfDistance = TypeDistance.km
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = asteroid.name
        convergencesCollectionView.delegate = self
        convergencesCollectionView.dataSource = self
        convergencesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        convergencesCollectionView.register(UINib(nibName: "ConvergenceCell", bundle: nil), forCellWithReuseIdentifier: "ConvergenceCell")
    }
    
    @IBAction func distanceTypeButtonAction(_ sender: UIButton) {
        let choiceOfDistanceType = UIAlertController(title: "Выберите единицу измерения", message: nil, preferredStyle: .alert)
        choiceOfDistanceType.addAction(UIAlertAction(title: "Километры", style: .default, handler: { _ in self.typeOfDistance = .km; self.convergencesCollectionView.reloadData() }))
        choiceOfDistanceType.addAction(UIAlertAction(title: "В расстояниях до луны", style: .default, handler: { _ in self.typeOfDistance = .lunar; self.convergencesCollectionView.reloadData() }))
        present(choiceOfDistanceType, animated: true, completion: nil)
    }
    

}

extension AsteroidViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asteroid.convergences.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = convergencesCollectionView.dequeueReusableCell(withReuseIdentifier: "ConvergenceCell", for: indexPath) as! ConvergenceCell
        
        setupCell(cell: cell, convergence: asteroid.convergences[indexPath.item])
        
        return cell
    }
        
    func setupCell(cell: ConvergenceCell, convergence: Convergence) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let date = convergence.date
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.distanceLabel.text = "\(convergence.distance / typeOfDistance.rawValue) \(typeOfDistance)"
        cell.speedLabel.text = "\(convergence.speed) Км/Ч"
        cell.orbitLabel.text = convergence.orbit == "Earth" ? "Земля" : convergence.orbit
        
    }
    
    func asteroidToDestroy(asteroid: Asteroid) {
        DataManager.addAsteroidForDestroy(asteroid)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.9, height: 350)//UIScreen.main.bounds.height * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
