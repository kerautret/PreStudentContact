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

  override func viewWillAppear(_ animated: Bool) {
    let sharedDefault = UserDefaults.standard
    let name = sharedDefault.object(forKey: "FORUM_NAME") as! String
    myNameForumLabel.text = name
    myMailField.text = sharedDefault.object(forKey: "MAIL_DEST") as? String

  }

  
  @IBAction func sendFiles(_ sender: AnyObject) {
    let sharedDefault = UserDefaults.standard
    if let listFile = sharedDefault.object(forKey: "ARRAY_SAVE") as? Array<String> {
      for file in listFile {
        print("file \(file) \n")
      }
    }
    
    let mailComposeViewController = configuredMailComposeViewController()
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposeViewController, animated: true, completion: nil)
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
    
    let data: Data? = exportListCSV(myNameForumLabel.text!)
    if data != nil {
      let d = (self.presentingViewController as! MainInputController).myDate!
      mailComposerVC.addAttachmentData(data!, mimeType: "csv", fileName: "listEtudiant_\(d).csv")
    }
    return mailComposerVC
  }
  
  
  func showSendMailErrorAlert() {
    let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email",
      message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",
      preferredStyle: UIAlertController.Style.alert )
     self.present(sendMailErrorAlert, animated: true, completion: nil)
    
  }

  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
     print("errr")
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    let sharedDefault = UserDefaults.standard
    sharedDefault.set(myNameForumLabel.text, forKey: "FORUM_NAME")
    sharedDefault.set(myMailField.text, forKey: "MAIL_DEST")

    (self.presentingViewController as! MainInputController).myForumLabel.text = myNameForumLabel.text!
    (self.presentingViewController as! MainInputController).myForumName = myNameForumLabel.text!
  }
  
  
  @IBAction func done(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func deleteAll(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
    (self.presentingViewController as! MainInputController).deleteAll()
    
  }
  
}
