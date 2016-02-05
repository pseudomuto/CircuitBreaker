//
//  NSTimeInterval.swift
//  Pods
//
//  Created by David Muto on 2016-02-08.
//
//

extension NSTimeInterval {
  func dispatchTime(from: UInt64 = DISPATCH_TIME_NOW) -> dispatch_time_t {
    return dispatch_time(DISPATCH_TIME_NOW, Int64(self * Double(NSEC_PER_SEC)))
  }
}
