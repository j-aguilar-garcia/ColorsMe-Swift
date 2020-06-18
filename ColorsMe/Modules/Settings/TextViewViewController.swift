//
//  TextViewViewController.swift
//  ColorsMe
//
//  Created by Juan Carlos Aguilar Garcia on 07.06.20.
//  Copyright © 2020 Juan Carlos Aguilar Garcia. All rights reserved.
//

import UIKit

class TextViewViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    fileprivate var key: String!
    var pageType: SettingsPageType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        self.downloadContent(pageType: pageType)
    }
    
    
    private func display(_ html: String) {
        let text = html.isEmpty ? key : html
        let html = Data(text!.utf8)
        if let attributedString = try? NSMutableAttributedString(data: html, options: [.documentType: NSAttributedString.DocumentType.html, ], documentAttributes: nil) {
            let range = NSMakeRange(0, attributedString.length)
            attributedString.addAttribute(.foregroundColor, value: UIColor.label, range: range)
            self.textView.attributedText = attributedString
            self.textView.scrollRangeToVisible(NSMakeRange(0, 0))
        } else {
            self.textView.text = text
        }
    }
    
    private func downloadContent(pageType: SettingsPageType) {
        switch pageType {
        case .aboutus:
            key = AppConfiguration.default.aboutUs
            let text = downloadTextFrom(url: AppConfiguration.default.aboutUsUrl)
            display(text)
        case .privacypolicy:
            key = AppConfiguration.default.privacyPolicy
            let text = downloadTextFrom(url: AppConfiguration.default.privacyPolicyUrl)
            display(text)
        }
    }
    
    private func downloadTextFrom(url: String) -> String {
        var downloadedText = ""
        let downloadUrl = URL(string: url)!

        let task = URLSession.shared.downloadTask(with: downloadUrl) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    downloadedText = string
                }
            }
        }
        
        task.resume()
        return downloadedText
    }

}
