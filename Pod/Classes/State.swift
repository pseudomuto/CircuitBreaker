//
//  State.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

public enum StateType {
  case Closed
  case Open
  case HalfOpen
}

public enum Error: ErrorType {
  case OpenCircuit
}

public protocol State {
  func type() -> StateType
  func invoke<T>(block: () -> T) throws -> T
  
  func activate()
  func onSuccess()
  func onError()
}

class BaseState: State {
  private(set) var breakerSwitch: Switch!
  
  internal init(breakerSwitch: Switch) {
    self.breakerSwitch = breakerSwitch
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
  
  func invoke<T>(block: () -> T) throws -> T {
    preconditionFailure("invoke() must be overridden")
  }
}
