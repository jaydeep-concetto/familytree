//
//  constant1.swift
//  Family_Tree
//
//  Created by Manish Patel on 30/12/16.
//  Copyright © 2016 Jaydeep Vachhani. All rights reserved.
//

import Foundation
import UIKit
import UIFloatLabelTextField
struct GlobalConstants {
    //  Device IPHONE
    
    static let MAINURL:String = "http://192.168.1.58/familytree/public/api/v1/"
    //static let MAINURL:String = "http://familytree.concetto-project-progress.com/api/v1/"
    static let toolbar1:UIColor = UIColor.init(colorLiteralRed: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1)
    static let toolbar2:UIColor = UIColor.init(colorLiteralRed: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
    static let btnabackground:UIColor = UIColor.init(colorLiteralRed: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1)
    static let btnatext:UIColor = UIColor.white
    static let btniabackground:UIColor = UIColor.white
    static let btniatext:UIColor = UIColor.init(colorLiteralRed: 76/255.0, green: 76/255.0, blue: 73/255.0, alpha: 1)
}
public func settextfield(textField2:UIFloatLabelTextField)
{
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
    textField2.tintColor = darkGreyColor // the color of the blinking cursor
    textField2.textColor = darkGreyColor
    textField2.floatLabelPassiveColor = lightGreyColor
    textField2.floatLabelActiveColor = lightGreyColor
}
public func getDocumentsDirectory() -> String {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = "\(paths[0])"
    return documentsDirectory
}

