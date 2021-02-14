//
//  ViewController.swift
//  HW2.6
//
//  Created by Сергей Корнев on 14.02.2021.
//  Copyright © 2021 Sergey Kornev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    
    @IBOutlet var colorPanelView: UIView!
    
    var color: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    private var colorComponents: (red: Float, green: Float, blue: Float) {
        (red: Float(color.cgColor.components?[0] ?? 1),
         green: Float(color.cgColor.components?[1] ?? 1),
         blue: Float(color.cgColor.components?[2] ?? 1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        colorPanelView.layer.cornerRadius = 15
        
        updateColorPanelView()
        updateSliders()
        updateTextFields()
        updateLabels()
    }
    
    private func updateColor() {
        color = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func round100(value: Float) -> Float {
        round(value * 100) / 100
    }
    
    private func updateFor(slider: UISlider, label: UILabel, textField: UITextField) {
        label.text = String(round100(value: slider.value))
        textField.text = label.text
    }
    
    private func updateColorPanelView() {
        colorPanelView.backgroundColor = color
    }
    
    private func updateSliders() {
        redSlider.value = colorComponents.red
        greenSlider.value = colorComponents.green
        blueSlider.value = colorComponents.blue
    }
    
    private func updateTextFields() {
        redTextField.text = String(colorComponents.red)
        greenTextField.text = String(colorComponents.green)
        blueTextField.text = String(colorComponents.blue)
    }
    
    private func updateLabels() {
        redLabel.text = String(colorComponents.red)
        greenLabel.text = String(colorComponents.green)
        blueLabel.text = String(colorComponents.blue)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        switch sender.tag {
            case 0: updateFor(slider: sender, label: redLabel, textField: redTextField)
            case 1: updateFor(slider: sender, label: greenLabel, textField: greenTextField)
            case 2: updateFor(slider: sender, label: blueLabel, textField: blueTextField)
            default: break
        }
        updateColor()
        updateColorPanelView()
    }
    
    @IBAction func doneButtonAction() {
        delegate.setNewValue(for: color)
        dismiss(animated: true)
    }

}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        if let numberValueFloat = Float(newValue) {
            var numberValueCGFloat = CGFloat(numberValueFloat)
            if numberValueCGFloat < 0 {
                numberValueCGFloat = 0.0
            } else if numberValueCGFloat > 1 {
                numberValueCGFloat = 1.0
            }
            switch textField.tag {
                case 0: color = UIColor(
                    red: numberValueCGFloat,
                    green: CGFloat(greenSlider.value),
                    blue: CGFloat(blueSlider.value),
                    alpha: 1)
                case 1: color = UIColor(
                    red: CGFloat(redSlider.value),
                    green: numberValueCGFloat,
                    blue: CGFloat(blueSlider.value),
                    alpha: 1)
                case 2: color = UIColor(
                    red: CGFloat(redSlider.value),
                    green: CGFloat(greenSlider.value),
                    blue: numberValueCGFloat,
                    alpha: 1)
                default: break
            }
        } else {
            showAlert(title: "🚫 It's not a values!", message: "Please, enter value in range 0.0 ... 1.0")
            textField.text?.removeAll()
            return
        }
        updateTextFields()
        updateColorPanelView()
        updateSliders()
        updateLabels()
    }
}

// MARK: - Alert controller
extension SettingsViewController {
    private func showAlert(title: String?, message: String?, textField: UITextField? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            textField?.text = nil
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
