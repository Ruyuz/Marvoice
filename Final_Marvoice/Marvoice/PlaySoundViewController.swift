//
//  PlaySoundViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/12/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var SlowButton: UIButton!
    @IBOutlet weak var FastButton: UIButton!
    @IBOutlet weak var HighPitchButton: UIButton!
    @IBOutlet weak var ReverbButton: UIButton!
    @IBOutlet weak var EchoButton: UIButton!
    @IBOutlet weak var SlowPitchButton: UIButton!
    // A timer that fires after a certain time interval has elapsed, sending a specified message to a target object.
    var timer: Timer!
    var recordedAudioURL: URL!
    var engine: AVAudioEngine!
    var audioPlayer: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    var alerts: Alerts = .NoError
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
        } catch {
            //same as pitchChangeViewController
            alerts = .fileError
            let alert = UIAlertController(title: alerts.rawValue, message: String(describing: error), preferredStyle: .alert)
            alerts = .dismiss
            alert.addAction(UIAlertAction(title: alerts.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("record load error")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //if true, the file is not playing
    func setButtonStates(_ enabled: Bool) {
        SlowButton.isEnabled = enabled
        HighPitchButton.isEnabled = enabled
        FastButton.isEnabled = enabled
        SlowPitchButton.isEnabled = enabled
        EchoButton.isEnabled = enabled
        ReverbButton.isEnabled = enabled
        StopButton.isEnabled = !enabled
    }
    // use tag attribute to distinguish which button are pressed
    // Attribution: https://gist.github.com/dhavaln/2021993bbbbe8a9a0934
    @IBAction func playSoundForButton(_ sender: UIButton) {
        print(sender.tag)
        switch(sender.tag) {
        case 1:
            playSound(rate: 1.5)
        case 0:
            playSound(rate: 0.5)
        case 2:
            playSound(pitch: 1200)
        case 3:
            playSound(pitch: -1000)
        case 5:
            playSound(echo: true)
        case 4:
            playSound(reverb: true)
        default:
            playSound(rate: 1.5)
        }
        setButtonStates(false)
    }
    
    @IBAction func stopSoundPressed(_ sender: AnyObject) {
        if let engine = engine {
            engine.stop()
            engine.reset()
        }
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
        }
        if let timer = timer {
            timer.invalidate()
        }
        setButtonStates(true)
    }
    
    func addNode(_ audios: AVAudioNode...) {
        for x in 0..<audios.count-1 {
            engine.connect(audios[x], to: audios[x+1], format: audioFile.processingFormat)
        }
    }
    
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        engine = AVAudioEngine()
        audioPlayer = AVAudioPlayerNode()
        engine.attach(audioPlayer)
        
        // adjusting rate/pitch: https://stackoverflow.com/questions/32294934/pitch-shifting-in-real-time-with-avaudioengine-using-swift
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        engine.attach(changeRatePitchNode)
        
        // add echo effect
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        engine.attach(echoNode)
        
        // add reverb effect
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        engine.attach(reverbNode)
        
        //if echo = true, add echo to the engine
        if echo == true {
            addNode(audioPlayer, changeRatePitchNode, echoNode, engine.outputNode)
        }
        //if reverb = true, add reverb to the engine
        else if reverb == true {
            addNode(audioPlayer, changeRatePitchNode, reverbNode, engine.outputNode)
        }
        //otherwise just change rate and pitch
        else {
            addNode(audioPlayer, changeRatePitchNode, engine.outputNode)
        }
        
        //schedule file
        audioPlayer.stop()
        //how to handle audio file: https://stackoverflow.com/questions/43256549/how-to-set-a-completionhandler-for-avaudioengine
        audioPlayer.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayer.lastRenderTime, let playerTime = self.audioPlayer.playerTime(forNodeTime: lastRenderTime) {
                delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
            }
            // use timer to control when to stop
            // Reference: https://www.jianshu.com/p/f509bd4304e1
            self.timer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(PitchChangeViewController.stop), userInfo: nil, repeats: false)
            RunLoop.main.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        do {
            try engine.start()
        } catch {
            let alert = UIAlertController(title: title, message: String(describing: error), preferredStyle: .alert)
            alerts = .dismiss
            alert.addAction(UIAlertAction(title: alerts.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // play the recording!
        audioPlayer.play()
    }
    //stop playing
    @objc func stop() {
        //reverse all the button enable status
        setButtonStates(true)
        if let timer = timer {
            timer.invalidate()
        }
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
        }
        
        if let engine = engine {
            engine.stop()
            engine.reset()
        }
    }
    
    
    
}




