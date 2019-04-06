//
//  ToolsInOut.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}




let internFileSave = "listeEtudiant"

func getPath(_ fileName: String) -> String{
  let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
  return paths + "/\(fileName)"
}



func checkExistSavingFile() -> Bool {
  let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
  let path = paths + "/\(internFileSave).plist"
  let fileManager = FileManager.default
  if (!(fileManager.fileExists(atPath: path)))
  {
    let bundle : NSString = Bundle.main.path(forResource: "emptyListStudent", ofType: "plist")! as NSString
    do{
      print("copy file...\(path)")
      try fileManager.copyItem(atPath: bundle as String, toPath: path)
    }catch let error as NSError {
      print("error file...\(error.description)")
    }
    return false
  }
  return true
}


func getCurrentForumName(_ forumName: String) -> String{
  let date = DateFormatter()
  date.dateFormat = "dd_MM_yyyy"
  let res =  "\(forumName)_\(date.string(from: Date()))"
  
  let sharedDefault = UserDefaults.standard
  if var listFile = sharedDefault.object(forKey: "ARRAY_SAVE") as? Array<String> {
    if !listFile.contains(res) {
      listFile.append(res)
      sharedDefault.set(listFile, forKey: "ARRAY_SAVE")
    }
  }
  return res
}


func exportListCSV(_ forumName: String) -> Data? {
  let path: String = "\(getPath(internFileSave)).plist"
  var strResu = "Id,Nom,Prénom,classe,spécialite,option,ville,departement,email,num téléphone,DUCCI1,DUCCI2,DUI3D,DULD,M2CIM, M2INFO,date inscription,forum,news letter\n"

  let Listkey = ["name","lastName","classe","specialite","option","town","dept","email","numTel","integrationDU","integrationM2","inscriptionDate","forumName", "NewsLetter" ]
  if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > > {
    for (id, etu) in listeEtudiant {
      strResu += "\(id)"
      for key in Listkey {
        if key == "NewsLetter" {
          if etu[key] as! Bool {
            strResu += ",NewsLetter"
          }else{
            strResu += ",--"
          }
        }
        else if key  == "integrationDU" {
          if (etu[key] as! [String]).contains("DUCCI1"){
            strResu += ",DUCCI 1"
          }else {strResu += ",--"}
          if (etu[key] as! [String]).contains("DUCCI2"){
            strResu += ",DUCCI 2"
          }else {strResu += ",--"}
          if (etu[key] as! [String]).contains("DULD"){
            strResu += ",DU LD"
          }else {strResu += ",--"}
          if (etu[key] as! [String]).contains("DUI3D"){
            strResu += ",DU I3D"
          }else {strResu += ",--"}
        }
        else if key  == "integrationM2" {
          if (etu[key] as! [String]).contains("M2CIM"){
            strResu += ",M2 CIM"
          }else {strResu += ",--"}
          if (etu[key] as! [String]).contains("M2INFO"){
            strResu += ",M2 INFO"
          }else {strResu += ",--"}
          
        }else{
          if etu[key] != nil {
            strResu += ","+"\(etu[key]!)".cleanPonctuation()
          }else{
            strResu += ",--"
          }
        }
      }
      strResu += "\n"
    }
    ((try? strResu.data(using: String.Encoding.utf8)?.write(to: URL(fileURLWithPath: "\(getPath(internFileSave)).csv"), options: [.atomic])) as ()??)
    return strResu.data(using: String.Encoding.utf8)
  }
  
  return nil
}


func saveListEtud(_ tabEtu: [Etudiant]){
  var path: String = "\(internFileSave).plist"
  path = getPath(path)
  print("path::: save\(path)")
  var listeEtudiant = Dictionary<String,  Dictionary<String, AnyObject > >()
  for unEtudiant in tabEtu {
    var dicoEtu = Dictionary<String, AnyObject > ()
    dicoEtu["name"] = unEtudiant.myName as AnyObject?
    dicoEtu["lastName"] = unEtudiant.myLastName as AnyObject?
    dicoEtu["classe"] = unEtudiant.myClass as AnyObject?
    dicoEtu["specialite"] = unEtudiant.mySpe as AnyObject?
    dicoEtu["option"] = unEtudiant.myOption as AnyObject?
    dicoEtu["town"] = unEtudiant.myTown as AnyObject?
    dicoEtu["dept"] = unEtudiant.myDept as AnyObject?
    dicoEtu["email"] = unEtudiant.myEmail as AnyObject?
    dicoEtu["numTel"] = unEtudiant.myTel as AnyObject?
    dicoEtu["integrationDU"] = unEtudiant.myDUProject as AnyObject?
    dicoEtu["integrationM2"] = unEtudiant.myM2Project as AnyObject?
    dicoEtu["inscriptionDate"] = unEtudiant.myDateInscription as AnyObject?
    dicoEtu["forumName"] = unEtudiant.myForumInscription as AnyObject?
    dicoEtu["heureCreation"] = unEtudiant.myHeureCreation as AnyObject?
    dicoEtu["NewsLetter"] = unEtudiant.myNewsLetter as AnyObject?
    dicoEtu["remarque"] = unEtudiant.myRemarque as AnyObject?
    
    listeEtudiant["\(unEtudiant.myCreationDate)"] = dicoEtu
  }
  (listeEtudiant as NSDictionary).write(toFile: path, atomically: true)
  
}


