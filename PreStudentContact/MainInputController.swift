//
//  ViewController.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import UIKit

class MainInputController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  var myListOfClassesOptions = [["Première", "Seconde", "terminale"], ["S", " L", " ES", "STG"]]
  var myListOfIntegrationDUT = ["DUT GEII", "DUT INFO", "DUT MMI"]
  var myListOfIntegrationLP = ["LP A2O", "LP I2M", "LP ISN", "LP ATC/CDG", "LP ATC/TeCAMTV"]
  
  var myTabEtudians = [Etudiant]()

  
  @IBOutlet var myNameField: UITextField!
  @IBOutlet weak var myLastNameField: UITextField!
  
  @IBOutlet weak var myClassePickView: UIPickerView!
  @IBOutlet weak var myIntergrationDUTPickView: UIPickerView!
  @IBOutlet weak var myIntegrationLPPickView: UIPickerView!

  
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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func updateDisplayWithEtudiant(unEtudiant: Etudiant)
  {
    
    
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
  
  
}

