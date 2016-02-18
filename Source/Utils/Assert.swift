//
//  Assert.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

class Assert {
  class func positive(value: Int) {
    assert(value > 0, "value must be greater than zero")
  }
  
  class func nonNegative(value: Int) {
    assert(value >= 0, "value must be non-negative")
  }
}