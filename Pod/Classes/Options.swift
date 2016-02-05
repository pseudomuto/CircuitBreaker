//
//  Options.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

public struct Options {
  
  public var errorThreshold = 2 {
    willSet(newThreshold) { Assert.positive(newThreshold) }
  }
  
  public var successThreshold = 2 {
    willSet(newThreshold) { Assert.positive(newThreshold) }
  }
  
  public var invocationTimeout: NSTimeInterval = 1.0
  
  public var resetTimeout: NSTimeInterval = 3.0
  
  public init() {
  }
  
  public init(errorThreshold: Int, successThreshold: Int, invocationTimeout: NSTimeInterval, resetTimeout: NSTimeInterval) {
    self.errorThreshold    = errorThreshold
    self.successThreshold  = successThreshold
    self.invocationTimeout = invocationTimeout
    self.resetTimeout      = resetTimeout
  }
}