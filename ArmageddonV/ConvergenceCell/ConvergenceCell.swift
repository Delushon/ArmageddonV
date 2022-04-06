//
//  ConvergenceCell.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 06.04.2022.
//

import UIKit

class ConvergenceCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var orbitLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        let borderColor: UIColor = .black
        self.layer.borderColor = borderColor.cgColor
    }

}
