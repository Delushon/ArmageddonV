//
//  ViewController.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 31.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonAction(_ sender: Any) {
        NetworkManager().getAsteroids(startDate: Date(), endDate: Date())
    }
    
}

