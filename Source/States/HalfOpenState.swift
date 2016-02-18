//
//  HalfOpenState.swift
//  Pods
//
//  Created by David Muto on 2016-02-05.
//
//

class HalfOpenState: BaseState {
  let successThreshold: Int
  let invocationTimeout: NSTimeInterval
  
  private(set) var successes: Int
  private var running: Int32 = 0
  
  init(_ breakerSwitch: Switch, invoker: Invoker, successThreshold: Int, invocationTimeout: NSTimeInterval) {
    self.successThreshold  = successThreshold
    self.invocationTimeout = invocationTimeout
    self.successes         = 0
    
    super.init(breakerSwitch, invoker: invoker)
  }
  
  override func type() -> StateType {
    return .HalfOpen
  }
  
  override func activate() {
    synchronized {
      self.running   = 0
      self.successes = 0
    }
  }
  
  override func onSuccess() {
    synchronized {
      self.running = 0
      self.successes++
      
      if self.successes == self.successThreshold {
        self.breakerSwitch.reset(self)
      }
    }
  }
  
  override func onError() {
    breakerSwitch.trip(self)
  }
  
  override func invoke<T>(block: () throws -> T) throws -> T {
    if OSAtomicCompareAndSwap32(0, 1, &running) {
      return try invoker.invoke(self, timeout: invocationTimeout, block: block)
    }

    throw Error.OpenCircuit
  }
}
