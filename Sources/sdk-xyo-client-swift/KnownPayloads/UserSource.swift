import Foundation

protocol XyoSentinelPayload {
  let uid:String
  let device_id:String
  let ad_id:String
  let days_old:Int
  let geomines:Int
  let plan:String
  let os:String
  let device:String
  let latitude:Double
  let longitude:Double
  let quadkey:String
}
