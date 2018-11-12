//
//  MemeTextFieldDelegate.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-10-29.
//  Copyright © 2018 Rita's company. All rights reserved.
//

import Foundation
import UIKit


class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        var newTextString = oldText.replacingCharacters(in: range, with: string)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //TODO: how to clear only the default text ?
        if (!textField.text!.isEmpty) {
            textField.text = "" // remove default strings
        }
        
    }
}

