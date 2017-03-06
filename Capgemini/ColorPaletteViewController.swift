//
//  ColorPaletteViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 06/03/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit

class ColorPaletteViewController: UIViewController {

    // Init ColorPicker with yellow
    var selectedColor: UIColor = UIColor.white
    
    @IBAction func backtoDraw(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // IBOutlet for the ColorPicker
    @IBOutlet var colorPicker: SwiftHSVColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Going to color palette")
        // Do any additional setup after loading the view, typically from a nib.
        // Setup Color Picker
        colorPicker.setViewColor(selectedColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getSelectedColor(_ sender: UIButton) {
        // Get the selected color from the Color Picker.
        let selectedColor = colorPicker.color
        
        print(selectedColor!)
    }
}
