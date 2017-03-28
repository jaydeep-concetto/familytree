//
//  EnterDetailViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 22/12/16.
//  Copyright © 2016 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import UIFloatLabelTextField
class EnterDetailViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate {
    var actionstr:String = ""
    var tempimage:Data = Data()
    var genderid:String = ""
    var isaliveid:String = ""
    var marital_status:String = ""
    var clickdate:String = ""
   
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var lblmaintitlr: UILabel!
    @IBOutlet weak var deathview: UIView!
    @IBOutlet weak var btnmarried: UIButton!
    @IBOutlet weak var btnsingle: UIButton!
    @IBOutlet weak var btnmale: UIButton!
    @IBOutlet weak var btnfemale: UIButton!
    @IBOutlet weak var btnyes: UIButton!
    @IBOutlet weak var imgprofilepic: UIImageView!
    @IBOutlet weak var btnaddphoto: UIButton!
    @IBOutlet weak var txtfirstname: UIFloatLabelTextField!
    @IBOutlet weak var txtlastname: UIFloatLabelTextField!
    @IBOutlet weak var txtdob: UIFloatLabelTextField!
    @IBOutlet weak var txtdod: UIFloatLabelTextField!
    @IBOutlet weak var datepickeroutlet: UIDatePicker!
    @IBOutlet weak var datepickerview: UIView!
    @IBAction func btnaddclicked(_ sender: Any) {
        if (txtfirstname.text?.isEmpty)! {
            let alert = UIAlertController(title: "Alert", message: "Please Enter the first name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtlastname.text?.isEmpty)! {
            let alert = UIAlertController(title: "Alert", message: "Please Enter the last name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
//        else if (txtdob.text?.isEmpty)! {
//            let alert = UIAlertController(title: "Alert", message: "Please Enter the Date of Birth", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if (genderid.isEmpty) {
//            let alert = UIAlertController(title: "Alert", message: "Please Select the Gender", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if (isaliveid == "0" && (txtdod.text?.isEmpty)!) {
//            let alert = UIAlertController(title: "Alert", message: "Please Enter the Date of Death", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        else
        {
            var parentid:Int = 0
            var spouseid:Int = 0
            var userid:Int = 0
            if (actionstr == "Add Me") {
                parentid = 0
                spouseid = 0
                userid = UserDefaults.standard.integer(forKey: "userid")
                print(userid)
                print((UserDefaults.standard.string(forKey: "userid"))! )
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
            //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            var dateObj:String = dateFormatter.string(from: NSDate() as Date)
            dateObj = dateObj+nowDouble
            dateObj = dateObj.replacingOccurrences(of: " ", with: "")+".png"
            if tempimage.count == 0 {
                dateObj = ""
            }
            else
            {
                let directorypath: URL = URL(fileURLWithPath: getDocumentsDirectory()).appendingPathComponent(dateObj)
                try? tempimage.write(to: directorypath)
            }
            var dobstr:String = ""
            var dodstr:String = ""
            
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
            
        
            
            AppDelegate.insertquery(query: "INSERT INTO User_profile (firstname,lastname,dob,dod,genderid,marital_statusid,profilepicturepath,isalive,parentid,spouseid,userid,relation) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", arr: [txtfirstname.text!,txtlastname.text!, dobstr,dodstr,genderid,marital_status,dateObj,isaliveid,parentid,spouseid,userid,actionstr])
            let abcd:NSDictionary = (AppDelegate.selectquery(query:"SELECT MAX(id) FROM User_profile", arr: [])).object(at: 0) as! NSDictionary
            if (actionstr == "Add Spouse") {
                AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE userid = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,UserDefaults.standard.integer(forKey: "userid")])
            }
            else if (actionstr == "Add Father") {
                AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = ? WHERE userid = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,UserDefaults.standard.integer(forKey: "userid")])
            }
            else if (actionstr == "Add Mother") {
                let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
                AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE id = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd1.value(forKey: "parentid") as! Int])
            }
            else if (actionstr == "Add GrandFather") {
                 let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
               AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = ? WHERE id = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd1.value(forKey: "parentid") as! Int])
            }
            else if (actionstr == "Add GrandMother") {
                let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
                let abcd2:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd1.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
                AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE id = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd2.value(forKey: "parentid") as! Int])
            }
            else if (actionstr == "Add GreatGrandFather") {
                let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
                let abcd2:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd1.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
                AppDelegate.insertquery(query: "UPDATE User_profile SET parentid = ? WHERE id = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd2.value(forKey: "parentid") as! Int])
            }
            else if (actionstr == "Add GreatGrandMother") {
                let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
                let abcd2:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd1.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
                let abcd3:NSDictionary = (AppDelegate.selectquery(query:"SELECT parentid FROM User_profile WHERE id = ? AND isdeleted = 0", arr: [abcd2.value(forKey: "parentid") as! Int])).object(at: 0) as! NSDictionary
                AppDelegate.insertquery(query: "UPDATE User_profile SET spouseid = ? WHERE id = ? AND isdeleted = 0", arr: [abcd.value(forKey: "MAX(id)") as! Int,abcd3.value(forKey: "parentid") as! Int])
            }
        _ = self.navigationController?.popViewController(animated: true)
        }

    }
    @IBAction func btndatepickerdone(_ sender: Any) {
        datepickerview.isHidden=true
        let dateformatter:DateFormatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMM-yyyy"
        if clickdate == "dob" {
            txtdob.text = dateformatter.string(from: datepickeroutlet.date)
        }
        else
        {
            txtdod.text = dateformatter.string(from: datepickeroutlet.date)
        }
        //datepickeroutlet.date=NSDate() as Date
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        datepickerview.isHidden=true
        return true
    }
    @IBAction func btnaddphotoclicked(_ sender: Any) {
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
                    self.imgprofilepic.image = UIImage(named:"girl.png")
                }
                else
                {
                    self.imgprofilepic.image = UIImage(named:"man.png")
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
    @IBAction func btnbackclicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        settextfield(textField2: txtfirstname)
        settextfield(textField2: txtlastname)
        settextfield(textField2: txtdob)
        settextfield(textField2: txtdod)
        genderid = "3"
        marital_status = "3"
        lblmaintitlr.text = actionstr
        super.viewDidLoad()
        toolbarview.backgroundColor = GlobalConstants.toolbar1

        datepickeroutlet.maximumDate=NSDate() as Date
        isaliveid = "1"
        btnmale.addTarget(self, action: #selector(genderbtn(_:)), for: .touchUpInside)
        btnfemale.addTarget(self, action: #selector(genderbtn(_:)), for: .touchUpInside)
        btnyes.addTarget(self, action: #selector(isalivebtn(_:)), for: .touchUpInside)
        btnsingle.addTarget(self, action: #selector(maritalbtn(_:)), for: .touchUpInside)
        btnmarried.addTarget(self, action: #selector(maritalbtn(_:)), for: .touchUpInside)
        btnmale.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmale.backgroundColor = (GlobalConstants.btnabackground)
        btnfemale.backgroundColor = (GlobalConstants.btniabackground)
        btnsingle.setTitleColor(GlobalConstants.btnatext, for: .normal)
        btnmarried.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnsingle.backgroundColor = (GlobalConstants.btnabackground)
        btnmarried.backgroundColor = (GlobalConstants.btniabackground)
        if (actionstr == "Add Me") {
                tempimage = UserDefaults.standard.data(forKey: "profilepic")!
                txtfirstname.text=UserDefaults.standard.string(forKey: "firstname")
                txtlastname.text=UserDefaults.standard.string(forKey: "lastname")
                imgprofilepic.image = UIImage(data: tempimage)
        }
        else if (actionstr == "Add Spouse") {
            let abcd1:NSDictionary = (AppDelegate.selectquery(query:"SELECT genderid FROM User_profile WHERE userid = ? AND isdeleted = 0", arr: [UserDefaults.standard.integer(forKey: "userid")])).object(at: 0) as! NSDictionary
            print(abcd1)
            if (abcd1.value(forKey: "genderid") as! Int == 1) {
                genderid = "2"
                btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
                btnfemale.setTitleColor(GlobalConstants.btnatext, for: .normal)
                btnmale.backgroundColor = (GlobalConstants.btniabackground)
                btnfemale.backgroundColor = (GlobalConstants.btnabackground)
                imgprofilepic.image = UIImage(named:"girl.png")
            }
            else
            {
                genderid = "1"
                btnmale.setTitleColor(GlobalConstants.btnatext, for: .normal)
                btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
                btnmale.backgroundColor = (GlobalConstants.btnabackground)
                btnfemale.backgroundColor = (GlobalConstants.btniabackground)
                imgprofilepic.image = UIImage(named:"man.png")
            }
        }
        else if (actionstr == "Add Father" || actionstr == "Add GrandFather" || actionstr == "Add GreatGrandFather") {
            genderid = "1"
            btnmale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btnabackground)
            btnfemale.backgroundColor = (GlobalConstants.btniabackground)
            
            imgprofilepic.image = UIImage(named:"man.png")
        }
        else if (actionstr == "Add Mother" || actionstr == "Add GrandMother" || actionstr == "Add GreatGrandMother") {
            genderid = "2"
            btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btniabackground)
            btnfemale.backgroundColor = (GlobalConstants.btnabackground)
            
            imgprofilepic.image = UIImage(named:"girl.png")
        }
        btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmale.backgroundColor = (GlobalConstants.btniabackground)
        btnfemale.backgroundColor = (GlobalConstants.btniabackground)
        btnsingle.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnmarried.setTitleColor(GlobalConstants.btniatext, for: .normal)
        btnsingle.backgroundColor = (GlobalConstants.btniabackground)
        btnmarried.backgroundColor = (GlobalConstants.btniabackground)
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtfirstname {
            txtfirstname.text = txtfirstname.text?.capitalized
        }
        if textField == txtlastname {
            txtlastname.text = txtlastname.text?.capitalized
        }
    }
    @IBAction func btndobenterclicked(_ sender: Any) {
        if txtdod.text != "" {
            let dateformatter:DateFormatter = DateFormatter()
            dateformatter.dateFormat = "dd-MMM-yyyy"
            datepickeroutlet.minimumDate=nil
            datepickeroutlet.maximumDate=dateformatter.date(from: txtdod.text!)
        }
        else
        {
            datepickeroutlet.minimumDate=nil
            datepickeroutlet.maximumDate=NSDate() as Date
        }
        clickdate = "dob"
        datepickerview.isHidden=false
        self.view.endEditing(true)
    }
    @IBAction func btncancelclicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btndodenterclicked(_ sender: Any) {
        if txtdob.text != "" {
            let dateformatter:DateFormatter = DateFormatter()
            dateformatter.dateFormat = "dd-MMM-yyyy"
            datepickeroutlet.minimumDate=dateformatter.date(from: txtdob.text!)
            datepickeroutlet.maximumDate=NSDate() as Date
        }
        else
        {
            datepickeroutlet.minimumDate=nil
            datepickeroutlet.maximumDate=NSDate() as Date
        }
        clickdate = "dod"
        datepickerview.isHidden=false
        self.view.endEditing(true)
    }
   
    func maritalbtn(_ sender: UIButton) {
        if sender == btnsingle {
            btnsingle.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmarried.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnsingle.backgroundColor = (GlobalConstants.btnabackground)
            btnmarried.backgroundColor = (GlobalConstants.btniabackground)
            marital_status = "1"
        }
        else if sender == btnmarried {
            btnsingle.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmarried.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnsingle.backgroundColor = (GlobalConstants.btniabackground)
            btnmarried.backgroundColor = (GlobalConstants.btnabackground)
            marital_status = "2"
        }
        
    }
    func genderbtn(_ sender: UIButton) {
        if sender == btnmale {
            btnmale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btnabackground)
            btnfemale.backgroundColor = (GlobalConstants.btniabackground)
            genderid = "1"
            if tempimage.count == 0 {
                imgprofilepic.image = UIImage(named:"man.png")
            }
        }
        else
        {
            btnmale.setTitleColor(GlobalConstants.btniatext, for: .normal)
            btnfemale.setTitleColor(GlobalConstants.btnatext, for: .normal)
            btnmale.backgroundColor = (GlobalConstants.btniabackground)
            btnfemale.backgroundColor = (GlobalConstants.btnabackground)
            genderid = "2"
            if tempimage.count == 0 {
                imgprofilepic.image = UIImage(named:"girl.png")
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
            deathview.frame=CGRect(x:deathview.frame.origin.x,y:sender.frame.origin.y+35,width:deathview.frame.size.width,height:deathview.frame.size.height)
            UIView.commitAnimations()
           
        }
        else
        {
            btnyes.setImage(UIImage(named:"radio_on.png"), for: .normal)
            isaliveid = "1"
            deathview.frame=CGRect(x:deathview.frame.origin.x,y:sender.frame.origin.y,width:deathview.frame.size.width,height:deathview.frame.size.height)
            deathview.isHidden=true
            txtdod.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            var image1:UIImage = UIImage()
            if image.size.width>400 {
                image1 = resizeImage(image: image, newWidth: 400)
            }
            print(image1.size.width)
            tempimage = UIImagePNGRepresentation(image1)!
            imgprofilepic.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
   

}
