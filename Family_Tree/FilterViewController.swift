//
//  FilterViewController.swift
//  Family_Tree
//
//  Created by Manish Patel on 18/02/17.
//  Copyright © 2017 Jaydeep Vachhani. All rights reserved.
//

import UIKit
import UIFloatLabelTextField
class FilterViewController: UIViewController {

    @IBOutlet weak var viewwidthheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var viewheightheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var viewageheightconstraint: NSLayoutConstraint!
    @IBOutlet weak var viewweight: UIView!
    @IBOutlet weak var viewheight: UIView!
    @IBOutlet weak var viewage: UIView!
    @IBOutlet weak var btnage: UIButton!
    @IBOutlet weak var btnheight: UIButton!
    @IBOutlet weak var btnweight: UIButton!
    @IBOutlet weak var sliderage: NMRangeSlider!
    @IBOutlet weak var sliderheight: NMRangeSlider!
    @IBOutlet weak var sliderweight: NMRangeSlider!
    @IBOutlet weak var toolbarview: UIView!
    @IBOutlet weak var scrviewheightconstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollviewoutlet: UIScrollView!
    @IBOutlet weak var minage: UILabel!
    @IBOutlet weak var maxage: UILabel!
    @IBOutlet weak var minheight: UILabel!
    @IBOutlet weak var maxheight: UILabel!
    @IBOutlet weak var minweight: UILabel!
    @IBOutlet weak var maxweight: UILabel!
    @IBOutlet weak var txtcity: UIFloatLabelTextField!
    @IBOutlet weak var txtvillage: UIFloatLabelTextField!
    @IBOutlet weak var txtmaternal_place: UIFloatLabelTextField!
    @IBOutlet weak var txtsurname: UIFloatLabelTextField!
    @IBAction func slideragechanged(_ sender: Any) {
        minage.text = "\(Int(sliderage.lowerValue))"
        maxage.text = "\(Int(sliderage.upperValue))"
    }
    @IBAction func sliderheightchanged(_ sender: Any) {
        minheight.text = "\(Int(sliderheight.lowerValue)+100)"
        maxheight.text = "\(Int(sliderheight.upperValue)+100)"
    }
    @IBAction func sliderweightchanged(_ sender: Any) {
        minweight.text = "\(Int(sliderweight.lowerValue)+20)"
        maxweight.text = "\(Int(sliderweight.upperValue)+20)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settextfield(textField2: txtcity)
        settextfield(textField2: txtvillage)
        settextfield(textField2: txtmaternal_place)
        settextfield(textField2: txtsurname)

        toolbarview.backgroundColor = GlobalConstants.toolbar1
        sliderage.minimumValue=0
        sliderage.maximumValue=100
        sliderage.lowerValue=0
        sliderage.upperValue=100
        sliderheight.minimumValue=0
        sliderheight.maximumValue=120
        sliderheight.lowerValue=0
        sliderheight.upperValue=120
        sliderweight.minimumValue=0
        sliderweight.maximumValue=180
        sliderweight.lowerValue=0
        sliderweight.upperValue=180
        minage.text = "\(Int(sliderage.lowerValue))"
        maxage.text = "\(Int(sliderage.upperValue))"
        minheight.text = "\(Int(sliderheight.lowerValue)+100)"
        maxheight.text = "\(Int(sliderheight.upperValue)+100)"
        minweight.text = "\(Int(sliderweight.lowerValue)+20)"
        maxweight.text = "\(Int(sliderweight.upperValue)+20)"
        btnage.addTarget(self, action: #selector(btnaction12(_sender:)), for: .touchUpInside)
         btnheight.addTarget(self, action: #selector(btnaction12(_sender:)), for: .touchUpInside)
         btnweight.addTarget(self, action: #selector(btnaction12(_sender:)), for: .touchUpInside)
        btnage.setImage(UIImage(named:"uncheck1.png")!, for: .normal)
        btnheight.setImage(UIImage(named:"uncheck1.png")!, for: .normal)
        btnweight.setImage(UIImage(named:"uncheck1.png")!, for: .normal)
        
        
        txtcity.text = UserDefaults.standard.string(forKey: "fcity")!
        txtvillage.text = UserDefaults.standard.string(forKey: "fvillage")!
        txtmaternal_place.text = UserDefaults.standard.string(forKey: "fmaternal_place")!
        txtsurname.text = UserDefaults.standard.string(forKey: "flastname")!
        let ch:UIImage = UIImage(named:"check1.png")!

        if UserDefaults.standard.string(forKey: "toage")! != "0" {
            btnage.setImage(ch, for: .normal)
            viewage.isHidden=false
            viewageheightconstraint.constant=45
            scrviewheightconstraint.constant = scrviewheightconstraint.constant + 45
            sliderage.lowerValue=Float(UserDefaults.standard.string(forKey: "fromage")!)!
            sliderage.upperValue=Float(UserDefaults.standard.string(forKey: "toage")!)!
            minage.text = "\(Int(sliderage.lowerValue))"
            maxage.text = "\(Int(sliderage.upperValue))"
        }
        if UserDefaults.standard.string(forKey: "toheight")! != "0" {
            btnheight.setImage(ch, for: .normal)
            viewheight.isHidden=false
            viewheightheightconstraint.constant=45
            scrviewheightconstraint.constant = scrviewheightconstraint.constant + 45
            sliderheight.lowerValue=Float(UserDefaults.standard.string(forKey: "fromheight")!)! - 100
            sliderheight.upperValue=Float(UserDefaults.standard.string(forKey: "toheight")!)! - 100
            minheight.text = "\(Int(sliderheight.lowerValue)+100)"
            maxheight.text = "\(Int(sliderheight.upperValue)+100)"
        }
        if UserDefaults.standard.string(forKey: "toweight")! != "0" {
            btnweight.setImage(ch, for: .normal)
            viewweight.isHidden=false
            viewwidthheightconstraint.constant=45
            scrviewheightconstraint.constant = scrviewheightconstraint.constant + 45
            sliderweight.lowerValue=Float(UserDefaults.standard.string(forKey: "fromweight")!)! - 20
            sliderweight.upperValue=Float(UserDefaults.standard.string(forKey: "toweight")!)! - 20
            minweight.text = "\(Int(sliderweight.lowerValue)+20)"
            maxweight.text = "\(Int(sliderweight.upperValue)+20)"
        }
    }
    func btnaction12(_sender:UIButton)
    {
        let unch:UIImage = UIImage(named:"uncheck1.png")!
        let ch:UIImage = UIImage(named:"check1.png")!

        if _sender == btnage {
            if (btnage.imageView?.image == unch) {
                btnage.setImage(ch, for: .normal)
                viewage.isHidden=false
                viewageheightconstraint.constant=45
            scrviewheightconstraint.constant = scrviewheightconstraint.constant + 45
            }
            else{
                btnage.setImage(unch, for: .normal)
                viewage.isHidden=true
                viewageheightconstraint.constant=0
                scrviewheightconstraint.constant = scrviewheightconstraint.constant - 45
            }
        }
        else if _sender == btnheight {
            if (btnheight.imageView?.image == unch) {
                btnheight.setImage(ch, for: .normal)
                viewheight.isHidden=false
                viewheightheightconstraint.constant=45
                scrviewheightconstraint.constant = scrviewheightconstraint.constant + 45
            }
            else{
                btnheight.setImage(unch, for: .normal)
                viewheight.isHidden=true
                viewheightheightconstraint.constant=0
                scrviewheightconstraint.constant = scrviewheightconstraint.constant - 45
            }
        }
        else if _sender == btnweight {
            if (btnweight.imageView?.image == unch) {
                btnweight.setImage(ch, for: .normal)
                viewweight.isHidden=false
                viewwidthheightconstraint.constant=45
                scrviewheightconstraint.constant = scrviewheightconstraint.constant + 45
            }
            else{
                btnweight.setImage(unch, for: .normal)
                viewweight.isHidden=true
                viewwidthheightconstraint.constant=0
                scrviewheightconstraint.constant = scrviewheightconstraint.constant - 45
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func btnapplyclicked(_ sender: Any) {
        UserDefaults.standard.set("yes", forKey: "filter")

        UserDefaults.standard.set(txtcity.text, forKey: "fcity")
        UserDefaults.standard.set(txtvillage.text, forKey: "fvillage")
        UserDefaults.standard.set(txtmaternal_place.text, forKey: "fmaternal_place")
        UserDefaults.standard.set(txtsurname.text, forKey: "flastname")
        let unch:UIImage = UIImage(named:"uncheck1.png")!
            if (btnage.imageView?.image == unch) {
                UserDefaults.standard.set("0", forKey: "fromage")
                UserDefaults.standard.set("0", forKey: "toage")
            }
            else{
                UserDefaults.standard.set(minage.text, forKey: "fromage")
                UserDefaults.standard.set(maxage.text, forKey: "toage")
            }
        
            if (btnheight.imageView?.image == unch) {
                UserDefaults.standard.set("0", forKey: "fromheight")
                UserDefaults.standard.set("0", forKey: "toheight")
            }
            else{
                UserDefaults.standard.set(minheight.text, forKey: "fromheight")
                UserDefaults.standard.set(maxheight.text, forKey: "toheight")
            }
        
            if (btnweight.imageView?.image == unch) {
                UserDefaults.standard.set("0", forKey: "fromweight")
                UserDefaults.standard.set("0", forKey: "toweight")
            }
            else{
                UserDefaults.standard.set(minweight.text, forKey: "fromweight")
                UserDefaults.standard.set(maxweight.text, forKey: "toweight")
            }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btncancelclicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
   
}
