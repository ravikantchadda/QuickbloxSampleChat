//
//  ViewController.swift
//  chatswift
//
//  Created by ravi kant on 12/17/15.
//  Copyright © 2015 Net Solutions. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    var allUsers = NSArray()
    var excludeUsersIDs = NSArray()
    var customUsers = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.toSignUP()
        self.toSignIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func toSignUP(){
    
        let tagsArray: NSMutableArray = NSMutableArray(object: "dev")
        
        // Create QuickBlox User entity
        
        let user = QBUUser()
        
        user.email = "xyz@gmail.com"
        user.login = "xyz@gmail.com"
        user.fullName = "ABCXYZ"
        user.tags = tagsArray
        user.password = "12345678"
        
        SVProgressHUD.showWithStatus("Signing Up...", maskType: SVProgressHUDMaskType.Clear)
        
        ServicesManager.instance().SignUPWithUser(user) { (success:Bool, errormessage:String!) -> Void in
            
            if success == true{
                
                SVProgressHUD.showSuccessWithStatus("Singed Up")
                
            }
            else{
            
                SVProgressHUD.showErrorWithStatus("Can not signup")
            
            }
            
            
        }
        
    }
    
    
    func toSignIn(){
        
        let user = QBUUser()
        user.email = "abc@gmail.com"
        user.password = "12345678"
        SVProgressHUD.showWithStatus("Logging in...", maskType: SVProgressHUDMaskType.Clear)
        ServicesManager.instance().logInWithUser(user) { (success:Bool, errormessage:String!) -> Void in
            if success == true{
                
                SVProgressHUD.showSuccessWithStatus("Singed Up")
                
            }
            else{
                
                SVProgressHUD.showErrorWithStatus("Can not login")
                
            }
        }
        

    
    }
    
    
    func alreadyLogedInUser(){
        
        let alreadyLogedIn: Bool = NSUserDefaults.standardUserDefaults().boolForKey("useralreadyregistered")
        
        if alreadyLogedIn == true{
            
            let user = QBUUser()
            user.email = "abc@gmail.com"
            user.password = "12345678"
            
            SVProgressHUD.showWithStatus("Logging in...", maskType: SVProgressHUDMaskType.Clear)
            // Logging in to Quickblox REST API and chat.
            ConnectionManager.instance().logInWithUser(user, completion: { (error:Bool) -> Void in
                
                if error == true{
                    
                }else{
                    
                }
                
                
                ServicesManager.instance().logInWithUser(user) { (success:Bool, errormessage:String!) -> Void in
                    if success == true{
                        
                        SVProgressHUD.showSuccessWithStatus("Singed Up")
                        self.retrieveUsers()
                        
                    }
                    else{
                        
                        SVProgressHUD.showErrorWithStatus("Can not login")
                        
                    }
                }
                
            })
            
        }else{
            
            self.retrieveUsers()
            
        }
        

    
    
    }
    
    
    func retrieveUsers(){
        
        ServicesManager.instance().usersService.cachedUsersWithCompletion { (users) -> Void in
            
            let getUsers = users as NSArray
            
            if getUsers.count>0{
                self.loadDataSourceWithUsers(getUsers)
            }else{
                self.downloadLatestUsers()
            }
        }
    
    }
    
    
   
    
    //MARK: --------------------------------------------------------------------------------------------------
    //MARK: - QB downloadLatestUsers
    
    func downloadLatestUsers(){
    
        SVProgressHUD.showWithStatus("Loading users", maskType: SVProgressHUDMaskType.Clear)
        // Downloading latest users.
        ServicesManager.instance().usersService.downloadLatestUsersWithSuccessBlock({ (users) -> Void in
            
            SVProgressHUD.showSuccessWithStatus("Completed")
            let latestUsers = users as NSArray

            self.loadDataSourceWithUsers(latestUsers)
            //reload tableview
            
            }) { (response:QBResponse!) -> Void in
                
                SVProgressHUD.showErrorWithStatus("Can not download users")
                
        }
        
        
    
    
    }
    
    func loadDataSourceWithUsers(users:NSArray){
        self.excludeUsersIDs = []
        
        self.customUsers = users.copy().sortedArrayUsingComparator {
            (obj1, obj2) -> NSComparisonResult in
            
            let p1 = obj1 as! QBUUser
            let p2 = obj2 as! QBUUser
            let result = p1.login.compare(p2.login)
            return result
        }
        
        
        let tempArray = NSArray()
        
        
        
        
    }
    
    
    
    
    
    


}

