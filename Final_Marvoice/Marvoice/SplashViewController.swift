//
//  SplashViewController.swift
//  Marvoice
//
//  Created by ruyuzhou on 3/16/18.
//  Copyright © 2018 ruyuzhou. All rights reserved.
//

import UIKit
//splash view
class SplashViewController: UIViewController {

    //
    // MARK: - Properties
    //
    var autoDismiss = false
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBAction func tapContinue(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //
    // MARK: - Lifecyle
    //
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        
        // If auto-dismissing hide the button and rely on tap to dismiss
        if self.autoDismiss {
            self.dismissButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.dismiss(animated: true, completion: {
                    print("done")
                })
            }
        }
    }

}
