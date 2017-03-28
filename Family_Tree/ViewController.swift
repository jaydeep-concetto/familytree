 //
//  ViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 20/12/16.
//  Copyright © 2016 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import FMDB
import Alamofire
import SDWebImage
import ARSLineProgress
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,FBSDKAppInviteDialogDelegate {
    /*!
     @abstract Sent to the delegate when the app invite encounters an error.
     @param appInviteDialog The FBSDKAppInviteDialog that completed.
     @param error The error.
     */
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        
    }

    /*!
     @abstract Sent to the delegate when the app invite completes without error.
     @param appInviteDialog The FBSDKAppInviteDialog that completed.
     @param results The results from the dialog.  This may be nil or empty.
     */
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        
    }

    @IBOutlet weak var cloneview: UIView!
    @IBOutlet weak var lblmaintitle: UILabel!
    var userid:Int = 0
    var api_token:String = ""
    var apiarr:NSMutableArray = NSMutableArray()
    var temparr:NSMutableArray=NSMutableArray()
    var tempdict1:NSDictionary=NSDictionary()
    var medict:NSDictionary=NSDictionary()
    var medict2:NSDictionary=NSDictionary()
    var sibling = [UIView]()
    var child = [UIView]()
    var tablearr:NSMutableArray=NSMutableArray()
    var tablearr1:NSMutableArray=NSMutableArray()
    var iconarr1:NSMutableArray=NSMutableArray()

    @IBOutlet weak var imguide: UIImageView!
    @IBOutlet weak var tabletoolbarview: UIView!
    var motherwidth:CGFloat = 0
    var tempconstant:CGFloat = 0
    @IBOutlet weak var contentviewwidth: NSLayoutConstraint!
    @IBOutlet weak var siblingconnectx: NSLayoutConstraint!
    @IBOutlet weak var siblingconnectview: UIView!
    @IBOutlet weak var childconnectview: UIView!
    var appDBPath1:String = ""
    @IBOutlet weak var maincontentview: UIView!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnmenu: UIButton!
    @IBOutlet weak var btnaddfamily: UIButton!
    @IBOutlet weak var view_meyconstraint: NSLayoutConstraint!
    @IBOutlet weak var view_ggf: UIView!
    @IBOutlet weak var view_ggm: UIView!
    @IBOutlet weak var view_gf: UIView!
    @IBOutlet weak var view_gm: UIView!
    @IBOutlet weak var view_f: UIView!
    @IBOutlet weak var view_m: UIView!
    @IBOutlet weak var view_me: UIView!
    @IBOutlet weak var view_mewife: UIView!
    @IBOutlet weak var scrview: UIScrollView!
    @IBOutlet weak var otherbtn: UIButton!

    @IBOutlet weak var btnhomes: UIButton!
    @IBOutlet weak var btnaddmemberview: UIView!
    @IBOutlet weak var btnaddmess: UIButton!
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var mainimgs: UIImageView!
    @IBOutlet weak var mainlbls: UILabel!
    @IBOutlet weak var viewtable: UIView!
    @IBOutlet weak var tableoutlet: UITableView!
    @IBOutlet weak var btnenvelope: UIButton!
    @IBOutlet weak var btnnotification: UIButton!
    @IBOutlet weak var viewnoti: UIView!
    @IBOutlet weak var lblnoti: UILabel!
    
    @IBAction func btntitleclicked(_ sender: Any) {
        var temparrssss:NSArray = NSArray()
        if userid == UserDefaults.standard.integer(forKey: "userid") {
            temparrssss = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [userid])
        }
        else
        {
            temparrssss = AppDelegate.selectquery(query: "SELECT * FROM User_profile1 WHERE userid = ?", arr: [userid])
        }
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            secondViewController.profileid=(temparrssss.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
            secondViewController.userid=userid
            secondViewController.api_token=api_token
            self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnhomesclicked(_ sender: Any) {
        if userid != UserDefaults.standard.integer(forKey: "userid") {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            self.navigationController!.popToViewController(viewControllers[1], animated: true);
        }
        else
        {
            getImageOfScrollView()
            
        }
    }
    @IBAction func btnprofileclicked(_ sender: Any) {
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.5)
        otherbtn.alpha=0
        viewtable.frame=CGRect(x:-240,y:0,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
        UIView.commitAnimations()
        viewtable.isHidden=true
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        secondViewController.profileid=(temparr.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
        secondViewController.userid=userid
        secondViewController.api_token=api_token
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @IBAction func btnotherclicked(_ sender: Any) {
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.5)
        otherbtn.alpha=0
        viewtable.frame=CGRect(x:-240,y:0,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
        UIView.commitAnimations()
    }
    @IBAction func btnaddmessclicked(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnterDetailViewController") as! EnterDetailViewController
        secondViewController.actionstr="Add Me"
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnenvelopeclicked(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "fcity")
        UserDefaults.standard.set("", forKey: "fvillage")
        UserDefaults.standard.set("", forKey: "fmaternal_place")
        UserDefaults.standard.set("", forKey: "flastname")
        UserDefaults.standard.set("0", forKey: "fromage")
        UserDefaults.standard.set("0", forKey: "toage")
        UserDefaults.standard.set("0", forKey: "fromheight")
        UserDefaults.standard.set("0", forKey: "toheight")
        UserDefaults.standard.set("0", forKey: "fromweight")
        UserDefaults.standard.set("0", forKey: "toweight")
        UserDefaults.standard.set("no", forKey: "filter")
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        secondViewController.actionstr = "Add Friend"
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnmenuclicked(_ sender: Any) {
        viewtable.isHidden=false
            UIView.beginAnimations("zoom", context: nil)
            UIView.setAnimationDuration(0.5)
            otherbtn.alpha=0.7
            viewtable.frame=CGRect(x:0,y:0,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
            UIView.commitAnimations()
    }
    func addsibling(abc:UIView,viewtag:Int,checkstr:String) {
        var v1:UIView = UIView()
        if checkstr == "sibling" {
            if viewtag%2 == 0 {
                v1.frame = CGRect(x:view_me.frame.origin.x+(CGFloat(viewtag-401)*68)+68+motherwidth,y:view_me.frame.origin.y,width:abc.frame.size.width,height:abc.frame.size.height)
            }
            else
            {
                v1.frame = CGRect(x:view_me.frame.origin.x-(CGFloat(viewtag-400)*68)-68,y:view_me.frame.origin.y,width:abc.frame.size.width,height:abc.frame.size.height)
                

            }
        }
        else
        {
    
            if viewtag%2 == 0 {
                v1=UIView(frame:CGRect(x:child[0].frame.origin.x-(CGFloat(viewtag-501)*68)-68,y:view_me.frame.origin.y+100,width:abc.frame.size.width,height:abc.frame.size.height))
            }
            else
            {
                if viewtag == 501 {
                    v1=UIView(frame:CGRect(x:view_me.frame.origin.x+(view_me.frame.size.width/2)-(abc.frame.size.width/2),y:view_me.frame.origin.y+100,width:abc.frame.size.width,height:abc.frame.size.height))
                }
                else
                {
                    v1=UIView(frame:CGRect(x:child[0].frame.origin.x+(CGFloat(viewtag-502)*68)+68,y:view_me.frame.origin.y+100,width:abc.frame.size.width,height:abc.frame.size.height))
                }
            }
        }
        
        v1.backgroundColor=abc.backgroundColor
        v1.tag=viewtag
        var old = abc.subviews
        for i in 0..<old.count {
            if (old[i] is UILabel) {
                let temp01 = (old[i] as! UILabel)
                let temp11 = UILabel(frame: temp01.frame)
                temp11.tag = temp01.tag
                temp11.text = temp01.text
                temp11.font = temp01.font
                temp11.textColor=temp01.textColor
                temp11.textAlignment = temp01.textAlignment
                temp11.layer.borderColor=temp01.layer.borderColor
                temp11.layer.borderWidth=temp01.layer.borderWidth
                v1.addSubview(temp11)
            }
            else if (old[i] is UIButton) {
                let temp01 = (old[i] as! UIButton)
                let temp11 = UIButton(frame: temp01.frame)
                v1.addSubview(temp11)
                temp11.tag = viewtag
                temp11.setImage(temp01.image(for: .normal), for: .normal)
                //temp11.addTarget(self, action: #selector(btnaction(_:)), for: .touchUpInside)
            }
            else if (old[i] is UIImageView) {
                let temp01 = (old[i] as! UIImageView)
                let temp11 = UIImageView(frame: temp01.frame)
                v1.addSubview(temp11)
                temp11.tag = viewtag
                temp11.clipsToBounds=temp01.clipsToBounds
                temp11.layer.cornerRadius=temp01.layer.cornerRadius
                temp11.image=temp01.image
            }
            else {
                let temp01 = (old[i] )
                let temp11 = UIView(frame: temp01.frame)
                temp11.backgroundColor=temp01.backgroundColor
                temp11.tag=temp01.tag
                v1.addSubview(temp11)
                temp11.clipsToBounds=temp01.clipsToBounds
                temp11.layer.cornerRadius=temp01.layer.cornerRadius
                temp11.layer.borderColor=temp01.layer.borderColor
                temp11.layer.borderWidth=temp01.layer.borderWidth

            }
        }
       
        maincontentview.addSubview(v1)
        if checkstr == "sibling" {
            sibling.append(v1)
        }
        else
        {
            child.append(v1)
        }
    }
    func setview1(tempview:UIView,tags:Int,dob:String,name:String, image:String,gender:Int){
        var image = image
        for subview in tempview.subviews {
            if (subview.isKind(of: UILabel.self))
            {
                let l1 : UILabel = (subview as? UILabel)!
                if l1.tag == 100 {
                    l1.text=name
                }
                else if l1.tag == 101 {
                    let dob = nullvalue(strings:dob)
                    if dob == ""  || dob == "0000-00-00 00:00:00" {
                        l1.text=dob
                    }
                    else
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                        l1.text=calculateAge(birthday:dateFormatter.date(from: dob)!)
                    }
                    l1.text=""
                }
                if tempview == view_me
                {
                    l1.textColor = UIColor.white
                }
            }
            else if (subview.isKind(of: UIButton.self))
            {
                let imagecache:SDImageCache = SDImageCache.shared()
                imagecache.clearMemory()
                imagecache.clearDisk()
                let b1 : UIButton = (subview as? UIButton)!
                b1.tag=tags
                b1.addTarget(self, action: #selector(btnaction1(_:)), for: .touchUpInside)
            }
            else if (subview.isKind(of: UIImageView.self))
            {
                let imagecache:SDImageCache = SDImageCache.shared()
                imagecache.clearMemory()
                imagecache.clearDisk()
                let b1 : UIImageView = (subview as? UIImageView)!
                if (image != "") {
                    //image = "\(getDocumentsDirectory())\((image))"
                }
                else
                {
                    if(gender == 2)
                    {
                        image = Bundle.main.path(forResource: "girl", ofType: "png")!
                    }
                    else
                    {
                        image = Bundle.main.path(forResource: "man", ofType: "png")!
                    }
                }
                if(gender == 2)
                {
                    b1.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"girl.png"))
                }
                else
                {
                    b1.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"man.png"))
                }
                
            }
            else if (subview.tag == 100)
            {
                let b1 : UIView = subview
                
                
                    if(gender == 1)
                    {
                        b1.layer.borderColor = UIColor.init(colorLiteralRed: 37/255.0, green: 170/255.0, blue: 225/255.0, alpha: 1).cgColor
                    }
                    else
                    {
                        b1.layer.borderColor = UIColor.init(colorLiteralRed: 255/255.0,green: 192/255.0, blue: 203/255.0, alpha: 1).cgColor
                    }
                if tempview == view_me
                {
                    b1.backgroundColor = UIColor.init(colorLiteralRed: 37/255.0, green: 170/255.0, blue: 225/255.0, alpha: 1)
                    b1.layer.borderColor = UIColor.init(colorLiteralRed: 255/255.0, green: 193/255.0, blue: 7/255.0, alpha: 1).cgColor
                }
                
            }
        }
    }
    func calculateAge (birthday: Date) -> String {
        let ageComponents = NSCalendar.current.dateComponents([.year], from: birthday, to: NSDate() as Date)
        let age = ageComponents.year!
        //let ageComponents = NSCalendar.current.component(.year, from: birthday as Date)
        return "\(age)"
    }
    func setview(tempview:UIView,tags:Int,dob:String,name:String, image:String,gender:Int){
        var image = image
        for subview in tempview.subviews {
            if (subview.isKind(of: UILabel.self))
            {
                let l1 : UILabel = (subview as? UILabel)!
                if l1.tag == 100 {
                    l1.text=name
                }
                else if l1.tag == 101 {
                    let dob = nullvalue(strings:dob)
                    if dob == "" || dob == "0000-00-00 00:00:00" {
                        l1.text=dob
                    }
                    else
                    {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        l1.text=calculateAge(birthday:dateFormatter.date(from: dob)!)
                    }
                    l1.text=""
                }
                if tempview == view_me
                {
                    l1.textColor = UIColor.white
                }
                
            }
            else if (subview.isKind(of: UIButton.self))
            {
                let imagecache:SDImageCache = SDImageCache.shared()
                imagecache.clearMemory()
                imagecache.clearDisk()
                let b1 : UIButton = (subview as? UIButton)!
                b1.tag=tags
                b1.addTarget(self, action: #selector(btnaction(_:)), for: .touchUpInside)
            }
            else if (subview.isKind(of: UIImageView.self))
            {
                let imagecache:SDImageCache = SDImageCache.shared()
                imagecache.clearMemory()
                imagecache.clearDisk()
                let b1 : UIImageView = (subview as? UIImageView)!
                if (image != "") {
                    image = "\(getDocumentsDirectory())\((image))"
                }
                else
                {
                    if(gender == 2)
                    {
                        image = Bundle.main.path(forResource: "girl", ofType: "png")!
                    }
                    else
                    {
                        image = Bundle.main.path(forResource: "man", ofType: "png")!
                    }
                }
                if(gender == 2)
                {
                    b1.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"girl.png"))
                }
                else
                {
                    b1.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"man.png"))
                }
               
            }
            else if (subview.tag == 100)
            {
                let b1 : UIView = subview
                if tempview == view_me
                {
                   b1.backgroundColor = UIColor.init(colorLiteralRed: 240/255.0, green: 236/255.0, blue: 225/255.0, alpha: 1)
                }
                
                    if(gender == 1)
                    {
                        b1.layer.borderColor = UIColor.init(colorLiteralRed: 37/255.0, green: 170/255.0, blue: 225/255.0, alpha: 1).cgColor
                    }
                    else
                    {
                        b1.layer.borderColor = UIColor.init(colorLiteralRed: 255/255.0, green: 192/255.0, blue: 203/255.0, alpha: 1).cgColor
                    }
                if tempview == view_me
                {
                    b1.backgroundColor = UIColor.init(colorLiteralRed: 37/255.0, green: 170/255.0, blue: 225/255.0, alpha: 1)
                    b1.layer.borderColor = UIColor.init(colorLiteralRed: 255/255.0, green: 193/255.0, blue: 7/255.0, alpha: 1).cgColor
                }
                
            }
        }
    }
    func setfather(tempdict:NSDictionary,fatherview:UIView,fathertag:Int) -> Bool {
        var tempbool:Bool = false
        if (tempdict.value(forKey: "parentid") as! Int) != 0 {
            let temparr1:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ?  AND isdeleted = 0", arr: [tempdict.value(forKey: "parentid") as! Int])
            if temparr1.count != 0 {
                tempbool = true
                fatherview.isHidden=false
                tempdict1 = temparr1.object(at: 0) as! NSDictionary
                fatherview.tag=(temparr1.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
                setview(tempview: fatherview,tags: fatherview.tag,dob:tempdict1.value(forKey: "dob") as! String,name:tempdict1.value(forKey: "firstname") as! String,image: tempdict1.value(forKey: "profilepicturepath") as! String,gender: tempdict1.value(forKey: "genderid") as! Int)
            }
        }
        return tempbool
    }
    func setmother(tempdict:NSDictionary,motherview:UIView,mothertag:Int) -> Bool {
        var tempbool:Bool = false
        if (tempdict.value(forKey: "spouseid") as! Int) != 0 {
            
            let temparr1:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ?  AND isdeleted = 0", arr: [tempdict1.value(forKey: "spouseid") as! Int])
            if temparr1.count != 0 {
                tempbool = true
                motherview.isHidden=false
                motherview.tag=(temparr1.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
                setview(tempview: motherview,tags: motherview.tag,dob:(temparr1.object(at: 0) as! NSDictionary).value(forKey: "dob") as! String,name:(temparr1.object(at: 0) as! NSDictionary).value(forKey: "firstname") as! String,image: (temparr1.object(at: 0) as! NSDictionary).value(forKey: "profilepicturepath") as! String,gender: (temparr1.object(at: 0) as! NSDictionary).value(forKey: "genderid") as! Int)
            }
        }
        return tempbool
    }
    func panGestureHandler(panGesture recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in:self.view)
        var startx:CGFloat = 0
        if recognizer.state == UIGestureRecognizerState.began
        {
           startx = viewtable.frame.origin.x
        }
        if translation.x<0 {
           if viewtable.frame.origin.x > -240
           {
                if startx+translation.x >= -240 {
                    viewtable.frame = CGRect(x:startx+translation.x,y:viewtable.frame.origin.y,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
                }
                else
                {
                    viewtable.frame = CGRect(x:-240,y:viewtable.frame.origin.y,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
                }

            }
        }
        else
        {
            if viewtable.frame.origin.x<0
            {
                if startx+translation.x <= 0 {
                   viewtable.frame = CGRect(x:startx+translation.x,y:viewtable.frame.origin.y,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
                }
                else
                {
                    viewtable.frame = CGRect(x:0,y:viewtable.frame.origin.y,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
                }
                
            }
        }
        if recognizer.state == UIGestureRecognizerState.ended
        {
            if viewtable.frame.origin.x < -120 {
                    UIView.beginAnimations("zoom", context: nil)
                    UIView.setAnimationDuration(0.5)
                    self.otherbtn.alpha=0
                    viewtable.frame = CGRect(x:-240,y:viewtable.frame.origin.y,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
                    UIView.commitAnimations()
            }
            else
            {
                    UIView.beginAnimations("zoom", context: nil)
                    UIView.setAnimationDuration(0.5)
                    self.otherbtn.alpha=0.7
                    viewtable.frame = CGRect(x:0,y:viewtable.frame.origin.y,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
                    UIView.commitAnimations()

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarview.backgroundColor = GlobalConstants.toolbar1
        tabletoolbarview.backgroundColor = GlobalConstants.toolbar1

        tableoutlet.backgroundColor=UIColor.white
        let tablepan:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGestureHandler(panGesture:)))
        viewtable.isUserInteractionEnabled=true
        viewtable.addGestureRecognizer(tablepan)
        contentviewwidth.constant=self.view.frame.size.width
        tablearr1=["My Friends","Search New Friends","Pending Friends Request","Your Friends Request","Invite Friends","About Us","Sign Out"]
        iconarr1=["myprofiles.png","add_friend1.png","pending_request.png","your_request.png","envelope.png","tree-with-many-leaves1.png","logout.png"]
        if userid != UserDefaults.standard.integer(forKey: "userid") {
            btnback.isHidden = false
            btnmenu.isHidden = true
            btnenvelope.isHidden = true
            btnnotification.isHidden = true
            viewnoti.isHidden = true
            btnaddmemberview.isHidden = true
            getotherusertree()
            btnhomes.setImage(UIImage(named: "home-shadow.png"), for: UIControlState.normal)
                        btnhomes.isHidden = false

        }
        else
        {
            btnhomes.isHidden = true
            btnhomes.setImage(UIImage(named: "camera_pic.png"), for: UIControlState.normal)
        }
    }
    func getotherusertree()
    {
         AppDelegate.insertquery(query: "DELETE FROM User_profile1", arr: [])
        ARSLineProgress.show()
        motherwidth=0
        tempconstant=self.view.frame.size.width
        let temppinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer()
        temppinch.addTarget(self, action: #selector(scaleImage(_:)))
        maincontentview.isUserInteractionEnabled=true
        maincontentview.addGestureRecognizer(temppinch)
    
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
                        enterarr = JSON.value(forKey: "me") as! NSArray
                        if (enterarr.count == 0)
                        {
                            let alert = UIAlertController(title: "Alert", message: "No Data Found.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.view_me.isHidden=true
                        }
                        else
                        {
                            self.view_me.isHidden=false
                            let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                            self.apiarr.add(tempdict12)
                            self.lblmaintitle.text="\(tempdict12.value(forKey: "firstname") as! String) \(tempdict12.value(forKey: "lastname") as! String)"
                            self.setview1(tempview: self.view_me,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                            self.tempinsert(maindict: tempdict12)
                            enterarr = JSON.value(forKey: "spouse") as! NSArray
                            if (enterarr.count != 0)
                            {
                                self.view_mewife.isHidden=false
                                let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                self.apiarr.add(tempdict12)
                                self.setview1(tempview: self.view_mewife,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                self.tempinsert(maindict: tempdict12)
                                self.motherwidth=136
                                for constraint: NSLayoutConstraint in self.view_me.constraints {
                                    if constraint.firstAttribute == .width {
                                        constraint.constant = 256
                                    }
                                }
                            }
                            
                            enterarr = JSON.value(forKey: "parents") as! NSArray
                            if (enterarr.count > 0)
                            {
                                
                                for v1:UIView in self.view_me.subviews
                                {
                                    if (v1.tag==4) {
                                        v1.isHidden=false
                                    }
                                }
                                let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                self.apiarr.add(tempdict12)
                                self.view_f.isHidden=false
                                self.setview1(tempview: self.view_f,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                self.tempinsert(maindict: tempdict12)
                                enterarr = JSON.value(forKey: "parents") as! NSArray
                                if (enterarr.count > 1)
                                {
                                    for constraint: NSLayoutConstraint in self.view_f.constraints {
                                        if constraint.firstAttribute == .width {
                                            constraint.constant = 256
                                        }
                                    }
                                    for v1:UIView in self.view_f.subviews
                                    {
                                        if (v1.tag==1) {
                                            v1.isHidden=false
                                        }
                                    }
                                     let tempdict12:NSDictionary = enterarr.object(at: 1) as! NSDictionary
                                    self.apiarr.add(tempdict12)
                                    self.view_m.isHidden=false
                                    self.setview1(tempview: self.view_m,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                    self.tempinsert(maindict: tempdict12)

                                }
                                enterarr = JSON.value(forKey: "grandparents") as! NSArray
                                if (enterarr.count > 0)
                                {
                                   
                                    if self.view_gf.frame.origin.y<25
                                    {
                                        self.view_meyconstraint.constant = 25-self.view_gf.frame.origin.y
                                    }
                                    let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                    self.apiarr.add(tempdict12)
                                    self.view_gf.isHidden=false
                                    self.setview1(tempview: self.view_gf,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                    self.tempinsert(maindict: tempdict12)
                                    enterarr = JSON.value(forKey: "grandparents") as! NSArray
                                    if (enterarr.count > 1)
                                    {
                                        for constraint: NSLayoutConstraint in self.view_gf.constraints {
                                            if constraint.firstAttribute == .width {
                                                constraint.constant = 256
                                            }
                                        }
                                        for v1:UIView in self.view_gf.subviews
                                        {
                                            if (v1.tag==1) {
                                                v1.isHidden=false
                                            }
                                        }
                                        let tempdict12:NSDictionary = enterarr.object(at: 1) as! NSDictionary
                                        self.apiarr.add(tempdict12)
                                        self.view_gm.isHidden=false
                                        self.setview1(tempview: self.view_gm,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                        self.tempinsert(maindict: tempdict12)
                                    }
                                    enterarr = JSON.value(forKey: "greatgrandparents") as! NSArray
                                    if (enterarr.count > 0)
                                    {
                                        if self.view_ggf.frame.origin.y<25
                                        {
                                            self.view_meyconstraint.constant = 25-self.view_ggf.frame.origin.y
                                        }
                                        let tempdict12:NSDictionary = enterarr.object(at: 0) as! NSDictionary
                                        self.apiarr.add(tempdict12)
                                        self.view_ggf.isHidden=false
                                        self.setview1(tempview: self.view_ggf,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                        self.tempinsert(maindict: tempdict12)
                                        enterarr = JSON.value(forKey: "greatgrandparents") as! NSArray
                                        if (enterarr.count > 1)
                                        {
                                            for constraint: NSLayoutConstraint in self.view_ggf.constraints {
                                                if constraint.firstAttribute == .width {
                                                    constraint.constant = 256
                                                }
                                            }
                                            for v1:UIView in self.view_ggf.subviews
                                            {
                                                if (v1.tag==1) {
                                                    v1.isHidden=false
                                                }
                                            }
                                            let tempdict12:NSDictionary = enterarr.object(at: 1) as! NSDictionary
                                            self.apiarr.add(tempdict12)
                                            self.view_ggm.isHidden=false
                                            self.setview1(tempview: self.view_ggm,tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                                            self.tempinsert(maindict: tempdict12)
                                        }
                                  }
                              }
                            }
                    }

                self.updateViewConstraints()
                self.view.layoutIfNeeded()
                var siblingarr:NSArray = NSArray()
                siblingarr = JSON.value(forKey: "siblings") as! NSArray
                var childarr:NSArray = NSArray()
                childarr = JSON.value(forKey: "childs") as! NSArray
                for i in 0..<siblingarr.count
                {
                    let tempdict12:NSDictionary = siblingarr.object(at: i) as! NSDictionary
                    self.apiarr.add(tempdict12)
                    self.addsibling(abc: self.cloneview, viewtag: 401+i,checkstr: "sibling")
                    self.sibling[i].isHidden = false
                    self.sibling[i].tag=Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!
                    self.setview1(tempview: self.sibling[i],tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                    self.tempinsert(maindict: tempdict12)
                }
                if (childarr.count != 0) {
                    for v1:UIView in self.view_me.subviews
                    {
                        if (v1.tag==5) {
                            v1.isHidden=false
                        }
                    }
                    for v1:UIView in self.view_mewife.subviews
                    {
                        if (v1.tag==2) {
                            v1.isHidden=false
                        }
                    }
                }
                for i in 0..<childarr.count
                {
                    let tempdict12:NSDictionary = childarr.object(at: i) as! NSDictionary
                    self.apiarr.add(tempdict12)
                    self.addsibling(abc: self.cloneview, viewtag: 501+i,checkstr: "child")
                    self.child[i].tag=Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!
                    self.setview1(tempview: self.child[i],tags: Int("\(tempdict12.value(forKey: "user_profileid") as AnyObject)")!,dob:self.nullvalue(strings:tempdict12.value(forKey: "dob") as Any) ,name:self.nullvalue(strings:tempdict12.value(forKey: "firstname") as Any),image:self.nullvalue(strings:tempdict12.value(forKey: "profilepicturepath") as Any),gender:Int("\(tempdict12.value(forKey: "genderid") as AnyObject)")!)
                    self.tempinsert(maindict: tempdict12)
                }
                if siblingarr.count > 1 {
                    for constraint: NSLayoutConstraint in self.siblingconnectview.constraints {
                        if constraint.firstAttribute == .width {
                            constraint.constant = CGFloat((siblingarr.count*136)+Int(self.motherwidth))
                        }
                    }
                    if siblingarr.count%2 != 0 {
                        self.siblingconnectx.constant = -68
                    }
                    else
                    {
                        self.siblingconnectx.constant = 0
                    }
                }
                else
                {
                    if siblingarr.count == 0  {
                        if self.view_mewife.isHidden == false
                        {
                            self.siblingconnectx.constant = -(self.view_me.frame.size.width+16)/4
                        }
                    }
                    else
                    {
                        
                        for constraint: NSLayoutConstraint in self.siblingconnectview.constraints {
                            if constraint.firstAttribute == .width {
                                constraint.constant = CGFloat((siblingarr.count*136))
                            }
                        }
                        if siblingarr.count%2 != 0 {
                            self.siblingconnectx.constant = -(self.view_me.frame.size.width+16)/2
                        }
                        else
                        {
                            self.siblingconnectx.constant = 0
                        }
                    }
                }
                if childarr.count != 0 {
                    for constraint: NSLayoutConstraint in self.childconnectview.constraints {
                        if constraint.firstAttribute == .width {
                            constraint.constant = CGFloat((childarr.count-1)*136)
                        }
                    }
                }
                self.updateViewConstraints()
                self.view.layoutIfNeeded()
                if self.view_f.frame.origin.x<0  && self.view_f.isHidden == false
                {
                    self.tempconstant = self.view.frame.size.width+50-(self.view_f.frame.origin.x*2)
                }
                print(self.view_f)
                if self.view_gf.frame.origin.x<0   && self.view_gf.isHidden == false
                {
                    self.tempconstant = self.view.frame.size.width+50-(self.view_gf.frame.origin.x*2)
                }
                print(self.tempconstant)
                print(self.view_ggf)

                if self.view_ggf.frame.origin.x<0   && self.view_ggf.isHidden == false
                {
                    self.tempconstant = self.view.frame.size.width+50-(self.view_ggf.frame.origin.x*2)
                }
                print(self.view_ggf)
                self.contentviewwidth.constant=self.tempconstant
                if siblingarr.count>0 {
                    var a:Int = siblingarr.count;
                    a = (a*136)+500
                    if (self.contentviewwidth.constant < CGFloat(a)) {
                        self.contentviewwidth.constant = CGFloat(a)
                        print(CGFloat(a))
                    }
                }
                if childarr.count>0 {
                    var a:Int = childarr.count - 1;
                    a = (a*136)+245
                    if (self.contentviewwidth.constant < CGFloat(a)) {
                        self.contentviewwidth.constant = CGFloat(a)
                        print(CGFloat(a))
                    }
                }
                for i in 0..<siblingarr.count {
                    self.sibling[i].frame=CGRect(x:self.sibling[i].frame.origin.x+(self.contentviewwidth.constant-self.view.frame.size.width)/2,y:self.sibling[i].frame.origin.y,width:self.sibling[i].frame.size.width,height:self.sibling[i].frame.size.height)
                    self.maincontentview.bringSubview(toFront: self.sibling[siblingarr.count-i-1])
                }
                for i in 0..<childarr.count {
                    self.child[i].frame=CGRect(x:self.child[i].frame.origin.x+(self.contentviewwidth.constant-self.view.frame.size.width)/2,y:self.child[i].frame.origin.y,width:self.child[i].frame.size.width,height:self.child[i].frame.size.height)
                    if childarr.count%2 == 0 {
                        self.child[i].frame=CGRect(x:self.child[i].frame.origin.x+68,y:self.child[i].frame.origin.y,width:self.child[i].frame.size.width,height:self.child[i].frame.size.height)
                    }
                    self.maincontentview.bringSubview(toFront: self.child[childarr.count-i-1])
                }
                
                self.maincontentview.bringSubview(toFront: self.view_mewife)
                self.maincontentview.bringSubview(toFront: self.view_me)
                self.scrview.contentOffset = CGPoint(x:(self.contentviewwidth.constant-self.view.frame.size.width)/2,y:0)
                    }
                    else
                    {
                        self.view_me.isHidden=true
                        let alert = UIAlertController(title: "Oops", message: "Data not Found", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    self.view_me.isHidden=true
                    let alert = UIAlertController(title: "Oops", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                ARSLineProgress.hide()
            }
    }
    func tempinsert(maindict:NSDictionary) {
        AppDelegate.insertquery(query: "INSERT INTO User_profile1 (id,userid,firstname,lastname,parentid,spouseid,profilepicturepath,mobile,dob,dod,dateofanniversary,birthplace,isalive,marital_statusid,village,genderid,address,city,height,weight,maternal_place,education) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", arr: [nullvalue(ints:maindict.value(forKey: "user_profileid") as AnyObject),nullvalue(ints:maindict.value(forKey: "userid") as AnyObject),nullvalue(strings:maindict.value(forKey: "firstname") as Any),nullvalue(strings:maindict.value(forKey: "lastname") as Any),nullvalue(ints:maindict.value(forKey: "parentid") as AnyObject),nullvalue(ints:maindict.value(forKey: "spouseid") as AnyObject),nullvalue(strings:maindict.value(forKey: "profilepicturepath") as Any),nullvalue(strings:maindict.value(forKey: "mobile") as Any),nullvalue(strings:maindict.value(forKey: "dob") as Any),nullvalue(strings:maindict.value(forKey: "dod") as Any),nullvalue(strings:maindict.value(forKey: "dateofanniversary") as Any),nullvalue(strings:maindict.value(forKey: "birthplace") as Any),nullvalue(ints:maindict.value(forKey: "isalive") as AnyObject),nullvalue(ints:maindict.value(forKey: "marital_statusid") as AnyObject),nullvalue(strings:maindict.value(forKey: "village") as Any),nullvalue(ints:maindict.value(forKey: "genderid") as AnyObject),nullvalue(strings:maindict.value(forKey: "address") as Any),nullvalue(strings:maindict.value(forKey: "city") as Any),nullvalue(ints:maindict.value(forKey: "height") as AnyObject),nullvalue(ints:maindict.value(forKey: "weight") as AnyObject),nullvalue(strings:maindict.value(forKey: "maternal_place") as Any),nullvalue(strings:maindict.value(forKey: "education") as Any)])
    }
    override func viewWillDisappear(_ animated: Bool) {
        //contentviewwidth.constant=self.view.frame.size.width
    }
    func setallthing() {
        motherwidth=0
        self.updateViewConstraints()
        self.view.layoutIfNeeded()
        tempconstant=self.view.frame.size.width
                let temppinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer()
                temppinch.addTarget(self, action: #selector(scaleImage(_:)))
                maincontentview.isUserInteractionEnabled=true
                maincontentview.addGestureRecognizer(temppinch)
        contentviewwidth.constant=self.view.frame.size.width

        for subview in maincontentview.subviews {
            if subview.tag == 10000 {
                subview.removeFromSuperview()
            }
        }
        for i in 0..<child.count {
            child[i].removeFromSuperview()
        }
        for i in 0..<sibling.count {
            sibling[i].removeFromSuperview()
        }
        siblingconnectx.constant = 0
        child.removeAll()
        sibling.removeAll()
        view_mewife.isHidden=true
        view_f.isHidden=true
        view_m.isHidden=true
        view_gf.isHidden=true
        view_gm.isHidden=true
        view_ggf.isHidden=true
        view_ggm.isHidden=true
        for v1:UIView in view_me.subviews
        {
            if (v1.tag==4) {
                v1.isHidden=true
            }
        }
        for constraint: NSLayoutConstraint in view_me.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 120
            }
        }
        for constraint: NSLayoutConstraint in view_f.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 120
            }
        }
        for v1:UIView in view_f.subviews
        {
            if (v1.tag==1) {
                v1.isHidden=true
            }
        }
        for constraint: NSLayoutConstraint in view_gf.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 120
            }
        }
        for v1:UIView in view_gf.subviews
        {
            if (v1.tag==1) {
                v1.isHidden=true
            }
        }
        for constraint: NSLayoutConstraint in view_ggf.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 120
            }
        }
        for v1:UIView in view_ggf.subviews
        {
            if (v1.tag==1) {
                v1.isHidden=true
            }
        }
        for v1:UIView in view_me.subviews
        {
            if (v1.tag==5) {
                v1.isHidden=true
            }
        }
        for v1:UIView in view_mewife.subviews
        {
            if (v1.tag==2) {
                v1.isHidden=true
            }
        }
        for constraint: NSLayoutConstraint in childconnectview.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 0
            }
        }
        for constraint: NSLayoutConstraint in siblingconnectview.constraints {
            if constraint.firstAttribute == .width {
                constraint.constant = 0
            }
        }
        appDBPath1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [userid])
        if (temparr.count == 0)
        {
            setview(tempview: view_me,tags: 1,dob:"",name:"Add Me",image:"",gender:1)
            tablearr=["Add Me"]
            mainimgs.image = UIImage(data: UserDefaults.standard.data(forKey: "profilepic")!)
            mainlbls.text="\(UserDefaults.standard.string(forKey: "firstname")!) \(UserDefaults.standard.string(forKey: "lastname")!)"
            view_me.isHidden=true
            btnaddmess.isHidden=false
            imguide.isHidden=false
            btnaddmemberview.isHidden=true
        }
        else
        {
            btnaddmemberview.isHidden=false
            btnaddmess.isHidden=true
            imguide.isHidden=true

            view_me.isHidden=false
            tempdict1 = temparr.object(at: 0) as! NSDictionary
            medict = temparr.object(at: 0) as! NSDictionary
            lblmaintitle.text="\(tempdict1.value(forKey: "firstname") as! String) \(tempdict1.value(forKey: "lastname") as! String)"
            var image:String = nullvalue(strings:
                tempdict1.value(forKey: "profilepicturepath") as! String)
            if (image != "") {
                image = "\(getDocumentsDirectory())\((image))"
            }
            else
            {
                if(tempdict1.value(forKey: "genderid") as! Int == 2)
                {
                    image = Bundle.main.path(forResource: "girl", ofType: "png")!
                }
                else
                {
                    image = Bundle.main.path(forResource: "man", ofType: "png")!
                }
            }
         
            if(tempdict1.value(forKey: "genderid") as! Int == 2)
            {
                mainimgs.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"girl.png"))
            }
            else
            {
                mainimgs.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"man.png"))
            }
            mainlbls.text="\(tempdict1.value(forKey: "firstname") as! String) \(tempdict1.value(forKey: "lastname") as! String)"
            setview(tempview: view_me,tags: 1,dob:tempdict1.value(forKey: "dob") as! String,name:tempdict1.value(forKey: "firstname") as! String,image: tempdict1.value(forKey: "profilepicturepath") as! String,gender: tempdict1.value(forKey: "genderid") as! Int)
            tablearr=["Add Father","Add Spouse","Add Children"]
            if setmother(tempdict: tempdict1, motherview: view_mewife,mothertag:2) {
                tablearr.remove("Add Spouse")
                motherwidth=136
                for constraint: NSLayoutConstraint in view_me.constraints {
                    if constraint.firstAttribute == .width {
                        constraint.constant = 256
                    }
                }
            }
            if setfather(tempdict: tempdict1, fatherview: view_f,fathertag:101) {
                tablearr.remove("Add Father")
                tablearr.add("Add Mother")
                tablearr.add("Add GrandFather")
                tablearr.add("Add Sibling")
                if view_f.frame.origin.x<0 {
                    tempconstant = self.view.frame.size.width+50-(view_f.frame.origin.x*2)
                }
                for v1:UIView in view_me.subviews
                {
                    if (v1.tag==4) {
                        v1.isHidden=false
                    }
                }
                if setmother(tempdict: tempdict1, motherview: view_m,mothertag:102) {
                    tablearr.remove("Add Mother")
                    for constraint: NSLayoutConstraint in view_f.constraints {
                        if constraint.firstAttribute == .width {
                            constraint.constant = 256
                        }
                    }
                    for v1:UIView in view_f.subviews
                    {
                        if (v1.tag==1) {
                            v1.isHidden=false
                        }
                    }
                }
                if setfather(tempdict: tempdict1, fatherview: view_gf,fathertag:201) {
                    tablearr.remove("Add GrandFather")
                    tablearr.add("Add GrandMother")
                    tablearr.add("Add GreatGrandFather")
                    if view_gf.frame.origin.x<0 {
                        tempconstant = self.view.frame.size.width+50-(view_gf.frame.origin.x*2)
                    }
                    if view_gf.frame.origin.y<25
                    {
                        view_meyconstraint.constant = 25-view_gf.frame.origin.y
                    }
                    if setmother(tempdict: tempdict1, motherview: view_gm,mothertag:202) {
                        tablearr.remove("Add GrandMother")
                        for constraint: NSLayoutConstraint in view_gf.constraints {
                            if constraint.firstAttribute == .width {
                                constraint.constant = 256
                            }
                        }
                        for v1:UIView in view_gf.subviews
                        {
                            if (v1.tag==1) {
                                v1.isHidden=false
                            }
                        }
                    }
                    if setfather(tempdict: tempdict1, fatherview: view_ggf,fathertag:301) {
                        tablearr.remove("Add GreatGrandFather")
                        if view_ggf.frame.origin.x<0 {
                            tempconstant = self.view.frame.size.width+50-(view_ggf.frame.origin.x*2)
                        }
                        if view_ggf.frame.origin.y<25
                        {
                            view_meyconstraint.constant = 25-view_ggf.frame.origin.y
                        }
                        tablearr.add("Add GreatGrandMother")
                        if setmother(tempdict: tempdict1, motherview: view_ggm,mothertag:302) {
                            tablearr.remove("Add GreatGrandMother")
                            for constraint: NSLayoutConstraint in view_ggf.constraints {
                                if constraint.firstAttribute == .width {
                                    constraint.constant = 256
                                }
                            }
                            for v1:UIView in view_ggf.subviews
                            {
                                if (v1.tag==1) {
                                    v1.isHidden=false
                                }
                            }
                        }
                    }
                }
            }
            self.updateViewConstraints()
            self.view.layoutIfNeeded()
            var siblingarr:NSMutableArray = NSMutableArray()
             let temparr11:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ?  AND isdeleted = 0", arr: [medict.value(forKey: "parentid") as! Int])
            if (temparr11.count != 0) {
                siblingarr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id != ? AND parentid = ?  AND isdeleted = 0", arr: [medict.value(forKey: "id") as! Int,medict.value(forKey: "parentid") as! Int])
                for i in 0..<siblingarr.count {
                    tempdict1 = siblingarr.object(at: i) as! NSDictionary
                    addsibling(abc: cloneview, viewtag: 401+i,checkstr: "sibling")
                    sibling[i].isHidden = false
                    sibling[i].tag=tempdict1.value(forKey: "id") as! Int
                    setview(tempview: sibling[i],tags: sibling[i].tag ,dob:tempdict1.value(forKey: "dob") as! String,name:tempdict1.value(forKey: "firstname") as! String,image: tempdict1.value(forKey: "profilepicturepath") as! String,gender: tempdict1.value(forKey: "genderid") as! Int)
                }
            }
            
                contentviewwidth.constant=tempconstant
           
            if siblingarr.count>0 {
                var a:Int = siblingarr.count;
                a = (a*136)+500
                if (contentviewwidth.constant < CGFloat(a)) {
                    contentviewwidth.constant = CGFloat(a)
                }
            }
            let childarr:NSMutableArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE parentid = ?  AND isdeleted = 0", arr: [medict.value(forKey: "id") as! Int])
            if (childarr.count != 0) {
                for v1:UIView in view_me.subviews
                {
                    if (v1.tag==5) {
                        v1.isHidden=false
                    }
                }
                for v1:UIView in view_mewife.subviews
                {
                    if (v1.tag==2) {
                        v1.isHidden=false
                    }
                }
            }
            for i in 0..<childarr.count {
                tempdict1 = childarr.object(at: i) as! NSDictionary

                addsibling(abc: cloneview, viewtag: 501+i,checkstr: "child")
                child[i].tag=tempdict1.value(forKey: "id") as! Int
                setview(tempview: child[i],tags: child[i].tag,dob:tempdict1.value(forKey: "dob") as! String ,name:tempdict1.value(forKey: "firstname") as! String,image: nullvalue(strings: tempdict1.value(forKey: "profilepicturepath") as Any),gender: tempdict1.value(forKey: "genderid") as! Int)
            }
            
            if childarr.count>0 {
                var a:Int = childarr.count - 1;
                a = (a*136)+245
                if (contentviewwidth.constant < CGFloat(a)) {
                    contentviewwidth.constant = CGFloat(a)
                }
            }
            for i in 0..<siblingarr.count {
                sibling[i].frame=CGRect(x:sibling[i].frame.origin.x+(contentviewwidth.constant-self.view.frame.size.width)/2,y:sibling[i].frame.origin.y,width:sibling[i].frame.size.width,height:sibling[i].frame.size.height)
                maincontentview.bringSubview(toFront: sibling[siblingarr.count-i-1])
            }
            for i in 0..<childarr.count {
                child[i].frame=CGRect(x:child[i].frame.origin.x+(contentviewwidth.constant-self.view.frame.size.width)/2,y:child[i].frame.origin.y,width:child[i].frame.size.width,height:child[i].frame.size.height)
                if childarr.count%2 == 0 {
                    child[i].frame=CGRect(x:child[i].frame.origin.x+68,y:child[i].frame.origin.y,width:child[i].frame.size.width,height:child[i].frame.size.height)
                }
                maincontentview.bringSubview(toFront: child[childarr.count-i-1])
            }
            if siblingarr.count > 1 {
                for constraint: NSLayoutConstraint in siblingconnectview.constraints {
                    if constraint.firstAttribute == .width {
                        constraint.constant = CGFloat((siblingarr.count*136)+Int(motherwidth))
                    }
                }
                if siblingarr.count%2 != 0 {
                    siblingconnectx.constant = -68
                }
                else
                {
                    siblingconnectx.constant = 0
                }
            }
            else
            {
                if siblingarr.count == 0  {
                    if view_mewife.isHidden == false
                    {
                        siblingconnectx.constant = -(view_me.frame.size.width+16)/4
                    }
                }
                else
                {
                    
                    for constraint: NSLayoutConstraint in siblingconnectview.constraints {
                        if constraint.firstAttribute == .width {
                            constraint.constant = CGFloat((siblingarr.count*136))
                        }
                    }
                    if siblingarr.count%2 != 0 {
                        siblingconnectx.constant = -(view_me.frame.size.width+16)/2
                    }
                    else
                    {
                        siblingconnectx.constant = 0
                    }
                }
            }
            if childarr.count != 0 {
                for constraint: NSLayoutConstraint in childconnectview.constraints {
                    if constraint.firstAttribute == .width {
                        constraint.constant = CGFloat((childarr.count-1)*136)
                    }
                }
            }
            
            maincontentview.bringSubview(toFront: view_mewife)
            maincontentview.bringSubview(toFront: view_me)
            scrview.contentOffset = CGPoint(x:(contentviewwidth.constant-self.view.frame.size.width)/2,y:0)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewtable.isHidden=true
        self.tableoutlet.tableFooterView = UIView.init(frame: CGRect.zero)

        if userid == UserDefaults.standard.integer(forKey: "userid") {
            contentviewwidth.constant=self.view.frame.size.width
            print(userid)
            print(api_token)
            if UserDefaults.standard.value(forKey: "starting") != nil {
                view_me.isHidden=true
                UserDefaults.standard.removeObject(forKey: "starting")
                ARSLineProgress.show()
            }
            insertapi()
            setallthing()
        }
        getnoticount()
        if UserDefaults.standard.value(forKey: "addmember") != nil {
               btnaddfamilyclicked(sender:self)
                UserDefaults.standard.removeObject(forKey: "addmember")
            }
    }
    func getImageOfScrollView(){
                let savedContentOffset = scrview.contentOffset
                let savedFrame = scrview.frame

                UIGraphicsBeginImageContext(scrview.contentSize)
                scrview.contentOffset = .zero
                scrview.frame = CGRect(x: 0, y: 0, width: scrview.contentSize.width, height: scrview.contentSize.height)
                scrview.layer.render(in: UIGraphicsGetCurrentContext()!)
                let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext();

                scrview.contentOffset = savedContentOffset
                scrview.frame = savedFrame
            

let str = "Checkout My Tree in Family of Friends app. https://itunes.apple.com/us/app/apple-store/id1204696872?mt=8"
            let vc = UIActivityViewController(activityItems: [str,(image) ], applicationActivities: [])
            present(vc, animated: true)

}
    func getnoticount()
    {
        
        let mainurl = "\(GlobalConstants.MAINURL)getnotificationcount?api_token=\(UserDefaults.standard.string(forKey: "api_token")!)&userid=\(UserDefaults.standard.integer(forKey: "userid")))"
        Alamofire.request(mainurl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        if self.userid == UserDefaults.standard.integer(forKey: "userid") {
                            if JSON.value(forKey: "result") as! Int != 0
                            {
                                self.viewnoti.isHidden=false
                                self.lblnoti.text = "\(JSON.value(forKey: "result") as! Int)"
                            }
                            else
                            {
                                self.viewnoti.isHidden=true
                            }
                        }
                        else
                        {
                            self.viewnoti.isHidden=true
                        }
                    }
                   
                }
                
        }
    }
    func post(userid: String,relation: String, tempdict:NSDictionary, withcalllback callback: @escaping (_ response: NSDictionary) -> Void) {
        var abcd:String = String()
        if nullvalue(strings:tempdict.object(forKey: "profilepicturepath") as Any) == "" {
            abcd = ""
        }
        else
        {
            let baseURL = NSURL(string: "\(getDocumentsDirectory())/\(nullvalue(strings:tempdict.object(forKey: "profilepicturepath") as Any))")
            let weatherData = NSData(contentsOf:baseURL as! URL)
            abcd = (weatherData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
        }
        Alamofire.request("\(GlobalConstants.MAINURL)uploadimg", method: .post, parameters: ["imagefile":abcd,"type":"avatar","api_token":nullvalue(strings:api_token as Any)], encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                var JSON:NSDictionary = NSDictionary()
                if response.result.value != nil
                {
                    JSON = response.result.value as! NSDictionary
                    var abcd1:String = String()
                    if JSON.value(forKey: "status") as! Int == 200 {
                        abcd1 = JSON.value(forKey: "result") as! String
                    }
                    else
                    {
                        abcd1 = ""
                    }
                   
                    let mainparameter:NSDictionary = ["firstname": self.nullvalue(strings:tempdict.object(forKey: "firstname") as Any),"lastname": self.nullvalue(strings:tempdict.object(forKey: "lastname") as Any),"api_token": self.nullvalue(strings:self.api_token as Any),"profileid": userid,"relation": relation,"dob": self.nullvalue(strings:tempdict.object(forKey: "dob") as Any),"dod": self.nullvalue(strings:tempdict.object(forKey: "dod") as Any),"dateofanniversary": self.nullvalue(strings:tempdict.object(forKey: "dateofanniversary") as Any),"city": self.nullvalue(strings:tempdict.object(forKey: "city") as Any),"isalive":self.nullvalue(ints:tempdict.object(forKey: "isalive") as AnyObject),"genderid":self.nullvalue(ints:tempdict.object(forKey: "genderid") as AnyObject),"marital_statusid":self.nullvalue(ints:tempdict.object(forKey: "marital_statusid") as AnyObject),"parentid":"0","spouseid":"0","profilepicturepath":abcd1,"mobile":self.nullvalue(strings:tempdict.object(forKey: "mobile") as Any),"phone":self.nullvalue(strings:tempdict.object(forKey: "mobile") as Any),"birthplace":self.nullvalue(strings:tempdict.object(forKey: "birthplace") as Any),"village":self.nullvalue(strings:tempdict.object(forKey: "village") as Any),"address":self.nullvalue(strings:tempdict.object(forKey: "address") as Any),"height":self.nullvalue(ints:tempdict.object(forKey: "height") as AnyObject),"weight":self.nullvalue(ints:tempdict.object(forKey: "weight") as AnyObject),"isdeleted":self.nullvalue(ints:tempdict.object(forKey: "isdeleted") as AnyObject),"maternal_place":self.nullvalue(strings:tempdict.object(forKey: "maternal_place") as Any),"education":self.nullvalue(strings:tempdict.object(forKey: "education") as Any)]
                    Alamofire.request("\(GlobalConstants.MAINURL)addnode", method: .post, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
                        .responseJSON { response in
                            var JSON:NSDictionary = NSDictionary()
                            if response.result.value != nil
                            {
                                JSON = response.result.value as! NSDictionary
                                callback(JSON)
                            }
                            else
                            {
                                callback([:])
                            }
                    }
                }
                else
                {
                    callback([:])
                }
        }
      
    }
    public func insertapi()
    {
        var temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [userid])
        if temparr.count == 0 {
            updateapi()
        }
        else
        {
            let tempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary
            medict2 = temparr.object(at: 0) as! NSDictionary
            if (tempdict2.object(forKey: "sid") as! Int == -1) {
                
                post(userid:nullvalue(strings:UserDefaults.standard.string(forKey: "userid") as Any),relation: "5", tempdict: tempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                            AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE   userid = ?", arr: [responce.value(forKey: "result") as! Int,self.userid])
                            temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ?", arr: [self.userid])
                            self.medict2 = temparr.object(at: 0) as! NSDictionary
                        }
                    }
                    self.secondlevel()
               })
            }
            else
            {
                secondlevel()
            }
        }
    }
    func secondlevel()
    {
        //father,spouse,child
        var temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [self.medict2.value(forKey: "parentid") as! Int])
        if(temparr.count == 0)
        {
            updateapi()
        }
        else
        {
            var fathertempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary
            if (fathertempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(self.medict2.value(forKey: "sid") as! Int)",relation: "1", tempdict: fathertempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                        AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,self.medict2.value(forKey: "parentid") as! Int])
                        fathertempdict2 = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ?", arr: [self.medict2.value(forKey: "parentid") as! Int]).object(at: 0) as! NSDictionary
                        }
                    }
                    self.thirdlevel(dict:fathertempdict2)
                })
            }
            else
            {
               thirdlevel(dict: fathertempdict2)
            }
        }
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [self.medict2.value(forKey: "spouseid") as! Int])
        if(temparr.count != 0)
        {
            let spousetempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary
            if (spousetempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(self.medict2.value(forKey: "sid") as! Int)",relation: "3", tempdict: spousetempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                            AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,self.medict2.value(forKey: "spouseid") as! Int])
                        }
                    }
                })
            }
        }
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE parentid = ? AND isdeleted = 0", arr: [self.medict2.value(forKey: "id") as! Int])
        for i in 0..<temparr.count {
            let childtempdict2:NSDictionary = temparr.object(at: i) as! NSDictionary
            if (childtempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(self.medict2.value(forKey: "sid") as! Int)",relation: "2", tempdict: childtempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                            AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,childtempdict2.object(forKey: "id") as! Int])
                        }
                    }
                })
            }
        }
    }
    func thirdlevel(dict:NSDictionary)
    {
        //grandfather,mother,sibling
        var temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "parentid") as! Int])
        if(temparr.count == 0)
        {
            updateapi()
        }
        else
        {
            var grandfathertempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary
            if (grandfathertempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(dict.value(forKey: "sid") as! Int)",relation: "1", tempdict: grandfathertempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                        AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,grandfathertempdict2.object(forKey: "id") as! Int])
                        grandfathertempdict2 = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "parentid") as! Int]).object(at: 0) as! NSDictionary
                        }
                    }
                    self.forthlevel(dict:grandfathertempdict2)
                })
            }
            else
            {
                forthlevel(dict:grandfathertempdict2)

            }
        }
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "spouseid") as! Int])
        if(temparr.count != 0)
        {
            let mothertempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary
                print(dict.value(forKey: "sid") as! Int)
            if (mothertempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(dict.value(forKey: "sid") as! Int)",relation: "3", tempdict: mothertempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                        AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,mothertempdict2.object(forKey: "id") as! Int])
                        }
                    }
                })
            }
        }
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE parentid = ? AND isdeleted = 0", arr: [dict.value(forKey: "id") as! Int])
        for i in 0..<temparr.count {
            let siblingtempdict2:NSDictionary = temparr.object(at: i) as! NSDictionary
            if (siblingtempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(self.medict2.value(forKey: "sid") as! Int)",relation: "4", tempdict: siblingtempdict2, withcalllback: { (responce) in
                    
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                            AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,siblingtempdict2.object(forKey: "id") as! Int])
                        }
                    }
                })
            }
        }
    }
    func forthlevel(dict:NSDictionary)
    {
        //greatgrandfather,grandmother
        var temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "parentid") as! Int])
        if(temparr.count == 0)
        {
            updateapi()
        }
        else
        {
            var greatgrandfathertempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary
            if (greatgrandfathertempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(dict.value(forKey: "sid") as! Int)",relation: "1", tempdict: greatgrandfathertempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                        AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,greatgrandfathertempdict2.object(forKey: "id") as! Int])
                        greatgrandfathertempdict2 = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "parentid") as! Int]).object(at: 0) as! NSDictionary
                        }
                    }
                    self.fifthlevel(dict:greatgrandfathertempdict2)
                })
            }
            else
            {
                self.fifthlevel(dict:greatgrandfathertempdict2)
            }
        }
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "spouseid") as! Int])
        if(temparr.count != 0)
        {
            let grandmothertempdict2:NSDictionary = temparr.object(at: 0) as! NSDictionary

            if (grandmothertempdict2.object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(dict.value(forKey: "sid") as! Int)",relation: "3", tempdict: grandmothertempdict2, withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        if responce.value(forKey: "status") as! Int == 200 {
                            AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,grandmothertempdict2.object(forKey: "id") as! Int])
                        }
                    }
                })
            }
        }
    }
    func fifthlevel(dict:NSDictionary)
    {
        //greatgrandmother
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [dict.value(forKey: "spouseid") as! Int])
        if(temparr.count == 0)
        {
            updateapi()
        }
        else
        {
            if ((temparr.object(at: 0) as! NSDictionary).object(forKey: "sid") as! Int == -1) {
                self.post(userid:"\(dict.value(forKey: "sid") as! Int)",relation: "3", tempdict: (temparr.object(at: 0) as! NSDictionary), withcalllback: { (responce) in
                    if(responce != [:])
                    {
                        print(responce)
                        print(dict.value(forKey: "spouseid") as! Int)
                        if responce.value(forKey: "status") as! Int == 200 {
                            AppDelegate.insertquery(query: "UPDATE User_profile SET sid = ? WHERE id = ?", arr: [responce.value(forKey: "result") as! Int,dict.value(forKey: "spouseid") as! Int])
                        }
                    }
                    self.updateapi()
                })
            }
            else
            {
                updateapi()
            }
        }
    }
    func updateapi1(tempdict:NSDictionary)
    {
        var abcd:String = String()
        if nullvalue(strings:tempdict.object(forKey: "profilepicturepath") as Any) == "" {
            abcd = ""
        }
        else
        {
            let baseURL = NSURL(string: "\(getDocumentsDirectory())/\(nullvalue(strings:tempdict.object(forKey: "profilepicturepath") as Any))")
            let weatherData = NSData(contentsOf:baseURL as! URL)
            abcd = (weatherData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)))!
        }
        Alamofire.request("\(GlobalConstants.MAINURL)uploadimg", method: .post, parameters: ["imagefile":abcd,"type":"avatar","api_token":nullvalue(strings:api_token as Any)], encoding: JSONEncoding.default)
            .responseJSON { response in
                var JSON:NSDictionary = NSDictionary()
                if response.result.value != nil
                {
                    JSON = response.result.value as! NSDictionary
                    var abcd1:String = String()
                    if JSON.value(forKey: "status") as! Int == 200 {
                        abcd1 = JSON.value(forKey: "result") as! String
                    }
                    else
                    {
                        abcd1 = ""
                    }
                        let mainparameter:NSDictionary = ["firstname": self.nullvalue(strings:tempdict.object(forKey: "firstname") as Any),"lastname": self.nullvalue(strings:tempdict.object(forKey: "lastname") as Any),"api_token": self.nullvalue(strings:self.api_token as Any),"profileid": tempdict.object(forKey: "sid") as! Int,"dob": self.nullvalue(strings:tempdict.object(forKey: "dob") as Any),"dod": self.nullvalue(strings:tempdict.object(forKey: "dod") as Any),"dateofanniversary": self.nullvalue(strings:tempdict.object(forKey: "dateofanniversary") as Any),"city": self.nullvalue(strings:tempdict.object(forKey: "city") as Any),"isalive":tempdict.object(forKey: "isalive") as! Int,"genderid":tempdict.object(forKey: "genderid") as! Int,"marital_statusid":tempdict.object(forKey: "marital_statusid")as! Int,"profilepicturepath":abcd1,"mobile":self.nullvalue(strings:tempdict.object(forKey: "mobile") as Any),"phone":self.nullvalue(strings:tempdict.object(forKey: "mobile") as Any),"birthplace":self.nullvalue(strings:tempdict.object(forKey: "birthplace") as Any),"village":self.nullvalue(strings:tempdict.object(forKey: "village") as Any),"address":self.nullvalue(strings:tempdict.object(forKey: "address") as Any),"height":self.nullvalue(ints:tempdict.object(forKey: "height") as AnyObject),"weight":self.nullvalue(ints:tempdict.object(forKey: "weight") as AnyObject),"isdeleted":self.nullvalue(ints:tempdict.object(forKey: "isdeleted")  as AnyObject),"maternal_place":self.nullvalue(strings:tempdict.object(forKey: "maternal_place") as Any),"education":self.nullvalue(strings:tempdict.object(forKey: "education") as Any)]
                        Alamofire.request("\(GlobalConstants.MAINURL)updateprofile", method: .put, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
                            .responseJSON { response in
                                var JSON:NSDictionary = NSDictionary()
                                print(response)
                                if response.result.value != nil
                                {
                                    JSON = response.result.value as! NSDictionary
                                    if JSON.value(forKey: "status") as! Int == 200 {
                                        AppDelegate.insertquery(query: "UPDATE User_profile SET issync = 1 WHERE sid = ?", arr: [tempdict.object(forKey: "sid") as! Int])
                                    }
                                    
                                }
                                self.temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE issync = 0 AND sid != -1 AND isdeleted != 1", arr: [])
                                if (self.temparr.count != 0)
                                {
                                    self.updateapi1(tempdict:self.temparr.object(at:0) as! NSDictionary)
                                }
                                else
                                {
                                    self.deleteapi()
                                }
                        }
                }
                else
                {
                    print(response)
                    self.deleteapi()
                }
        }
    }
    func updateapi()
    {
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE issync = 0 AND sid != -1 AND isdeleted != 1", arr: [])
        if temparr.count == 0 {
            deleteapi()
        }
        else
        {
                updateapi1(tempdict:temparr.object(at: 0) as! NSDictionary)
        }
    }
    func deleteapi1(tempdict:NSDictionary)
    {
        
        
        print(tempdict)
        var related_profileid:Int = 0
        var relationid_with_relatedprofile:Int = 0
        if (tempdict.object(forKey: "relation") as! String == "Add Father" || tempdict.object(forKey: "relation") as! String == "Add GrandFather" || tempdict.object(forKey: "relation") as! String == "Add GreatGrandFather") {
            let abcdarr=AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE parentid = ? AND isdeleted != 1", arr: [tempdict.object(forKey: "id") as! Int])
            if abcdarr.count == 0 {
                AppDelegate.insertquery(query: "UPDATE User_profile SET issync = 1 WHERE id = ?", arr: [tempdict.object(forKey: "id") as! Int])
            }
            else
            {
             related_profileid = (abcdarr.object(at: 0) as! NSDictionary).value(forKey: "sid") as! Int
            relationid_with_relatedprofile = 1
            }
        }
        else if (tempdict.object(forKey: "relation") as! String == "Add Mother" || tempdict.object(forKey: "relation") as! String == "Add GrandMother" || tempdict.object(forKey: "relation") as! String == "Add GreatGrandMother" || tempdict.object(forKey: "relation") as! String == "Add Spouse") {
            let abcdarr=AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE spouseid = ? AND isdeleted != 1", arr: [tempdict.object(forKey: "id") as! Int])
            if abcdarr.count == 0 {
                AppDelegate.insertquery(query: "UPDATE User_profile SET issync = 1 WHERE id = ?", arr: [tempdict.object(forKey: "id") as! Int])
            }
            else
            {
                related_profileid = (abcdarr.object(at: 0) as! NSDictionary).value(forKey: "sid") as! Int
                relationid_with_relatedprofile = 3
            }
        }
        else if (tempdict.object(forKey: "relation") as! String == "Add Children")
        {
            related_profileid = tempdict.object(forKey: "parentid") as! Int
            relationid_with_relatedprofile = 2
        }
        else if (tempdict.object(forKey: "relation") as! String == "Add Sibling")
        {
            let abcdarr=AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE parentid = ? AND isdeleted != 1", arr: [tempdict.object(forKey: "parentid") as! Int])
            if abcdarr.count == 0 {
                AppDelegate.insertquery(query: "UPDATE User_profile SET issync = 1 WHERE id = ?", arr: [tempdict.object(forKey: "id") as! Int])
            }
            else
            {
                related_profileid = (abcdarr.object(at: 0) as! NSDictionary).value(forKey: "sid") as! Int
                relationid_with_relatedprofile = 4
            }
        }
        else if (tempdict.object(forKey: "relation") as! String == "Add Me")
        {
            related_profileid = tempdict.object(forKey: "sid") as! Int
            relationid_with_relatedprofile = 5
        }
        let mainparameter:NSDictionary = ["deleted_profileid": tempdict.object(forKey: "sid") as! Int,"related_profileid":related_profileid,"relationid_with_relatedprofile": relationid_with_relatedprofile,"api_token": self.nullvalue(strings:self.api_token as Any)]

        Alamofire.request("\(GlobalConstants.MAINURL)deleteprofile", method: .delete, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
            var JSON:NSDictionary = NSDictionary()
            print(response)
            if response.result.value != nil
            {
                JSON = response.result.value as! NSDictionary
                if JSON.value(forKey: "status") as! Int == 200 {
                    if (tempdict.object(forKey: "relation") as! String == "Add Father" || tempdict.object(forKey: "relation") as! String == "Add GrandFather" || tempdict.object(forKey: "relation") as! String == "Add GreatGrandFather") {
                         AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = 0 WHERE parentid = ?", arr: [tempdict.object(forKey: "id") as! Int])
                    }
                    else if (tempdict.object(forKey: "relation") as! String == "Add Mother" || tempdict.object(forKey: "relation") as! String == "Add GrandMother" || tempdict.object(forKey: "relation") as! String == "Add GreatGrandMother" || tempdict.object(forKey: "relation") as! String == "Add Spouse") {
                         AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = 0 WHERE spouseid = ?", arr: [tempdict.object(forKey: "id") as! Int])
                    }
                    
                   AppDelegate.insertquery(query: "UPDATE User_profile SET issync = 1 WHERE id = ?", arr: [tempdict.object(forKey: "id") as! Int])
                    self.temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE issync = 0 AND sid != -1 AND isdeleted = 1", arr: [])
                    if (self.temparr.count != 0)
                    {
                        self.deleteapi1(tempdict:self.temparr.object(at:0) as! NSDictionary)
                    }
                    else
                    {
                        self.getapi()
                    }
                }
                else
                {
                    self.getapi()
                }
            }
            else
            {
                self.getapi()
            }
            
        }
        
    }
    func deleteapi(){
        temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE issync = 0 AND sid != -1 AND isdeleted = 1", arr: [])
        if temparr.count == 0 {
            getapi()
        }
        else
        {
            deleteapi1(tempdict:temparr.object(at: 0) as! NSDictionary)
        }
    }
    func getapi()
    {
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
                    enterarr = JSON.value(forKey: "me") as! NSArray
                    if (enterarr.count != 0)
                    {
                        let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [self.userid])
                        if(temparr.count == 0)
                        {
                            self.add(actionstr:"Add Me",maindict:enterarr.object(at: 0) as! NSDictionary)
                        }
                        enterarr = JSON.value(forKey: "spouse") as! NSArray
                        if (enterarr.count != 0)
                        {
                            let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 0) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                            if(temparr.count == 0)
                            {
                                self.add(actionstr:"Add Spouse",maindict:enterarr.object(at: 0) as! NSDictionary)
                            }
                        }
                        enterarr = JSON.value(forKey: "childs") as! NSArray
                        for i in 0..<enterarr.count
                        {
                            let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: i) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                            if(temparr.count == 0)
                            {
                                self.add(actionstr:"Add Children",maindict:enterarr.object(at: i) as! NSDictionary)
                            }
                        }
                        enterarr = JSON.value(forKey: "parents") as! NSArray
                        if (enterarr.count > 0)
                        {
                            let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 0) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                            if(temparr.count == 0)
                            {
                                self.add(actionstr:"Add Father",maindict:enterarr.object(at: 0) as! NSDictionary)
                            }
                            enterarr = JSON.value(forKey: "siblings") as! NSArray
                            for i in 0..<enterarr.count
                            {
                                let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: i) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                                if(temparr.count == 0)
                                {
                                    self.add(actionstr:"Add Sibling",maindict:enterarr.object(at: i) as! NSDictionary)
                                }
                            }
                            enterarr = JSON.value(forKey: "parents") as! NSArray
                            if (enterarr.count > 1)
                            {
                                let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 1) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                                if(temparr.count == 0)
                                {
                                    self.add(actionstr:"Add Mother",maindict:enterarr.object(at: 1) as! NSDictionary)
                                }
                            }
                            enterarr = JSON.value(forKey: "grandparents") as! NSArray
                            if (enterarr.count > 0)
                            {
                                let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 0) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                                if(temparr.count == 0)
                                {
                                    self.add(actionstr:"Add GrandFather",maindict:enterarr.object(at: 0) as! NSDictionary)
                                }
                                enterarr = JSON.value(forKey: "grandparents") as! NSArray
                                if (enterarr.count > 1)
                                {
                                    let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 1) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                                    if(temparr.count == 0)
                                    {
                                        self.add(actionstr:"Add GrandMother",maindict:enterarr.object(at: 1) as! NSDictionary)
                                    }
                                }
                                enterarr = JSON.value(forKey: "greatgrandparents") as! NSArray
                                if (enterarr.count > 0)
                                {
                                    let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 0) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                                    if(temparr.count == 0)
                                    {
                                        self.add(actionstr:"Add GreatGrandFather",maindict:enterarr.object(at: 0) as! NSDictionary)
                                    }
                                    enterarr = JSON.value(forKey: "greatgrandparents") as! NSArray
                                    if (enterarr.count > 1)
                                    {
                                        let temparr:NSArray = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE sid = ? AND isdeleted = 0", arr: [(enterarr.object(at: 1) as! NSDictionary).value(forKey: "user_profileid") as AnyObject])
                                        if(temparr.count == 0)
                                        {
                                            self.add(actionstr:"Add GreatGrandMother",maindict:enterarr.object(at: 1) as! NSDictionary)
                                        }
                                    }
                                }
                            }
                        }
                        }
                   }
                }
               
                self.contentviewwidth.constant=self.view.frame.size.width
                self.view_me.isHidden=false
                self.setallthing()
                ARSLineProgress.hide()                
        }
    }
    func add(actionstr:String,maindict:NSDictionary)
    {
        var parentid:Int = 0
        var spouseid:Int = 0
        var userid:Int = 0
        if (actionstr == "Add Me") {
            parentid = 0
            spouseid = 0
            userid = UserDefaults.standard.integer(forKey: "userid")
        }
        else if (actionstr == "Add Children") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT id FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            parentid = abcd1.value(forKey: "id") as! Int
            spouseid = 0
            userid = 0
        }
        else if (actionstr == "Add Sibling") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            parentid = abcd1.value(forKey: "parentid") as! Int
            spouseid = 0
            userid = 0
        }
        else{
            parentid = 0
            spouseid = 0
            userid = 0
        }
        let nowDouble:String = "\(NSDate().timeIntervalSince1970*1000)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy hh mm ss"
        var dateObj:String = dateFormatter.string(from: NSDate() as Date)
        dateObj = dateObj+nowDouble
        dateObj = dateObj.replacingOccurrences(of: " ", with: "")+".png"
        let baseURL = NSURL(string: nullvalue(strings:maindict.value(forKey: "profilepicturepath") as Any))
        let tempimage =  NSData(contentsOf:baseURL as! URL)
        if tempimage == nil {
            dateObj = ""
        }
        else
        {
            let directorypath: URL = URL(fileURLWithPath: getDocumentsDirectory()).appendingPathComponent(dateObj)
            try? tempimage?.write(to: directorypath)
        }
        var a1str:String = nullvalue(strings:maindict.value(forKey: "dob") as Any)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if a1str != "" && a1str != "0000-00-00 00:00:00"  {
            let a2:Date = dateFormatter.date(from: a1str)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            a1str = dateFormatter.string(from: a2)
        }
        else
        {
            a1str = ""
        }
        var a2str:String = nullvalue(strings:maindict.value(forKey: "dod") as Any)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if a2str != "" && a2str != "0000-00-00 00:00:00" {
            let a2:Date = dateFormatter.date(from: a2str)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            a2str = dateFormatter.string(from: a2)
        }
        else
        {
            a2str = ""
        }
        var a3str:String = nullvalue(strings:maindict.value(forKey: "dateofanniversary") as Any)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if a3str != "" && a3str != "0000-00-00 00:00:00" {
            let a3:Date = dateFormatter.date(from: a3str)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            a3str = dateFormatter.string(from: a3)
        }
        else
        {
            a3str = ""
        }
        
        

        AppDelegate.insertquery(query: "INSERT INTO User_profile (userid,firstname,lastname,parentid,spouseid,profilepicturepath,mobile,dob,dod,dateofanniversary,birthplace,isalive,marital_statusid,village,genderid,address,city,height,weight,sid,relation,maternal_place,education) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", arr: [userid,nullvalue(strings:maindict.value(forKey: "firstname") as Any),nullvalue(strings:maindict.value(forKey: "lastname") as Any),parentid,spouseid,dateObj,nullvalue(strings:maindict.value(forKey: "mobile") as Any),a1str,a2str,a3str,nullvalue(strings:maindict.value(forKey: "birthplace") as Any),nullvalue(ints:maindict.value(forKey: "isalive") as AnyObject),nullvalue(ints:maindict.value(forKey: "marital_statusid") as AnyObject),nullvalue(strings:maindict.value(forKey: "village") as Any),nullvalue(ints:maindict.value(forKey: "genderid") as AnyObject),nullvalue(strings:maindict.value(forKey: "address") as Any),nullvalue(strings:maindict.value(forKey: "city") as Any),nullvalue(ints:maindict.value(forKey: "height") as AnyObject),nullvalue(ints:maindict.value(forKey: "weight") as AnyObject),nullvalue(ints:maindict.value(forKey: "user_profileid") as AnyObject),actionstr,nullvalue(strings:maindict.value(forKey: "maternal_place") as Any),nullvalue(strings:maindict.value(forKey: "education") as Any)])
        
    
        let abcd:NSDictionary = (AppDelegate.selectquery(query:"SELECT MAX(id) FROM User_profile", arr: [])).object(at: 0) as! NSDictionary
        if (actionstr == "Add Spouse") {
            AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE userid = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,UserDefaults.standard.integer(forKey: "userid")])
        }
        else if (actionstr == "Add Father") {
            AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = ? WHERE userid = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,UserDefaults.standard.integer(forKey: "userid")])
        }
        else if (actionstr == "Add Mother") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE id = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd1.value(forKey: "parentid") as! Int])
        }
        else if (actionstr == "Add GrandFather") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = ? WHERE id = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd1.value(forKey: "parentid") as! Int])
        }
        else if (actionstr == "Add GrandMother") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            let abcd2:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd1.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
            AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE id = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd2.value(forKey: "parentid") as! Int])
        }
        else if (actionstr == "Add GreatGrandFather") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            let abcd2:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd1.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
            AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = ? WHERE id = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd2.value(forKey: "parentid") as! Int])
        }
        else if (actionstr == "Add GreatGrandMother") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            let abcd2:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd1.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
            let abcd3:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd2.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
            AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE id = ?", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd3.value(forKey: "parentid") as! Int])
        }
    }
    func nullvalue(strings:Any) -> String {
        var tempstr:Any = strings
        if (tempstr is NSNull) {
            tempstr = ""
        }
        return tempstr as! String
    }
    func nullvalue(ints:AnyObject) -> AnyObject {
        var tempstr:AnyObject = ints
        if (tempstr is NSNull) {
            tempstr = 0 as AnyObject
        }
        return tempstr as AnyObject
    }
    func scaleImage(_ sender: UIPinchGestureRecognizer) {
        if maincontentview.transform.a <= 1 && maincontentview.transform.scaledBy(x: sender.scale, y: sender.scale).a<=1 {
             maincontentview.transform = maincontentview.transform.scaledBy(x: sender.scale, y: sender.scale)
        }
        sender.scale = 1
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scrview
        {
            scrollView.contentOffset.y = 0.0
        }
    }

    @IBAction func btnnotificationclicked(_ sender: Any) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @IBAction func btnaddfamilyclicked(_ sender: Any) {
//        UIView.beginAnimations("zoom", context: nil)
//        UIView.setAnimationDuration(0.5)
//        otherview.alpha=0.7
//        relationtablefview.frame=CGRect(x:relationtablefview.frame.origin.x,y:0,width:relationtablefview.frame.size.width,height:relationtablefview.frame.size.height)
//        UIView.commitAnimations()
        
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select the Option:", message: nil, preferredStyle: .actionSheet)
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            for i in 0..<self.tablearr.count {
                let saveActionButton: UIAlertAction = UIAlertAction(title: self.tablearr.object(at: i) as? String, style: .default)
                { action -> Void in
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnterDetailViewController") as! EnterDetailViewController
                    secondViewController.actionstr=(self.tablearr.object(at: i) as? String)!
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
                actionSheetControllerIOS8.addAction(saveActionButton)
            }
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
        
//        let AddFriendButton: UIAlertAction = UIAlertAction(title: "Add Friend", style: .default) { action -> Void in
//        }
//        actionSheetControllerIOS9.addAction(AddFriendButton)
//        
//        let PendingRequestButton: UIAlertAction = UIAlertAction(title: "Pending Request", style: .default) { action -> Void in
//        }
//        actionSheetControllerIOS9.addAction(PendingRequestButton)
//        
//        let YourRequestButton: UIAlertAction = UIAlertAction(title: "Send Request", style: .default) { action -> Void in
//        }
//        actionSheetControllerIOS9.addAction(YourRequestButton)
//        
//        let SignoutButton: UIAlertAction = UIAlertAction(title: "Sign Out", style: .default) { action -> Void in
//        }
//        actionSheetControllerIOS9.addAction(SignoutButton)
//        present(actionSheetControllerIOS9, animated: true, completion: nil)
    }
    
    func btnaction1(_ sender:UIButton) {
        print(sender.tag)
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        secondViewController.profileid=sender.tag
        secondViewController.userid=userid
        secondViewController.api_token=api_token
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func btnaction(_ sender:UIButton) {
        if  (sender.tag == 1) {
    
            temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [userid])
            if (temparr.count == 0)
            {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnterDetailViewController") as! EnterDetailViewController
                secondViewController.actionstr="Add Me"
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else
            {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
                secondViewController.profileid=(temparr.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
                secondViewController.userid=userid
                secondViewController.api_token=api_token
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        }
        else
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            secondViewController.profileid=sender.tag
            secondViewController.userid=userid
            secondViewController.api_token=api_token
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tablearr1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "reuse"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let l1: UILabel = (cell.viewWithTag(1) as? UILabel)!
        l1.text = tablearr1.object(at: indexPath.row) as? String
        l1.textColor = GlobalConstants.toolbar1
        let i1: UIImageView = (cell.viewWithTag(2) as? UIImageView)!
        i1.image=UIImage(named:(iconarr1.object(at: indexPath.row) as? String)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        UIView.beginAnimations("zoom", context: nil)
        UIView.setAnimationDuration(0.5)
        otherbtn.alpha=0
        viewtable.frame=CGRect(x:-240,y:0,width:viewtable.frame.size.width,height:viewtable.frame.size.height)
        UIView.commitAnimations()
        viewtable.isHidden=true
        if indexPath.row == 0 {
            temparr = AppDelegate.selectquery(query: "SELECT * FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [userid])
            if (temparr.count == 0)
            {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EnterDetailViewController") as! EnterDetailViewController
                secondViewController.actionstr="Add Me"
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            else
            {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
                secondViewController.profileid=(temparr.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int
                secondViewController.userid=userid
                secondViewController.api_token=api_token
                secondViewController.myfriend="2"
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
        }
        else if indexPath.row == 1 {
            UserDefaults.standard.set("", forKey: "fcity")
            UserDefaults.standard.set("", forKey: "fvillage")
            UserDefaults.standard.set("", forKey: "fmaternal_place")
            UserDefaults.standard.set("", forKey: "flastname")
            UserDefaults.standard.set("0", forKey: "fromage")
            UserDefaults.standard.set("0", forKey: "toage")
            UserDefaults.standard.set("0", forKey: "fromheight")
            UserDefaults.standard.set("0", forKey: "toheight")
            UserDefaults.standard.set("0", forKey: "fromweight")
            UserDefaults.standard.set("0", forKey: "toweight")
            UserDefaults.standard.set("no", forKey: "filter")

            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
            secondViewController.actionstr = "Add Friend"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else if indexPath.row == 2 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PendingrequestViewController") as! PendingrequestViewController
            secondViewController.actionstr = "Pending Friend Request"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else if indexPath.row == 3 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PendingrequestViewController") as! PendingrequestViewController
            secondViewController.actionstr = "Your Friend Request"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else if indexPath.row == 4 {
            let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/apple-store/id1204696872?mt=8")
            
            let vc = UIActivityViewController(activityItems: [myWebsite], applicationActivities: [])
            present(vc, animated: true)
            
            //  content.appLinkURL = NSURL(string:"https://fb.me/250627542059191") as URL!
            // content.appInvitePreviewImageURL = NSURL(string:"https://itunes.apple.com/us/app/apple-store/id375380948?mt=8") as URL!
//            let content:FBSDKAppInviteContent = FBSDKAppInviteContent.init()
//            content.appLinkURL = NSURL(string:"https://fb.me/250627305392548") as URL!
//            
//            FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
            
            
//            let myUrls: String = "fb://https://fb.me/250627305392548"
//            let urls: [String] = myUrls.components(separatedBy: "|")
//            for url: String in urls {
//                let nsurl = URL(string: url)
//                if UIApplication.shared.canOpenURL(nsurl!) {
//                    UIApplication.shared.openURL(nsurl!)
//                    break
//                }
//            }
        }
        else if indexPath.row == 5 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutusViewController") as! AboutusViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else if indexPath.row == 6 {
            UserDefaults.standard.removeObject(forKey: "userid")
            UserDefaults.standard.removeObject(forKey: "api_token")
            UserDefaults.standard.removeObject(forKey: "firstname")
            UserDefaults.standard.removeObject(forKey: "lastname")
            UserDefaults.standard.removeObject(forKey: "profilepic")
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let imagecache:SDImageCache = SDImageCache.shared()
        imagecache.clearMemory()
        imagecache.clearDisk()
      }

    @IBAction func btnbackclicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}

