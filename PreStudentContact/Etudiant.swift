//
//  Etudiant.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import Foundation


open class Etudiant: NSObject{
  var myName: String
  var myLastName: String
  var myClass: String
  var mySpe: String
  var myTown: String
  var myDept: Int?
  var myTel: String?
  var myEmail: String?
  var myRemarque: String?
  var myDUProject: [String]?
  var myM2Project: [String]?
  var myForumInscription: String
  var myDateInscription: String
  var myOption: String?
  var myCreationDate: String
  var myHeureCreation: String
  var myNewsLetter: Bool = false
  
  init(other: Etudiant ) {
    myCreationDate = "\(Date().timeIntervalSince1970)"
    let datef = DateFormatter()
    datef.dateFormat = "hh:ss"
    myHeureCreation = "\(datef.string(from: Date()))"
    myName = other.myName
    myRemarque = other.myRemarque
    myLastName = other.myLastName
    myClass = other.myClass
    mySpe = other.mySpe
    myTown = other.myTown
    myDept = other.myDept
    myTel = other.myTel
    myEmail = other.myEmail
    myDUProject = other.myDUProject
    myM2Project = other.myM2Project
    myForumInscription = other.myForumInscription
    myDateInscription = other.myDateInscription
    myOption = other.myOption
    myNewsLetter = other.myNewsLetter
  }
  
  init(aName: String, aLastName: String, aClass: String, aSpe: String, aTown: String,
      aForumInscription: String, aDateInscription: String)
  {
    let datef = DateFormatter()
    datef.dateFormat = "hh_ss"
    myHeureCreation = "\(datef.string(from: Date()))"
    myCreationDate = "\(Date().timeIntervalSince1970)"
    myName = aName
    myLastName = aLastName
    myClass = aClass
    mySpe = aSpe
    myTown = aTown
    myDateInscription = aDateInscription
    myForumInscription = aForumInscription
  }
  
  
}


