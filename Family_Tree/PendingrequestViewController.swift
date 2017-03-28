//
//  FriendViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 10/01/17.
//  Copyright © 2017 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import ARSLineProgress
import Alamofire
class pendingrequestcell: UITableViewCell{
    @IBOutlet weak var imgmain: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var btnaccept: UIButton!
    @IBOutlet weak var btndecline: UIButton!
}
class sendrequestcell: UITableViewCell{
    @IBOutlet weak var imgmain: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var btncancelrequest: UIButton!
}
class PendingrequestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var tableviewoutlet: UITableView!
    var actionstr:String = ""
    var friendarr:NSMutableArray = NSMutableArray()
    @IBOutlet weak var lblmain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarview.backgroundColor = GlobalConstants.toolbar1

        lblmain.text=actionstr
        self.tableviewoutlet.tableFooterView = UIView.init(frame: CGRect.zero)
        if actionstr == "Pending Friend Request" {
            getpendingrequest()
        }
        else
        {
            getsendrequest()
        }
    }
    @IBAction func btnhome1clicked(_ sender: Any) {
 
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[1], animated: true);
    }
    func getsendrequest() {
        let mainurl = "\(GlobalConstants.MAINURL)getallsentrequests?api_token=\(UserDefaults.standard.string(forKey: "api_token")!)"
        ARSLineProgress.show()
        Alamofire.request(mainurl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                        self.friendarr=(JSON.value(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
                        self.tableviewoutlet.reloadData()
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
    func getpendingrequest() {
       
        let mainurl = "\(GlobalConstants.MAINURL)getallfriendrequests?api_token=\(UserDefaults.standard.string(forKey: "api_token")!)"
        
        ARSLineProgress.show()
        Alamofire.request(mainurl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                        self.friendarr=(JSON.value(forKey: "result") as! NSArray).mutableCopy() as! NSMutableArray
                        self.tableviewoutlet.reloadData()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendarr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if friendarr.count>0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
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
        return numOfSections
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if actionstr == "Pending Friend Request" {
            let cellIdentifier = "reuse"
            let cell:pendingrequestcell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! pendingrequestcell
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
            if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 1)
            {
                cell.lblemail.text = cell.lblemail.text! + "Male, "
            }
            else
            {
                cell.lblemail.text = cell.lblemail.text! + "Female, "
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
            cell.btnaccept.tag=indexPath.row+500
            cell.btndecline.tag=indexPath.row+500
            let image:String = nullvalue(strings: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "profilepicturepath") as Any)
            if (image != "") {
                 if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2) {
                cell.imgmain.sd_setImage(with: URL(string:image),placeholderImage:UIImage(named:"girl.png"))
                }
                else
                 {
                    cell.imgmain.sd_setImage(with: URL(string:image),placeholderImage:UIImage(named:"man.png"))
                }
            }
            else
            {
                if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2) {
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
            let cellIdentifier = "reuse1"
            let cell:sendrequestcell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! sendrequestcell
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
            else
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
            cell.btncancelrequest.tag=indexPath.row+500
            let image:String = nullvalue(strings: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "profilepicturepath") as Any)
            if (image != "") {
                if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2) {
                    cell.imgmain.sd_setImage(with: URL(string:image),placeholderImage:UIImage(named:"girl.png"))
                }
                else
                {
                    cell.imgmain.sd_setImage(with: URL(string:image),placeholderImage:UIImage(named:"man.png"))
                }

            }
            else
            {
                if (nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "genderid") as AnyObject) == 2) {
                    cell.imgmain.image=UIImage(named:"girl.png")
                }
                else
                {
                    cell.imgmain.image=UIImage(named:"man.png")
                    
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        
        secondViewController.userid=nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as AnyObject)
        secondViewController.api_token=UserDefaults.standard.string(forKey: "api_token")!
        self.navigationController?.pushViewController(secondViewController, animated: true)
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
    func nullvalue(ints:AnyObject) -> Int {
        var tempstr:AnyObject = ints
        if (tempstr is NSNull) {
            tempstr = 0 as AnyObject
        }
        print(tempstr)
        
        return Int("\(tempstr)")!
    }
    func nullvalue(strings:Any) -> String {
        var tempstr:Any = strings
        if (tempstr is NSNull) {
            tempstr = ""
        }
        return tempstr as! String
    }
    @IBAction func btncancelrequestclicked(_ sender: UIButton) {
        
        let mainurl = "\(GlobalConstants.MAINURL)cancelrequest"
        let mainparameter:NSDictionary = ["friend_requestid":(friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "friend_requestid") as AnyObject,"api_token":UserDefaults.standard.string(forKey: "api_token")!]
        self.friendarr.removeObject(at: sender.tag-500)
        self.tableviewoutlet.reloadData()
        //ARSLineProgress.show()
        Alamofire.request(mainurl, method: .delete, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                       
                        self.view.makeToast("You have cancelled a friend request.", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
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
    @IBAction func btnacceptedclicked(_ sender: UIButton) {
        respondapi(tag:sender.tag-500, respond: "2")
    }
    @IBAction func btndeclineclicked(_ sender: UIButton) {
        respondapi(tag:sender.tag-500, respond: "3")
    }
    func respondapi(tag:Int,respond:String){
        let mainurl = "\(GlobalConstants.MAINURL)respondrequest"
        print(respond)
        print((friendarr.object(at: tag) as? NSDictionary)?.value(forKey: "friend_requestid") as AnyObject)
        print(UserDefaults.standard.string(forKey: "api_token")!)
        let mainparameter:NSDictionary = ["respondstatusid":respond,"requestid":(friendarr.object(at: tag) as? NSDictionary)?.value(forKey: "friend_requestid") as AnyObject,"api_token":UserDefaults.standard.string(forKey: "api_token")!]
        let tempname:String = self.nullvalue(strings:(self.friendarr.object(at: tag) as? NSDictionary)?.value(forKey: "firstname") as Any) + " " + self.nullvalue(strings:(self.friendarr.object(at: tag) as? NSDictionary)?.value(forKey: "lastname") as Any)
        self.friendarr.removeObject(at: tag)
        self.tableviewoutlet.reloadData()
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
                            self.view.makeToast(tempname + " has been added to your friend list.", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnbackclicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
