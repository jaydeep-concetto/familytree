//
//  LoginViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 23/12/16.
//  Copyright © 2016 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Alamofire
import ARSLineProgress
import Firebase
import FirebaseInstanceID
import FirebaseMessaging   
class LoginViewController: UIViewController {
    
    var socialfrd:NSMutableArray = NSMutableArray()
    

    
    @IBAction func btnfacebookloginclicked(_ sender: Any) {
        socialfrd  = NSMutableArray()
        
        
            let login = FBSDKLoginManager()
            login.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result, error) in
                if (error != nil) {
                    print("Process error")
                    let alert = UIAlertController(title: "Oops", message: "fcfg\(error)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if (result?.isCancelled)! {
                    let alert = UIAlertController(title: "Oops", message: "\(result)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    print("Logged in")
                    self.getfacebookinfo()
                }
                
            }
    }
    func getfacebookinfo() {
        //me?fields=id,name,picture{url},birthday,email,location,gender,about
        let request = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id,name,birthday,email,gender,picture{url},location,friends{id,name}"], httpMethod: "GET")
        let connection = FBSDKGraphRequestConnection()

        connection.add(request, completionHandler: { (connection, result, error) in

            if (error != nil) {
                print("Picker loading error:\(error)")
                let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let abcd:NSDictionary=result as! NSDictionary
                let fullNameArr = (abcd.value(forKey: "name") as! String).components(separatedBy: " ")

                print("result : \(abcd)")
                var gender:String = String()
                gender = "1"
                if (abcd.value(forKey: "gender") as! String == "female")
                {
                    gender = "2"
                }
                print((abcd.value(forKey: "friends") as! NSDictionary).value(forKey: "data") as! NSArray)
                let abcdtemp:NSArray = (abcd.value(forKey: "friends") as! NSDictionary).value(forKey: "data") as! NSArray
                for i in 0..<abcdtemp.count
                {
                    let tempdict:NSMutableDictionary = NSMutableDictionary()
                    tempdict.setValue((abcdtemp.object(at: i) as! NSDictionary).value(forKey: "id"), forKey: "socialid")
                    self.socialfrd.add(tempdict)
                }
                print(self.socialfrd)
            print("https://graph.facebook.com/\(self.nullvalue(strings:abcd.value(forKey: "id") as Any))/picture?type=large")
                self.login(socialid:self.nullvalue(strings:abcd.value(forKey: "id") as Any), account_typeid: "1", firstname: self.nullvalue(strings:fullNameArr[0] as Any) , lastname: self.nullvalue(strings:fullNameArr[1] as Any) , email: self.nullvalue(strings:abcd.value(forKey: "email") as Any), genderid: gender, socialpicturepath: "https://graph.facebook.com/\(self.nullvalue(strings:abcd.value(forKey: "id") as Any))/picture?width=9999")
            }
        })
        connection.start()
        
    
        
    }
    func nullvalue(strings:Any) -> String {
        var tempstr:Any = strings
        if ("\(tempstr)" == "nil") {
            tempstr = ""
        }
        return tempstr as! String
    }

    
    func login(socialid:String,account_typeid:String,firstname:String,lastname:String,email:String,genderid:String,socialpicturepath:String) {
        var device_id:String = ""
        if FIRInstanceID.instanceID().token() != nil
        {
            device_id = FIRInstanceID.instanceID().token()!
        }
        print(device_id)
        let mainurl = "\(GlobalConstants.MAINURL)login"
        let mainparameter=["socialid": socialid,"account_typeid": account_typeid,"firstname": firstname,"lastname": lastname,"email": email,"genderid": genderid,"socialpicturepath":socialpicturepath,"device_id":device_id,"device_typeid":"2"]
        print(FIRInstanceID.instanceID().token()!)
        ARSLineProgress.show()
        Alamofire.request(mainurl, method: .post, parameters: mainparameter, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    print(JSON)

                if JSON.value(forKey: "status") as! Int == 200 {
                   
                    if (self.nullvalue(ints:((JSON.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "isactive") as AnyObject)) == 1
                    {
                        UserDefaults.standard.set(((JSON.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "userid") as Any, forKey: "userid")
                        UserDefaults.standard.set("\(((JSON.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "api_token") as! String)", forKey: "api_token")
                        UserDefaults.standard.set("\(firstname)", forKey: "firstname")
                        UserDefaults.standard.set("\(lastname)", forKey: "lastname")
                        let url = URL(string: socialpicturepath)
                        
                        let imageData:NSData = NSData(contentsOf: url!)!
                        UserDefaults.standard.set(imageData, forKey: "profilepic")
                        UserDefaults.standard.set("yes", forKey: "starting")
                        self.versionapi()
                    }
                    else
                    {
                        
                        let mainurl1 = "\(GlobalConstants.MAINURL)getfriendregister"
                        let mainparameter1=["api_token": "\(((JSON.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "api_token") as! String)","socialidlist":self.socialfrd] as [String : Any]
                        print(mainparameter1)
                        Alamofire.request(mainurl1, method: .post, parameters: mainparameter1, encoding: JSONEncoding.default)
                            .responseJSON { response in
                                print(response)

                                if response.result.value != nil
                                {
                                    let JSON1 = response.result.value as! NSDictionary
                                    print(JSON1)

                                    if JSON1.value(forKey: "status") as! Int == 200 {
                                        UserDefaults.standard.set(((JSON.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "userid") as Any, forKey: "userid")
                                        UserDefaults.standard.set("\(((JSON.value(forKey: "result") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "api_token") as! String)", forKey: "api_token")
                                        UserDefaults.standard.set("\(firstname)", forKey: "firstname")
                                        UserDefaults.standard.set("\(lastname)", forKey: "lastname")
                                        let url = URL(string: socialpicturepath)
                                        
                                        let imageData:NSData = NSData(contentsOf: url!)!
                                        UserDefaults.standard.set(imageData, forKey: "profilepic")
                                        UserDefaults.standard.set("yes", forKey: "starting")
                                        
                                    }
                                }
                                self.versionapi()
                                
                        }
                    }
                    
                    
                    
                    
                   ARSLineProgress.hide()

                }
                else
                {
                    ARSLineProgress.hide()

                    let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                }
                else
                {
                    ARSLineProgress.hide()

                    let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        if UserDefaults.standard.string(forKey: "userid") == nil {
            UserDefaults.standard.set("0", forKey: "userid")
        }
        if UserDefaults.standard.string(forKey: "userid") != "0" {
            ARSLineProgress.show()
            var device_id:String = ""
            if FIRInstanceID.instanceID().token() != nil
            {
                device_id = FIRInstanceID.instanceID().token()!
            }
            let mainurl1 = "\(GlobalConstants.MAINURL)setdeviceid"
            let mainparameter1=["api_token": UserDefaults.standard.string(forKey: "api_token")!,"device_id":device_id]
            print(mainparameter1)
            Alamofire.request(mainurl1, method: .post, parameters: mainparameter1, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    self.versionapi()
            }
        }
    }
    func versionapi()
    {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let mainurl1 = "\(GlobalConstants.MAINURL)setappversion"
        let mainparameter1=["api_token": UserDefaults.standard.string(forKey: "api_token")!,"device_typeid":"2","app_version":version]
        print(mainparameter1)
        Alamofire.request(mainurl1, method: .post, parameters: mainparameter1, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                ARSLineProgress.hide()
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                secondViewController.userid=UserDefaults.standard.integer(forKey: "userid")
                secondViewController.api_token=UserDefaults.standard.string(forKey: "api_token")!
                
                self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func nullvalue(ints:AnyObject) -> Int {
        var tempstr:AnyObject = ints
        if (tempstr is NSNull) {
            tempstr = 0 as AnyObject
        }
        print(tempstr)
        
        return Int("\(tempstr)")!
    }
}
