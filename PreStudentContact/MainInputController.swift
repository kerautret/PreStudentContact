//
//  ViewController.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit
import Foundation


extension String{
  func cleanPonctuation() -> String {
    var newString = self.replacingOccurrences(of: ",", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "'", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "\"", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "$", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: "&", with: " ", options: NSString.CompareOptions.literal, range: nil)
    newString = newString.replacingOccurrences(of: ";", with: " ", options: NSString.CompareOptions.literal, range: nil)
    return newString
  }
  
}


class MainInputController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
  
  var myPasswordDelete = "Forum2016"
  var myListOfClassesOptions = [["--------","DUT", "BTS", "Licence", "Autre"],
    ["--------","Informatique", "Langue,Communication",  "Medias", "Autres"]]
  
  let myKeyboardShift = CGFloat(-0.1*UIScreen.main.bounds.height)
  let myKeyboardLargeShift = CGFloat(-0.4*UIScreen.main.bounds.height)

  var myTabEtudians = [Etudiant]()
  var myIsEditing = false
  let myColorActive = UIColor.white
  let myColorInActive = UIColor.lightGray
  let myColorBGViewActive = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
  let myColorBGViewInActive = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
  var myCurrentDisplayStudent = 0
  var myIsInHistory = false
  var myCurrentStudent: Etudiant?
  var myEmailExport : String?
  var myForumName: String = "ForumNoName"
  var myDate: String?
  var myDateM1: String?
  var myHistoryMode: Bool = false
  var myInterfaceIsShifted: Bool = false
  var myIsAcceptSel: Bool = false
  
  @IBOutlet var myInterfaceView: UIView!
  @IBOutlet var myNameField: UITextField!
  @IBOutlet weak var myLastNameField: UITextField!
  @IBOutlet weak var myOptionField: UITextField!
  
  @IBOutlet weak var myClassePickView: UIPickerView!
  @IBOutlet weak var myHeureCreation: UILabel!
  
  @IBOutlet weak var myInscriptionDateLabel: UILabel!
  @IBOutlet weak var myForumLabel: UILabel!
  @IBOutlet weak var myIdStudent: UILabel!
  @IBOutlet weak var myTotalSaved: UILabel!
  @IBOutlet weak var myTotalSavedDay: UILabel!
  @IBOutlet weak var myTotalSaveDayM1: UILabel!
  @IBOutlet weak var myScoreLabelInfo: UILabel!
  @IBOutlet weak var myScoreLabelGEII: UILabel!
  @IBOutlet weak var myScoreLabelMMI: UILabel!
  
  @IBOutlet weak var myTownField: UITextField!
  @IBOutlet weak var myEmailField: UITextField!
  @IBOutlet weak var myPhoneField: UITextField!
  @IBOutlet weak var mySaveButton: UIButton!
  @IBOutlet weak var myDeptField: UITextField!
  @IBOutlet weak var myRemarqueField: UITextView!

  var myPasswordTextField: UITextField?
  
  @IBOutlet weak var myEditButton: UIButton!
  @IBOutlet weak var myPrecButton: UIButton!
  @IBOutlet weak var mySuivButton: UIButton!
  @IBOutlet weak var mySaveModifs: UIButton!
  @IBOutlet weak var myCancelButton: UIButton!
  
  @IBOutlet weak var myDeleteButton: UIButton!
  
  @IBOutlet weak var myHistoryButton: UIButton!
  @IBOutlet weak var myDUCCI1Button: UIButton!
  @IBOutlet weak var myDUCCI2Button: UIButton!
  @IBOutlet weak var myDUI3DButton: UIButton!
  @IBOutlet weak var myDULDButton: UIButton!

  @IBOutlet weak var myAcceptButton: UIButton!
  @IBOutlet weak var myM2CIMButton: UIButton!
  @IBOutlet weak var myM2InfoButton: UIButton!
 
  
  @IBOutlet weak var myNewsLetterButton: UIButton!
  
  var myIsDUCCI1Sel: Bool = false
  var myIsDUCCI2Sel: Bool = false
  var myIsDUI3DSel: Bool = false
  var myIsDULDSel: Bool = false
  var myIsM2CIMSel: Bool = false
  var myIsM2InfoSel: Bool = false
  var myIsNewLetterSel: Bool = true
  
  func getIndex(_ aName: String)-> Int?{
    //searching index
    for list in  myListOfClassesOptions {
      var pos = 0
      for n in list {
        if n == aName {
          return pos
        }
        pos += 1
      }
    }
    
    return nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tapReco = UITapGestureRecognizer(target: self, action: #selector(MainInputController.dismissKeyboard))
    self.view.addGestureRecognizer(tapReco)
    loadDate()
    
    
    // Recover the tab of all students:
    myClassePickView.dataSource = self
    myClassePickView.delegate = self
    myCurrentStudent = Etudiant(aName: "--", aLastName: "--", aClass: "--", aSpe: "--", aTown: "--",
      aForumInscription: myForumName, aDateInscription: myDate!)
    myCurrentStudent?.myM2Project = [String]()
    myCurrentStudent?.myDUProject = [String]()
    
    updateStudent(myCurrentStudent!)
    myNameField.delegate = self
    myLastNameField.delegate = self
    myOptionField.delegate = self
    myTownField.delegate = self
    myPhoneField.delegate = self
    myDeptField.delegate = self
    myEmailField.delegate = self
    myRemarqueField.delegate = self
    let sharedDefault = UserDefaults.standard
    myForumName = sharedDefault.object(forKey: "FORUM_NAME") as! String
    myTabEtudians = recoverTableauEtudiant(myForumName)
    myInscriptionDateLabel.text = myDate
    updateInterfaceState()
    updateDisplayWithEtudiant(myCurrentStudent!)
    myForumLabel.text = myForumName
    
    NotificationCenter.default.addObserver(self, selector: #selector(MainInputController.keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func loadPrevious(_ sender: UIButton) {
    if myCurrentDisplayStudent == 0 {
      updateStudent(myCurrentStudent!)
    }
    if myCurrentDisplayStudent != myTabEtudians.count  {
      myCurrentDisplayStudent += 1
    }
    myIsEditing = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
  }
  
  @IBAction func loadNext(_ sender: AnyObject) {
    if myCurrentDisplayStudent == 0 {
      return
    }
    
    if myCurrentDisplayStudent != 1{
      myCurrentDisplayStudent -= 1
      myIsEditing = false
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
      myEditButton.isHidden = false
      myCancelButton.isHidden = false
      mySaveButton.isHidden = true
    }else{
      myCurrentDisplayStudent -= 1
      myIsEditing = true
      updateDisplayWithEtudiant(myCurrentStudent!)
    }
    updateInterfaceState()
  }
  
  
  func loadDate(){
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "dd_MM_yyyy"
    
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let dateM1 = (calendar as NSCalendar?)?.date(byAdding: NSCalendar.Unit.day, value: -1, to: Date(), options: NSCalendar.Options())
    
    myDate =  "\(dateFormater.string(from: Date()))"
    myDateM1 =  "\(dateFormater.string(from: dateM1!))"
    
    
  }
  
  func updateStudent(_ aStudent: Etudiant){
    aStudent.myName = myNameField.text!.cleanPonctuation()
    aStudent.myLastName = myLastNameField.text!.cleanPonctuation()
    aStudent.myClass = myListOfClassesOptions[0][myClassePickView.selectedRow(inComponent: 0)]
    aStudent.mySpe = myListOfClassesOptions[1][myClassePickView.selectedRow(inComponent: 1)]
    aStudent.myTown = myTownField.text!.cleanPonctuation()
    if myDeptField.text != ""{
      aStudent.myDept = (Int) (NSString(string: myDeptField.text!).intValue)
    }
    aStudent.myRemarque = myRemarqueField.text
    aStudent.myEmail = myEmailField.text!.cleanPonctuation()
    aStudent.myTel = myPhoneField.text!.cleanPonctuation()
    aStudent.myDUProject?.removeAll()
    aStudent.myM2Project?.removeAll()
    
    if myIsDUCCI1Sel {
      aStudent.myDUProject?.append("DUCCI1")
    }
    if myIsDUCCI2Sel {
      aStudent.myDUProject?.append("DUCCI2")
    }
    if myIsDUI3DSel {
      aStudent.myDUProject?.append("DUI3D")
    }
    if myIsDULDSel {
      aStudent.myDUProject?.append("DULD")
    }
    if myIsM2CIMSel {
      aStudent.myM2Project?.append("M2CIM")
    }
    if myIsM2InfoSel {
      aStudent.myM2Project?.append("M2INFO")
    }
   
    aStudent.myNewsLetter = myIsNewLetterSel
    aStudent.myDateInscription = myDate!
    aStudent.myForumInscription = myForumName
    aStudent.myOption = myOptionField.text
    
  }
  
  
  func eraseFields(){
    myNameField.text = ""
    myLastNameField.text = ""
    myTownField.text =  ""
    myEmailField.text = ""
    myRemarqueField.text = ""
    myPhoneField.text =  ""
    myOptionField.text = ""
    myDeptField.text = ""
    myIsM2InfoSel = false
    myIsDULDSel = false
    myIsDUI3DSel = false
    myIsM2CIMSel = false
    myIsDUCCI1Sel = false
    myIsDUCCI2Sel = false
    myIsNewLetterSel = true
    updateOrientationButtonState()
    myClassePickView.selectRow(0, inComponent: 0, animated: true)
    myClassePickView.selectRow(0, inComponent: 1, animated: true)
  }
  
  
  @IBAction func saveData(_ sender: UIButton) {
    updateStudent(myCurrentStudent!)
    addEtudiant(myCurrentStudent!)
    eraseFields()
    myCurrentStudent = Etudiant(other: myCurrentStudent!)
    myTabEtudians.append(Etudiant(other: myCurrentStudent!))
    updateStudent(myCurrentStudent!)
    updateDisplayWithEtudiant(myCurrentStudent!)
  }
  
  
  @IBAction func cancel(_ sender: AnyObject) {
    myIsEditing = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
  }
  
  @IBOutlet weak var cancel: UIButton!
  //-----------------------
  // Processing display:
  
  
  
  func updateInterfaceState(){
    updateOrientationButtonState()
    updateScore()
    myClassePickView.isUserInteractionEnabled = myIsEditing
    myLastNameField.isEnabled = myIsEditing
    myNameField.isEnabled = myIsEditing
    myPhoneField.isEnabled = myIsEditing
    myTownField.isEnabled = myIsEditing
    myEmailField.isEnabled = myIsEditing
    myRemarqueField.isEditable = myIsEditing
    myDeptField.isEnabled = myIsEditing
    myOptionField.isEnabled = myIsEditing
    myDUI3DButton.isEnabled = myIsEditing
    myDUCCI1Button.isEnabled = myIsEditing
    myDUCCI2Button.isEnabled = myIsEditing
    myM2InfoButton.isEnabled = myIsEditing
    myDULDButton.isEnabled = myIsEditing
    myNewsLetterButton.isEnabled = myIsEditing
    myM2CIMButton.isEnabled = myIsEditing
    
    let colorBg: UIColor = myIsEditing ? myColorActive : myColorInActive
    myLastNameField.backgroundColor = colorBg
    myNameField.backgroundColor = colorBg
    myPhoneField.backgroundColor = colorBg
    myTownField.backgroundColor = colorBg
    myEmailField.backgroundColor = colorBg
    myRemarqueField.backgroundColor = colorBg
    myDeptField.backgroundColor = colorBg
    myOptionField.backgroundColor = colorBg
    mySaveButton.isHidden = !myIsEditing || myCurrentDisplayStudent != 0 || myHistoryMode || !checkOKSaving()
    myEditButton.isHidden = myCurrentDisplayStudent == 0
    
    myPrecButton.isHidden =  myCurrentDisplayStudent == myTabEtudians.count || myTabEtudians.count == 0 || !myHistoryMode
    mySuivButton.isHidden = myCurrentDisplayStudent <= 1 || myTabEtudians.count == 1 || !myHistoryMode
    myEditButton.isHidden = myIsEditing
    mySaveModifs.isHidden = !myIsEditing || myCurrentDisplayStudent == 0
    myCancelButton.isHidden = myCurrentDisplayStudent == 0 || !myIsEditing
    myDeleteButton.isHidden =  myCurrentDisplayStudent == 0 || !myIsEditing
    let colorBgView: UIColor = myIsEditing ? myColorBGViewActive : myColorBGViewInActive
    myInterfaceView.backgroundColor = colorBgView

  }
  
  
  func updateScore(){
    myTotalSavedDay.text = "\(getNumberStudentToday().0)"
    myTotalSaveDayM1.text = "\(getNumberStudentToday().1)"
    let score = getScore()
    myScoreLabelInfo.text = "DU: \(score.0) (\(score.3))"
    myScoreLabelMMI.text = "M2: \(score.1) (\(score.4))"
    myScoreLabelInfo.textColor = score.0 >= score.1 && score.0 >= score.2 ? UIColor.blue : UIColor.gray
    myScoreLabelMMI.textColor = score.1 >= score.0 && score.1 >= score.2 ? UIColor.blue : UIColor.gray
    myScoreLabelInfo.textColor = score.3 >= score.4 && score.3 >= score.5 ? UIColor.blue : UIColor.gray
    myScoreLabelMMI.textColor = score.4 >= score.3 && score.4 >= score.5 ? UIColor.blue : UIColor.gray

  }
  
  
  
  func updateDisplayWithEtudiant(_ unEtudiant: Etudiant){
    myNameField.text = unEtudiant.myName
    myLastNameField.text = unEtudiant.myLastName
    myTownField.text = unEtudiant.myTown
    myDeptField.text = unEtudiant.myDept == nil ? "" : "\(unEtudiant.myDept!)"
    myEmailField.text = unEtudiant.myEmail
    myRemarqueField.text = unEtudiant.myRemarque
    myPhoneField.text = unEtudiant.myTel
    myIdStudent.text = unEtudiant.myCreationDate
    myHeureCreation.text = unEtudiant.myHeureCreation
    myTotalSaved.text = "\(myTabEtudians.count)"
    let indexClass: Int? = getIndex(unEtudiant.myClass)
    let indexSpe: Int? = getIndex(unEtudiant.mySpe)
    myIsDUCCI2Sel = unEtudiant.myDUProject!.contains("DUCCI2")
    myIsDUCCI1Sel = unEtudiant.myDUProject!.contains("DUCCI1")

    myIsM2CIMSel = unEtudiant.myM2Project!.contains("M2CIM")
    myIsDULDSel = unEtudiant.myM2Project!.contains("DULD")
    myIsDUI3DSel = unEtudiant.myM2Project!.contains("DUI3D")
    myIsM2InfoSel = unEtudiant.myM2Project!.contains("M2INFO")
    myIsNewLetterSel = unEtudiant.myNewsLetter
    myClassePickView.selectRow(indexClass != nil ? indexClass! : 0, inComponent: 0, animated: true)
    myClassePickView.selectRow(indexSpe != nil ? indexSpe! : 0, inComponent: 1, animated: true)
    myForumLabel.text = unEtudiant.myForumInscription
    myInscriptionDateLabel.text = unEtudiant.myDateInscription
    myOptionField.text = unEtudiant.myOption
    
    updateInterfaceState()
    updateOrientationButtonState()
    myEditButton.isHidden = true

  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    updateInterfaceState()
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int{
    if pickerView.tag == 0
    {
      return 2
    }
    else
    {
      return 1
    }
  }
  
  func pickerView(_ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int) -> Int{
      if pickerView.tag == 0
      {
        return myListOfClassesOptions[component].count
      }
      return 0
  }
  
  func pickerView(_ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int) -> String?{
      if pickerView.tag == 0
      {
        return myListOfClassesOptions[component][row]
      }
      return "---"
  }
  
  
  @IBAction func edit(_ sender: AnyObject) {
    myIsEditing = true
    updateInterfaceState()
  }
  
  @IBAction func saveModifs(_ sender: AnyObject){
    myIsEditing = false
    updateStudent(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
    saveListEtud(myTabEtudians)
  }
  
  func textFieldDidBeginEditing(_ textField : UITextField){
    
  }
  
  func textFieldShouldBeginEditing(){
    
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateInterfaceState()
    textField.resignFirstResponder()
  }
  
  
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.8)
      self.view.transform = CGAffineTransform(translationX: 0, y: UIApplication.shared.statusBarOrientation.isLandscape ? myKeyboardLargeShift: myKeyboardLargeShift*0.7)
      UIView.commitAnimations()
      myInterfaceIsShifted = true
    
     return true
  }
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    if myInterfaceIsShifted {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.8)
      self.view.transform = CGAffineTransform(translationX: 0, y: 0)
      UIView.commitAnimations()
      myInterfaceIsShifted = false
    }
    return true
  }
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if UIApplication.shared.statusBarOrientation.isLandscape {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.2)
      self.view.transform = CGAffineTransform(translationX: 0, y: myKeyboardShift)
      UIView.commitAnimations()
      myInterfaceIsShifted = true
    }
    return true
  }
