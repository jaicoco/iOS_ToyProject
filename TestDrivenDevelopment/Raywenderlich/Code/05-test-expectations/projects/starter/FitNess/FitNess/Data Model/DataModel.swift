/// Copyright (c) 2019 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class DataModel {

  // MARK: - Alerts
  var sentAlerts: [Alert] = []
  
  // MARK: - Goal Calculation
  var goal: Int?
  var steps: Int = 0 {
    didSet {
      updateForSteps()
    }
  }

  var goalReached: Bool {
    if let goal = goal,
      steps >= goal, !caught {
        return true
    }
    return false
  }

  // MARK: - Nessie
  let nessie = Nessie()
  var distance: Double = 0

  var caught: Bool {
    return distance > 0 && nessie.distance >= distance
  }

  // MARK: - Lifecycle
  func restart() {
    goal = nil
    steps = 0
    distance = 0
    nessie.distance = 0
    sentAlerts.removeAll()
  }
  
  private func checkThreshold(percent: Double, alert: Alert) {
    guard !sentAlerts.contains(alert),
          let goal = goal else { return }
    if Double(steps) >= Double(goal) * percent {
      AlertCenter.instance.postAlert(alert: alert)
      sentAlerts.append(alert)
    }
  }
  
  func updateForSteps() {
    checkThreshold(percent: 0.25, alert: .milestone25Percent)
    checkThreshold(percent: 0.50, alert: .milestone50Percent)
    checkThreshold(percent: 0.75, alert: .milestone75Percent)
    checkThreshold(percent: 1.00, alert: .goalComplete)
  }
}
