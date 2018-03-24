//
//  ViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/12/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
import AVFoundation

//Functionality of ViewController:
//In Piano View Controller, there are 7 buttons(keys) represent 7 tunes, and tapping each button will trigger IBAction pressed(), to implement the simulated piano sound
class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var stop: UIButton!
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    // Use an array to store the 7 sound files
    let soundArray = ["tune1", "tune2", "tune3", "tune4", "tune5", "tune6", "tune7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stop.isEnabled = false
        record.isEnabled = true
        
    }
    //start recording the composed file
    @IBAction func startRecording(_ sender: Any) {
        record.isEnabled = false
        stop.isEnabled = true
        
        // Creates a list of path strings for the specified directories in the specified domains.
        // Attribution: https://developer.apple.com/documentation/foundation/1414224-nssearchpathfordirectoriesindoma?language=objc
        let pathString = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //
        let recordTitle = "recordedSound.wav"
        let pathArray = [pathString, recordTitle]
        let fileUrl = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: fileUrl!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        record.isEnabled = true
        stop.isEnabled = false
        audioPlayer.stop()
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "RecorderStopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording not finished")
        }
    }
    
    // Use attribution 'tag' to lable the 7 tune buttons, from 1 to 7, so when pressed() function is triggered, through tab attribution audioPlayer can know which sound file to play.
    @IBAction func pressed(_ sender: UIButton) {
        let selectedtune = soundArray[sender.tag - 1]
        
        //log out to the console when a button pressed
        print(selectedtune)
        
        let tuneUrl = Bundle.main.url(forResource: selectedtune, withExtension: "wav")
        audioPlayer = try! AVAudioPlayer(contentsOf: tuneUrl!)
        audioPlayer.play()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecorderStopRecording"{
            let playSoundVC = segue.destination as! PitchChangeViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    


}

