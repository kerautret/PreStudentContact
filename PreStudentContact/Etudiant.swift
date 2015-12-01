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
  var myForumInscription: String
  var myDateInscription: String
  var mySpecialite: String?
  
  init(other: Etudiant ) {
    myName = other.myName
    myLastName = other.myLastName
    myClass = other.myClass
    mySpe = other.mySpe
    myTown = other.myTown
    myDept = other.myDept
    myTel = other.myTel
    myEmail = other.myEmail
    myDUTProject = other.myDUTProject
    myLPProject = other.myLPProject
    myForumInscription = other.myForumInscription
    myDateInscription = other.myDateInscription
    mySpecialite = other.mySpecialite
  }
  
  init(aName: String, aLastName: String, aClass: String, aSpe: String, aTown: String,
      aForumInscription: String, aDateInscription: String)
  {
    myName = aName
    myLastName = aLastName
    myClass = aClass
    mySpe = aSpe
    myTown = aTown
    myDateInscription = aDateInscription
    myForumInscription = aForumInscription
  }
  
  
}


