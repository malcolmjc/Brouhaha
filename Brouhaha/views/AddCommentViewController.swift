//
//  AddCommentViewController.swift
//  Brouhaha
//
//  Created by Malcolm Craney on 3/4/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AddCommentViewController: UIViewController, UITextViewDelegate {
    var header: String!
    var postToCommentOn: TextPost!
    var groupTitle: String?
    let textColor = UIColor.white
    
    @IBOutlet weak var previousMessageLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var databaseRef: DatabaseReference!
    
    func setupTextView() {
        textView.delegate = self
        textView.text = "Add your comment here"
        textView.textColor = textColor
        textView.layer.cornerRadius = 14
        textView.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("Groups").child(groupTitle!)
            .child("posts").child(postToCommentOn.dateCreated)
        
        previousMessageLabel.text = "Previous Post: " + postToCommentOn.content
        setupTextView()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
    }
    
    var newPost: TextPost?
    var cancelled = false
    
    @IBAction func cancelPressed(_ sender: Any) {
        cancelled = true
        performSegue(withIdentifier: "unwindToPostDetail", sender: self)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if !textView.text!.isEmpty {
            newPost = TextPost(textView.text)
            let newPostRef = databaseRef.child("comments").child(newPost!.dateCreated)
            newPostRef.setValue(newPost?.toAnyObject())
            performSegue(withIdentifier: "unwindToPostDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToPostDetail" {
            let destVC = segue.destination as? PostDetailView
            if !cancelled {
                destVC?.commentList.append(newPost!)
            }
        }
    }
}
