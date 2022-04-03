//
//  ViewController.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 31.03.2022.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var asteroidsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        asteroidsCollectionView.delegate = self
        asteroidsCollectionView.dataSource = self
        asteroidsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        asteroidsCollectionView.register(UINib(nibName: "AsteroidCell", bundle: nil), forCellWithReuseIdentifier: "AsteroidCell")
        NetworkManager.getAsteroids(startDate: Date(), endDate: Date())
    }

    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.asteroids.count + 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = asteroidsCollectionView.dequeueReusableCell(withReuseIdentifier: "AsteroidCell", for: indexPath) as! AsteroidCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        let borderColor: UIColor = .black
        cell.layer.borderColor = borderColor.cgColor
//        cell.setupCell(asteroid: DataManager.asteroids[indexPath.item], isLunar: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.9 - 10, height: UIScreen.main.bounds.height * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAsteroid", sender: self)
    }
    
}

