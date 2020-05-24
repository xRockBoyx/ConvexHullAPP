//
//  RootViewController.swift
//  ConvexHull
//
//  Created by 黃威愷 on 2020/5/24.
//  Copyright © 2020 iOSClub. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var input:UITextField!
    @IBOutlet weak var Titlelabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if input.text == nil{
            Titlelabel.text = "輸入值不能為空！"
        }else{
            performSegue(withIdentifier: "next", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next"{
            let destVC = segue.destination as! ConvexHullViewController
            destVC.max_points = Int(input.text!)!
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
