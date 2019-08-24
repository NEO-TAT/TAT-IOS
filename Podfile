platform :ios, '11.0'
inhibit_all_warnings!

def rx_swift
  pod 'RxSwift'
end

def rx_cocoa
  pod 'RxCocoa'
end


target 'TAT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  rx_cocoa

end

target 'Domain' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift

end

target 'NetworkPlatform' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  pod 'Moya/RxSwift'

end

