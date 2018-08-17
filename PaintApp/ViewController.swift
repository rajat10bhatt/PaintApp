//
//  ViewController.swift
//  PaintApp
//
//  Created by Rajat on 7/20/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var drawingImageView: UIImageView!
    @IBOutlet weak var colorStackView: UIStackView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var cyanButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var toolsStackView: UIStackView!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    
    //MARK: Properties
    var lastPoint = CGPoint.zero
    var swiped = false
    var selectedColor = UIColor.black
    var strokeWidth: CGFloat = 5
    var tool: UIImageView!
    
    // MARK: View controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initailizeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Drawing logic
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        //Set lastTouch to first touch when touches began
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    // Func to draw lines
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        // Begin Image Context with size of the Context i.e. size of our view
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawingImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        // Drawing context
        let context = UIGraphicsGetCurrentContext()
        // Create line from one point to another
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        //Set tool center to move it while drawing
        tool.center = CGPoint(x: toPoint.x + 15, y: toPoint.y - 15)
        tool.isHidden = false
        
        // Set all the properties of the stroke/line
        context?.setBlendMode(.normal)
        context?.setLineCap(.round)
        context?.setLineWidth(strokeWidth)
        context?.setStrokeColor(selectedColor.cgColor)
        context?.strokePath()
        
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // Func to draw rectangle
    func drawRectangleOrSquare(fromPoint: CGPoint, toPoint: CGPoint) {
        // Begin Image Context with size of the Context i.e. size of our view
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawingImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        // Drawing context
        let context = UIGraphicsGetCurrentContext()
        // Create line from one point to another
        context?.move(to: fromPoint)
        context?.addRect(CGRect(x: fromPoint.x, y: fromPoint.y, width: (toPoint.x - fromPoint.x), height: (toPoint.y - fromPoint.y)))
        
        // Set all the properties of the stroke/line
        context?.setBlendMode(.normal)
        context?.setLineCap(.round)
        context?.setLineWidth(strokeWidth)
        context?.setStrokeColor(selectedColor.cgColor)
        context?.strokePath()
        
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // Func to draw circle
    func drawCircle(fromPoint: CGPoint, toPoint: CGPoint) {
        // Begin Image Context with size of the Context i.e. size of our view
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawingImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        // Drawing context
        let context = UIGraphicsGetCurrentContext()
        // Create line from one point to another
        context?.move(to: fromPoint)
        let absoluteXValue = abs(toPoint.x - fromPoint.x)
        let absoluteYValue = abs(toPoint.y - fromPoint.y)
        if (absoluteXValue > absoluteYValue) {
            let radius = absoluteXValue
            context?.addEllipse(in: CGRect(x: fromPoint.x , y: fromPoint.y - radius, width: radius * 2, height: radius * 2))
        } else {
            let radius = absoluteYValue
            context?.addEllipse(in: CGRect(x: fromPoint.x - (radius), y: fromPoint.y, width: radius * 2, height: radius * 2))
        }
        
        // Set all the properties of the stroke/line
        context?.setBlendMode(.normal)
        context?.setLineCap(.round)
        context?.setLineWidth(strokeWidth)
        context?.setStrokeColor(selectedColor.cgColor)
        context?.strokePath()
        
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if !rectangleButton.isSelected && !circleButton.isSelected {
            // When user moves finger update lastPoint and draw line
            if let touch = touches.first {
                let touchLocation = touch.location(in: self.view)
                if !(self.toolsStackView.frame.contains(touchLocation) || self.colorStackView.frame.contains(touchLocation)) {
                    let currentPoint = touch.location(in: self.view)
                    drawLines(fromPoint: lastPoint, toPoint: currentPoint)
                    lastPoint = currentPoint
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tool.isHidden = true
        if let touch = touches.first {
            let touchLocation = touch.location(in: self.view)
            if (lastPoint.x != touchLocation.x) || (lastPoint.y != touchLocation.y) {
                if rectangleButton.isSelected {
                    drawRectangleOrSquare(fromPoint: lastPoint, toPoint: touchLocation)
                } else if circleButton.isSelected {
                    drawCircle(fromPoint: lastPoint, toPoint: touchLocation)
                }
            }
        }
    }
    
    // MARK: Custom Methods
    // Initialize views
    func initailizeView() {
        // Add border color and width to all color buttons
        let buttonArray = [redButton, greenButton, blueButton, pinkButton, yellowButton, cyanButton, whiteButton, blackButton]
        if let colorButtonArray = buttonArray as? [UIButton] {
            setBorderColorAndWidthToButton(buttonArray: colorButtonArray)
        }
        
        // Setup tool
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.frame.width, y: self.view.frame.height, width: 40, height: 40)
        tool.image = #imageLiteral(resourceName: "icons8-edit-64")
        self.view.addSubview(tool)
    }
    
    // Set border color to an array of buttons
    func setBorderColorAndWidthToButton(buttonArray: [UIButton]) {
        for button in buttonArray {
            button.layer.masksToBounds = true
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
        }
    }
    
    // MARK: Button Actions
    @IBAction func onClickOfResetButton(_ sender: UIButton) {
        //Reset layer
        self.drawingImageView.image = nil
    }
    
    @IBAction func onClickOfColorButton(_ sender: UIButton) {
        // Set stroke color
        if let backgroundColor = sender.backgroundColor {
            self.selectedColor = backgroundColor
            self.strokeWidth = 5
            self.tool.image = #imageLiteral(resourceName: "icons8-edit-64")
            eraserButton.isSelected = false
        }
    }
    
    @IBAction func onClickOfSaveButton(_ sender: UIButton) {
        if let image = drawingImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    @IBAction func onClickOfEraseButton(_ sender: UIButton) {
        self.rectangleButton.isSelected = false
        self.circleButton.isSelected = false
        textButton.isSelected = false
        if let backgroundColor = self.view.backgroundColor {
            tool.image = #imageLiteral(resourceName: "icons8-eraser-48")
            self.selectedColor = backgroundColor
            self.strokeWidth = 20
        }
    }
    
    @IBAction func onClickOfRectangle(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        circleButton.isSelected = false
        textButton.isSelected = false
        eraserButton.isSelected = false
    }
    
    @IBAction func onClickOfSettingButton(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickOfCircleButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        rectangleButton.isSelected = false
        textButton.isSelected = false
        eraserButton.isSelected = false
    }
    
    @IBAction func onClickOfPathButton(_ sender: UIButton) {
        rectangleButton.isSelected = false
        circleButton.isSelected = false
        textButton.isSelected = false
        eraserButton.isSelected = false
        tool.image = #imageLiteral(resourceName: "icons8-edit-64")
        self.selectedColor = UIColor.black
        self.strokeWidth = 5
    }
    
    @IBAction func onClickOfTextButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        rectangleButton.isSelected = false
        circleButton.isSelected = false
        eraserButton.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let settingsVC = segue.destination as! SettingsViewController
        if let red = selectedColor.rgb()?.red, let blue = selectedColor.rgb()?.blue, let green = selectedColor.rgb()?.green, let opacity = selectedColor.rgb()?.alpha {
            settingsVC.red = red
            settingsVC.blue = blue
            settingsVC.green = green
            settingsVC.opacity = opacity
        }
        settingsVC.brushSize = strokeWidth
        settingsVC.delegate = self
    }
}

extension ViewController: GetDataFromSettingsDelegate {
    func getDataFromSettings(_ settingsVc: SettingsViewController) {
        self.selectedColor = UIColor(red: settingsVc.red, green: settingsVc.green, blue: settingsVc.blue, alpha: settingsVc.opacity)
        self.strokeWidth = settingsVc.brushSize
    }
}

extension UIColor {
    
    func rgb() -> (red :CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = fRed
            let iGreen = fGreen
            let iBlue = fBlue
            let iAlpha = fAlpha
            
            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
