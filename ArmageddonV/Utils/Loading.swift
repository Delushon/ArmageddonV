//
//  Loading.swift
//  ArmageddonV
//
//  Created by Александр Паньшин on 06.04.2022.
//

import Foundation
import UIKit

var aView: UIView?

extension UIViewController {
    
    func showSpinner() {
        DispatchQueue.main.async {
            aView = UIView(frame: self.view.bounds)
            aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            
            let indicator = UIActivityIndicatorView(style: .large)
                        
            
            indicator.center = CGPoint(x: aView!.center.x, y: aView!.center.y - 40.0)
            indicator.startAnimating()
            aView?.addSubview(indicator)
            self.view.addSubview(aView!)
            
            Timer.scheduledTimer(withTimeInterval: 3600.0, repeats: false, block: { _ in
                self.removeSpinner()
            })
        }
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            aView?.removeFromSuperview()
            aView = nil
        }
    }
    
}

