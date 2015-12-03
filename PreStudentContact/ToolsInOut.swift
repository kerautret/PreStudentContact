//
//  ToolsInOut.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import Foundation



let internFileSave = "listeEtudiant"

func getPath(fileName: String) -> String{
  let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
  return paths.stringByAppendingString("/\(fileName)")
}



func checkExistSavingFile() -> Bool {
  let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
  let path = paths.stringByAppendingString("/\(internFileSave).plist")
  let fileManager = NSFileManager.defaultManager()
  if (!(fileManager.fileExistsAtPath(path)))
  {
    let bundle : NSString = NSBundle.mainBundle().pathForResource("emptyListStudent", ofType: "plist")!
    do{
      print("copy file...\(path)")
      try fileManager.copyItemAtPath(bundle as String, toPath: path)
    }catch let error as NSError {
      print("error file...\(error.description)")
    }
    return false
  }
  return true
}


func getCurrentForumName(forumName: String) -> String{
  let date = NSDateFormatter()
  date.dateFormat = "dd_MM_yyyy"
  let res =  "\(forumName)_\(date.stringFromDate(NSDate()))"
  
  let sharedDefault = NSUserDefaults.standardUserDefaults()
  if var listFile = sharedDefault.objectForKey("ARRAY_SAVE") as? Array<String> {
    if !listFile.contains(res) {
      listFile.append(res)
      sharedDefault.setObject(listFile, forKey: "ARRAY_SAVE")
    }
  }
  return res
}


func exportListCSV(forumName: String) -> NSData? {
  let path: String = "\(getPath(internFileSave)).plist"
  var strResu = "Id,Nom,Prénom,classe,spécialite,option,ville,departement,email,num téléphone,DUT GEII,DUT MMI,DUT INFO,LP I2M,LP A2I,LP ATC/CDG, LP ATC/TECAMTV,LP A2I,date inscription,forum,news letter\n"
  let Listkey = ["name","lastName","classe","specialite",
              "option","town","dept","email","numTel","integrationDUT","integrationLP","inscriptionDate","forumName", "NewsLetter" ]
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
            
          }else if key  == "integrationDUT" {
            if (etu[key] as! [String]).contains("DUT GEII"){
              strResu += ",DUT GEII"
            }else {strResu += ",--"}
            if (etu[key] as! [String]).contains("DUT MMI"){
              strResu += ",DUT MMI"
            }else {strResu += ",--"}
            if (etu[key] as! [String]).contains("DUT INFO"){
              strResu += ",DUT INFO"
            }else {strResu += ",--"}
          }
          else if key  == "integrationLP" {
            if (etu[key] as! [String]).contains("LP I2M"){
              strResu += ",LP I2M"
            }else {strResu += ",--"}
            if (etu[key] as! [String]).contains("LP A2I"){
              strResu += ",LP A2I"
            }else {strResu += ",--"}
            if (etu[key] as! [String]).contains("LP ATC/CDG"){
              strResu += ",LP ATC/CDG"
            }else {strResu += ",--"}
            if (etu[key] as! [String]).contains("LP ATC/TECAMTV"){
              strResu += ",LP ATC/TECAMTV"
            }else {strResu += ",--"}
            if (etu[key] as! [String]).contains("LP A2I"){
              strResu += ",LP A2I"
            }else {strResu += ",--"}
          }else{
            if etu[key] != nil {
              strResu += ",\(etu[key]!)"
            }else{
              strResu += ",--"
            }
          }
        }
        strResu += "\n"
      }
      strResu.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile("\(getPath(internFileSave)).csv", atomically: true)
      return strResu.dataUsingEncoding(NSUTF8StringEncoding)
    }
  
  return nil
}


