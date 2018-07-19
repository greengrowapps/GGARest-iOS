//
//  ObjectWithNullables.swift
//  GGARest_Tests
//
//  Created by Adrian Sanchis Serrano on 19/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GGARest

class ObjectWithNullables: JSonBaseObject {
    @objc dynamic var nullableString : String?;
    @objc dynamic var nullableInt : NSNumber?;
    @objc dynamic var nullableChild : MyChild?
    @objc dynamic var nullablechildList : [MyChild]? 
}
