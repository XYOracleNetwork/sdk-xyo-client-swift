//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on April 19, 2021

import Foundation
import SwiftyJSON


class XyoBoundWitnessMetaJson : NSObject, NSCoding{

    var _hash : String!
    var _signatures : [String]!

  /**
   * Instantiate the instance using the passed json values to set the properties values
   */
  init(fromJson json: JSON!){
    if json.isEmpty{
      return
    }
        _hash = json["_hash"].stringValue
        _signatures = [String]()
        let signaturesArray = json["_signatures"].arrayValue
        for signaturesJson in signaturesArray{
            _signatures.append(signaturesJson.stringValue)
        }
  }

  /**
   * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
   */
  func toDictionary() -> [String:Any]
  {
    var dictionary = [String:Any]()
        if _hash != nil{
          dictionary["_hash"] = hash
        }
        if _signatures != nil{
          dictionary["_signatures"] = _signatures
        }
    return dictionary
  }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
  {
    _hash = aDecoder.decodeObject(forKey: "_hash") as? String
    _signatures = aDecoder.decodeObject(forKey: "_signatures") as? [String]
  }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
  {
    if _hash != nil{
      aCoder.encode(hash, forKey: "_hash")
    }
    if _signatures != nil{
      aCoder.encode(_signatures, forKey: "_signatures")
    }

  }

}
