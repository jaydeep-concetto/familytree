//
//  AboutusViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 02/02/17.
//  Copyright © 2017 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
class AboutusViewController: UIViewController,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var lblmain: UILabel!
    var mainsubject:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
       // let build = dictionary["CFBundleVersion"] as! String
        lblmain.text = "Family Tree \(version)"
        toolbarview.backgroundColor = GlobalConstants.toolbar1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnbackclicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnrateclicked(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string:"https://itunes.apple.com/us/app/apple-store/id1204696872?mt=8")!)
    }
    @IBAction func btnfeedbackclicked(_ sender: UIButton) {
        mainsubject = "Feedback (Ios App)"
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func btnrequestclicked(_ sender: UIButton) {
        mainsubject = "Request a Feature (Ios App)"
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    @IBAction func btnlinkclicked(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string:"https://www.concettolabs.com")!)
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info@concettolabs.com"])
        mailComposerVC.setSubject(mainsubject)
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
