# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'



target 'NYTimesAPI' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Moya'
  pod 'Dollar'
  pod 'ReactiveKit', :git => 'https://github.com/ReactiveKit/ReactiveKit.git', :branch => 'swift-4'
  pod 'Bond', :git => 'https://github.com/ahartwel/Bond.git', :branch => 'swift-4'
  pod 'SwiftLint'
  pod 'PromiseKit'
  pod 'SwiftyJSON'
  pod 'SnapKit'
  # Pods for NYTimesAPI

  target 'NYTimesAPITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'FBSnapshotTestCase'
  end

  target 'NYTimesAPIUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
      end
  end
  
end