//  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//    if myInterfaceIsShifted {
//      UIView.beginAnimations("registerScroll", context: nil)
//      UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
//      UIView.setAnimationDuration(0.2)
//      self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//      UIView.commitAnimations()
//      myInterfaceIsShifted = false
//    }
//
//
//    return true
//  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.tag == 1 {
      self.view.endEditing(true)
      return true
    }
    return false
  }
  
  @objc func keyboardDidShow(source: Any?)
  {
    if UIApplication.shared.statusBarOrientation.isLandscape {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.2)
      if source is UITextField
      {
        self.view.transform = CGAffineTransform(translationX: 0, y: myKeyboardLargeShift)

      }else{
        self.view.transform = CGAffineTransform(translationX: 0, y: myKeyboardShift)

      }
      UIView.commitAnimations()
      myInterfaceIsShifted = true
    }
  }
  @objc func keyboardDidShowLargeShift()
  {
    if UIApplication.shared.statusBarOrientation.isLandscape {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
      UIView.setAnimationDuration(0.8)
      self.view.transform = CGAffineTransform(translationX: 0, y: myKeyboardLargeShift)
      UIView.commitAnimations()
      myInterfaceIsShifted = true
    }
  }
  
  
  
  @objc func keyboardDidHide()
  {
    if myInterfaceIsShifted {
            UIView.beginAnimations("registerScroll", context: nil)
            UIView.setAnimationCurve(UIView.AnimationCurve.easeInOut)
            UIView.setAnimationDuration(0.2)
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.commitAnimations()
            myInterfaceIsShifted = false
          }
    
  }
  
  @IBAction func clickM2CIM(_ sender: AnyObject) {
    myIsM2CIMSel  = !myIsM2CIMSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickM2Info(_ sender: AnyObject) {
    myIsM2InfoSel = !myIsM2InfoSel
    updateOrientationButtonState()
  }
  
  
  @IBAction func clickDUCCI1(_ sender: AnyObject) {
    myIsDUCCI1Sel = !myIsDUCCI1Sel
    updateOrientationButtonState()
    
  }
  
  @IBAction func clickDUCCI2(_ sender: AnyObject) {
    myIsDUCCI2Sel = !myIsDUCCI2Sel
    updateOrientationButtonState()
    
  }
  
  @IBAction func clickDUI3D(_ sender: AnyObject) {
    myIsDUI3DSel = !myIsDUI3DSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickDULD(_ sender: AnyObject) {
    myIsDULDSel = !myIsDULDSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickNewsLetter(_ sender: AnyObject) {
    myIsNewLetterSel = !myIsNewLetterSel
    updateOrientationButtonState()
    self.view.endEditing(true)
  }
  
  @IBAction func clickAccept(_ sender: Any) {
    myIsEditing = !myIsEditing
    updateOrientationButtonState()
    myIsAcceptSel = !myIsAcceptSel
    updateInterfaceState()
    myEditButton.isHidden = true

  }
  
  
  func updateOrientationButtonState(){
    myM2CIMButton.setImage(UIImage(named: myIsM2CIMSel ? "checked.png" : "unChecked.png"), for: UIControl.State())
    myM2InfoButton.setImage(UIImage(named: myIsM2InfoSel ? "checked.png" : "unChecked.png"), for: UIControl.State())
    myDUI3DButton.setImage(UIImage(named: myIsDUI3DSel ? "checked.png" : "unChecked.png"), for: UIControl.State())
    myDULDButton.setImage(UIImage(named: myIsDULDSel ? "checked.png" : "unChecked.png"), for: UIControl.State())
    myDUCCI1Button.setImage(UIImage(named: myIsDUCCI1Sel ? "checked.png" : "unChecked.png"), for: UIControl.State())
    myDUCCI2Button.setImage(UIImage(named: myIsDUCCI2Sel ? "checked.png" : "unChecked.png"), for: UIControl.State())
    myAcceptButton.setImage(UIImage(named: myIsAcceptSel ? "checked.png" : "unChecked.png"), for: UIControl.State())

    myNewsLetterButton.setImage(UIImage(named: myIsNewLetterSel ? "checked.png" : "unChecked.png"), for: UIControl.State())
  }
  
  
  func getNumberStudentToday() -> (Int, Int) {
    var resu: (Int, Int) = (0, 0)
    for etu in myTabEtudians {
      if etu.myDateInscription == myDate {
        resu.0 += 1
      }
      if etu.myDateInscription == myDateM1 {
        resu.1 += 1
      }
    }
    return resu
  }
  
  
  
  @IBAction func changeMode(_ sender: AnyObject) {
    if myTabEtudians.count >= 1 {
      myHistoryMode = !myHistoryMode
      myHistoryButton.setTitle(myHistoryMode ? "stop history" : "history" , for: UIControl.State())
      if !myHistoryMode {
        myCurrentDisplayStudent = 0
        myIsEditing = true
        updateDisplayWithEtudiant(myCurrentStudent!)
      }else if myTabEtudians.count != 0{
        updateStudent(myCurrentStudent!)
        myCurrentDisplayStudent = 1
        myIsEditing = false
        updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
      }
      updateInterfaceState()
    }
  }
  
  
  func checkOKSaving() -> Bool {
    return myNameField.text != "" && myLastNameField.text != "" && myTownField.text != "" && myClassePickView.selectedRow(inComponent: 0) != 0 && myClassePickView.selectedRow(inComponent: 1) != 0;
  }
  
  
  
  @IBAction func deleteSudent(_ sender: AnyObject){
    let alert = UIAlertController(title: "pass needed", message: "enter password", preferredStyle: UIAlertController.Style.alert)
    alert.addTextField(configurationHandler: {(textField: UITextField!) in
      textField.placeholder = "Password"
      textField.isSecureTextEntry = true
      self.myPasswordTextField = textField
    })
    present(alert, animated: true, completion: nil)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: tryDeleteCurrentStudent))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
  }
  
  func deleteAll(){
    let alert = UIAlertController(title: "pass needed", message: "enter password", preferredStyle: UIAlertController.Style.alert)
    alert.addTextField(configurationHandler: {(textField: UITextField!) in
      textField.placeholder = "Password"
      textField.isSecureTextEntry = true
      self.myPasswordTextField = textField
    })
    present(alert, animated: true, completion: nil)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: tryDelete))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
  }
  
  func tryDelete(_ alert: UIAlertAction!){
    if myPasswordTextField!.text == myPasswordDelete {
      myTabEtudians.removeAll()
      saveListEtud(myTabEtudians)
      updateInterfaceState()
      updateDisplayWithEtudiant(myCurrentStudent!)
    }
  }
  
  func tryDeleteCurrentStudent(_ alert: UIAlertAction!){
    if myPasswordTextField!.text == myPasswordDelete {
      if myTabEtudians.count == 1 {
        myTabEtudians.remove(at: myTabEtudians.count - myCurrentDisplayStudent)
        myCurrentDisplayStudent = 0
        myIsEditing = true
        myHistoryMode = false
        myHistoryButton.setTitle("history" , for: UIControl.State())
        
        updateDisplayWithEtudiant(myCurrentStudent!)
        updateInterfaceState()
        return
      }
      
      myTabEtudians.remove(at: myTabEtudians.count - myCurrentDisplayStudent)
      if myCurrentDisplayStudent != 1 {
        myCurrentDisplayStudent = myCurrentDisplayStudent - 1
      }
      saveListEtud(myTabEtudians)
      myIsEditing = false
      updateInterfaceState()
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent])
    }
    
  }
  
  @objc func dismissKeyboard(){
    myNameField.resignFirstResponder()
    myLastNameField.resignFirstResponder()
    myOptionField.resignFirstResponder()
    myTownField.resignFirstResponder()
    myEmailField.resignFirstResponder()
    myRemarqueField.resignFirstResponder()
    myDeptField.resignFirstResponder()
    myPhoneField.resignFirstResponder()
  }
  
  
  func getScore() -> (Int, Int, Int, Int, Int, Int)
  {
    var res = (0,0,0,0, 0, 0)
    for etu in myTabEtudians {
      if etu.myDateInscription == myDate || etu.myDateInscription == myDateM1 {
        var isInfo = false
        isInfo = etu.myDUProject != nil &&  etu.myDUProject!.contains("DUCCI1")
        isInfo = isInfo || (etu.myM2Project != nil && (etu.myM2Project!.contains("DUCCI2") ||
          etu.myM2Project!.contains("DULD") ||  etu.myM2Project!.contains("DUI3D")))
        var isGeii = false
        isGeii = etu.myDUProject != nil &&  etu.myDUProject!.contains("M2CIM")
        isGeii = isGeii || (etu.myM2Project != nil && (etu.myM2Project!.contains("M2INFO")))
        
        if etu.myDateInscription == myDate {
          res.0 += isInfo ? 1 : 0
          res.1 += isGeii ? 1 : 0
          
        }else {
          res.3 += isInfo ? 1 : 0
          res.4 += isGeii ? 1 : 0
        }
      }
    }
    return res
  }
  
    @IBAction func exportData(_ sender: Any) {
        let data: Data? = exportListCSV(myForumName)
        if data != nil {
            let d = myDate!
            let fileName = "listEtudiant_\(d).csv"
            if let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) {
                do {
                    try data?.write(to: path)
                    
                } catch {
                    print("Failed to create file")
                    print("\(error)")
                }
             let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
             // important to not crash on iPad
             vc.popoverPresentationController?.sourceView = self.view
             present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
}






