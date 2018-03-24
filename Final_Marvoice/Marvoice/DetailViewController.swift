//
//  DetailViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/14/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
//
class DetailViewController: UIViewController,AVAudioPlayerDelegate{
    var audioPlayer:AVAudioPlayer! = nil
    var currentAudio = ""
    var currentAudioPath:URL!
    var audioList:NSArray!
    var currentAudioIndex = 0
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepare audio file
        prepareAudio()
        play("" as AnyObject)
        print(audioList)
        print(currentAudioIndex)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //get the passed data
    func set(audioList: NSArray, currentAudioIndex: Int) {
        self.audioList = audioList
        self.currentAudioIndex = currentAudioIndex
    }
    //find the audio according to audioList and currentAudioIndex
    func prepareAudio(){
        //save the chosen audio info
        var songNameDict = NSDictionary();
        songNameDict = audioList.object(at: currentAudioIndex) as! NSDictionary
        print(songNameDict)
        currentAudio = songNameDict.value(forKey: "songName") as! String
        currentAudioPath = URL(fileURLWithPath: Bundle.main.path(forResource: currentAudio, ofType: "mp3")!)
        let img = songNameDict.value(forKey: "picture")
        self.image.image = UIImage(named: img as! String)!
        print("\(currentAudioPath)")
        do {
            //keep alive audio at background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            print("AVAudioSession Failed")
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        audioPlayer = try? AVAudioPlayer(contentsOf: currentAudioPath)
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        
        
    }
    //responsible for playing the previous song
    @IBAction func playPrevious(_ sender: Any) {
        currentAudioIndex -= 1
        if currentAudioIndex<0{
            //use alert here to remind the user this is the first song
            let alert = UIAlertController(title: "This is our first song", message: "You have reached the head of our play list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //recover currentAudioIndex to zero otherwise it will be -1 and the next time we use play next button, we will need to press twice.
            currentAudioIndex += 1
            return
        }
        if audioPlayer.isPlaying{
            prepareAudio()
            audioPlayer.play()
        }else{
            prepareAudio()
        }
    }
    //responsible for playing the next song
    @IBAction func playNext(_ sender: Any) {
        //turn to the next audio
        currentAudioIndex += 1
        if currentAudioIndex>audioList.count-1{
            //use alert here to remind the user this is the last song
            let alert = UIAlertController(title: "No More Songs", message: "You have reached the end of our play list", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //same reason as playPrevios
            currentAudioIndex -= 1
            return
        }
        if audioPlayer.isPlaying{
            prepareAudio()
            audioPlayer.play()
        }else{
            prepareAudio()
        }
    }
    //for play
    @IBAction func play(_ sender : AnyObject) {
        print("play button pressed")
        let play = UIImage(named: "play")
        let pause = UIImage(named: "pause")
        if audioPlayer.isPlaying{
            audioPlayer.pause()
            //if pause the song, the button should change to pause button
            if audioPlayer.isPlaying {playButton.setImage( pause, for: UIControlState())}
            else {playButton.setImage(play , for: UIControlState())}
            
        }else{
            
            //while playing the song, the button should change to play button
            audioPlayer.play()
            if audioPlayer.isPlaying {playButton.setImage( pause, for: UIControlState())}
            else{playButton.setImage(play , for: UIControlState())}
        }
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
