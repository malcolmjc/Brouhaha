//
//  AddPostViewController.swift
//  Brouhaha
//
//  Created by Malcolm Craney on 3/2/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddPostViewController: UIViewController, UITextViewDelegate {
    var header: String!
    var groupName: String!
    var subgroupName: String!
    let textColor = UIColor.white
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var databaseRef: DatabaseReference!
    
    func setupTextView() {
        textView.delegate = self
        textView.text = "Message goes here..."
        textView.textColor = textColor
        textView.layer.cornerRadius = 14
        textView.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("Groups").child(groupName)
            .child("subgroups").child(subgroupName)
        
        groupTitleLabel.text = header
        setupTextView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    var cancelled = false
    @IBAction func submitPressed(_ sender: Any) {
        if !textView.text!.isEmpty {
            let newPost = TextPost(textView.text)
            let newPostRef = databaseRef.child("posts").child(newPost.dateCreated)
            newPostRef.setValue(newPost.toAnyObject())
            performSegue(withIdentifier: "unwindToPosts", sender: self)
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        cancelled = true
        performSegue(withIdentifier: "unwindToPosts", sender: self)
    }
}
