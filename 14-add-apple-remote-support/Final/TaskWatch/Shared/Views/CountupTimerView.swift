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

import SwiftUI

struct CountupTimerView: View {
  
  let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter
  }()
  
  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.maximumIntegerDigits  = 0
    formatter.alwaysShowsDecimalSeparator = true
    return formatter
  }()
  
  @ObservedObject var timer: TimerWrapper
  
  var body: some View {
    VStack {
      Text(String(formatter.string(from: timer.timeRemaining)! + numberFormatter.string(from: NSNumber(value: (timer.timeRemaining.truncatingRemainder(dividingBy: 1))))!))
        .font(.system(size: 72).monospacedDigit())
      
      HStack {
        if timer.runningState == .stopped {
          Button("Start") {
            start()
          }
          #if !os(tvOS)
          .buttonStyle(CircleButtonStyle(bgColor: Color.green))
          .keyboardShortcut("l")
          #endif
        } else if timer.runningState == .paused {
          Button("Resume") {
            start()
          }
          #if !os(tvOS)
          .buttonStyle(CircleButtonStyle(bgColor: Color.green))
          .keyboardShortcut("r")
          #endif
        } else if timer.runningState == .running {
          Button("Pause") {
            pause()
          }
          #if !os(tvOS)
          .buttonStyle(CircleButtonStyle(bgColor: Color.yellow))
          .keyboardShortcut("k")
          #endif
        }
        
        Spacer()
        
        Button("Cancel") {
          stop()
        }
        #if !os(tvOS)
        .buttonStyle(CircleButtonStyle(bgColor: Color.gray))
        .keyboardShortcut("c")
        #endif
      }.padding()
      Spacer()
    }
#if os(tvOS)
    .focusable()
    .onPlayPauseCommand(perform: {
      if timer.runningState == .stopped ||
          timer.runningState == .paused {
        start()
      } else {
        pause()
      }
    })
#endif
  }
  
}

extension CountupTimerView {
  
  func start() {
    timer.start()
  }
  
  func pause() {
    timer.pause()
  }
  
  func stop() {
    timer.cancel()
  }
  
}


struct CountupTimerView_Previews: PreviewProvider {
  static var previews: some View {
    CountupTimerView(
      timer: TimerWrapper(totalTime: 0,
                          timeInterval: 0.01,
                          direction: .up)
    )
  }
}
