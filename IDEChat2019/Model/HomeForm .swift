//
//  RegisterationForm .swift
//  IDEChat2019
//
//  Created by mohamed gamal mohamed on 6/16/19.
//  Copyright © 2019 mohamed gamal mohamed. All rights reserved.
//

import Foundation

struct HomeForm {
    
    var formType:topSegment
    var userName:String?
    var passowrd:String?
    var email:String?
    
    func validateField() -> Bool{
        if(email?.isEmpty == false && passowrd?.isEmpty == false &&
            (userName?.isEmpty == false && formType == .register )){
            return true
        }else{
            return false
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    
}
