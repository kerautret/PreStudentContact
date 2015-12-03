//
//  ViewController.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit


extension String{
  func cleanPonctuation() -> String {
    var newString = self.stringByReplacingOccurrencesOfString(",", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    newString = newString.stringByReplacingOccurrencesOfString("'", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    newString = newString.stringByReplacingOccurrencesOfString("\"", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    newString = newString.stringByReplacingOccurrencesOfString("$", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    newString = newString.stringByReplacingOccurrencesOfString("&", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    newString = newString.stringByReplacingOccurrencesOfString(";", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    return newString
  }
  
}


class MainInputController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
  
  var myListOfClassesOptions = [["--------","Première", "Seconde", "Terminale"],
    ["--------","S","ES", "L", "STI","STI2D","STI2A", "STAV", "STG", "STT", "STI","STMG", "PRO", "DAEU", "BAC étranger"]]
  
  let myKeyboardShift = CGFloat(-70.0)
  var myTabEtudians = [Etudiant]()
  var myIsEditing = true
  let myColorActive = UIColor.whiteColor()
  let myColorInActive = UIColor.lightGrayColor()
  var myCurrentDisplayStudent = 0
  var myIsInHistory = false
  var myCurrentStudent: Etudiant?
  var myEmailExport : String?
  var myForumName: String = "ForumNoName"
  var myDate: String?
  var myDateM1: String?
  var myHistoryMode: Bool = false
  var myInterfaceIsShifted: Bool = false
  
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
  @IBOutlet weak var myTownField: UITextField!
  @IBOutlet weak var myEmailField: UITextField!
  @IBOutlet weak var myPhoneField: UITextField!
  @IBOutlet weak var mySaveButton: UIButton!
  @IBOutlet weak var myDeptField: UITextField!
  var myPasswordTextField: UITextField?

  @IBOutlet weak var myEditButton: UIButton!
  @IBOutlet weak var myPrecButton: UIButton!
  @IBOutlet weak var mySuivButton: UIButton!
  @IBOutlet weak var mySaveModifs: UIButton!
  @IBOutlet weak var myCancelButton: UIButton!
  
  @IBOutlet weak var myDeleteButton: UIButton!
  
  @IBOutlet weak var myHistoryButton: UIButton!
  @IBOutlet weak var myDUTInfoButton: UIButton!
  @IBOutlet weak var myDUTGeiiButton: UIButton!
  @IBOutlet weak var myDUTMiiButton: UIButton!
  
  @IBOutlet weak var myLPIsnButton: UIButton!
  @IBOutlet weak var myLPI2mButton: UIButton!
  @IBOutlet weak var myLPA2iButton: UIButton!
  @IBOutlet weak var myLPAtcTecamButton: UIButton!
  @IBOutlet weak var myLPAtcCdgButton: UIButton!
  
  var myIsDUTInfoSel: Bool = false
  var myIsDUTGeiiSel: Bool = false
  var myIsDUTMiiSel: Bool = false
  var myIsLPIsnSel: Bool = false
  var myIsLPI2mSel: Bool = false
  var myIsLPA2iSel: Bool = false
  var myIsLPAtcTecamSel: Bool = false
  var myIsLPAtcCdgSel: Bool = false
  
  func getIndex(aName: String)-> Int?{
    //searching index
    for list in  myListOfClassesOptions {
      var pos = 0
      for n in list {
        if n == aName {
          return pos
        }
        pos++
      }
    }

    return nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dateFormater = NSDateFormatter()
    dateFormater.dateFormat = "dd_MM_yyyy"

    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let dateM1 = calendar?.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: NSDate(), options: NSCalendarOptions())
    
    myDate =  "\(dateFormater.stringFromDate(NSDate()))"
    myDateM1 =  "\(dateFormater.stringFromDate(dateM1!))"
    

    
    // Recover the tab of all students:
    myClassePickView.dataSource = self
    myClassePickView.delegate = self
    myCurrentStudent = Etudiant(aName: "--", aLastName: "--", aClass: "--", aSpe: "--", aTown: "--",
                                aForumInscription: myForumName, aDateInscription: myDate!)
    myCurrentStudent?.myLPProject = [String]()
    myCurrentStudent?.myDUTProject = [String]()
    
    updateStudent(myCurrentStudent!)
    myNameField.delegate = self
    myLastNameField.delegate = self
    myOptionField.delegate = self
    myTownField.delegate = self
    myPhoneField.delegate = self
    myDeptField.delegate = self
    myEmailField.delegate = self
    
    let sharedDefault = NSUserDefaults.standardUserDefaults()
    myForumName = sharedDefault.objectForKey("FORUM_NAME") as! String
    myTabEtudians = recoverTableauEtudiant(myForumName)
    myInscriptionDateLabel.text = myDate
    updateInterfaceState()
    updateDisplayWithEtudiant(myCurrentStudent!)
    myForumLabel.text = myForumName

  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func loadPrevious(sender: UIButton) {
    if myCurrentDisplayStudent == 0 {
      updateStudent(myCurrentStudent!)
    }
    if myCurrentDisplayStudent != myTabEtudians.count  {
      myCurrentDisplayStudent++
    }
    myIsEditing = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
  }
  
  @IBAction func loadNext(sender: AnyObject) {
    if myCurrentDisplayStudent == 0 {
      return
    }
    
    if myCurrentDisplayStudent != 1{
      myCurrentDisplayStudent--
      myIsEditing = false
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
      myEditButton.hidden = false
      myCancelButton.hidden = false
      mySaveButton.hidden = true
    }else{
      myCurrentDisplayStudent--
      myIsEditing = true
      updateDisplayWithEtudiant(myCurrentStudent!)
    }
    updateInterfaceState()
  }
  
  func updateStudent(aStudent: Etudiant){
    aStudent.myName = myNameField.text!.cleanPonctuation()
    aStudent.myLastName = myLastNameField.text!.cleanPonctuation()
    aStudent.myClass = myListOfClassesOptions[0][myClassePickView.selectedRowInComponent(0)]
    aStudent.mySpe = myListOfClassesOptions[1][myClassePickView.selectedRowInComponent(1)]
    aStudent.myTown = myTownField.text!.cleanPonctuation()
    if myDeptField.text != ""{
      aStudent.myDept = (Int) (NSString(string: myDeptField.text!).intValue)
    }
    aStudent.myEmail = myEmailField.text!.cleanPonctuation()
    aStudent.myTel = myPhoneField.text!.cleanPonctuation()
    aStudent.myDUTProject?.removeAll()
    aStudent.myLPProject?.removeAll()
    
    if myIsDUTInfoSel {
      aStudent.myDUTProject?.append("DUT INFO")
    }
    if myIsDUTGeiiSel {
      aStudent.myDUTProject?.append("DUT GEII")
    }
    if myIsDUTMiiSel {
      aStudent.myDUTProject?.append("DUT MMI")
    }
    if myIsLPIsnSel {
      aStudent.myLPProject?.append("LP ISN")
    }
    if myIsLPI2mSel {
      aStudent.myLPProject?.append("LP I2M")
    }
    if myIsLPA2iSel {
      aStudent.myLPProject?.append("LP A2I")
    }
    if myIsLPAtcCdgSel {
      aStudent.myLPProject?.append("LP ATC/CDG")
    }
    if myIsLPAtcTecamSel {
      aStudent.myLPProject?.append("LP ATC/TECAMTV")
    }
    
    aStudent.myDateInscription = myDate!
    aStudent.myForumInscription = myForumName
    aStudent.myOption = myOptionField.text
    
  }
  
  
  func eraseFields(){
    myNameField.text = ""
    myLastNameField.text = ""
    myTownField.text =  ""
    myEmailField.text = ""
    myPhoneField.text =  ""
    myOptionField.text = ""
    myDeptField.text = ""
    myIsLPAtcTecamSel = false
    myIsLPAtcCdgSel = false
    myIsLPI2mSel = false
    myIsLPIsnSel = false
    myIsLPA2iSel = false
    myIsDUTMiiSel = false
    myIsDUTInfoSel = false
    myIsDUTGeiiSel = false
    updateOrientationButtonState()
    myClassePickView.selectRow(0, inComponent: 0, animated: true)
    myClassePickView.selectRow(0, inComponent: 1, animated: true)
  }
  
  
  @IBAction func saveData(sender: UIButton) {
    updateStudent(myCurrentStudent!)
    addEtudiant(myCurrentStudent!)
    eraseFields()
    myCurrentStudent = Etudiant(other: myCurrentStudent!)
    myTabEtudians.append(Etudiant(other: myCurrentStudent!))
    updateStudent(myCurrentStudent!)
    updateDisplayWithEtudiant(myCurrentStudent!)
  }
  
  
  @IBAction func cancel(sender: AnyObject) {
    myIsEditing = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
  }
  
  @IBOutlet weak var cancel: UIButton!
  //-----------------------
  // Processing display:
  
  
  
  func updateInterfaceState(){
    updateOrientationButtonState()
    myClassePickView.userInteractionEnabled = myIsEditing
    myLastNameField.enabled = myIsEditing
    myNameField.enabled = myIsEditing
    myPhoneField.enabled = myIsEditing
    myTownField.enabled = myIsEditing
    myEmailField.enabled = myIsEditing
    myDeptField.enabled = myIsEditing
    myOptionField.enabled = myIsEditing
    myDUTMiiButton.enabled = myIsEditing
    myDUTInfoButton.enabled = myIsEditing
    myDUTGeiiButton.enabled = myIsEditing
    myLPIsnButton.enabled = myIsEditing
    myLPA2iButton.enabled = myIsEditing
    myLPAtcCdgButton.enabled = myIsEditing
    myLPAtcTecamButton.enabled = myIsEditing
    myLPI2mButton.enabled = myIsEditing
    
    let colorBg: UIColor = myIsEditing ? myColorActive : myColorInActive
    myLastNameField.backgroundColor = colorBg
    myNameField.backgroundColor = colorBg
    myPhoneField.backgroundColor = colorBg
    myTownField.backgroundColor = colorBg
    myEmailField.backgroundColor = colorBg
    myDeptField.backgroundColor = colorBg
    myOptionField.backgroundColor = colorBg
    mySaveButton.hidden = !myIsEditing || myCurrentDisplayStudent != 0 || myHistoryMode || !checkOKSaving()
    myEditButton.hidden = myCurrentDisplayStudent == 0

    myPrecButton.hidden =  myCurrentDisplayStudent == myTabEtudians.count || myTabEtudians.count == 0 || !myHistoryMode
    mySuivButton.hidden = myCurrentDisplayStudent <= 1 || myTabEtudians.count == 1 || !myHistoryMode
    myEditButton.hidden = myIsEditing
    mySaveModifs.hidden = !myIsEditing || myCurrentDisplayStudent == 0
    myCancelButton.hidden = myCurrentDisplayStudent == 0 || !myIsEditing
    myDeleteButton.hidden =  myCurrentDisplayStudent == 0 || !myIsEditing
  }
  
  func updateDisplayWithEtudiant(unEtudiant: Etudiant){
    myNameField.text = unEtudiant.myName
    myLastNameField.text = unEtudiant.myLastName
    myTownField.text = unEtudiant.myTown
    myDeptField.text = unEtudiant.myDept == nil ? "" : "\(unEtudiant.myDept!)"
    myEmailField.text = unEtudiant.myEmail
    myPhoneField.text = unEtudiant.myTel
    myIdStudent.text = unEtudiant.myCreationDate
    myHeureCreation.text = unEtudiant.myHeureCreation
    myTotalSaved.text = "\(myTabEtudians.count)"
    myTotalSavedDay.text = "\(getNumberStudentToday().0)"
    myTotalSaveDayM1.text = "\(getNumberStudentToday().1)"
    let indexClass: Int? = getIndex(unEtudiant.myClass)
    let indexSpe: Int? = getIndex(unEtudiant.mySpe)
    myIsDUTMiiSel = unEtudiant.myDUTProject!.contains("DUT MMI")
    myIsDUTGeiiSel = unEtudiant.myDUTProject!.contains("DUT GEII")
    myIsDUTInfoSel = unEtudiant.myDUTProject!.contains("DUT INFO")
    
    myIsLPA2iSel = unEtudiant.myLPProject!.contains("LP A2I")
    myIsLPI2mSel = unEtudiant.myLPProject!.contains("LP I2M")
    myIsLPIsnSel = unEtudiant.myLPProject!.contains("LP ISN")
    myIsLPAtcCdgSel = unEtudiant.myLPProject!.contains("LP ATC/CDG")
    myIsLPAtcTecamSel = unEtudiant.myLPProject!.contains("LP ATC/TECAMTV")
    
    myClassePickView.selectRow(indexClass != nil ? indexClass! : 0, inComponent: 0, animated: true)
    myClassePickView.selectRow(indexSpe != nil ? indexSpe! : 0, inComponent: 1, animated: true)
    myForumLabel.text = unEtudiant.myForumInscription
    myInscriptionDateLabel.text = unEtudiant.myDateInscription
    myOptionField.text = unEtudiant.myOption
    
    updateInterfaceState()
    updateOrientationButtonState()
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    updateInterfaceState()
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
    if pickerView.tag == 0
    {
      return 2
    }
    else
    {
      return 1
    }
  }
  
  func pickerView(pickerView: UIPickerView,
    numberOfRowsInComponent component: Int) -> Int{
      if pickerView.tag == 0
      {
        return myListOfClassesOptions[component].count
      }
      return 0
  }
  
  func pickerView(pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int) -> String?{
      if pickerView.tag == 0
      {
        return myListOfClassesOptions[component][row]
      }
      return "---"
  }
  
  
  @IBAction func edit(sender: AnyObject) {
    myIsEditing = true
    updateInterfaceState()
  }
  
  @IBAction func saveModifs(sender: AnyObject){
    myIsEditing = false
    updateStudent(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    updateInterfaceState()
    saveListEtud(myTabEtudians)
  }
  
  func textFieldDidBeginEditing(textField : UITextField){
    
  }
  
  func textFieldShouldBeginEditing(){
    
  }
 
  func textFieldDidEndEditing(textField: UITextField) {
    updateInterfaceState()
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow",
      name: UIKeyboardDidShowNotification, object: nil)
    return true
  }
  
  
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide", name: UIKeyboardDidHideNotification, object: nil)
    self.view.endEditing(true)
    return true
  }
  
  
  func keyboardDidShow()
  {
    if UIApplication.sharedApplication().statusBarOrientation.isLandscape {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
      UIView.setAnimationDuration(0.2)
      self.view.transform = CGAffineTransformMakeTranslation(0, myKeyboardShift)
      UIView.commitAnimations()
      myInterfaceIsShifted = true
    }
  }
  
  
  func keyboardDidHide()
  {
    if myInterfaceIsShifted {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
      UIView.setAnimationDuration(0.2)
      self.view.transform = CGAffineTransformMakeTranslation(0, 0)
      UIView.commitAnimations()
      myInterfaceIsShifted = false
    }
  }
  
  @IBAction func clickLPISN(sender: AnyObject) {
    myIsLPIsnSel = !myIsLPIsnSel
    updateOrientationButtonState()
  }

  @IBAction func clickLPI2M(sender: AnyObject) {
    myIsLPI2mSel = !myIsLPI2mSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickLPA2I(sender: AnyObject) {
    myIsLPA2iSel = !myIsLPA2iSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickLPATCCDG(sender: AnyObject) {
    myIsLPAtcCdgSel = !myIsLPAtcCdgSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickTACTECAMTV(sender: AnyObject) {
    myIsLPAtcTecamSel = !myIsLPAtcTecamSel
    updateOrientationButtonState()
  }
  
  @IBAction func clickDUTINFO(sender: AnyObject) {
    myIsDUTInfoSel = !myIsDUTInfoSel
    updateOrientationButtonState()

  }
  
  @IBAction func clickDUTGEII(sender: AnyObject) {
    myIsDUTGeiiSel = !myIsDUTGeiiSel
    updateOrientationButtonState()

  }
  
  @IBAction func clickDUTMMI(sender: AnyObject) {
    myIsDUTMiiSel = !myIsDUTMiiSel
    updateOrientationButtonState()

  }
  
  
  func updateOrientationButtonState(){
    myLPIsnButton.setImage(UIImage(named: myIsLPIsnSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myLPI2mButton.setImage(UIImage(named: myIsLPI2mSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myLPA2iButton.setImage(UIImage(named: myIsLPA2iSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myLPIsnButton.setImage(UIImage(named: myIsLPIsnSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myLPAtcCdgButton.setImage(UIImage(named: myIsLPAtcCdgSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myLPAtcTecamButton.setImage(UIImage(named: myIsLPAtcTecamSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myDUTInfoButton.setImage(UIImage(named: myIsDUTInfoSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myDUTGeiiButton.setImage(UIImage(named: myIsDUTGeiiSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
    myDUTMiiButton.setImage(UIImage(named: myIsDUTMiiSel ? "checked.png" : "unChecked.png"), forState: UIControlState.Normal)
  }
  
  
  func getNumberStudentToday() -> (Int, Int) {
    var resu: (Int, Int) = (0, 0)
    for etu in myTabEtudians {
      if etu.myDateInscription == myDate {
        resu.0++
      }
      if etu.myDateInscription == myDateM1 {
        resu.1++
      }
    }
    return resu
  }
  
  
  
  @IBAction func changeMode(sender: AnyObject) {
    
    if myTabEtudians.count >= 1 {
      myHistoryMode = !myHistoryMode
      myHistoryButton.setTitle(myHistoryMode ? "stop history" : "history" , forState: UIControlState.Normal)
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
    return myNameField.text != "" && myLastNameField.text != "" && myTownField != "" && myClassePickView.selectedRowInComponent(0) != 0 && myClassePickView.selectedRowInComponent(1) != 0;
  }
  
  
  
  @IBAction func deleteSudent(sender: AnyObject){
      let alert = UIAlertController(title: "pass needed", message: "enter password", preferredStyle: UIAlertControllerStyle.Alert)
      alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
        textField.placeholder = "Password"
        textField.secureTextEntry = true
        self.myPasswordTextField = textField
      })
      presentViewController(alert, animated: true, completion: nil)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: tryDeleteCurrentStudent))
      alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
  }
  
  func deleteAll(){
    let alert = UIAlertController(title: "pass needed", message: "enter password", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
      textField.placeholder = "Password"
      textField.secureTextEntry = true
      self.myPasswordTextField = textField
    })
    presentViewController(alert, animated: true, completion: nil)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: tryDelete))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
  }
  
  func tryDelete(alert: UIAlertAction!){
    print("field::::\(myPasswordTextField!.text)")
    if myPasswordTextField!.text == "Forum2015" {
      myTabEtudians.removeAll()
      saveListEtud(myTabEtudians)
      updateInterfaceState()
      updateDisplayWithEtudiant(myCurrentStudent!)
    }
  }
  
  func tryDeleteCurrentStudent(alert: UIAlertAction!){
    print("field::::\(myPasswordTextField!.text)")
    if myPasswordTextField!.text == "Forum2015" {
      if myTabEtudians.count == 1 {
        myTabEtudians.removeAtIndex(myTabEtudians.count - myCurrentDisplayStudent)
        myCurrentDisplayStudent = 0
        myIsEditing = true
        myHistoryMode = false
        updateDisplayWithEtudiant(myCurrentStudent!)
        updateInterfaceState()
        return
      }

      myTabEtudians.removeAtIndex(myTabEtudians.count - myCurrentDisplayStudent)
      if myCurrentDisplayStudent != 1 {
        myCurrentDisplayStudent = myCurrentDisplayStudent - 1
      }
      saveListEtud(myTabEtudians)
      myIsEditing = false
      updateInterfaceState()
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent])
    }
    
  }

  
}






