# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'
platform :osx, '10.10'

target 'yata' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Model
  pod 'ObjectMapper'

  # Rx
  pod 'RxSwift'

  # Network
  pod 'Alamofire'
  pod 'Moya/RxSwift'

  target 'yataTests' do
    inherit! :search_paths

    pod 'ObjectMapper'
    pod 'Alamofire'
    pod 'Moya/RxSwift'

    pod 'RxSwift'
    pod 'RxTest'
    pod 'RxBlocking'
  end
end
