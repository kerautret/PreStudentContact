//
//  Etudiant.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import Foundation


public class Etudiant: NSObject{
  var myName: String
  var myLastName: String
  var myClass: String
  var mySpe: String
  var myTown: String
  var myDept: Int?
  var myTel: String?
  var myEmail: String?
  var myDUTProject: String?
  var myLPProject: String?

  init(aName: String, aLastName: String, aClass: String, aSpe: String, aTown: String)
  {
    myName = aName
    myLastName = aLastName
    myClass = aClass
    mySpe = aSpe
    myTown = aTown
  }
  
}


