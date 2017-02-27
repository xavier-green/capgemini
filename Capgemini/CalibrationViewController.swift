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
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var calibrationViewTap: UITapGestureRecognizer!
    @IBOutlet weak var currentFrequencyLabel: UILabel!
    
    
    func saveUserInfo() {
        if userInfo != nil {
            if UserInfo.ArchiveURL.path == "" {
                print("path nil")
            }
            if userInfo == nil {
                print("userInfo nil")
            }
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userInfo!, toFile: UserInfo.ArchiveURL.path)
            if !isSuccessfulSave {
                print("Failed to save user info...")
            }
            else {
                print("Successful save")
            }
        }
        else {
            print("Failed to save user info, no user info found")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentFrequencyLabel.isHidden = true
        // Do any additional setup after loading the view.
        if userInfo?.frequencyParameters == nil { // We should perform the calibration
            calibrationStep = 0
        }
        else { // We can skip the calibration
            calibrationStep = -1
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
            instructionLabel.text = "Your voice parameters have already been recorded"
            calibrationStep = 3
            break
        case 0:
            instructionLabel.text = "We just need to set the parameters according to your voice"
            break
        case 1:
            tapLabel.isHidden = true
            calibrationViewTap.isEnabled = false
            currentFrequencyLabel.text = "Please sing louder"
            currentFrequencyLabel.isHidden = false
            startCalibration()
            instructionLabel.text = "Sing at a single convenient frequency"
            break
        case 2:
            currentFrequencyLabel.isHidden = true
            tapLabel.isHidden = false
            calibrationViewTap.isEnabled = true
            AudioKit.stop()
            calibrationTimer.invalidate()
            instructionLabel.text =  "Successfully calibrated ! Your convenience frequency is " + "160" + " Hz"
            break
        case 3:
            instructionLabel.text = "Medium frequencies will draw a straight line"
            break
        case 4:
            instructionLabel.text = "Lower frequencies will rotate the line clockwise"
            break
        case 5:
            instructionLabel.text = "Higher frequencies will rotate the line counterclockwise"
            break
        case 6:
            self.performSegue(withIdentifier: "successfulCalibrationSegueToDrawView", sender: self)//segue to Draw Controller
            
            
        default: instructionLabel.text = "Error in process"
            
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
            currentFrequencyLabel.text = "Your current frequency : " + String(Int(tracker.frequency)) + " Hz"
            
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
                    userInfo?.frequencyParameters = FrequencyVoiceParameters(mediumFrequency: avgFreq)
                    //saveUserInfo()
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
            currentFrequencyLabel.text = "Please sing louder"
        }
        
    }
    
    @IBAction func SegueButtonTapped(_ sender: AnyObject) {
        userInfo?.frequencyParameters = FrequencyVoiceParameters(mediumFrequency: 140.0)
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
