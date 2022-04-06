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
    @IBOutlet weak var bruceButton: UIButton!
    
    var typeOfCollection = typeCollection.all
    
    var onlyDangerous = false
    
    var typeOfDistance = TypeDistance.km
    
    var selectedAsteroid: Asteroid!
        
    enum typeCollection {
        case all
        case forDestroy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        asteroidsCollectionView.delegate = self
        asteroidsCollectionView.dataSource = self
        asteroidsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        asteroidsCollectionView.register(UINib(nibName: "AsteroidCell", bundle: nil), forCellWithReuseIdentifier: "AsteroidCell")
        NetworkManager.getAsteroids()
        DataManager.initAsteroidsForDestroy()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadAsteroids(_:)), name: NSNotification.Name("ReloadAsteroids"), object: nil)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReloadAsteroids"), object: nil)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func reloadAsteroids(_ notification: Notification?) {
        DispatchQueue.main.async {
            self.asteroidsCollectionView.reloadData()
            self.removeSpinner()
        }
    }
    
    @IBAction func typeOfCollectionSliderAction(_ sender: UISegmentedControl) {
        asteroidsCollectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .top, animated: false)
        bruceButton.isHidden = sender.selectedSegmentIndex == 0
        typeOfCollection = sender.selectedSegmentIndex == 0 ? .all : .forDestroy
        asteroidsCollectionView.reloadData()
    }
    
    @IBAction func onlyDangerousButtonAction(_ sender: UISwitch) {
        onlyDangerous = sender.isOn
        asteroidsCollectionView.reloadData()
    }
    
    @IBAction func distanceTypeButtonAction(_ sender: UIButton) {
        let choiceOfDistanceType = UIAlertController(title: "Выберите единицу измерения", message: nil, preferredStyle: .alert)
        choiceOfDistanceType.addAction(UIAlertAction(title: "Километры", style: .default, handler: { _ in self.typeOfDistance = .km; self.asteroidsCollectionView.reloadData(); sender.titleLabel?.text = "В километрах" }))
        choiceOfDistanceType.addAction(UIAlertAction(title: "В дистанциях до луны", style: .default, handler: { _ in self.typeOfDistance = .lunar; self.asteroidsCollectionView.reloadData(); sender.titleLabel?.text = "В дистанциях" }))
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
        cell.setGradientBackground(dangerous: asteroid.dangerous)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.16
        cell.nameLabel.attributedText = NSMutableAttributedString(string: asteroid.name, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        cell.asteroidImage.image? = (cell.asteroidImage.image?.resize(maxWidthHeight: 150.0 * (Double(asteroid.size) / 85.0))) ?? cell.asteroidImage.image!
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
        return CGSize(width: UIScreen.main.bounds.width * 0.9, height: 700)//UIScreen.main.bounds.height * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch typeOfCollection {
            case .all: selectedAsteroid = DataManager.asteroids.prepare(onlyDangerous: onlyDangerous)[indexPath.item]
            case .forDestroy: selectedAsteroid = DataManager.getAsteroidsForDestroy().prepare(onlyDangerous: onlyDangerous)[indexPath.item]
        }
        performSegue(withIdentifier: "toAsteroid", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AsteroidViewController else { return }
        destination.asteroid = selectedAsteroid
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            showSpinner()
            NetworkManager.getAsteroids()
        }
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

extension UIImage {

    func resize(maxWidthHeight : Double)-> UIImage? {

        let actualHeight = Double(size.height)
        let actualWidth = Double(size.width)
        var maxWidth = 0.0
        var maxHeight = 0.0

        if actualWidth > actualHeight {
            maxWidth = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualWidth)
            maxHeight = (actualHeight * per) / 100.0
        }else{
            maxHeight = maxWidthHeight
            let per = (100.0 * maxWidthHeight / actualHeight)
            maxWidth = (actualWidth * per) / 100.0
        }

        let hasAlpha = true
        let scale: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: maxHeight), !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxWidth, height: maxHeight)))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }

}
