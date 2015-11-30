//
//  Layer.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 11/29/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import Foundation
import SVProgressHUD

class Layer {
    static var layerClient: LYRClient!
    
    // MARK - Layer Authentication Methods
    
    static func loginLayer(performAction: Void -> Void) {
        SVProgressHUD.show()
        
        // Connect to Layer
        // See "Quick Start - Connect" for more details
        // https://developer.layer.com/docs/quick-start/ios#connect
        Layer.layerClient.connectWithCompletion { success, error in
            if (!success) {
                print("Failed to connect to Layer: \(error)")
            } else {
                let userID: String = User.currentUser()!.objectId!
                // Once connected, authenticate user.
                // Check Authenticate step for authenticateLayerWithUserID source
                self.authenticateLayerWithUserID(userID, completion: { success, error in
                    if (!success) {
                        print("Failed Authenticating Layer Client with error:\(error)")
                    } else {
                        print("Authenticated")
                        //self.presentConversationListViewController()
                        performAction()
                    }
                })
            }
        }
    }
    
    static func authenticateLayerWithUserID(userID: NSString, completion: ((success: Bool , error: NSError!) -> Void)!) {
        // Check to see if the layerClient is already authenticated.
        if Layer.layerClient.authenticatedUserID != nil {
            // If the layerClient is authenticated with the requested userID, complete the authentication process.
            if Layer.layerClient.authenticatedUserID == userID {
                print("Layer Authenticated as User \(Layer.layerClient.authenticatedUserID)")
                if completion != nil {
                    completion(success: true, error: nil)
                }
                return
            } else {
                //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
                Layer.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError!) in
                    if error != nil {
                        self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError?) in
                            if (completion != nil) {
                                completion(success: success, error: error)
                            }
                        })
                    } else {
                        if completion != nil {
                            completion(success: true, error: error)
                        }
                    }
                }
            }
        } else {
            // If the layerClient isn't already authenticated, then authenticate.
            self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError!) in
                if completion != nil {
                    completion(success: success, error: error)
                }
            })
        }
    }
    
    static func authenticationTokenWithUserId(userID: NSString, completion:((success: Bool, error: NSError!) -> Void)!) {
        /*
        * 1. Request an authentication Nonce from Layer
        */
        Layer.layerClient.requestAuthenticationNonceWithCompletion { (nonce: String!, error: NSError!) in
            if (nonce.isEmpty) {
                if (completion != nil) {
                    completion(success: false, error: error)
                }
                return
            }
            
            /*
            * 2. Acquire identity Token from Layer Identity Service
            */
            PFCloud.callFunctionInBackground("generateToken", withParameters: ["nonce": nonce, "userID": userID]) { (object:AnyObject?, error: NSError?) -> Void in
                if error == nil {
                    let identityToken = object as! String
                    Layer.layerClient.authenticateWithIdentityToken(identityToken) { authenticatedUserID, error in
                        if (!authenticatedUserID.isEmpty) {
                            if (completion != nil) {
                                completion(success: true, error: nil)
                            }
                            print("Layer Authenticated as User: \(authenticatedUserID)")
                        } else {
                            completion(success: false, error: error)
                        }
                    }
                } else {
                    print("Parse Cloud function failed to be called to generate token with error: \(error)")
                }
            }
        }
    }

}