//
//  SoundRecordViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/12/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
import AVFoundation

// Record sound and send to PlaySoundViewController.
class SoundRecordViewController: UIViewController, AVAudioRecorderDelegate{
    var audioRecorder : AVAudioRecorder!
    
    @IBOutlet weak var Record: UIButton!
    @IBOutlet weak var StopRecord: UIButton!
    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Label.text = "Begin Record"
        
        // set record button enabled and stop button disabled
        StopRecord.isEnabled = false
        Record.isEnabled = true
    }    
    
    //stop the recording process
    @IBAction func Stop(_ sender: Any) {
        
        Label.text = "Begin Record"
        
        // After recording done, Record Button is not enabled, while StopRecord Button isn enabled.
        Record.isEnabled = true
        StopRecord.isEnabled = false
        audioRecorder.stop()
        //create audio session
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    //begin to record sound and save sound locally
    @IBAction func record(_ sender: Any) {
        Label.text = "Recording..."
        
        // In recording process, Record Button is not enabled, while StopRecord Button isn enabled.
        Record.isEnabled = false
        StopRecord.isEnabled = true
        
        // Creates a list of path strings for the specified directories in the specified domains.
        // Attribution: https://developer.apple.com/documentation/foundation/1414224-nssearchpathfordirectoriesindoma?language=objc
        let pathString = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //how to save recorded file: https://stackoverflow.com/questions/39433639/how-to-save-recorded-audio-ios
        //sound title
        let recordTitle = "recordedSound.wav"
        //create an array for joining path name
        let pathArray = [pathString, recordTitle]
        let fileUrl = URL(string: pathArray.joined(separator: "/"))
        //create a audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        //assign audioRecorder and let it record
        try! audioRecorder = AVAudioRecorder(url: fileUrl!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        //prepare to record
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // If AVAudioRecorder finish recording successfully, prepare playSoundVC for PlaySoundViewController
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("stop recording succefully")
            performSegue(withIdentifier: "StopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording not finished")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // send recorded sound to PlaySoundViewController and assign the sound file to playSoundVC.recordedAudioURL
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording"{
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}


