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
  var strResu = ""
  if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > > {
      for (id, etu) in listeEtudiant {
        strResu += "\(id)"
        for (_, attribut) in etu {
          strResu += ",\(attribut)"
        }
        strResu += "\n"
      }
      strResu.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile("\(getPath(internFileSave)).csv", atomically: true)
      return strResu.dataUsingEncoding(NSUTF8StringEncoding)
    }
  
  return nil
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

      listeEtudiant!["\(unEtudiant.hash)"] = dicoEtu
      (listeEtudiant! as NSDictionary).writeToFile(path, atomically: true)
    
}
  


func recoverTableauEtudiant(forum: String) ->[Etudiant] {
  var tabResu = [Etudiant]()
  let path: String = "\(getPath(internFileSave)).plist"
  
  print("path:::\(path)")
  if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject > {
      for (_, etu) in listeEtudiant {
        let name = etu["name"]! as! String
        let lastName = etu["lastName"]! as! String
        let classe = etu["classe"]! as! String
        let specialite = etu["specialite"]! as! String
        let town = etu["town"]! as! String
        let dept = etu["dept"]! as? Int
        let email = etu["email"] as? String
        let integrationDUT = etu["integrationDUT"] as? String
        let integrationLP = etu["integrationLP"] as? String
        let inscriptionDate = etu["inscriptionDate"] as? String
        let forumName = etu["forumName"] as? String
        let option = etu["option"] as? String
        let etudiant = Etudiant(aName: name, aLastName: lastName, aClass: classe, aSpe: specialite, aTown: town, aForumInscription: forumName!, aDateInscription: inscriptionDate!)
        
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
        if option != nil {
          etudiant.myOption = option
        }
        tabResu.append(etudiant)
      }
    }
  
  return tabResu
  
}




