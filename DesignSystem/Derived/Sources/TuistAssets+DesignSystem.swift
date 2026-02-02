// swiftlint:disable:this file_name
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum DesignSystemAsset: Sendable {
  public enum Chromatic {
  public static let blue100 = DesignSystemColors(name: "blue100")
    public static let green100 = DesignSystemColors(name: "green100")
    public static let green200 = DesignSystemColors(name: "green200")
    public static let red100 = DesignSystemColors(name: "red100")
  }
  public enum Color {
  public static let black = DesignSystemColors(name: "black")
  }
  public enum Gray {
  public static let gray0 = DesignSystemColors(name: "gray0")
    public static let gray100 = DesignSystemColors(name: "gray100")
    public static let gray1000 = DesignSystemColors(name: "gray1000")
    public static let gray200 = DesignSystemColors(name: "gray200")
    public static let gray300 = DesignSystemColors(name: "gray300")
    public static let gray400 = DesignSystemColors(name: "gray400")
    public static let gray50 = DesignSystemColors(name: "gray50")
    public static let gray500 = DesignSystemColors(name: "gray500")
    public static let gray600 = DesignSystemColors(name: "gray600")
    public static let gray700 = DesignSystemColors(name: "gray700")
    public static let gray800 = DesignSystemColors(name: "gray800")
    public static let gray900 = DesignSystemColors(name: "gray900")
  }
  public enum Icon {
  public static let camera = DesignSystemImages(name: "camera")
    public static let check = DesignSystemImages(name: "check")
    public static let close = DesignSystemImages(name: "close")
    public static let completed = DesignSystemImages(name: "completed")
    public static let `left` = DesignSystemImages(name: "left")
    public static let my = DesignSystemImages(name: "my")
    public static let notification = DesignSystemImages(name: "notification")
    public static let notificationFill = DesignSystemImages(name: "notification_fill")
    public static let plus = DesignSystemImages(name: "plus")
    public static let product = DesignSystemImages(name: "product")
    public static let `right` = DesignSystemImages(name: "right")
    public static let vote = DesignSystemImages(name: "vote")
    public static let voteCheck = DesignSystemImages(name: "vote_check")
    public static let won = DesignSystemImages(name: "won")
  }
  public enum Image {
  public static let loginBackground = DesignSystemImages(name: "login_background")
    public static let logo = DesignSystemImages(name: "logo")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class DesignSystemColors: Sendable {
  public let name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
  public var color: Color {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
  public var swiftUIColor: SwiftUI.Color {
      return SwiftUI.Color(asset: self)
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension DesignSystemColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
  convenience init?(asset: DesignSystemColors) {
    let bundle = Bundle.module
    #if os(iOS) || os(tvOS) || os(visionOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
public extension SwiftUI.Color {
  init(asset: DesignSystemColors) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct DesignSystemImages: Sendable {
  public let name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = Bundle.module
    #if os(iOS) || os(tvOS) || os(visionOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
public extension SwiftUI.Image {
  init(asset: DesignSystemImages) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }

  init(asset: DesignSystemImages, label: Text) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: DesignSystemImages) {
    let bundle = Bundle.module
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
