//
//  OpenState.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

class OpenState: BaseState {
  private var timer: NSTimer!

  override func type() -> StateType {
    return .Open
  }

  override func activate() {
    timer = NSTimer(timeInterval: 2, target: self, selector: Selector("halfOpen"), userInfo: nil, repeats: false)
  }

  override func onSuccess() {

  }

  override func onError() {

  }

  override func invoke<T>(block: () -> T) throws -> T {
    throw Error.OpenCircuit
  }

  private func halfOpen() {
    breakerSwitch.attempt(self)

    Sync.lock(self) {
      self.timer.invalidate()
    }
  }
}
