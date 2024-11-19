//
//  ViewController.swift
//  ProximityApp
//
//  Created by Amit Garg on 18/11/24.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view = ProximityView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInfoAlert()
    }
    
    func showInfoAlert() {
        let alert = UIAlertController(title: "Info", message: "Tap any where in the screen to start.", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

