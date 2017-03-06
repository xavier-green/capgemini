//
//  CalibrationViewController.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//
import AudioKit
import UIKit

class CalibrationViewController: UIViewController {

    var mic: AKMicrophone!
    var tracker: AKFrequencyTracker!
    var silence: AKBooster!
    
    
    @IBOutlet var instructionLabel: UITextView!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var calibrationViewTap: UITapGestureRecognizer!
    @IBOutlet weak var currentFrequencyLabel: UILabel!
    private var frequencyRegistered: Bool!
    private var frequencyParameters: Any!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentFrequencyLabel.isHidden = true
        assignbackground()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.userFreq), name: NSNotification.Name(rawValue: "GOT_USER_FREQ"), object: nil)
        CotoBackMethods().getUserFreq(speakerId: GlobalVariables.username)
        if frequencyRegistered==false { // We should perform the calibration
            calibrationStep = 0
        }
        else { // We can skip the calibration
            calibrationStep = -1
        }
    }
    
    @objc func userFreq(notification: NSNotification) {
        let dictionary = notification.object as! [String:Any]
        frequencyRegistered = dictionary["registered"] as! Bool
        if frequencyRegistered==true {
            frequencyParameters = dictionary["frequency"]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Calibration
    
    var calibrationStep: Int!
    var isCalibrated = false
    var calibrationTimer: Timer!
    var frequencySamples: [Double] = []
    let numberOfSamples: Int = 10
    let toleranceInterval: Double = 5.0
    var indexOfOldestSample: Int = 0
    var averageFrequency = 160
    
    func performCalibration() {
    }
    
    @IBAction func calibrationViewTapped(_ sender: UITapGestureRecognizer) {
        nextCalibrationStep()
    }
    
    
    func nextCalibrationStep(){
        let currentStep = calibrationStep
        calibrationStep = calibrationStep + 1
        performStep(currentStep!)
    }
    
    func performStep(_ calStep: Int){
        switch calStep{
        case -1:
            instructionLabel.text = "Vos paramètres de voix ont été enregistrés"
            calibrationStep = 6
            break
        case 0:
            instructionLabel.text = "Nous avons juste besoin de paramétrer votre voix"
            break
        case 1:
            tapLabel.isHidden = true
            calibrationViewTap.isEnabled = false
            currentFrequencyLabel.text = "Veuillez chanter plus fort"
            currentFrequencyLabel.isHidden = false
            startCalibration()
            instructionLabel.text = "Chantez à une fréquence moyenne"
            break
        case 2:
            currentFrequencyLabel.isHidden = true
            tapLabel.isHidden = false
            calibrationViewTap.isEnabled = true
            AudioKit.stop()
            calibrationTimer.invalidate()
            instructionLabel.text =  "Calibration reussie ! Votre fréquence moyenne est " + String(self.averageFrequency) + " Hz"
            CotoBackMethods().sendUserFreq(speakerId: GlobalVariables.username,frequency: self.averageFrequency)
            break
        case 3:
            instructionLabel.text = "Les fréquences moyennes dessineront un trait droit"
            break
        case 4:
            instructionLabel.text = "Les plus basses fréquences feront tourner le pinceau dans le sens des aiguilles d'une montre"
            break
        case 5:
            instructionLabel.text = "Les plus hautes fréquences le feront tourner dans le sens inverse"
            break
        case 6:
            self.performSegue(withIdentifier: "successfulCalibrationSegueToDrawView", sender: self)//segue to Draw Controller
            
            
        default: instructionLabel.text = "Erreur dans le processus"
            
        }
    }
    
    func startCalibration() {
        mic = AKMicrophone()
        
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
        
        AudioKit.output = silence
        AudioKit.start()
        calibrationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CalibrationViewController.getMediumFrequency), userInfo: nil, repeats: true)
        
    }
    
    func getMediumFrequency() {
        
        
        if tracker.amplitude > 0.1 {
            print("frequencyAnalysis : " + String(tracker.frequency) + " amplitudeAnalysis : " + String(tracker.amplitude))
            currentFrequencyLabel.text = "Votre fréquence actuelle est : " + String(Int(tracker.frequency)) + " Hz"
            
            if frequencySamples.count < numberOfSamples { //Is the number of samples collected enough ?
                frequencySamples.append(tracker.frequency) //Collect new sample
            }
            else {
                // Compute average frequency
                let avgFreq = frequencySamples.reduce(0, +) / Double(frequencySamples.count)
                // Are all the sample in a minimum interval ? (are the samples relevant ?)
                var areSamplesRelevant = true
                for f in frequencySamples {
                    if f < avgFreq - toleranceInterval || f > avgFreq + toleranceInterval {
                        areSamplesRelevant = false
                    }
                }
                print("average frequency :" + String(avgFreq))
                print("Are Samples Relevant :" + String(areSamplesRelevant))
                if areSamplesRelevant {
                    frequencyParameters = FrequencyVoiceParameters(mediumFrequency: avgFreq)
                    self.averageFrequency = Int(avgFreq)
                    print("Successfully calibrated !!")
                    nextCalibrationStep() // Successfully calibrated
                }
                else { // We remove the oldest sample and replace it with a new one
                    // A proper implementation would involve a queue, but we actually store the index of the oldest sample, replace it with a new frequency and update the index
                    frequencySamples[indexOfOldestSample] = tracker.frequency
                    indexOfOldestSample = (indexOfOldestSample + 1) % numberOfSamples
                }
            }
        }
        else {
            currentFrequencyLabel.text = "Veuillez chanter plus fort"
        }
        
    }
    
    @IBAction func SegueButtonTapped(_ sender: AnyObject) {
        frequencyParameters = FrequencyVoiceParameters(mediumFrequency: 140.0)
        self.performSegue(withIdentifier: "successfulCalibrationSegueToDrawView", sender: self)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "successfulCalibrationSegueToDrawView" {
        //            let source = segue.sourceViewController as! CalibrationController
        //            let destination = segue.destinationViewController as! DrawViewController
        //            destination.userFrequencyParameters = source.userFrequencyParameters
        //    }
        //        else {
        //        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
    }

}
