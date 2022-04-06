//
//  AsteroidCell.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 03.04.2022.
//

import UIKit

class AsteroidCell: UICollectionViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var asteroidImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var dangerousLabel: UILabel!
    @IBOutlet weak var destroyButton: UIButton!
    
    override func prepareForReuse() {
        destroyButton.isHidden = false
        topView.layer.sublayers?.remove(at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        let borderColor: UIColor = .black
        self.layer.borderColor = borderColor.cgColor
        

        
    }
    
    func setGradientBackground(dangerous: Bool) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = dangerous ?
        [
            UIColor(red: 1, green: 0.694, blue: 0.6, alpha: 1).cgColor,
            
            UIColor(red: 1, green: 0.031, blue: 0.267, alpha: 1).cgColor]
        :
        [
            UIColor(red: 0.811, green: 0.952, blue: 0.491, alpha: 1).cgColor,
            
            UIColor(red: 0.492, green: 0.908, blue: 0.549, alpha: 1).cgColor
        ]
        
        gradientLayer.locations = [0, 1]
        
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)

        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)

        gradientLayer.frame = self.topView.bounds

        topView.layer.insertSublayer(gradientLayer, at: 0)
        
    }

}
