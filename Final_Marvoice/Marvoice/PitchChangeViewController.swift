//
//  PitchChangeViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/16/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
import AVFoundation
//get all sorts of alert
enum Alerts: String {
    case dismiss = "Dismiss"
    case fileError = "Audio File Error"
    case NoError = "No Error"
}

class PitchChangeViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var original: UIButton!
    @IBOutlet weak var echo: UIButton!
    @IBOutlet weak var reverb: UIButton!
    var timer: Timer!
    var recordedAudioURL: URL!
    var engine: AVAudioEngine!
    var audioPlayer: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    var alerts: Alerts = .NoError
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
            print("audio file loaded")
        } catch {
            //there should be no error otherwise the whole system will not complete
            alerts = .fileError
            let alert = UIAlertController(title: alerts.rawValue, message: String(describing: error), preferredStyle: .alert)
            alerts = .dismiss
            alert.addAction(UIAlertAction(title: alerts.rawValue, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("record load error")
        }
    }
    //how to add effect like echo and reverb to audio player(chinese): https://www.jianshu.com/p/8acc016da423
    //add audio file or echo or reverb node to the engine
    func addNode(_ audios: AVAudioNode...) {
        for x in 0..<audios.count-1 {
            engine.connect(audios[x], to: audios[x+1], format: audioFile.processingFormat)
        }
    }
    
    // Play the music without special effects
    @IBAction func PlayOriginal(_ sender: Any) {
        // initialize audio engine
        engine = AVAudioEngine()
        // node for playing audio
        audioPlayer = AVAudioPlayerNode()
        //add audioPlayer to engine
        engine.attach(audioPlayer)
        //switch all the button
        setButtonStates(false)
        
        
        setButtonStates(false)
        // connect audios
        addNode(audioPlayer, engine.outputNode)
        // schedule to play and start the engine!
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
        
        // play the recording
        audioPlayer.play()
    }
    
    // Play the music with echo effect
    @IBAction func playEcho(_ sender: Any) {
        // initialize audio engine
        engine = AVAudioEngine()
        // node for playing audio
        audioPlayer = AVAudioPlayerNode()
        //add audioPlayer to engine
        engine.attach(audioPlayer)
        //switch all the button
        setButtonStates(false)
        
        //add echo effect
        let echo = AVAudioUnitDistortion()
        echo.loadFactoryPreset(.multiEcho1)
        engine.attach(echo)
        //switch all the button
        setButtonStates(false)
        // connect audios
        addNode(audioPlayer, echo, engine.outputNode)
        // schedule to play and start the engine!
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
        
        // play the recorded music
        audioPlayer.play()
    }
    
    // Play the muisc with reverb effect
    @IBAction func PlayReverb(_ sender: Any) {
        setButtonStates(false)
        // initialize audio engine components
        engine = AVAudioEngine()
        // node for playing audio
        audioPlayer = AVAudioPlayerNode()
        //add audioPlayer to engine
        engine.attach(audioPlayer)
        // add reverb effect
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        engine.attach(reverbNode)
        //switch all the button
        setButtonStates(false)
        
        // connect audios
        // for reverb
        addNode(audioPlayer, reverbNode, engine.outputNode)
        
        audioPlayer.stop()
        //same as above
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
        setButtonStates(false)
        // play the recording music
        audioPlayer.play()
    }
    
    
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
    @IBAction func StopPlaying(_ sender: Any) {
        //stop playing button
        stop()
    }
    //if true, the file is not playing
    func setButtonStates(_ enabled: Bool) {
        //the logic to enable certain button while playing
        original.isEnabled = enabled
        reverb.isEnabled = enabled
        echo.isEnabled = enabled
        stopButton.isEnabled = !enabled
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
