//
//  CreateGroupViewController.swift
//  Brouhaha
//
//  Created by Malcolm Craney on 3/2/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateGroupViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var groupField: UITextField!
    @IBOutlet weak var textView: UITextView!
    let textColor = UIColor.white
    
    var databaseRef: DatabaseReference!
    
    func setupTextView() {
        textView.delegate = self
        textView.text = "Group description goes here..."
        textView.textColor = textColor
    }
    
    var supergroupName: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("Groups").child(supergroupName).child("subgroups")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    var cancelled = false
    
    var newGroup: Subgroup?

    @IBAction func submitPressed(_ sender: Any) {
        if !groupField.text!.isEmpty {
            newGroup = Subgroup(groupField.text!, textView.text!)
            let newGroupRef = databaseRef.child(groupField.text!)
            newGroupRef.setValue(newGroup!.toAnyObject())
            
            performSegue(withIdentifier: "unwindToGroup", sender: self)
        } else {
            groupField.placeholder = "Must have a name!"
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        cancelled = true
        performSegue(withIdentifier: "unwindToGroup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToGroup" {
            let destVC = segue.destination as? GroupViewController
            if !cancelled {
                destVC?.subgroupList.append(newGroup!)
            }
        }
    }
}
