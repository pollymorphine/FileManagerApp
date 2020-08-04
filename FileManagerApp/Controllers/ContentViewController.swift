//
//  ContentViewController.swift
//  FileManagerApp
//
//  Created by Polina on 28.07.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    var content: String!
    var fileTitle: String!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = content
        self.navigationItem.title = fileTitle
    }
}
