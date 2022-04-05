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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        let borderColor: UIColor = .black
        self.layer.borderColor = borderColor.cgColor
    }

}
