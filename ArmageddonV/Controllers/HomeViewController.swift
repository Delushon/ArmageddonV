//
//  ViewController.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 31.03.2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var asteroidsCollectionView: UICollectionView!
    @IBOutlet weak var typeOfCollectionSlider: UISegmentedControl!
    @IBOutlet weak var onlyDangerousButton: UISwitch!
    @IBOutlet weak var distanceTypeButton: UIButton!
    
    var typeOfCollection = typeCollection.all
    
    var onlyDangerous = false
    
    var typeOfDistance = typeDistance.km
        
    enum typeCollection {
        case all
        case forDestroy
    }
    
    enum typeDistance: Int {
        case km = 1
        case lunar = 384400
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        asteroidsCollectionView.delegate = self
        asteroidsCollectionView.dataSource = self
        asteroidsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        asteroidsCollectionView.register(UINib(nibName: "AsteroidCell", bundle: nil), forCellWithReuseIdentifier: "AsteroidCell")
        NetworkManager.getAsteroids(startDate: Date(), endDate: Date())
        DataManager.initAsteroidsForDestroy()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAsteroids(_:)), name: NSNotification.Name("ReloadAsteroids"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReloadAsteroids"), object: nil)
    }
    
    @objc func reloadAsteroids(_ notification: Notification?) {
        DispatchQueue.main.async {
            self.asteroidsCollectionView.reloadData()
        }
    }
    
    @IBAction func typeOfCollectionSliderAction(_ sender: UISegmentedControl) {
        typeOfCollection = sender.selectedSegmentIndex == 0 ? .all : .forDestroy
        asteroidsCollectionView.reloadData()
    }
    
    @IBAction func onlyDangerousButtonAction(_ sender: UISwitch) {
        onlyDangerous = sender.isOn
        asteroidsCollectionView.reloadData()
    }
    
    @IBAction func distanceTypeButtonAction(_ sender: Any) {
        let choiceOfDistanceType = UIAlertController(title: "Выберите еденицу измерения", message: nil, preferredStyle: .alert)
        choiceOfDistanceType.addAction(UIAlertAction(title: "Километры", style: .default, handler: { _ in self.typeOfDistance = .km; self.asteroidsCollectionView.reloadData() }))
        choiceOfDistanceType.addAction(UIAlertAction(title: "В расстояниях до луны", style: .default, handler: { _ in self.typeOfDistance = .lunar; self.asteroidsCollectionView.reloadData() }))
        present(choiceOfDistanceType, animated: true, completion: nil)
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeOfCollection {
        case .all: return DataManager.asteroids.prepare(onlyDangerous: onlyDangerous).count
            case .forDestroy: return DataManager.getAsteroidsForDestroy().prepare(onlyDangerous: onlyDangerous).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var asteroid: Asteroid
        switch typeOfCollection {
            case .all: asteroid = DataManager.asteroids.prepare(onlyDangerous: onlyDangerous)[indexPath.item]
            case .forDestroy: asteroid = DataManager.getAsteroidsForDestroy().prepare(onlyDangerous: onlyDangerous)[indexPath.item]
        }
        let cell = asteroidsCollectionView.dequeueReusableCell(withReuseIdentifier: "AsteroidCell", for: indexPath) as! AsteroidCell
        
        setupCell(cell: cell, asteroid: asteroid)
        
        return cell
    }
        
    func setupCell(cell: AsteroidCell, asteroid: Asteroid) {
        cell.nameLabel.text = asteroid.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        let convergence = asteroid.convergences[0]
        let date = convergence.date
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.distanceLabel.text = "\(convergence.distance / typeOfDistance.rawValue) \(typeOfDistance)"
        cell.sizeLabel.text = "\(asteroid.size) м"
        cell.dangerousLabel.text = asteroid.dangerous ? "Опасен" : "Не опасен"
        if DataManager.getAsteroidsForDestroy().contains(asteroid) {
            cell.destroyButton.isHidden = true
        } else {
            cell.destroyButton.addAction(UIAction(handler: { _ in
                self.asteroidToDestroy(asteroid: asteroid)
                self.asteroidsCollectionView.reloadData()
            }), for: .touchUpInside)
        }
        
    }
    
    func asteroidToDestroy(asteroid: Asteroid) {
        DataManager.addAsteroidForDestroy(asteroid)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.9, height: 600)//UIScreen.main.bounds.height * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAsteroid", sender: self)
    }
    
    
}

extension Array where Element == Asteroid {
    func prepare(onlyDangerous: Bool) -> [Asteroid] {
        if onlyDangerous {
            return self.filter { asteroid in
                return asteroid.dangerous
            }
        } else {
            return self
        }
    }
}

