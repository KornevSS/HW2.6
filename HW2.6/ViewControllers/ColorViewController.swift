//
//  ColorViewController.swift
//  HW2.6
//
//  Created by Сергей Корнев on 14.02.2021.
//  Copyright © 2021 Sergey Kornev. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setNewValue(for color: UIColor)
}

class ColorViewController: UIViewController {

// MARK: - IB Outlets
    @IBOutlet var colorView: UIView!

// MARK: - Private properties
    private var color = UIColor(red: 0.7, green: 0.5, blue: 0.3, alpha: 1)
  
// MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.backgroundColor = color
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let settingsVC = navigationVC.topViewController as? SettingsViewController else { return }
        settingsVC.color = color
        settingsVC.delegate = self
    }


}

// MARK: - Extentions
extension ColorViewController: SettingsViewControllerDelegate {
    func setNewValue(for color: UIColor) {
        colorView.backgroundColor = color
        self.color = color
    }
    
}
