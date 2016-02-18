//
//  OpenState.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

class OpenState: BaseState {
  private var timer: NSTimer?
  
  private(set) var scheduled: Bool = false
  private(set) var resetTimeout: NSTimeInterval
  
  init(_ breakerSwitch: Switch, invoker: Invoker, resetTimeout: NSTimeInterval) {
    self.resetTimeout = resetTimeout
    super.init(breakerSwitch, invoker: invoker)
  }
  
  override func type() -> StateType {
    return .Open
  }
  
  override func activate() {
    synchronized {
      self.timer = NSTimer.scheduledTimerWithTimeInterval(
        self.resetTimeout,
        target: self,
        selector: Selector("halfOpen:"),
        userInfo: nil,
        repeats: false
      )
      
      self.scheduled = true
    }
  }
  
  override func onSuccess() {
    
  }
  
  override func onError() {
    
  }
  
  override func invoke<T>(block: () throws -> T) throws -> T {
    throw Error.OpenCircuit
  }
  
  @objc func halfOpen(timer: NSTimer) {
    timer.invalidate()
    
    synchronized {
      self.scheduled = false
      self.breakerSwitch.attempt(self)
    }
  }
}
