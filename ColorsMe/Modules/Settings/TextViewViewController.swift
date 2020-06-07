//
//  TextViewViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit
import Firebase

class TextViewViewController: UIViewController {

        @IBOutlet weak var textView: UITextView!
        
        var remoteConfig: RemoteConfig!
        
        var key: String!
        
        override func viewDidLoad() {
            super.viewDidLoad()

            navigationController?.navigationItem.largeTitleDisplayMode = .always
            self.textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            self.display()
        }
        
        
        private func display() {
            let text = remoteConfig[key].stringValue
            let html = Data(text!.utf8)
            print("remoteConfig Text = \(String(describing: text))")
            if let attributedString = try? NSMutableAttributedString(data: html, options: [.documentType: NSAttributedString.DocumentType.html, ], documentAttributes: nil) {
                print("remotConfig Text attributedString = \(attributedString)")

                let range = NSMakeRange(0, attributedString.length)
                attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: range)
                self.textView.attributedText = attributedString
                self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
            } else {
                self.textView.text = text
            }
        }
        

    }
