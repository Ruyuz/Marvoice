//
//  InstructionViewController.swift
//  Marvoice
//
//  Created by ruyuzhouon 3/17/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {

    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        instruction.text = "Instruction"
        textView.text = "This app has 3 functions. First it let you to catch instant inspiration by virtual chordand with special effects. Second, it helps you record sound using your device’s microphone and play it back with some different sound modulations: super slow, superfast, high pitch, low pitch, echo and reverb. It also can help you to collect music and play it!"
        // Do any additional setup after loading the view.
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
