//
//  MusicTableViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/14/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class MusicTableViewController: UITableViewController, AVAudioPlayerDelegate {
    
    var currentAudio = ""
    var currentAudioPath:URL!
    //here I use a NSArray to read the list.plist file regard to all the info of a list of music in the following structure:
    //class music
    //  songName : String
    //  picture: String
    //  singer: String
    var audioList:NSArray!
    var currentAudioIndex = 0
    var audioPlayer:AVAudioPlayer! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        //load the list of music from plist
        //https://stackoverflow.com/questions/39910461/how-to-read-from-a-plist-with-swift-3-ios-app
        let path = Bundle.main.path(forResource: "list", ofType: "plist") 
        print(path as Any)
        audioList = NSArray(contentsOfFile:path!)
        do {
            //check content of the path
            let content = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            print(content)
        } catch {
            print("...nil")
        }
    }
    
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        var musicDict = NSDictionary();
        musicDict = audioList.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let songName = musicDict.value(forKey: "songName") as! String
        let singer = musicDict.value(forKey: "singer") as! String
        let photo = musicDict.value(forKey: "picture") as! String
        
        print(photo)
        print(songName)
        print(singer)
        let cellIdentifier = "MusicTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MusicCell.")
        }
        //assign image title and singer
        cell.songName.text = songName
        cell.singer.text = singer
        let image : UIImage = UIImage(named:photo)!
        print(image)
        cell.cover.image = image
        return cell
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    //pass the audio list and current audio index to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let editor = segue.destination as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            editor.set(audioList: audioList!, currentAudioIndex: indexPath.row)
        }
        
    }
    
    
    


}
