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
  
  public var invocationTimeout = 1000 {
    willSet(newTimeout) { Assert.nonNegative(newTimeout) }
  }
  
  public var resetTimeout = 3000 {
    willSet(newTimeout) { Assert.nonNegative(newTimeout) }
  }
  
  public init() {
  }
  
  public init(errorThreshold: Int, successThreshold: Int, invocationTimeout: Int, resetTimeout: Int) {
    self.errorThreshold    = errorThreshold
    self.successThreshold  = successThreshold
    self.invocationTimeout = invocationTimeout
    self.resetTimeout      = resetTimeout
  }
}