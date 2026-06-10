import Foundation

public enum MotionCuesActivator {
  /// Ask launchd to restart the agent that renders on-screen motion cue dots.
  public static func restartVisualsAgent() {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
    process.arguments = ["AccessibilityVisualsAgent"]
    process.standardOutput = FileHandle.nullDevice
    process.standardError = FileHandle.nullDevice
    try? process.run()
    process.waitUntilExit()
  }
}
