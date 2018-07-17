//
//  HttpBinResponse.swift
//  GGARest_Tests
//
//  Created by Adrian Sanchis Serrano on 17/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GGARest

class HttpBinResponse: JSonBaseObject {
    @objc dynamic var url : String = ""
    @objc dynamic var origin : String = ""
    @objc dynamic var headers =  [String : String]()

}
