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
class notificationcell: UITableViewCell{
    
    @IBOutlet weak var imgmain: UIImageView!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var notiview: UIView!
}
class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var tableviewoutlet: UITableView!
    var actionstr:String = ""
    var friendarr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarview.backgroundColor = GlobalConstants.toolbar1
        
        self.tableviewoutlet.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    override func viewWillAppear(_ animated: Bool) {
        getuserlist()
    }
    
    func getuserlist()
    {
        
        let mainurl = "\(GlobalConstants.MAINURL)getnotifications?api_token=\(UserDefaults.standard.string(forKey: "api_token")!)"
        
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
    @IBAction func btnhome1clicked(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[1], animated: true);
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "reuse"
        let cell:notificationcell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! notificationcell
        cell.lblemail.text = nullvalue(strings: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "description") as Any)
        let image:String = nullvalue(strings: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "profilepicturepath") as Any)
        if (image != "") {
            cell.imgmain.sd_setImage(with: URL(string:image), placeholderImage: UIImage(named:"man.png"))
        }
        else
        {
            cell.imgmain.image=UIImage(named:"man.png")
        }
        if (nullvalue(ints: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "notification_seenid") as AnyObject) == 0)
        {
            cell.notiview.isHidden=false
        }
        else
        {
            cell.notiview.isHidden=true

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (nullvalue(ints: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "notification_seenid") as AnyObject) != 0)
        {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            secondViewController.userid=self.nullvalue(ints:(self.friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "notification_sent_by") as AnyObject)
            secondViewController.api_token=UserDefaults.standard.string(forKey: "api_token")!
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        else
        {
        
        let mainurl = "\(GlobalConstants.MAINURL)setnotificationseen?)"
        
        let parameter = ["api_token":UserDefaults.standard.string(forKey: "api_token")!,"notification_id":"\(nullvalue(ints: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "notification_id") as AnyObject))"]
       
        ARSLineProgress.show()
        Alamofire.request(mainurl, method: .post, parameters: parameter, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
                        secondViewController.userid=self.nullvalue(ints:(self.friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "notification_sent_by") as AnyObject)
                        secondViewController.api_token=UserDefaults.standard.string(forKey: "api_token")!
                        self.navigationController?.pushViewController(secondViewController, animated: true)
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
    func nullvalue(strings:Any) -> String {
        var tempstr:Any = strings
        if (tempstr is NSNull) {
            tempstr = ""
        }
        return tempstr as! String
    }
    func nullvalue(ints:AnyObject) -> Int {
        var tempstr:AnyObject = ints
        if (tempstr is NSNull) {
            tempstr = 0 as AnyObject
        }
        print(tempstr)
        
        return Int("\(tempstr)")!
    }
    @IBAction func btnaddfriendclicked(_ sender: UIButton) {
        let mainurl = "\(GlobalConstants.MAINURL)addfriend"
        let mainparameter:NSDictionary = ["socialid":(friendarr.object(at:sender.tag-500) as? NSDictionary)?.value(forKey: "socialid") as! String,"api_token":UserDefaults.standard.string(forKey: "api_token")!]
        //ARSLineProgress.show()
        let tempname:String = self.nullvalue(strings:(self.friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "firstname") as Any) + " " + self.nullvalue(strings:(self.friendarr.object(at: sender.tag-500) as? NSDictionary)?.value(forKey: "lastname") as Any)
        self.friendarr.removeObject(at: sender.tag-500)
        self.tableviewoutlet.reloadData()
        Alamofire.request(mainurl, method: .post, parameters: mainparameter as? Parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                if response.result.value != nil
                {
                    let JSON = response.result.value as! NSDictionary
                    
                    
                    if JSON.value(forKey: "status") as! Int == 200 {
                        
                        self.view.makeToast("You have sent friend request to " + tempname + ".", duration: 2.0, position: CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height-80))
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

