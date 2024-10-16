import Foundation

extension Double {
  func convert(from originalUnit: UnitLength, to convertedUnit: UnitLength) -> Double {
    return Measurement(value: self, unit: originalUnit).converted(to: convertedUnit).value
  }
}

func secondsToHoursMinutesSeconds(_ seconds: Int32) -> (hours: Int32, min: Int32, sec: Int32) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func createTimeLabel(hours: Int32, min: Int32, sec: Int32) -> String {
    let h = String(format: "%02d", hours);
    let m = String(format: "%02d", min);
    let s = String(format: "%02d", sec);
    
    let text = "\(h):\(m):\(s)";
    
    return text;
}

