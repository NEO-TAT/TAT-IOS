platform :ios, '11.0'
inhibit_all_warnings!

def rx_swift
  pod 'RxSwift'
  pod 'NSObject+Rx'
end

def rx_cocoa
  pod 'RxCocoa'
end

def swift_lint
  pod 'SwiftLint'
end

def ui
  pod 'Dropdowns'
  pod 'SnapKit', '~> 5.0.0'
end

target 'TAT' do
  use_frameworks!
  swift_lint
  rx_swift
  rx_cocoa
  ui
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
