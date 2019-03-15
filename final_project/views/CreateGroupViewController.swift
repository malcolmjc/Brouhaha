//
//  CreateGroupViewController.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var groupField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = "Group description..."
        textView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Group description..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    var cancelled = false

    @IBAction func submitPressed(_ sender: Any) {
        if !groupField.text!.isEmpty {
            performSegue(withIdentifier: "unwindToExplore", sender: self)
        }
        
        else {
            groupField.placeholder = "Must have a name!"
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        cancelled = true
        performSegue(withIdentifier: "unwindToExplore", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToExplore" {
            let destVC = segue.destination as? ExploreViewController
            if (!cancelled) {
                //TODO - append group datatype instead w/ title and description
                destVC?.groupList.append(Group(groupField.text!, textView.text!))
            }
        }
    }
    
}
