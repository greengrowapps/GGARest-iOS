//
//  MyClass.swift
//  GGARest
//
//  Created by Adrian Sanchis Serrano on 9/7/18.
//  Copyright © 2018 GreenGrowApps. All rights reserved.
//

import UIKit
import SwiftyJSON
import GGARest


class MyClass : JSonBaseObject {
     @objc dynamic var name : String = ""
     @objc dynamic var id : Int = 1
     @objc dynamic var child : MyChild = MyChild();
     @objc dynamic var child2 : MyChild?
     @objc dynamic var childList : [MyChild] = []
}
