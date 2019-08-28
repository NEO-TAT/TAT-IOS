platform :ios, '11.0'
inhibit_all_warnings!

def rx_swift
  pod 'RxSwift'
end

def rx_cocoa
  pod 'RxCocoa'
end

def swift_lint
  pod 'SwiftLint'
end

target 'TAT' do
  use_frameworks!
  swift_lint
  rx_swift
  rx_cocoa
end

target 'Domain' do
  use_frameworks!
  rx_swift
end

target 'NetworkPlatform' do
  use_frameworks!
  rx_swift
  pod 'Moya/RxSwift'
end
