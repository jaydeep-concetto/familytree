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
class addfriendcell: UITableViewCell{
    
    @IBOutlet weak var btnwidth: NSLayoutConstraint!
    @IBOutlet weak var imgmain: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var btnaddfriend: UIButton!
}
class AddFriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBAction func btnfilterclicked(_ sender: Any) {
        

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.present(secondViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var searchoutlet: UISearchBar!
    @IBOutlet weak var tableviewoutlet: UITableView!
    var actionstr:String = ""
    var friendarr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarview.backgroundColor = GlobalConstants.toolbar1

        self.tableviewoutlet.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: "filter")! == "yes")
        {
            searchoutlet.text = ""
            getuserlist(texts:searchoutlet.text!)
        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchBar.showsCancelButton=true
        return true;
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        getuserlist(texts:searchBar.text!)
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton=false
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton=false
    }
    func getuserlist(texts:String)
    {
       
        let mainurl = "\(GlobalConstants.MAINURL)searchfriend?api_token=\(UserDefaults.standard.string(forKey: "api_token")!)&searchkey=\(texts)&fromage=\(UserDefaults.standard.string(forKey: "fromage")!)&toage=\(UserDefaults.standard.string(forKey: "toage")!)&fromheight=\(UserDefaults.standard.string(forKey: "fromheight")!)&toheight=\(UserDefaults.standard.string(forKey: "toheight")!)&fromweight=\(UserDefaults.standard.string(forKey: "fromweight")!)&toweight=\(UserDefaults.standard.string(forKey: "toweight")!)&village=\(UserDefaults.standard.string(forKey: "fvillage")!)&maternal_place=\(UserDefaults.standard.string(forKey: "fmaternal_place")!)&lastname=\(UserDefaults.standard.string(forKey: "flastname")!)&city=\(UserDefaults.standard.string(forKey: "fcity")!)"
     
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
        let cell:addfriendcell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! addfriendcell
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
        cell.btnaddfriend.tag=indexPath.row+500
        cell.btnwidth.constant=70
        if (nullvalue(ints: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "isfriend") as AnyObject) == 1 || nullvalue(ints: (friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "isfriendrequested") as AnyObject) == 1)
        {
            cell.btnwidth.constant=0
        }
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
        
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        
                secondViewController.userid=nullvalue(ints:(friendarr.object(at: indexPath.row) as? NSDictionary)?.value(forKey: "userid") as AnyObject)
                secondViewController.api_token=UserDefaults.standard.string(forKey: "api_token")!
                self.navigationController?.pushViewController(secondViewController, animated: true)
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
