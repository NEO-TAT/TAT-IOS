platform :ios, '11.0'
inhibit_all_warnings!

def rx_swift
  pod 'RxSwift'
end

def rx_cocoa
  pod 'RxCocoa'
end

def rx_ns_object
  pod 'NSObject+Rx'
end


target 'TAT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  rx_cocoa
  rx_ns_object

end

target 'Domain' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  rx_ns_object

end

target 'NetworkPlatform' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  rx_ns_object
  pod 'Moya/RxSwift'

end