func saveListEtud(tabEtu: [Etudiant]){
  var path: String = "\(internFileSave).plist"
  path = getPath(path)
  print("path::: save\(path)")
  var listeEtudiant = Dictionary<String,  Dictionary<String, AnyObject > >()
  for unEtudiant in tabEtu {
    var dicoEtu = Dictionary<String, AnyObject > ()
    dicoEtu["name"] = unEtudiant.myName
    dicoEtu["lastName"] = unEtudiant.myLastName
    dicoEtu["classe"] = unEtudiant.myClass
    dicoEtu["specialite"] = unEtudiant.mySpe
    dicoEtu["option"] = unEtudiant.myOption
    dicoEtu["town"] = unEtudiant.myTown
    dicoEtu["dept"] = unEtudiant.myDept
    dicoEtu["email"] = unEtudiant.myEmail
    dicoEtu["numTel"] = unEtudiant.myTel
    dicoEtu["integrationDUT"] = unEtudiant.myDUTProject
    dicoEtu["integrationLP"] = unEtudiant.myLPProject
    dicoEtu["inscriptionDate"] = unEtudiant.myDateInscription
    dicoEtu["forumName"] = unEtudiant.myForumInscription
    dicoEtu["heureCreation"] = unEtudiant.myHeureCreation
    dicoEtu["NewsLetter"] = unEtudiant.myNewsLetter

    listeEtudiant["\(unEtudiant.myCreationDate)"] = dicoEtu
  }
  (listeEtudiant as NSDictionary).writeToFile(path, atomically: true)

}


func addEtudiant(unEtudiant: Etudiant){
  var path: String = "\(internFileSave).plist"
  path = getPath(path)
  print("path::: save\(path)")
  var listeEtudiant: Dictionary<String,  Dictionary<String, AnyObject > >?
  listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > >
  if listeEtudiant == nil {
    listeEtudiant = Dictionary<String,  Dictionary<String, AnyObject > >()
  }

  var dicoEtu = Dictionary<String, AnyObject > ()
  dicoEtu["name"] = unEtudiant.myName
  dicoEtu["lastName"] = unEtudiant.myLastName
  dicoEtu["classe"] = unEtudiant.myClass
  dicoEtu["specialite"] = unEtudiant.mySpe
  dicoEtu["option"] = unEtudiant.myOption
  dicoEtu["town"] = unEtudiant.myTown
  dicoEtu["dept"] = unEtudiant.myDept
  dicoEtu["email"] = unEtudiant.myEmail
  dicoEtu["numTel"] = unEtudiant.myTel
  dicoEtu["integrationDUT"] = unEtudiant.myDUTProject
  dicoEtu["integrationLP"] = unEtudiant.myLPProject
  dicoEtu["inscriptionDate"] = unEtudiant.myDateInscription
  dicoEtu["forumName"] = unEtudiant.myForumInscription
  dicoEtu["heureCreation"] = unEtudiant.myHeureCreation
  dicoEtu["NewsLetter"] = unEtudiant.myNewsLetter

  listeEtudiant!["\(unEtudiant.myCreationDate)"] = dicoEtu
  (listeEtudiant! as NSDictionary).writeToFile(path, atomically: true)
}





func recoverTableauEtudiant(forum: String) ->[Etudiant] {
  var tabResu = [Etudiant]()
  let path: String = "\(getPath(internFileSave)).plist"
  
  print("path:::\(path)")
  if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject > {
    let sortedListe = listeEtudiant.sort { Double($0.0) < Double($1.0) }

    for (key, etu) in sortedListe {
        let name = etu["name"]! as! String
        let lastName = etu["lastName"]! as! String
        let classe = etu["classe"]! as! String
        let specialite = etu["specialite"]! as! String
        let town = etu["town"]! as! String
        let dept = etu["dept"]! as? Int
        let numTel = etu["numTel"]! as? String
        let email = etu["email"] as? String
        let integrationDUT = etu["integrationDUT"] as? [String]
        let integrationLP = etu["integrationLP"] as? [String]
        let inscriptionDate = etu["inscriptionDate"] as? String
        let forumName = etu["forumName"] as? String
        let heureCreation = etu["heureCreation"] as? String
        let option = etu["option"] as? String
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
        if integrationDUT != nil
        {
          etudiant.myDUTProject = integrationDUT
        }
        if integrationLP != nil  {
          etudiant.myLPProject   = integrationLP
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




