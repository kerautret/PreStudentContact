//
//  ToolsInOut.swift
//  PreStudentContact
//
//  Created by kerautret on 12/11/2015.
//  Copyright © 2015 ker. All rights reserved.
//

import Foundation


func getFileURL(fileName: String) -> NSURL? {
  let manager = NSFileManager.defaultManager()
  do{
    let dirURL =  try manager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
    return dirURL.URLByAppendingPathComponent(fileName)

  } catch {
    print("error reading..")
    return nil
  }
}

func getCurrentName(forumName: String) -> String{
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
  let exportName = getCurrentName(forumName)
  print("export: \(exportName)")
  var strResu: String = ""
  var path: String = "\(getCurrentName(forumName)).plist"

  path = getFileURL(path)!.path!
  print("path:::\(path)")

  if let listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > > {
      for (id, etu) in listeEtudiant {
        strResu += "\(id);"
        for (_, attribut) in etu {
          strResu += "\(attribut) "
        }
        strResu += "\n"
      }
      return strResu.dataUsingEncoding(NSUTF8StringEncoding)
    }
  
  return nil
}




func addEtudiant(unEtudiant: Etudiant, forum: String){
  var path: String = "\(getCurrentName(forum)).plist"
  path = getFileURL(path)!.path!
  print("path:::\(path)")

    if var listeEtudiant = NSDictionary(contentsOfFile: path) as? Dictionary<String,  Dictionary<String, AnyObject > > {
      var dicoEtu = Dictionary<String, AnyObject > ()
      dicoEtu["name"] = unEtudiant.myName
      dicoEtu["lastName"] = unEtudiant.myLastName
      dicoEtu["classe"] = unEtudiant.myClass
      dicoEtu["specialite"] = unEtudiant.mySpe
      dicoEtu["town"] = unEtudiant.myTown
      dicoEtu["dept"] = unEtudiant.myDept
      dicoEtu["email"] = unEtudiant.myEmail
      dicoEtu["numTel"] = unEtudiant.myTel
      dicoEtu["integrationDUT"] = unEtudiant.myDUTProject
      dicoEtu["integrationLP"] = unEtudiant.myLPProject
      
      listeEtudiant["\(unEtudiant.hash)"] = dicoEtu
      (listeEtudiant as NSDictionary).writeToFile(path, atomically: true)
    }
  
    
}
  


func recoverTableauEtudiant(forum: String) ->[Etudiant] {
  var tabResu = [Etudiant]()
 
  var path: String = "\(getCurrentName(forum)).plist"
  
  path = getFileURL(path)!.path!
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
        let etudiant = Etudiant(aName: name, aLastName: lastName, aClass: classe, aSpe: specialite, aTown: town)
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
        tabResu.append(etudiant)
      }
    }
  
  return tabResu
  
}




