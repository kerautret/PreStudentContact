//
//  ViewController.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit

class MainInputController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

  var myListOfClassesOptions = [["--------","Première", "Seconde", "Terminale"],
                                ["S", "L", "ES", "STG"]]
  var myListOfIntegrationDUT = ["--------", "DUT GEII", "DUT INFO", "DUT MMI"]
  var myListOfIntegrationLP = ["--------", "LP A2O", "LP I2M", "LP ISN",
                               "LP ATC/CDG", "LP ATC/TeCAMTV"]

  var dicoIndex = ["--------":0,"Première": 1, "Seconde": 2, "Terminale": 3,"S":0, "L":1, "ES":2,
                   "STG":3, "DUT GEII":1, "DUT INFO":2, "DUT MMI":3,"LP A2O":1, "LP I2M":2, "LP ISN":3,
                    "LP ATC/CDG":4, "LP ATC/TeCAMTV":5]
  
  var myTabEtudians = [Etudiant]()
  var myIsEditing = true
  let myColorActive = UIColor.whiteColor()
  let myColorInActive = UIColor.lightGrayColor()
  var myCurrentDisplayStudent = 0
  var myIsInHistory = false
  var myCurrentStudent: Etudiant?
 
  @IBOutlet var myNameField: UITextField!
  @IBOutlet weak var myLastNameField: UITextField!
  
  @IBOutlet weak var myClassePickView: UIPickerView!
  @IBOutlet weak var myIntergrationDUTPickView: UIPickerView!
  @IBOutlet weak var myIntegrationLPPickView: UIPickerView!

  @IBOutlet weak var myTownField: UITextField!
  @IBOutlet weak var myEmailField: UITextField!
  @IBOutlet weak var myPhoneField: UITextField!
  @IBOutlet weak var mySaveButton: UIButton!
  @IBOutlet weak var myDeptField: UITextField!
  @IBOutlet weak var myEditButton: UIButton!
  @IBOutlet weak var myPrecButton: UIButton!
  @IBOutlet weak var mySuivButton: UIButton!
  
  @IBOutlet weak var mySaveModifs: UIButton!
  
  @IBOutlet weak var myCancelButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Recover the tab of all students:
    myTabEtudians = recoverTableauEtudiant()
    myClassePickView.dataSource = self
    myClassePickView.delegate = self
    myIntergrationDUTPickView.delegate = self
    myIntergrationDUTPickView.dataSource = self
    myIntegrationLPPickView.dataSource = self
    myIntegrationLPPickView.delegate = self
    myCurrentStudent = Etudiant(aName: "--", aLastName: "--", aClass: "--", aSpe: "--", aTown: "--")
    updateStudent(myCurrentStudent!)
    myNameField.delegate = self
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
    aStudent.myName = myNameField.text!
    aStudent.myLastName = myLastNameField.text!
    aStudent.myClass = myListOfClassesOptions[0][myClassePickView.selectedRowInComponent(0)]
    aStudent.mySpe = myListOfClassesOptions[1][myClassePickView.selectedRowInComponent(1)]
    aStudent.myTown = myTownField.text!
    aStudent.myDept = (Int) (NSString(string: myDeptField.text!).intValue)
    aStudent.myEmail = myEmailField.text!
    aStudent.myTel = myPhoneField.text!
    aStudent.myDUTProject = myListOfIntegrationDUT[ myIntergrationDUTPickView.selectedRowInComponent(0) ]
    aStudent.myLPProject = myListOfIntegrationLP[ myIntegrationLPPickView.selectedRowInComponent(0) ]
  }
  

  func eraseFields(){
    myNameField.text = ""
    myLastNameField.text = ""
    myTownField.text =  ""
    myEmailField.text = ""
    myPhoneField.text =  ""
    myIntergrationDUTPickView.selectRow(0, inComponent: 0, animated: true)
    myIntegrationLPPickView.selectRow(0, inComponent: 0, animated: true)
    myClassePickView.selectRow(0, inComponent: 0, animated: true)
    myClassePickView.selectRow(0, inComponent: 1, animated: true)
  }
  
  @IBAction func saveData(sender: UIButton) {
    updateStudent(myCurrentStudent!)
    addEtudiant(myCurrentStudent!)
    eraseFields()
    myTabEtudians.append(Etudiant(other: myCurrentStudent!))
    updateStudent(myCurrentStudent!)
  }
  @IBAction func cancel(sender: AnyObject) {
    myCurrentDisplayStudent = 0
    myIsEditing = true
    updateDisplayWithEtudiant(myCurrentStudent!)
    updateInterfaceState()
  }
  
  @IBOutlet weak var cancel: UIButton!
  //-----------------------
  // Processing display:
  
  
  
  func updateInterfaceState(){
    myClassePickView.userInteractionEnabled = myIsEditing
    myIntegrationLPPickView.userInteractionEnabled = myIsEditing
    myIntergrationDUTPickView.userInteractionEnabled = myIsEditing
    myLastNameField.enabled = myIsEditing
    myNameField.enabled = myIsEditing
    myPhoneField.enabled = myIsEditing
    myTownField.enabled = myIsEditing
    myEmailField.enabled = myIsEditing
    myDeptField.enabled = myIsEditing
    let colorBg: UIColor = myIsEditing ? myColorActive : myColorInActive
    myLastNameField.backgroundColor = colorBg
    myNameField.backgroundColor = colorBg
    myPhoneField.backgroundColor = colorBg
    myTownField.backgroundColor = colorBg
    myEmailField.backgroundColor = colorBg
    myDeptField.backgroundColor = colorBg
    mySaveButton.hidden = !myIsEditing
    myEditButton.hidden = myCurrentDisplayStudent == 0
    myCancelButton.hidden = myCurrentDisplayStudent == 0
    myPrecButton.hidden = myCurrentDisplayStudent == myTabEtudians.count
    mySuivButton.hidden = myCurrentDisplayStudent <= 0
    myEditButton.hidden = myIsEditing
    mySaveModifs.hidden = !myIsEditing || myCurrentDisplayStudent == 0
    myCancelButton.hidden = myCurrentDisplayStudent == 0
  }
  
  func updateDisplayWithEtudiant(unEtudiant: Etudiant)
  {
    myNameField.text = unEtudiant.myName
    myLastNameField.text = unEtudiant.myLastName
    myTownField.text = unEtudiant.myTown
    myDeptField.text = "\(unEtudiant.myDept)"
    myEmailField.text = unEtudiant.myEmail
    myPhoneField.text = unEtudiant.myTel
    myClassePickView.selectRow(dicoIndex[unEtudiant.myClass]!, inComponent: 0, animated: true)
    myClassePickView.selectRow(dicoIndex[unEtudiant.mySpe]!, inComponent: 1, animated: true)
    myIntergrationDUTPickView.selectRow(dicoIndex[unEtudiant.myDUTProject!]!, inComponent: 0, animated: true)
    myIntegrationLPPickView.selectRow(dicoIndex[unEtudiant.myLPProject!]!, inComponent: 0, animated: true)
    
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
      else if pickerView.tag == 1
      {
        return myListOfIntegrationDUT.count
      }
      else if pickerView.tag == 2
      {
        return myListOfIntegrationLP.count
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
      if pickerView.tag == 1
      {
        return myListOfIntegrationDUT[row]
      }
      if pickerView.tag == 2
      {
        return myListOfIntegrationLP[row]
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
  }

  func textFieldDidBeginEditing(textField : UITextField){
    
    
  }
  
  func textFieldShouldBeginEditing(){
    
  }
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow", name: UIKeyboardDidShowNotification, object: nil)
    return true
  }
  

  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide", name: UIKeyboardDidHideNotification, object: nil)
    self.view.endEditing(true)
    return true
  }
  
  
  func keyboardDidShow()
  {
    if UIDevice.currentDevice().orientation.isLandscape {
      UIView.beginAnimations("registerScroll", context: nil)
      UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
      UIView.setAnimationDuration(0.2)
      self.view.transform = CGAffineTransformMakeTranslation(0, -40)
      UIView.commitAnimations()
      
    }
  }
  
  
  
  func keyboardDidHide()
  {
    if UIDevice.currentDevice().orientation.isLandscape {

    UIView.beginAnimations("registerScroll", context: nil)
    UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
    UIView.setAnimationDuration(0.2)
    self.view.transform = CGAffineTransformMakeTranslation(0, 0)
    UIView.commitAnimations()

    }
  }
  
  
}
















