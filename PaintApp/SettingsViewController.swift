//
//  SettingsViewController.swift
//  PaintApp
//
//  Created by Rajat on 7/27/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

protocol GetDataFromSettingsDelegate {
    func getDataFromSettings(_ settingsVc: SettingsViewController)
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var brushSizeLabel: UILabel!
    @IBOutlet weak var opacityLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var opacitySlider: UISlider!
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var brushSize: CGFloat = 0
    var opacity: CGFloat = 0
    var delegate: GetDataFromSettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showColorPreview()
        setAllSliderValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAllSliderValues() {
        redSlider.value = Float(red)
        blueSlider.value = Float(blue)
        greenSlider.value = Float(green)
        brushSizeSlider.value = Float(brushSize/100)
        opacitySlider.value = Float(opacity)
    }
    
    @IBAction func brushSizeChanged(_ sender: UISlider) {
        self.brushSize = CGFloat(sender.value * 100)
    }
    
    @IBAction func opacityChanged(_ sender: UISlider) {
        self.opacity = CGFloat(sender.value)
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        delegate?.getDataFromSettings(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func redValueChanged(_ sender: UISlider) {
        red = CGFloat(sender.value)
        showColorPreview()
    }
    
    @IBAction func blueValueChanged(_ sender: UISlider) {
        blue = CGFloat(sender.value)
        showColorPreview()
    }
    
    @IBAction func greenValueChanged(_ sender: UISlider) {
        green = CGFloat(sender.value)
        showColorPreview()
    }
    
    func showColorPreview() {
        imageView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
