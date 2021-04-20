//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on April 19, 2021

import Foundation
import SwiftyJSON

class XyoBoundWitnessBodyJson : NSObject, NSCoding{

    var addresses : [String] = []
    var hashes : [String?] = []
    var payload : Any!

  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init(fromJson json: JSON!){
    if json.isEmpty{
      return
    }
        addresses = [String]()
        let addressesArray = json["addresses"].arrayValue
        for addressesJson in addressesArray{
            addresses.append(addressesJson.stringValue)
        }
        hashes = [String]()
        let hashesArray = json["hashes"].arrayValue
        for hashesJson in hashesArray{
            hashes.append(hashesJson.stringValue)
        }
        let payloadJson = json["payload"]
        if !payloadJson.isEmpty{
          payload = payloadJson
        }
  }

  /**
   * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
   */
  func toDictionary() -> [String:Any]
  {
    var dictionary = [String:Any]()
        dictionary["addresses"] = addresses
        dictionary["hashes"] = hashes
        if payload != nil{
          dictionary["payload"] = payload
        }
    return dictionary
  }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
  {
    addresses = aDecoder.decodeObject(forKey: "addresses") as! [String]
    hashes = aDecoder.decodeObject(forKey: "hashes") as! [String]
    payload = aDecoder.decodeObject(forKey: "payload")
  }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
  {
    aCoder.encode(addresses, forKey: "addresses")
    aCoder.encode(hashes, forKey: "hashes")
    if payload != nil{
      aCoder.encode(payload, forKey: "payload")
    }

  }

}
