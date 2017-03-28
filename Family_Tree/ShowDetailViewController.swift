//
//  ShowDetailViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 31/12/16.
//  Copyright © 2016 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import ARSLineProgress
import Toast
import UIFloatLabelTextField
class friendcell: UITableViewCell{
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var imgmain: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btnaddfriend: UIButton!
}
class relativecell: UITableViewCell{
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var imgmain: UIImageView!
    @IBOutlet weak var lblname: UILabel!
}
class ShowDetailViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var tempimage:Data = Data()
    var genderid:String = ""
    var isaliveid:String = ""
    var marital_status:String = ""
    @IBOutlet weak var viewrelativebtn: UIView!
    @IBOutlet var frdviewwidth: NSLayoutConstraint!
    @IBOutlet var scrviewcontentwidth: NSLayoutConstraint!
    var profileid:Int = 0
    var image:String = ""
    var api_token:String = ""
    var isfriend:Int = 0
    var isrequested:Int = 0
    var issentbyfriend:Int = 0
    var friend_requestid:Int = 0
    var myfriend:String = ""
    @IBOutlet weak var lblviewrequest: UILabel!
    @IBOutlet weak var lblmaintraling: NSLayoutConstraint!
    @IBOutlet weak var doeview: UIView!
    var socialid:String = ""
    var mainarr:NSDictionary = NSDictionary()
    var clickdate:String = ""
    var userid:Int = 0
    @IBOutlet weak var scrviewoutlet: UIScrollView!
    @IBOutlet weak var txtfirstname1: UIFloatLabelTextField!
    @IBOutlet weak var txtlastname1: UIFloatLabelTextField!
    @IBOutlet weak var txtcity1: UIFloatLabelTextField!
    @IBOutlet weak var btnmale1: UIButton!
    @IBOutlet weak var btnfemale1: UIButton!
    @IBOutlet weak var btnsingle1: UIButton!
    @IBOutlet weak var btnmarried1: UIButton!
    
    

    @IBOutlet weak var bigimage: UIImageView!
    @IBOutlet weak var bigimageview: UIView!
    @IBOutlet weak var toolbarview2: UIView!
    @IBOutlet weak var toolbarview1: UIView!
    @IBOutlet weak var txtdoe: UIFloatLabelTextField!
    @IBOutlet weak var txtfirstname: UIFloatLabelTextField!
    @IBOutlet weak var txtlastname: UIFloatLabelTextField!
    @IBOutlet weak var txtdob: UIFloatLabelTextField!
    @IBOutlet weak var txtdod: UIFloatLabelTextField!
    @IBOutlet weak var txtmobileno: UIFloatLabelTextField!
    @IBOutlet weak var txtbirthplace: UIFloatLabelTextField!
    @IBOutlet weak var txtvillage: UIFloatLabelTextField!
    @IBOutlet weak var txtaddress: UIFloatLabelTextField!
    @IBOutlet weak var txtcity: UIFloatLabelTextField!
    @IBOutlet weak var txtheight: UIFloatLabelTextField!
    @IBOutlet weak var txtweight: UIFloatLabelTextField!
    @IBOutlet weak var txteducation: UIFloatLabelTextField!
    @IBOutlet weak var txtmaternal_place: UIFloatLabelTextField!
    @IBOutlet weak var deathview: UIView!
    @IBOutlet weak var btnimage: UIButton!
    @IBOutlet weak var btnmale: UIButton!
    @IBOutlet weak var btnfemale: UIButton!
    @IBOutlet weak var btnyes: UIButton!
    @IBOutlet weak var btnsingle: UIButton!
    @IBOutlet weak var btnmarried: UIButton!
    @IBOutlet weak var imgprofilepic: UIImageView!
    @IBOutlet weak var lblmaintitle: UILabel!
    @IBOutlet weak var btnmenu: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var btndob: UIButton!
    @IBOutlet weak var btndod: UIButton!
    @IBOutlet weak var btndoe: UIButton!
    @IBOutlet weak var pickerview: UIView!
    @IBOutlet weak var pickeroutlet: UIDatePicker!
    @IBOutlet weak var deathview1: UIView!  
    @IBOutlet weak var aboutview1: UIView!
    @IBOutlet weak var aboutview2: UIView!
    @IBOutlet weak var bttnsaveview: UIView!

    @IBOutlet weak var requestview: UIView!
    @IBOutlet weak var btnviewtree: UIButton!
    @IBOutlet weak var btnaddfriend: UIButton!
    @IBOutlet weak var btnaddfriendview: UIView!
    @IBOutlet weak var btnabout: UIButton!
    @IBOutlet weak var btnfriend: UIButton!
    @IBOutlet weak var btnabout1: UIButton!
   @IBOutlet weak var btncontact1: UIButton!
    @IBOutlet weak var btncontact: UIButton!
    @IBOutlet weak var aboutheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var friendtable: UITableView!
    @IBOutlet weak var relativetable: UITableView!    
    @IBOutlet weak var viewrequest: UIView!
    @IBOutlet weak var viewrequestheight: NSLayoutConstraint!
    @IBOutlet weak var doemainviewheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var doeviewheightconstraint: NSLayoutConstraint!
    var dateofanniversarylength:CGFloat  = 0
    var friendarr:NSMutableArray = NSMutableArray()
    var relativearr:NSMutableArray = NSMutableArray()
    func getfriend()
    {
        let mainurl = "\(GlobalConstants.MAINURL)getallfriend?api_token=\(UserDefaults.standard.string(forKey: "api_token")!)&userid=\(userid)"
        print(UserDefaults.standard.string(forKey: "api_token")!)
        print(userid)
       // ARSLineProgress.show()
        Alamofire.request(mainurl, method: .get, parameters: nil, encoding: JSONEncoding.default)
           
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    
                    let JSON = response.result.value as! NSDictionary
                    if JSON.value(forKey: "status") as! Int == 200 {
                        self.friendarr=(JSON.value(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
                        self.friendtable.reloadData()
                    }
                }
           
               // ARSLineProgress.hide()
        }
    }
    func respondapi(respond:String){
        let mainurl = "\(GlobalConstants.MAINURL)respondrequest"
        let mainparameter:NSDictionary = ["respondstatusid":respond,"requestid":friend_requestid,"api_token":UserDefaults.standard.string(forKey: "api_token")!]
     
        //ARSLineProgress.show()
        Alamofire.request(mainurl, method: .put, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                        
                        if respond == "2"
                        {
                            self.view.makeToast(self.lblmaintitle.text! + " has been added to your friend list.", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
                        }
                        else
                        {
                            self.view.makeToast("You have declined a friend request.", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
                        }
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Message", message: JSON.value(forKey: "result") as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                //ARSLineProgress.hide()
        }
    }
    @IBAction func btnviewrequestrejectclicked(_ sender: Any) {
        viewrequest.isHidden=true
        viewrequestheight.constant=0
        btnaddfriendview.isHidden=false
        requestview.isHidden=true
        respondapi(respond: "3")
    }
    @IBAction func btnviewrequestacceptclicked(_ sender: Any) {
        viewrequest.isHidden=true
        viewrequestheight.constant=0
        getrelative(tablename: "User_profile1")
        btnviewtree.isHidden=false
        self.lblmaintraling.constant = 65
        
        btnaddfriendview.isHidden=true
        aboutview1.isHidden=false
        aboutview2.isHidden=true
        aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength
        respondapi(respond: "2")
    }
    @IBAction func btnhome1clicked(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[1], animated: true);
    }
    @IBAction func btnviewtreeclicked(_ sender: Any) {
        if userid == UserDefaults.standard.integer(forKey: "userid")
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[1], animated: true);
        }
        else
        {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        secondViewController.userid=userid
        secondViewController.api_token = api_token
        self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    @IBAction func btnaddfriendclicked(_ sender: Any) {
        let mainurl = "\(GlobalConstants.MAINURL)addfriend"
        let mainparameter:NSDictionary = ["socialid":socialid,"api_token":UserDefaults.standard.string(forKey: "api_token")!]
        ARSLineProgress.show()
        Alamofire.request(mainurl, method: .post, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        self.btnaddfriendview.isHidden=true
                        self.requestview.isHidden=false
                       
                        self.view.makeToast("You have sent friend request to " + self.nullvalue(strings: self.mainarr.value(forKey: "firstname") as Any) + " " + self.nullvalue(strings: self.mainarr.value(forKey: "lastname") as Any) + ".", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
                    }
                    else if JSON.value(forKey: "status") as! Int == 409 {
                        let alert = UIAlertController(title: "Message", message: JSON.value(forKey: "result") as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                ARSLineProgress.hide()
        }
    }
    func getrelative(tablename:String)
    {
        var tempprofileid:Int = profileid
        let tempmedict = (AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE id = ?" as NSString, arr: [profileid])).object(at: 0) as! NSDictionary
        if (tempmedict.value(forKey: "spouseid") as! Int) != 0 {

        let tempsdict = ((AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE id = ?" as NSString, arr: [tempmedict.value(forKey: "spouseid") as! Int])).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if (tempmedict.value(forKey: "genderid") as! Int) == 2 {
                tempsdict.setValue("Husband", forKey: "relation")
            }
            else
            {
                tempsdict.setValue("Wife", forKey: "relation")
            }
            self.relativearr.add(tempsdict)
        }
        else
        {
            let tempsarr = (AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE spouseid = ?" as NSString, arr: [profileid]))
            if tempsarr.count != 0
            {
                let tempsdict = (tempsarr.object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                tempprofileid = (tempsdict.value(forKey: "id") as! Int)
                if (tempmedict.value(forKey: "genderid") as! Int) == 2 {
                    tempsdict.setValue("Husband", forKey: "relation")
                }
                else
                {
                    tempsdict.setValue("Wife", forKey: "relation")
                }
                self.relativearr.add(tempsdict)
            }
        }
        if (tempmedict.value(forKey: "parentid") as! Int) != 0 {
            let tempdict = ((AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE id = ?" as NSString, arr: [tempmedict.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            tempdict.setValue("Father", forKey: "relation")
            self.relativearr.add(tempdict)
            if (tempdict.value(forKey: "spouseid") as! Int) != 0 {
                let tempdict = ((AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE id = ?" as NSString, arr: [tempdict.value(forKey: "spouseid") as! Int])).object(at: 0) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                tempdict.setValue("Mother", forKey: "relation")
                self.relativearr.add(tempdict)
            }
            let tempdict12 = (AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE parentid = ? AND id != ?" as NSString, arr: [tempmedict.value(forKey: "parentid") as! Int,profileid]))
            if tempdict12.count != 0 {
                for i in 0..<tempdict12.count {
                    let tempdict1 = (tempdict12.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if (tempdict1.value(forKey: "genderid") as! Int) == 2 {
                        tempdict1.setValue("Sister", forKey: "relation")
                    }
                    else
                    {
                        tempdict1.setValue("Brother", forKey: "relation")
                    }
                    self.relativearr.add(tempdict1)
                }
            }
        }
        let tempdict = (AppDelegate.selectquery(query:"SELECT * FROM \(tablename) WHERE parentid = ?" as NSString, arr: [tempprofileid]))
        if tempdict.count != 0 {
            for i in 0..<tempdict.count {
                let tempdict1 = (tempdict.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if (tempdict1.value(forKey: "genderid") as! Int) == 2 {
                    tempdict1.setValue("Daughter", forKey: "relation")
                }
                else
                {
                    tempdict1.setValue("Son", forKey: "relation")
                }
                self.relativearr.add(tempdict1)
            }
        }
        self.relativetable.reloadData()

    }
    func tempinsert(maindict:NSDictionary) {
        AppDelegate.insertquery(query: "INSERT INTO User_profile1 (id,userid,firstname,lastname,parentid,spouseid,profilepicturepath,mobile,dob,dod,dateofanniversary,birthplace,isalive,marital_statusid,village,genderid,address,city,height,weight,maternal_place,education) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", arr: [maindict.value(forKey: "user_profileid") as AnyObject,maindict.value(forKey: "userid") as AnyObject,nullvalue(strings:maindict.value(forKey: "firstname") as Any),nullvalue(strings:maindict.value(forKey: "lastname") as Any),nullvalue(ints:maindict.value(forKey: "parentid") as AnyObject),nullvalue(ints:maindict.value(forKey: "spouseid") as AnyObject),nullvalue(strings:maindict.value(forKey: "profilepicturepath") as Any),nullvalue(strings:maindict.value(forKey: "mobile") as Any),nullvalue(strings:maindict.value(forKey: "dob") as Any),nullvalue(strings:maindict.value(forKey: "dod") as Any),nullvalue(strings:maindict.value(forKey: "dateofanniversary") as Any),nullvalue(strings:maindict.value(forKey: "birthplace") as Any),nullvalue(ints:maindict.value(forKey: "isalive") as AnyObject),nullvalue(ints:maindict.value(forKey: "marital_statusid") as AnyObject),nullvalue(strings:maindict.value(forKey: "village") as Any),nullvalue(ints:maindict.value(forKey: "genderid") as AnyObject),nullvalue(strings:maindict.value(forKey: "address") as Any),nullvalue(strings:maindict.value(forKey: "city") as Any),nullvalue(ints:maindict.value(forKey: "height") as AnyObject),nullvalue(ints:maindict.value(forKey: "weight") as AnyObject),nullvalue(strings:maindict.value(forKey: "maternal_place") as Any),nullvalue(strings:maindict.value(forKey: "education") as Any)])
    }
    func getotherusertree()
    {
        AppDelegate.insertquery(query: "DELETE FROM User_profile1", arr: [])
        ARSLineProgress.show()
        print(userid)
        Alamofire.request("\(GlobalConstants.MAINURL)getusersprofile?api_token=\(nullvalue(strings:api_token as Any))&userid=\(userid)", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                var JSON:NSDictionary = NSDictionary()
                print(response)
                if response.result.value != nil
                {
                    JSON = response.result.value as! NSDictionary
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                        JSON = (response.result.value as! NSDictionary).value(forKey: "result") as! NSDictionary
                        var enterarr:NSArray = NSArray()
                        self.isfriend = JSON.value(forKey: "isfriend") as! Int
                        self.socialid = JSON.value(forKey: "socialid") as! String
                        self.isrequested = JSON.value(forKey: "isrequestedfriend") as! Int
                        self.issentbyfriend = JSON.value(forKey: "issentbyfriend") as! Int
                        self.friend_requestid = self.nullvalue(ints:JSON.value(forKey: "friend_requestid") as AnyObject)

                        enterarr = JSON.value(forKey: "me") as! NSArray
                        if (enterarr.count == 0)
                        {
                            
                        }
                        else
                        {
                            let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                            self.tempinsert(maindict: tempdict12)
                            if self.profileid == 0
                            {
                                
                                self.profileid = self.nullvalue(ints:tempdict12.value(forKey: "user_profileid") as AnyObject)
                            }
                            enterarr = JSON.value(forKey: "spouse") as! NSArray
                            if (enterarr.count != 0)
                            {
                                let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                self.tempinsert(maindict: tempdict12)
                            }
                            enterarr = JSON.value(forKey: "parents") as! NSArray
                            if (enterarr.count > 0)
                            {
                                
                                
                                let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                
                                self.tempinsert(maindict: tempdict12)
                                enterarr = JSON.value(forKey: "parents") as! NSArray
                                if (enterarr.count > 1)
                                {
                                    
                                    let tempdict12:NSDictionary = enterarr.object(at: 1) as! NSDictionary
                                    
                                    self.tempinsert(maindict: tempdict12)
                                    
                                }
                                enterarr = JSON.value(forKey: "grandparents") as! NSArray
                                if (enterarr.count > 0)
                                {
                                    
                                    let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                
                                    self.tempinsert(maindict: tempdict12)
                                    enterarr = JSON.value(forKey: "grandparents") as! NSArray
                                    if (enterarr.count > 1)
                                    {
                                        
                                        let tempdict12:NSDictionary = enterarr.object(at: 1) as! NSDictionary
                                        
                                        self.tempinsert(maindict: tempdict12)
                                    }
                                    enterarr = JSON.value(forKey: "greatgrandparents") as! NSArray
                                    if (enterarr.count > 0)
                                    {
                                        let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                        self.tempinsert(maindict: tempdict12)
                                        enterarr = JSON.value(forKey: "greatgrandparents") as! NSArray
                                        if (enterarr.count > 1)
                                        {
                                            let tempdict12:NSDictionary = enterarr.object(at: 1) as! NSDictionary
                                            self.tempinsert(maindict: tempdict12)
                                        }
                                    }
                                }
                            }
                        }
                        var siblingarr:NSArray = NSArray()
                        siblingarr = JSON.value(forKey: "siblings") as! NSArray
                        var childarr:NSArray = NSArray()
                        childarr = JSON.value(forKey: "childs") as! NSArray
                        for i in 0..<siblingarr.count
                        {
                            let tempdict12:NSDictionary = siblingarr.object(at: i) as! NSDictionary
                            self.tempinsert(maindict: tempdict12)
                        }
                        for i in 0..<childarr.count
                        {
                            let tempdict12:NSDictionary = childarr.object(at: i) as! NSDictionary
                            self.tempinsert(maindict: tempdict12)
                        }
                    }
                }
                self.setthing()
                ARSLineProgress.hide()
        }
    }
    func setthing()
    {
       
        pickeroutlet.maximumDate=NSDate() as Date
        btnmenu.isHidden=false
        bttnsaveview.isHidden=true
        
        if userid == UserDefaults.standard.integer(forKey: "userid") {
            
            mainarr = (AppDelegate.selectquery(query:"SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [profileid])).object(at: 0) as! NSDictionary
            
            isaliveid = "\(mainarr.value(forKey: "isalive") as! Int)"
            marital_status = "\(mainarr.value(forKey: "marital_statusid") as! Int)"
            genderid = "\(mainarr.value(forKey: "genderid") as! Int)"
            print(mainarr)
            image = nullvalue(strings: mainarr.value(forKey: "profilepicturepath") as Any)
            if (image != "") {
                imgprofilepic.sd_setImage(with: URL(string:"\(getDocumentsDirectory())/\(image)"))
                let baseURL = NSURL(string: "\(getDocumentsDirectory())/\(image)")
                tempimage = try! NSData(contentsOf:baseURL as! URL) as Data
            }
            else
            {
                if genderid == "2" {
                    imgprofilepic.image=UIImage(named:"girl.png")
                }
                else {
                    imgprofilepic.image=UIImage(named:"man.png")
                }
            }
            let dateFormatter = DateFormatter()
            var a1str:String = nullvalue(strings:mainarr.value(forKey: "dob") as Any)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if a1str != ""  && a1str != "0000-00-00 00:00:00" {
                let a2:Date = dateFormatter.date(from: a1str)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                a1str = dateFormatter.string(from: a2)
            }
            
            var a2str:String = nullvalue(strings:mainarr.value(forKey: "dod") as Any)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if a2str != ""  && a2str != "0000-00-00 00:00:00" {
                let a2:Date = dateFormatter.date(from: a2str)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                a2str = dateFormatter.string(from: a2)
            }
            else
            {
                a2str = ""
            }
            var a3str:String = nullvalue(strings:mainarr.value(forKey: "dateofanniversary") as Any)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if a3str != ""  && a3str != "0000-00-00 00:00:00" {
                let a3:Date = dateFormatter.date(from: a3str)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                a3str = dateFormatter.string(from: a3)
            }
            else
            {
                a3str = ""
            }
            txtdob.text = a1str
            txtdod.text = a2str
            txtdoe.text = a3str

            getrelative(tablename: "User_profile")
            btnviewtree.isHidden=false
            self.lblmaintraling.constant = 65

            btnaddfriendview.isHidden=true
            aboutview1.isHidden=false
            aboutview2.isHidden=true
            aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength
            if (nullvalue(ints:mainarr.value(forKey: "userid") as AnyObject)) != 0
            {
                viewrelativebtn.isHidden = true
                scrviewcontentwidth.constant=self.view.frame.size.width*3
                frdviewwidth.constant=self.view.frame.size.width
                
            }
            else
            {
                viewrelativebtn.isHidden = false
                scrviewcontentwidth.constant=self.view.frame.size.width*2
                frdviewwidth.constant=0
                btnviewtree.isHidden=true

            }
        }
        else
        {
            print(profileid)
            let mainarr1=(AppDelegate.selectquery(query:"SELECT * FROM User_profile1 WHERE id = ?", arr: [profileid]))
            if mainarr1.count != 0 {
            
            mainarr = mainarr1.object(at: 0) as! NSDictionary
            
            btnmenu.isHidden = true
            isaliveid = "\(mainarr.value(forKey: "isalive") as! Int)"
            marital_status = "\(mainarr.value(forKey: "marital_statusid") as! Int)"
            genderid = "\(mainarr.value(forKey: "genderid") as! Int)"
            image = nullvalue(strings: mainarr.value(forKey: "profilepicturepath") as Any)
            if (image != "") {
                imgprofilepic.sd_setImage(with: URL(string:image))
                let baseURL = NSURL(string: image)
                tempimage = try! NSData(contentsOf:baseURL as! URL) as Data
            }
            else
            {
                if genderid == "2" {
                    imgprofilepic.image=UIImage(named:"girl.png")
                }
                else {
                    imgprofilepic.image=UIImage(named:"man.png")
                }
            }
           // if userid == UserDefaults.standard.integer(forKey: "userid") {
               
            if isfriend == 1 {
                getrelative(tablename: "User_profile1")
                btnviewtree.isHidden=false
                self.lblmaintraling.constant = 65

                btnaddfriendview.isHidden=true
                aboutview1.isHidden=false
                aboutview2.isHidden=true
                aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength
            }
            else
            {
                btnviewtree.isHidden=true
                self.lblmaintraling.constant = 10

                if isrequested == 1
                {
                    if issentbyfriend == 1
                    {
                        btnaddfriendview.isHidden=true
                        requestview.isHidden=true
                        viewrequest.isHidden=false
                        viewrequestheight.constant=91
                        lblviewrequest.text="You got a friend request from \(mainarr.value(forKey: "firstname") as! String)"
                    }
                    else
                    {
                        btnaddfriendview.isHidden=true
                        requestview.isHidden=false
                    }
                  
                }
                else
                {
                    if issentbyfriend == 1
                    {
                        btnaddfriendview.isHidden=true
                        requestview.isHidden=true
                        viewrequest.isHidden=false
                        viewrequestheight.constant=91
                        lblviewrequest.text="You got a friend request from \(mainarr.value(forKey: "firstname") as! String)"
                    }
                    else
                    {
                        btnaddfriendview.isHidden=false
                        requestview.isHidden=true
                    }
                }
                aboutview1.isHidden=true
                aboutview2.isHidden=false
                aboutheightconstraint.constant = 190
            }
            }
            let dateFormatter = DateFormatter()
            var a1str:String = nullvalue(strings:mainarr.value(forKey: "dob") as Any)
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            if a1str != "" && a1str != "0000-00-00 00:00:00" {
                let a2:Date = dateFormatter.date(from: a1str)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                a1str = dateFormatter.string(from: a2)
            }
            
            var a2str:String = nullvalue(strings:mainarr.value(forKey: "dod") as Any)
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            if a2str != "" && a2str != "0000-00-00 00:00:00" {
                let a2:Date = dateFormatter.date(from: a2str)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                a2str = dateFormatter.string(from: a2)
            }
            else
            {
                a2str = ""
            }
            
            var a3str:String = nullvalue(strings:mainarr.value(forKey: "dateofanniversary") as Any)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if a3str != ""  && a3str != "0000-00-00 00:00:00" {
                let a3:Date = dateFormatter.date(from: a3str)!
                dateFormatter.dateFormat = "dd-MMM-yyyy"
                a3str = dateFormatter.string(from: a3)
            }
            else
            {
                a3str = ""
            }

            txtdob.text = a1str
            txtdod.text = a2str
            txtdoe.text = a3str
            if (nullvalue(ints:mainarr.value(forKey: "userid") as AnyObject)) != 0
            {
                viewrelativebtn.isHidden = true
                scrviewcontentwidth.constant=self.view.frame.size.width*3
                frdviewwidth.constant=self.view.frame.size.width
                
            }
            else
            {
                viewrelativebtn.isHidden = false
                scrviewcontentwidth.constant=self.view.frame.size.width*2
                frdviewwidth.constant=0
                btnviewtree.isHidden=true
                
            }
           // }
        }
        getfriend()
        txtfirstname.text = nullvalue(strings: mainarr.value(forKey: "firstname") as Any)
        txtlastname.text = nullvalue(strings: mainarr.value(forKey: "lastname") as Any)
        
        txtmobileno.text = nullvalue(strings: mainarr.value(forKey: "mobile") as Any)
        txtbirthplace.text = nullvalue(strings: mainarr.value(forKey: "birthplace") as Any)
        txtvillage.text = nullvalue(strings: mainarr.value(forKey: "village") as Any)
        txtaddress.text = nullvalue(strings: mainarr.value(forKey: "address") as Any)
        txtcity.text = nullvalue(strings: mainarr.value(forKey: "city") as Any)
        txteducation.text = nullvalue(strings: mainarr.value(forKey: "education") as Any)
        txtmaternal_place.text = nullvalue(strings: mainarr.value(forKey: "maternal_place") as Any)

        txtheight.text = "\(nullvalue(ints: mainarr.value(forKey: "height") as AnyObject))"
        txtweight.text = "\(nullvalue(ints: mainarr.value(forKey: "weight") as AnyObject))"
        lblmaintitle.text = nullvalue(strings: mainarr.value(forKey: "firstname") as Any) + " " + nullvalue(strings: mainarr.value(forKey: "lastname") as Any)
        txtfirstname1.text = nullvalue(strings: mainarr.value(forKey: "firstname") as Any)
        txtlastname1.text = nullvalue(strings: mainarr.value(forKey: "lastname") as Any)
        txtcity1.text = nullvalue(strings: mainarr.value(forKey: "city") as Any)
        
        
        
        
        if isaliveid == "1" {
            btnyes.setImage(UIImage(named:"radio_on.png"), for: .normal)
        }
        else
        {
            btnyes.setImage(UIImage(named:"radio_off.png"), for: .normal)
            deathview.isHidden=false
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
            deathview1.frame=CGRect(x:deathview1.frame.origin.x,y:btnyes.frame.origin.y+35,width:deathview1.frame.size.width,height:deathview1.frame.size.height)
            
            
        }
        if genderid == "2" {
            btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btniabackground)
            btnfemale.backgroundColor = (GlobalConstants.btnabackground)
            btnmale1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnfemale1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmale1.backgroundColor = (GlobalConstants.btniabackground)
            btnfemale1.backgroundColor = (GlobalConstants.btnabackground)
        }
        else if genderid == "1"
        {
            btnmale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btnabackground)
            btnfemale.backgroundColor = (GlobalConstants.btniabackground)
            btnmale1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnfemale1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmale1.backgroundColor = (GlobalConstants.btnabackground)
            btnfemale1.backgroundColor = (GlobalConstants.btniabackground)
        }
        
        if marital_status == "1" {
            btnsingle.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmarried.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnsingle.backgroundColor = (GlobalConstants.btnabackground)
            btnmarried.backgroundColor = (GlobalConstants.btniabackground)
            btnsingle1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmarried1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnsingle1.backgroundColor = (GlobalConstants.btnabackground)
            btnmarried1.backgroundColor = (GlobalConstants.btniabackground)
            dateofanniversarylength = 0
            doeview.isHidden=true
            doeviewheightconstraint.constant = 485
            doemainviewheightconstraint.constant = 0
            aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength
        }
        else if marital_status == "2" {
            btnsingle.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmarried.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnsingle.backgroundColor = (GlobalConstants.btniabackground)
            btnmarried.backgroundColor = (GlobalConstants.btnabackground)
            btnsingle1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmarried1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnsingle1.backgroundColor = (GlobalConstants.btniabackground)
            btnmarried1.backgroundColor = (GlobalConstants.btnabackground)
            dateofanniversarylength = 51
            doeview.isHidden=false
            doeviewheightconstraint.constant = 536
            doemainviewheightconstraint.constant = 51
            aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength

        }
        btnmale1.addTarget(self, action: #selector(genderbtn(_:)), for: .touchUpInside)
        btnfemale1.addTarget(self, action: #selector(genderbtn(_:)), for: .touchUpInside)
        btnsingle1.addTarget(self, action: #selector(maritalbtn(_:)), for: .touchUpInside)
        btnmarried1.addTarget(self, action: #selector(maritalbtn(_:)), for: .touchUpInside)
        btnmale.addTarget(self, action: #selector(genderbtn(_:)), for: .touchUpInside)
        btnfemale.addTarget(self, action: #selector(genderbtn(_:)), for: .touchUpInside)
        btnyes.addTarget(self, action: #selector(isalivebtn(_:)), for: .touchUpInside)
        btnsingle.addTarget(self, action: #selector(maritalbtn(_:)), for: .touchUpInside)
        btnmarried.addTarget(self, action: #selector(maritalbtn(_:)), for: .touchUpInside)
        btndob.addTarget(self, action: #selector(dobbtn(_:)), for: .touchUpInside)
        btndod.addTarget(self, action: #selector(dodbtn(_:)), for: .touchUpInside)
        btndoe.addTarget(self, action: #selector(doebtn(_:)), for: .touchUpInside)

        btnsave.addTarget(self, action: #selector(savebtn(_:)), for: .touchUpInside)
          
        
        enableornot(check: false)
        //btnviewtree.isHidden=false
   
    }
   
   
    @IBAction func btnbigimageviewclicked(_ sender: Any) {
        bigimage.image = imgprofilepic.image
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.5)
        bigimageview.alpha=0
        bigimage.frame=CGRect(x:50,y:110,width:0,height:0)
        UIView.commitAnimations()
    }
    
override func viewWillLayoutSubviews(){
    
        if myfriend != ""
        {
            if myfriend != "0"
            {
                scrviewoutlet.contentOffset=CGPoint(x:self.view.frame.size.width,y:0)
                myfriend = "\(Int(myfriend)!-1)"
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewrequest.isHidden=true
        viewrequestheight.constant=0

        settextfield(textField2: txtfirstname1)
        settextfield(textField2: txtlastname1)
        settextfield(textField2: txtcity1)
        settextfield(textField2: txtfirstname)
        settextfield(textField2: txtlastname)
        settextfield(textField2: txtdob)
        settextfield(textField2: txtdod)
        settextfield(textField2: txtdoe)
        settextfield(textField2: txtmobileno)
        settextfield(textField2: txtbirthplace)
        settextfield(textField2: txtvillage)
        settextfield(textField2: txtaddress)
        settextfield(textField2: txtcity)
        settextfield(textField2: txtheight)
        settextfield(textField2: txtweight)
        settextfield(textField2: txteducation)
        settextfield(textField2: txtmaternal_place)
        btnabout1.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnabout1.backgroundColor = (GlobalConstants.btnabackground)
        btncontact1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btncontact1.backgroundColor = (GlobalConstants.btniabackground)

        btnabout.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnabout.backgroundColor = (GlobalConstants.btnabackground)
        btnfriend.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnfriend.backgroundColor = (GlobalConstants.btniabackground)
        btncontact.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btncontact.backgroundColor = (GlobalConstants.btniabackground)
        btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmale.backgroundColor = (GlobalConstants.btniabackground)
        btnfemale.backgroundColor = (GlobalConstants.btniabackground)
        btnsingle.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmarried.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnsingle.backgroundColor = (GlobalConstants.btniabackground)
        btnmarried.backgroundColor = (GlobalConstants.btniabackground)
        btnmale1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnfemale1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmale1.backgroundColor = (GlobalConstants.btniabackground)
        btnfemale1.backgroundColor = (GlobalConstants.btniabackground)
        btnsingle1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmarried1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnsingle1.backgroundColor = (GlobalConstants.btniabackground)
        btnmarried1.backgroundColor = (GlobalConstants.btniabackground)
        self.friendtable.tableFooterView = UIView.init(frame: CGRect.zero)
        self.relativetable.tableFooterView = UIView.init(frame: CGRect.zero)
        toolbarview1.backgroundColor = GlobalConstants.toolbar1
        toolbarview2.backgroundColor = GlobalConstants.toolbar2

        if userid == UserDefaults.standard.integer(forKey: "userid") {

        setthing()
        }
        else
        {
            getotherusertree()
        }
        // Do any additional setup after loading the view.
    }
    
    func nullvalue(strings:Any) -> String {
        var tempstr:Any = strings
        if (tempstr is NSNull) {
            tempstr = ""
        }
        print(tempstr)
        return tempstr as! String
    }
    func enableornot(check:Bool) {
        btnimage.isUserInteractionEnabled=true
        txtfirstname.isUserInteractionEnabled=check
        txtfirstname.isUserInteractionEnabled=check
        txtlastname.isUserInteractionEnabled=check
        btndob.isUserInteractionEnabled=check
        btndod.isUserInteractionEnabled=check
        btndoe.isUserInteractionEnabled=check

        txtdob.isUserInteractionEnabled=false
        txtdod.isUserInteractionEnabled=false
        txtdoe.isUserInteractionEnabled=false

        txtmobileno.isUserInteractionEnabled=check
        txtbirthplace.isUserInteractionEnabled=check
        txtvillage.isUserInteractionEnabled=check
        txteducation.isUserInteractionEnabled=check
        txtmaternal_place.isUserInteractionEnabled=check
        txtaddress.isUserInteractionEnabled=check
        txtcity.isUserInteractionEnabled=check
        txtheight.isUserInteractionEnabled=check
        txtweight.isUserInteractionEnabled=check
            btnmale.isUserInteractionEnabled=check
            btnfemale.isUserInteractionEnabled=check
            btnmale1.isUserInteractionEnabled=check
            btnfemale1.isUserInteractionEnabled=check
        
        btnyes.isUserInteractionEnabled=check
        btnsingle.isUserInteractionEnabled=check
        btnmarried.isUserInteractionEnabled=check
        btnsingle1.isUserInteractionEnabled=check
        btnmarried1.isUserInteractionEnabled=check
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerview.isHidden=true
        return true
    }
    func nullvalue(ints:AnyObject) -> Int {
        var tempstr:AnyObject = ints
        if (tempstr is NSNull) {
            tempstr = 0 as AnyObject
        }
        print(tempstr)
        
        return Int("\(tempstr)")!
    }
    func btndeleteclicked() {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the node", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{ action in
            AppDelegate.insertquery(query: "UPDATE User_profile SET issync = 0,isdeleted = 1 WHERE id = ?", arr: [self.profileid])
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler:{ action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    func maritalbtn(_ sender: UIButton) {
        if sender == btnsingle {
            btnsingle.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmarried.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnsingle.backgroundColor = (GlobalConstants.btnabackground)
            btnmarried.backgroundColor = (GlobalConstants.btniabackground)
            btnsingle1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmarried1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnsingle1.backgroundColor = (GlobalConstants.btnabackground)
            btnmarried1.backgroundColor = (GlobalConstants.btniabackground)
            marital_status = "1"
            dateofanniversarylength = 0
            doeview.isHidden=true
            doeviewheightconstraint.constant = 485
            doemainviewheightconstraint.constant = 0
            aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength
        }
        else if sender == btnmarried {
            btnsingle.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmarried.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnsingle.backgroundColor = (GlobalConstants.btniabackground)
            btnmarried.backgroundColor = (GlobalConstants.btnabackground)
            btnsingle1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmarried1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnsingle1.backgroundColor = (GlobalConstants.btniabackground)
            btnmarried1.backgroundColor = (GlobalConstants.btnabackground)
            marital_status = "2"
            dateofanniversarylength = 51
            doeview.isHidden=false
            doeviewheightconstraint.constant = 536
            doemainviewheightconstraint.constant = 51
            aboutheightconstraint.constant = CGFloat(737) + dateofanniversarylength
        }
        
    }
    func genderbtn(_ sender: UIButton) {
        if sender == btnmale {
            btnmale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btnabackground)
            btnfemale.backgroundColor = (GlobalConstants.btniabackground)
            btnmale1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnfemale1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmale1.backgroundColor = (GlobalConstants.btnabackground)
            btnfemale1.backgroundColor = (GlobalConstants.btniabackground)
            genderid = "1"
            if tempimage.count == 0 {
                imgprofilepic.image=UIImage(named:"man.png")

            }
        }
        else
        {
            btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btniabackground)
            btnfemale.backgroundColor = (GlobalConstants.btnabackground)
            btnmale1.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnfemale1.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmale1.backgroundColor = (GlobalConstants.btniabackground)
            btnfemale1.backgroundColor = (GlobalConstants.btnabackground)
            genderid = "2"
            if tempimage.count == 0 {
                imgprofilepic.image=UIImage(named:"girl.png")
            }
        }
    }
    func isalivebtn(_ sender: UIButton) {
        if isaliveid == "1" {
            btnyes.setImage(UIImage(named:"radio_off.png"), for: .normal)
            isaliveid = "0"
            deathview.isHidden=false
            UIView.beginAnimations("zoom", context: nil)
            UIView.setAnimationDuration(0.3)
            deathview1.frame=CGRect(x:deathview1.frame.origin.x,y:sender.frame.origin.y+35,width:deathview1.frame.size.width,height:deathview1.frame.size.height)
          
            UIView.commitAnimations()
            
        }
        else
        {
            btnyes.setImage(UIImage(named:"radio_on.png"), for: .normal)
            isaliveid = "1"
            UIView.beginAnimations("zoom", context: nil)
            UIView.setAnimationDuration(0.3)
        deathview1.frame=CGRect(x:deathview1.frame.origin.x,y:sender.frame.origin.y,width:deathview1.frame.size.width,height:deathview1.frame.size.height)
            UIView.setAnimationDelay(0.3)
            deathview.isHidden=true
            UIView.commitAnimations()
            txtdod.text = ""
        }
    }
    func savebtn(_ sender: UIButton) {
        
            if (image == "") {
                let nowDouble:String = "\(NSDate().timeIntervalSince1970*1000)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MM yyyy hh mm ss"
                image = dateFormatter.string(from: NSDate() as Date)
                image = image+nowDouble
                image = image.replacingOccurrences(of: " ", with: "")+".png"
            }
            if tempimage.count == 0 {
                image = ""
            }
            else
            {
                let directorypath: URL = URL(fileURLWithPath: getDocumentsDirectory()).appendingPathComponent(image)
                try? tempimage.write(to: directorypath)
            }
            var dobstr:String = ""
            var dodstr:String = ""
            var doestr:String = ""

            if txtdob.text! != ""
            {
                let dateformatter12:DateFormatter = DateFormatter()
                dateformatter12.dateFormat = "dd-MMM-yyyy"
                let temps = dateformatter12.date(from: txtdob.text!)
                dateformatter12.dateFormat = "yyyy-MM-dd"
                dobstr = dateformatter12.string(from: temps!)
            }
            if txtdod.text! != ""
            {
                let dateformatter12:DateFormatter = DateFormatter()
                dateformatter12.dateFormat = "dd-MMM-yyyy"
                let temps = dateformatter12.date(from: txtdod.text!)
                dateformatter12.dateFormat = "yyyy-MM-dd"
                dodstr = dateformatter12.string(from: temps!)
            }
        if txtdoe.text! != ""
        {
            let dateformatter12:DateFormatter = DateFormatter()
            dateformatter12.dateFormat = "dd-MMM-yyyy"
            let temps = dateformatter12.date(from: txtdoe.text!)
            dateformatter12.dateFormat = "yyyy-MM-dd"
            doestr = dateformatter12.string(from: temps!)
        }
             lblmaintitle.text = txtfirstname.text! + " " + txtlastname.text!
                AppDelegate.insertquery(query: "UPDATE User_profile SET firstname = ?,lastname=?,mobile=?,dob=?,dod=?,dateofanniversary=?,birthplace=?,isalive=?,marital_statusid=?,village=?,maternal_place=?,education=?,genderid=?,address=?,city=?,height=?,weight=?,issync=0,profilepicturepath=? WHERE id = ?", arr: [txtfirstname.text!,txtlastname.text!,txtmobileno.text!,dobstr,dodstr,doestr,txtbirthplace.text!,isaliveid,marital_status,txtvillage.text!,txtmaternal_place.text!,txteducation.text!,genderid,txtaddress.text!,txtcity.text!,txtheight.text!,txtweight.text!,image,profileid])
        
            btnmenu.isHidden=false
            bttnsaveview.isHidden=true
            btnviewtree.isHidden=false
            self.lblmaintraling.constant = 65

            enableornot(check: false)
    }

    @IBAction func btnhomeclicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func btnaboutclicked(_ sender: Any) {
        btnabout.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnabout.backgroundColor = (GlobalConstants.btnabackground)
        btnfriend.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnfriend.backgroundColor = (GlobalConstants.btniabackground)
        btncontact.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btncontact.backgroundColor = (GlobalConstants.btniabackground)
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.3)
        scrviewoutlet.contentOffset=CGPoint(x:0,y:0)
        UIView.commitAnimations()
    }
    
    @IBAction func btnfriendclicked(_ sender: Any) {
        btnfriend.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnfriend.backgroundColor = (GlobalConstants.btnabackground)
        btnabout.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnabout.backgroundColor = (GlobalConstants.btniabackground)
        btncontact.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btncontact.backgroundColor = (GlobalConstants.btniabackground)
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.3)
        scrviewoutlet.contentOffset=CGPoint(x:self.view.frame.size.width,y:0)
        UIView.commitAnimations()
    }
    @IBAction func btncontactclicked(_ sender: Any) {
        btncontact.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btncontact.backgroundColor = (GlobalConstants.btnabackground)
        btnfriend.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnfriend.backgroundColor = (GlobalConstants.btniabackground)
        btnabout.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnabout.backgroundColor = (GlobalConstants.btniabackground)
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.3)
        scrviewoutlet.contentOffset=CGPoint(x:self.view.frame.size.width*2,y:0)
        UIView.commitAnimations()
    }
    @IBAction func btnabout1clicked(_ sender: UIButton) {
        btnabout1.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnabout1.backgroundColor = (GlobalConstants.btnabackground)
        btncontact1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btncontact1.backgroundColor = (GlobalConstants.btniabackground)
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.3)
        scrviewoutlet.contentOffset=CGPoint(x:0,y:0)
        UIView.commitAnimations()
    }
    @IBAction func btncontact1clicked(_ sender: UIButton) {
        btncontact1.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btncontact1.backgroundColor = (GlobalConstants.btnabackground)
        btnabout1.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnabout1.backgroundColor = (GlobalConstants.btniabackground)
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.3)
        scrviewoutlet.contentOffset=CGPoint(x:self.view.frame.size.width,y:0)
        UIView.commitAnimations()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrviewoutlet {
            
            if (nullvalue(ints:mainarr.value(forKey: "userid") as AnyObject)) != 0
            {
                if scrollView.contentOffset.x<self.view.frame.size.width/2 {
                    btnabout.setTitleColor(GlobalConstants.btnatext, for: .normal)
                    btnabout.backgroundColor = (GlobalConstants.btnabackground)
                    btnfriend.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btnfriend.backgroundColor = (GlobalConstants.btniabackground)
                    btncontact.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btncontact.backgroundColor = (GlobalConstants.btniabackground)
                }
                else if (scrollView.contentOffset.x>(self.view.frame.size.width*(1/2)) && scrollView.contentOffset.x<(self.view.frame.size.width*(3/2))) {
                    btnfriend.setTitleColor(GlobalConstants.btnatext, for: .normal)
                    btnfriend.backgroundColor = (GlobalConstants.btnabackground)
                    btnabout.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btnabout.backgroundColor = (GlobalConstants.btniabackground)
                    btncontact.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btncontact.backgroundColor = (GlobalConstants.btniabackground)
                }
                else if scrollView.contentOffset.x>self.view.frame.size.width*(3/2) {
                    btncontact.setTitleColor(GlobalConstants.btnatext, for: .normal)
                    btncontact.backgroundColor = (GlobalConstants.btnabackground)
                    btnfriend.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btnfriend.backgroundColor = (GlobalConstants.btniabackground)
                    btnabout.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btnabout.backgroundColor = (GlobalConstants.btniabackground)
                }
            }
            else
            {
                if scrollView.contentOffset.x<self.view.frame.size.width/2 {
                    btnabout1.setTitleColor(GlobalConstants.btnatext, for: .normal)
                    btnabout1.backgroundColor = (GlobalConstants.btnabackground)
                    btncontact1.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btncontact1.backgroundColor = (GlobalConstants.btniabackground)
                }
                else if (scrollView.contentOffset.x>(self.view.frame.size.width*(1/2)) && scrollView.contentOffset.x<(self.view.frame.size.width*(3/2))) {
                    btncontact1.setTitleColor(GlobalConstants.btnatext, for: .normal)
                    btncontact1.backgroundColor = (GlobalConstants.btnabackground)
                    btnabout1.setTitleColor(GlobalConstants.btniatext, for: .normal)
                    btnabout1.backgroundColor = (GlobalConstants.btniabackground)
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == friendtable {
            return friendarr.count
        }
        else
        {
            return relativearr.count
        }
    }
    func addfriendbtnss (_ sender: UIButton){
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        secondViewController.actionstr = "Add Friend"
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    func addmemberbtnss (_ sender: UIButton){
        UserDefaults.standard.set("yes", forKey: "addmember")
        _ = self.navigationController?.popViewController(animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == friendtable {
            var numOfSections: Int = 0
            if friendarr.count>0
            {
                tableView.separatorStyle = .singleLine
                numOfSections            = 1
                tableView.backgroundView = nil
            }
            else
            {
                if userid == UserDefaults.standard.integer(forKey: "userid") {

                let noDataLabel1: UIView     = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                let noDataLabel: UIButton     = UIButton(frame: CGRect(x: (noDataLabel1.frame.size.width-200)/2, y: 200, width: 200, height: 54))
                noDataLabel.addTarget(self, action: #selector(addfriendbtnss(_:)), for: .touchUpInside)

                noDataLabel1.addSubview(noDataLabel)

                noDataLabel.setImage(UIImage(named:"shadow-search-new-friends.png"), for: .normal)
                tableView.backgroundView = noDataLabel1
                //tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                }
                else
                {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                }
            }
            return numOfSections
        }
        else
        {
            var numOfSections: Int = 0
            if relativearr.count>0
            {
                tableView.separatorStyle = .singleLine
                numOfSections            = 1
                tableView.backgroundView = nil
            }
            else
            {
                if userid == UserDefaults.standard.integer(forKey: "userid") {

                let noDataLabel1: UIView     = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                let noDataLabel: UIButton     = UIButton(frame: CGRect(x: (noDataLabel1.frame.size.width-200)/2, y: 200, width: 200, height: 54))
                noDataLabel.addTarget(self, action: #selector(addmemberbtnss(_:)), for: .touchUpInside)

                noDataLabel1.addSubview(noDataLabel)

                noDataLabel.setImage(UIImage(named:"shadow-add-member.png"), for: .normal)
                tableView.backgroundView = noDataLabel1
                //tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none

                }
                else
                {
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                }
            }
            return numOfSections
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == friendtable {
            let cellIdentifier = "reuse"
            let cell:friendcell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! friendcell
            cell.lblname.text = nullvalue(strings:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "firstname") as Any) + " " + nullvalue(strings:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "lastname") as Any)
            if (nullvalue(strings:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "city") as Any) != "")
            {
                cell.lblname.text = cell.lblname.text! + " (" + nullvalue(strings:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "city") as Any).capitalized + ")"
            }
            cell.lblemail.text = ""
            if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "marital_statusid") as AnyObject) == 1)
            {
                cell.lblemail.text = cell.lblemail.text! + "Single, "
            }
            else
            {
                cell.lblemail.text = cell.lblemail.text! + "Married, "
            }
            if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2)
            {
                cell.lblemail.text = cell.lblemail.text! + "Female, "
            }
            else if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 1)
            {
                cell.lblemail.text = cell.lblemail.text! + "Male, "
            }
            let dob = nullvalue(strings:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "dob") as Any)
            if dob != "" && dob != "0000-00-00 00:00:00" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                cell.lblemail.text = cell.lblemail.text! + calculateAge(birthday:dateFormatter.date(from: dob)!)
            }
            else
            {
                cell.lblemail.text = String(cell.lblemail.text!.characters.dropLast())
                cell.lblemail.text = String(cell.lblemail.text!.characters.dropLast())
            }
            if userid != UserDefaults.standard.integer(forKey: "userid") {
                cell.btnaddfriend.isHidden=true
            }
            cell.btnaddfriend.tag=indexPath.row+500
            let image:String = nullvalue(strings: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "profilepicturepath") as Any)
            if (image != "") {
               if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2)
               {
                cell.imgmain.sd_setImage(with: URL(string:image),placeholderImage: UIImage(named:"girl.png"))
                }
                else
               {
                    cell.imgmain.sd_setImage(with: URL(string:image),placeholderImage: UIImage(named:"man.png"))
                }
            }
            else
            {
                if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2)
                {
                    cell.imgmain.image=UIImage(named:"girl.png")

                }
                else
                {
                    cell.imgmain.image=UIImage(named:"man.png")

                }
            }
            return cell
        }
        else
        {
            let cellIdentifier = "reuse"
            let cell:relativecell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! relativecell
            cell.lblname.text = ((relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "firstname") as? String)! + " " + ((relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "lastname") as? String)!
            cell.lblemail.text = nullvalue(strings:(relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "relation") as Any)
            if userid == UserDefaults.standard.integer(forKey: "userid") {
               let image:String = nullvalue(strings: (relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "profilepicturepath") as Any)
                if (image != "") {
                    cell.imgmain.sd_setImage(with: URL(string:"\(getDocumentsDirectory())/\(image)"))
                }
                else
                {
                    if (nullvalue(ints:(relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2) {
                        cell.imgmain.image=UIImage(named:"girl.png")
                    }
                    else
                    {
                        cell.imgmain.image=UIImage(named:"man.png")
                    }
                }
            }
            else
            {
                let image:String = nullvalue(strings: (relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "profilepicturepath") as Any)
                if (image != "") {
                    cell.imgmain.sd_setImage(with: URL(string:image))
                }
                else
                {
                    if (nullvalue(ints:(relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2) {
                        cell.imgmain.image=UIImage(named:"girl.png")
                    }
                    else
                    {
                        cell.imgmain.image=UIImage(named:"man.png")
                    }
                }
            }
            return cell
        }
    }
    func calculateAge (birthday: Date) -> String {
        let ageComponents = NSCalendar.current.dateComponents([.year], from: birthday, to: NSDate() as Date)
        var age = ageComponents.year!
        if age == 0 {
            age = 1
        }
        //let ageComponents = NSCalendar.current.component(.year, from: birthday as Date)
        return "\(age)" + "  years old"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == friendtable {
//                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                secondViewController.userid=(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as! Int
//                secondViewController.api_token = api_token
//                self.navigationController?.pushViewController(secondViewController, animated: true)
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            print("\((friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as AnyObject)")
            if "\((friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as AnyObject)" == UserDefaults.standard.string(forKey: "userid") {
                 secondViewController.profileid =  ((AppDelegate.selectquery(query:"SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as AnyObject])).object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
            }
            else
            {
                secondViewController.profileid=Int("\((friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "user_profileid") as AnyObject)")!
            }
                secondViewController.userid=Int("\((friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as AnyObject)")!
                secondViewController.api_token=api_token
                self.navigationController?.pushViewController(secondViewController, animated: true)
        
        }
        else
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            secondViewController.profileid=(relativearr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "id") as! Int
            secondViewController.userid=userid
            secondViewController.api_token=api_token
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    @IBAction func btnpickerdoneclicked(_ sender: Any) {
        pickerview.isHidden=true
        let dateformatter:DateFormatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMM-yyyy"
        if clickdate == "dob" {
            txtdob.text = dateformatter.string(from: pickeroutlet.date)
        }
        else if clickdate == "dod"
        {
            txtdod.text = dateformatter.string(from: pickeroutlet.date)
        }
        else if clickdate == "doe"
        {
            txtdoe.text = dateformatter.string(from: pickeroutlet.date)
        }
    }
    func dobbtn(_ sender: UIButton) {
        clickdate = "dob"
        pickerview.isHidden=false
        self.view.endEditing(true)
    }
    func dodbtn(_ sender: UIButton) {
        clickdate = "dod"
        pickerview.isHidden=false
        self.view.endEditing(true)
    }
    func doebtn(_ sender: UIButton) {
        clickdate = "doe"
        pickerview.isHidden=false
        self.view.endEditing(true)
    }
    @IBAction func btnmenuclicked(_ sender: Any) {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select the Option", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Edit", style: .default)
        { action -> Void in
            self.btnmenu.isHidden=true
            self.bttnsaveview.isHidden=false
            self.btnviewtree.isHidden=true
            self.lblmaintraling.constant = 10
            self.enableornot(check: true)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .default)
        { action -> Void in
            self.btndeleteclicked()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtfirstname {
            txtfirstname.text = txtfirstname.text?.capitalized
        }
        if textField == txtlastname {
            txtlastname.text = txtlastname.text?.capitalized
        }
    }
    @IBAction func btnprofilepiceditclicked(_ sender: Any) {
        if ((self.btnmenu.isHidden == false && userid == UserDefaults.standard.integer(forKey: "userid")) || (self.btnmenu.isHidden == true && userid != UserDefaults.standard.integer(forKey: "userid")))
        {
            bigimage.image = imgprofilepic.image
            UIView.beginAnimations("zoom", context: nil)
            UIView.setAnimationDuration(0.5)
            bigimageview.alpha=1
            bigimage.frame=CGRect(x:20,y:(self.view.frame.size.height-((bigimage.image?.size.height)!*(self.view.frame.size.width-40))/(bigimage.image?.size.width)!)/2,width:self.view.frame.size.width-40,height:((bigimage.image?.size.height)!*(self.view.frame.size.width-40))/(bigimage.image?.size.width)!)
            UIView.commitAnimations()
        }
        else
        {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        if tempimage.count != 0 {
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Delete Photo", style:.destructive)
            { action -> Void in
                self.tempimage = Data()
                if self.genderid == "2"
                {
                    self.imgprofilepic.image=UIImage(named:"girl.png")
                }
                else
                {
                    self.imgprofilepic.image=UIImage(named:"man.png")
                }
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
        }
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default)
        { action -> Void in
            self.openCamera()
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Select Photo", style: .default)
        { action -> Void in
            self.openGallary()
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        let picker:UIImagePickerController?=UIImagePickerController()
        picker?.delegate=self
        picker!.allowsEditing = true
        picker!.sourceType = .photoLibrary
        picker!.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            let picker:UIImagePickerController?=UIImagePickerController()
            picker?.delegate=self
            picker!.allowsEditing = true
            picker!.sourceType = .camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth,height:newHeight))
        image.draw(in: CGRect(x:0,y:0,width:newWidth,height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
             //image = cropBottomImage(image: image)
            var image1:UIImage = UIImage()
            if image.size.width>400 {
                image1 = resizeImage(image: image, newWidth: 400)
            }
            tempimage = UIImagePNGRepresentation(image1)!
            imgprofilepic.image=image1
        }
        self.dismiss(animated: true, completion: nil)
    }
//    func cropBottomImage(image: UIImage) -> UIImage {
//        let height = CGFloat(image.size.height / 3)
//        let rect = CGRect(x: 0, y: image.size.height - height, width: image.size.width, height: height)
//        let imageRef:CGImage = image.cgImage!.cropping(to: rect)!
//        let croppedImage:UIImage = UIImage(cgImage:imageRef)
//        let abcd:UIImageView = UIImageView()
//        abcd.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.view.addSubview(abcd)
//        return croppedImage
//    }
    @IBAction func btnunfriendclicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Message", message: "Are you sure you want to remove \(((friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "firstname") as? String)!) \(((friendarr.object(at:sender.tag-500) as? NSDictionary)?.value(forKey: "lastname") as? String)!) as a friend?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:{ action in
            
        }))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler:{ action in
           
        let mainurl = "\(GlobalConstants.MAINURL)unfriend"
        let mainparameter:NSDictionary = ["friendid":(self.friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "friendid") as AnyObject,"requestid":(self.friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "friend_requestid") as AnyObject,"api_token":UserDefaults.standard.string(forKey: "api_token")!]
            let tempname:String = ((self.friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "firstname") as? String)! + " " + ((self.friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "lastname") as? String)!
            self.friendarr.removeObject(at: sender.tag-500)
            self.friendtable.reloadData()
       // ARSLineProgress.show()
        Alamofire.request(mainurl, method: .put, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                        self.view.makeToast(tempname + " has been removed from friend list.", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Message", message: JSON.value(forKey: "result") as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                //ARSLineProgress.hide()
        }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
