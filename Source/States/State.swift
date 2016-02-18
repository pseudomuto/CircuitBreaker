//
//  State.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

public protocol State {
  func type() -> StateType
  func invoke<T>(block: () throws -> T) throws -> T

  func activate()
  func onSuccess()
  func onError()
}

class BaseState: State {
  private static let acquireTimeout = 200 * NSEC_PER_MSEC
  private let semaphore = dispatch_semaphore_create(1)
  
  private(set) var breakerSwitch: Switch!
  private(set) var invoker: Invoker!
  
  internal init(_ breakerSwitch: Switch, invoker: Invoker) {
    self.breakerSwitch = breakerSwitch
    self.invoker       = invoker
  }
  
  func type() -> StateType {
    preconditionFailure("type() must be overridden")
  }
  
  func activate() {
    preconditionFailure("activate() must be overridden")
  }
  
  func onSuccess() {
    preconditionFailure("onSuccess() must be overridden")
  }
  
  func onError() {
    preconditionFailure("onError() must be overridden")
  }
  
  func invoke<T>(block: () throws -> T) throws -> T {
    preconditionFailure("invoke() must be overridden")
  }
  
  func synchronized<T>(block: () -> T) -> T {
    dispatch_semaphore_wait(semaphore, BaseState.acquireTimeout)
    defer { dispatch_semaphore_signal(semaphore) }
    
    return block()
  }
}
