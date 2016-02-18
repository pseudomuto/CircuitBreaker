//
//  ClosedState.swift
//  Pods
//
//  Created by David Muto on 2016-02-05.
//
//

class ClosedState: BaseState {
  let errorThreshold: Int
  let invocationTimeout: NSTimeInterval
  
  private(set) var failures: Int
  
  init(_ breakerSwitch: Switch, invoker: Invoker, errorThreshold: Int, invocationTimeout: NSTimeInterval) {
    self.errorThreshold    = errorThreshold
    self.invocationTimeout = invocationTimeout
    self.failures          = 0
    
    super.init(breakerSwitch, invoker: invoker)
  }
  
  override func type() -> StateType {
    return .Closed
  }
  
  override func activate() {
    synchronized {
      self.failures = 0
    }
  }
  
  override func onSuccess() {
    activate()
  }
  
  override func onError() {
    synchronized {
      self.failures++
      
      if self.failures == self.errorThreshold {
        self.breakerSwitch.trip(self)
      }
    }
  }
  
  override func invoke<T>(block: () throws -> T) throws -> T {
    return try invoker.invoke(self, timeout: invocationTimeout, block: block)
  }
}
