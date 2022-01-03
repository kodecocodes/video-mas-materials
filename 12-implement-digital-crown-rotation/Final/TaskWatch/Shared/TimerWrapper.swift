/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Combine

class TimerWrapper: ObservableObject {
  
  enum Direction {
    case up
    case down
  }
  
  enum RunningState {
    case running
    case paused
    case stopped
  }
  
  private let timeInterval: TimeInterval
  var totalTime: TimeInterval {
    didSet {
      timeRemaining = totalTime
    }
  }
  private let direction: TimerWrapper.Direction
  private var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
  private var cancellables: Set<AnyCancellable> = []
  
  @Published
  var timeRemaining: TimeInterval
  
  @Published
  var timeElapsed: TimeInterval = 0
  
  @Published
  var runningState: RunningState = .stopped
  
  init(totalTime: TimeInterval = 60,
       timeInterval: TimeInterval = 1,
       direction: TimerWrapper.Direction = .down
  ) {
    self.totalTime = totalTime
    self.timeRemaining = totalTime
    self.timeInterval = timeInterval
    self.direction = direction
    
    setUp()
  }
  
  func setUp() {
    $timeElapsed
      .map { [unowned self] t -> TimeInterval in
        switch direction {
        case .down:
          let timeDifference = totalTime - t
          return timeDifference > 0 ? timeDifference : 0
        case .up:
          return t
        }
      }
      .handleEvents(receiveOutput: { [unowned self] time in
        if time == 0 && direction == .down {
          cancel()
        }
      })
      .assign(to: &$timeRemaining)
  }
  
  func start() {
    timerPublisher
      .assign(to: &$timeElapsed)
    runningState = .running
  }
  
  func pause() {
    timer?.upstream.connect().cancel()
    cancellables.removeAll()
    runningState = .paused
  }
  
  func cancel() {
    timer?.upstream.connect().cancel()
    timeElapsed = 0
    timer = nil
    timeRemaining = totalTime
    cancellables.removeAll()
    runningState = .stopped
  }
  
  private var timerPublisher: AnyPublisher<TimeInterval, Never> {
    timer = Timer.publish(every: timeInterval, on: .main, in: .default).autoconnect()
    return timer!
      .scan(timeElapsed) { [unowned self] accumulated, _ in
        accumulated + timeInterval
      }.eraseToAnyPublisher()
  }
}
