//
//  ViewController.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit

class MainInputController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  var myListOfClassesOptions = [["--------","Première", "Seconde", "Terminale"],
                                ["S", "L", "ES", "STG"]]
  var myListOfIntegrationDUT = ["--------", "DUT GEII", "DUT INFO", "DUT MMI"]
  var myListOfIntegrationLP = ["--------", "LP A2O", "LP I2M", "LP ISN",
                               "LP ATC/CDG", "LP ATC/TeCAMTV"]

  var dicoIndex = ["--------":0,"Première": 1, "Seconde": 2, "Terminale": 3,"S":0, "L":1, "ES":2,
                   "STG":3, "DUT GEII":1, "DUT INFO":2, "DUT MMI":3,"LP A2O":1, "LP I2M":2, "LP ISN":3,
                    "LP ATC/CDG":4, "LP ATC/TeCAMTV":5]
  
  var myTabEtudians = [Etudiant]()
  var myIsEditable = true
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
    updateStudent()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  @IBAction func loadPrevious(sender: UIButton) {
    if myCurrentDisplayStudent == 0 {
      updateStudent()
    }
    if myCurrentDisplayStudent != myTabEtudians.count  {
      myCurrentDisplayStudent++
    }
    myIsEditable = false
    updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
    myEditButton.hidden = false
    myCancelButton.hidden = false
    mySaveButton.hidden = true
  }
  
  @IBAction func loadNext(sender: AnyObject) {
    if myCurrentDisplayStudent == 0 {
      return
    }

    if myCurrentDisplayStudent != 1{
      myCurrentDisplayStudent--
      myIsEditable = false
      updateDisplayWithEtudiant(myTabEtudians[myTabEtudians.count - myCurrentDisplayStudent ])
      myEditButton.hidden = false
      myCancelButton.hidden = false
      mySaveButton.hidden = true
    }else{
      myCurrentDisplayStudent--
      myIsEditable = true
      updateDisplayWithEtudiant(myCurrentStudent!)
    }

  }
  
  func updateStudent(){
    myCurrentStudent?.myName = myNameField.text!
    myCurrentStudent?.myLastName = myLastNameField.text!
    myCurrentStudent?.myClass = myListOfClassesOptions[0][myClassePickView.selectedRowInComponent(0)]
    myCurrentStudent?.mySpe = myListOfClassesOptions[1][myClassePickView.selectedRowInComponent(1)]
    myCurrentStudent?.myTown = myTownField.text!
    myCurrentStudent?.myDept = (Int) (NSString(string: myDeptField.text!).intValue)
    myCurrentStudent?.myEmail = myEmailField.text!
    myCurrentStudent?.myTel = myPhoneField.text!
    myCurrentStudent?.myDUTProject = myListOfIntegrationDUT[ myIntergrationDUTPickView.selectedRowInComponent(0) ]
    myCurrentStudent?.myLPProject = myListOfIntegrationLP[ myIntegrationLPPickView.selectedRowInComponent(0) ]
  }
  
  
  @IBAction func saveData(sender: UIButton) {
    var etudiantCourant = Etudiant(aName: "Kerautret", aLastName: "Bertrand",
      aClass: "Première", aSpe: "ES", aTown: "Bordeaux")
    addEtudiant(etudiantCourant)
    
  }
  @IBAction func cancel(sender: AnyObject) {
    myIsEditable = true
    myCurrentDisplayStudent = 0
    //updateDisplayWithEtudiant(my)
    myEditButton.hidden = false
    myCancelButton.hidden = false
    mySaveButton.hidden = true

    
  }
  
  @IBOutlet weak var cancel: UIButton!
  //-----------------------
  // Processing display:
  
  
  
  func updateDisplayWithEtudiant(unEtudiant: Etudiant)
  {
    let colorBg: UIColor = myIsEditable ? myColorActive : myColorInActive
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
    
    myClassePickView.userInteractionEnabled = myIsEditable
    myIntegrationLPPickView.userInteractionEnabled = myIsEditable
    myIntergrationDUTPickView.userInteractionEnabled = myIsEditable
    
    myLastNameField.enabled = myIsEditable
    myNameField.enabled = myIsEditable
    myPhoneField.enabled = myIsEditable
    myTownField.enabled = myIsEditable
    myEmailField.enabled = myIsEditable
    myDeptField.enabled = myIsEditable
    myLastNameField.backgroundColor = colorBg
    myNameField.backgroundColor = colorBg
    myPhoneField.backgroundColor = colorBg
    myTownField.backgroundColor = colorBg
    myEmailField.backgroundColor = colorBg
    myDeptField.backgroundColor = colorBg
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
    
    
  }

  

  
}

