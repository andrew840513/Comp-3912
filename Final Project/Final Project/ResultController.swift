//
//  ResultController.swift
//  Final Project
//
//  Created by Andrew Chen on 2017-06-06.
//  Copyright © 2017 Andrew Chen. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func discard(_ sender: Any) {
        let message = "Do you want to discard your workout? This cannot be undone."
        let alert = UIAlertController(title: "Discard your workout", message: message, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (action) -> Void in
            print("YES")
            self.dismiss(animated: true, completion: nil)
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: {(action) -> Void in})
        alert.addAction(yes)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
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
