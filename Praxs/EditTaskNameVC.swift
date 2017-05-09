//
//  editTaskNameVC.swift
//  prouks
//
//  Created by Arnaud on 2017-04-14.
//  Copyright © 2017 arnaud. All rights reserved.
//

import UIKit

class EditTaskNameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    var dateFormatter = DateFormatter()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        var frameRect:CGRect = nameField.frame;
//        frameRect.size.height = 80;
//        nameField.frame = frameRect;
        nameField.becomeFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        validateButton.setTitleColor(UIColor.cyan,for:.normal)
        return true
    }
    @IBAction func validate(_ sender: Any) {
        self.performSegue(withIdentifier: "returnName", sender:self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "returnName") {
            let taskVC = segue.destination as!TaskVC;
            if let theNewTitle = nameField.text {
                taskVC.task.name = theNewTitle.capitalized
                taskVC.tableView.reloadData()
            }
        }
        else{
//            self.shake
        }
    }
 
}
