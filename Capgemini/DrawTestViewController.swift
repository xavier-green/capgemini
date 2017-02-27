//
//  DrawTestViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import AudioKit
import UIKit

class DrawTestViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var stackColors: UIStackView!
    
    
    // MARK: Audio Properties
    
    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    
    // MARK: Notes Properties
    
    let noteFrequencies = [16.35,17.32,18.35,19.45,20.6,21.83,23.12,24.5,25.96,27.5,29.14,30.87]
    let noteNamesWithSharps = ["C", "C♯","D","D♯","E","F","F♯","G","G♯","A","A♯","B"]
    let noteNamesWithFlats = ["C", "D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    //MARK: Initialisation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mic = AKMicrophone()
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
        
        AudioKit.output = silence
        AudioKit.start()
        
        if userInfo?.frequencyParameters != nil {
            setFrequencyParameters((userInfo?.frequencyParameters)!)
        }
        
        //stackColors.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DrawTestViewController.analyseAudioInput), userInfo: nil, repeats: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("YOUHOUUU")
        AudioKit.stop()
        super.viewDidDisappear(animated)
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        drawView.viewImage = UIImage()
        drawView.currentLine = nil
        drawView.setNeedsDisplay()
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("IPhone is shaken")
        if motion == .motionShake {
            print("IPhone is shaken")
            drawView.viewImage = UIImage()
            drawView.currentLine = nil
            drawView.setNeedsDisplay()
        }
    }
    
    func analyseAudioInput() {
        print("frequency : " + String(tracker.frequency) + " ampmlitude : " + String(tracker.amplitude))
        
        let frequencyDisplay = tracker.frequency
        let amplitudeDisplay = tracker.amplitude
        
        frequencyLabel.text = String(frequencyDisplay.roundToN(n: 2))
        amplitudeLabel.text = String(amplitudeDisplay.roundToN(n: 2))
        
        
        if tracker.amplitude > 0.06 {
            drawView.getMoveFromAudioInput(tracker.frequency,amplitude: tracker.amplitude)
        }
        
    }
    
    func setFrequencyParameters(_ frequencyParameters: FrequencyVoiceParameters) {
        drawView.f0 = frequencyParameters.f0
        drawView.fmin = frequencyParameters.fmin
        drawView.fmax = frequencyParameters.fmax
        drawView.fe = frequencyParameters.fe
    }
    
    
    @IBAction func colorsButtonTapped(_ sender: UIButton) {
        stackColors.isHidden = !stackColors.isHidden
    }
    
    @IBAction func redButtonTapped(_ sender: UIButton) {
        drawView.currentColor = UIColor.red
        stackColors.isHidden = true
        
    }
    
    @IBAction func greenButtonTapped(_ sender: AnyObject) {
        drawView.currentColor = UIColor.green
        stackColors.isHidden = true
    }
    
    @IBAction func blueButtonTapped(_ sender: AnyObject) {
        drawView.currentColor = UIColor.blue
        stackColors.isHidden = true
    }
    
    @IBAction func blackButtonTapped(_ sender: UIButton) {
        drawView.currentColor = UIColor.black
        stackColors.isHidden = true
    }
    
    @IBAction func navigatingTo(_ segue: UIStoryboardSegue) {
        
    }
    


}
