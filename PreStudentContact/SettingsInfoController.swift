//
//  SettingsInfoController.swift
//  PreStudentContact
//
//  Created by kerautret on 14/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit
import MessageUI
import Foundation


class SettingsInfoController: UIViewController, MFMailComposeViewControllerDelegate{
  
  @IBOutlet weak var myMailField: UITextField!
  @IBOutlet weak var myNameForumLabel: UITextField!

  var myDefaultMailSubject = "liste participation forum"
  var myDefaultMailContent = "Bonjour, \n voilà la liste des inscrits... \n"

  override func viewWillAppear(animated: Bool) {
    let sharedDefault = NSUserDefaults.standardUserDefaults()
    let name = sharedDefault.objectForKey("FORUM_NAME") as! String
    myNameForumLabel.text = name
    myMailField.text = sharedDefault.objectForKey("MAIL_DEST") as? String

  }

  
  @IBAction func sendFiles(sender: AnyObject) {
    let sharedDefault = NSUserDefaults.standardUserDefaults()
    if let listFile = sharedDefault.objectForKey("ARRAY_SAVE") as? Array<String> {
      for file in listFile {
        print("file \(file) \n")
      }
    }
    
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    } else {
      self.showSendMailErrorAlert()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  
  func configuredMailComposeViewController() -> MFMailComposeViewController {
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients([myMailField.text!])
    mailComposerVC.setSubject(myDefaultMailSubject)
    mailComposerVC.setMessageBody("", isHTML: false)
    
    let data: NSData? = exportListCSV(myNameForumLabel.text!)
    if data != nil {
      let d = (self.presentingViewController as! MainInputController).myDate
      mailComposerVC.addAttachmentData(data!, mimeType: "csv", fileName: "listEtudiant_\(d).csv")
    }
    return mailComposerVC
  }
  
  
  func showSendMailErrorAlert() {
    let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email",
      message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
      preferredStyle: UIAlertControllerStyle.Alert )
     self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    
  }

  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    controller.dismissViewControllerAnimated(true, completion: nil)
     print("errr")
  }
  
  
  override func viewWillDisappear(animated: Bool) {
    let sharedDefault = NSUserDefaults.standardUserDefaults()
    sharedDefault.setObject(myNameForumLabel.text, forKey: "FORUM_NAME")
    sharedDefault.setObject(myMailField.text, forKey: "MAIL_DEST")

    (self.presentingViewController as! MainInputController).myForumLabel.text = myNameForumLabel.text!
    (self.presentingViewController as! MainInputController).myForumName = myNameForumLabel.text!
  }
  
  
  @IBAction func done(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}