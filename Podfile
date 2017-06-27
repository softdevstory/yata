# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'
platform :osx, '10.11'

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

  # UI
  pod 'SnapKit', '~> 3.2.0'

  # Etc
  pod 'Then'

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