func addEtudiant(_ unEtudiant: Etudiant){
  var path: String = "\(internFileSave).plist"
  path = getPath(path)
  print("path::: save\(path)")
  var listeEtudiant: Dictionary<String,  Dictionary<String, AnyObject > >?
  listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > >
  if listeEtudiant == nil {
    listeEtudiant = Dictionary<String,  Dictionary<String, AnyObject > >()
  }
  
  var dicoEtu = Dictionary<String, AnyObject > ()
  dicoEtu["name"] = unEtudiant.myName as AnyObject?
  dicoEtu["lastName"] = unEtudiant.myLastName as AnyObject?
  dicoEtu["classe"] = unEtudiant.myClass as AnyObject?
  dicoEtu["specialite"] = unEtudiant.mySpe as AnyObject?
  dicoEtu["option"] = unEtudiant.myOption as AnyObject?
  dicoEtu["town"] = unEtudiant.myTown as AnyObject?
  dicoEtu["dept"] = unEtudiant.myDept as AnyObject?
  dicoEtu["email"] = unEtudiant.myEmail as AnyObject?
  dicoEtu["numTel"] = unEtudiant.myTel as AnyObject?
  dicoEtu["integrationDU"] = unEtudiant.myDUProject as AnyObject?
  dicoEtu["integrationM2"] = unEtudiant.myM2Project as AnyObject?
  dicoEtu["inscriptionDate"] = unEtudiant.myDateInscription as AnyObject?
  dicoEtu["forumName"] = unEtudiant.myForumInscription as AnyObject?
  dicoEtu["heureCreation"] = unEtudiant.myHeureCreation as AnyObject?
  dicoEtu["NewsLetter"] = unEtudiant.myNewsLetter as AnyObject?
  dicoEtu["remarque"] = unEtudiant.myRemarque as AnyObject?
  
  listeEtudiant!["\(unEtudiant.myCreationDate)"] = dicoEtu
  (listeEtudiant! as NSDictionary).write(toFile: path, atomically: true)
}





func recoverTableauEtudiant(_ forum: String) ->[Etudiant] {
  var tabResu = [Etudiant]()
  let path: String = "\(getPath(internFileSave)).plist"
  
  print("path:::\(path)")
  if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject > {
    let sortedListe = listeEtudiant.sorted { Double($0.0) < Double($1.0) }
    
    for (key, etu) in sortedListe {
      let name = etu["name"]! as! String
      let lastName = etu["lastName"]! as! String
      let classe = etu["classe"]! as! String
      let specialite = etu["specialite"]! as! String
      let town = etu["town"]! as! String
      let dept = etu["dept"]! as? Int
      let numTel = etu["numTel"]! as? String
      let email = etu["email"] as? String
      let integrationDU = etu["integrationDU"] as? [String]
      let integrationM2 = etu["integrationM2"] as? [String]
      let inscriptionDate = etu["inscriptionDate"] as? String
      let forumName = etu["forumName"] as? String
      let heureCreation = etu["heureCreation"] as? String
      let option = etu["option"] as? String
      let remarque = etu["remarque"] as? String
      let newsLetter = etu["NewsLetter"] as? Bool
      let etudiant = Etudiant(aName: name, aLastName: lastName, aClass: classe, aSpe: specialite, aTown: town, aForumInscription: forumName!, aDateInscription: inscriptionDate!)
      etudiant.myCreationDate = key
      if email != nil
      {
        etudiant.myEmail = email
      }
      if dept != nil
      {
        etudiant.myDept = dept
      }
      if remarque != nil
      {
        etudiant.myRemarque = remarque
      }
      if integrationDU != nil
      {
        etudiant.myDUProject = integrationDU
      }
      if integrationM2 != nil  {
        etudiant.myM2Project   = integrationM2
      }
      if numTel != nil {
        etudiant.myTel = numTel
      }
      if option != nil {
        etudiant.myOption = option
      }
      if newsLetter != nil {
        etudiant.myNewsLetter = newsLetter!
      }
      if heureCreation != nil {
        etudiant.myHeureCreation = heureCreation!
      }
      tabResu.append(etudiant)
    }
  }
  
  return tabResu
  
}




