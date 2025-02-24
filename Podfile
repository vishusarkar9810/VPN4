# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
def shared_pods
  use_frameworks!
  pod 'OpenVPNAdapter', :git => 'https://github.com/ss-abramchuk/OpenVPNAdapter.git', :tag => '0.8.0'
end
target 'VPN' do
  shared_pods
  # Pods for VPN
   pod 'Alamofire', '5.4.3'
   pod 'ReachabilitySwift'
   pod 'SDWebImage'
   pod 'ObjectMapper'
   pod 'DZNEmptyDataSet'
   pod 'TPKeyboardAvoiding'
   pod 'CocoaLumberjack/Swift'
   pod 'SwiftyJSON'
   pod 'PINCache'
   pod 'DifferenceKit'
   pod 'Toast-Swift'
   pod 'MBProgressHUD'
   pod 'NDT7'
   pod 'SwiftyStoreKit'
   pod 'Google-Mobile-Ads-SDK', '~> 11.3.0'
   pod 'lottie-ios','~> 4.2.0'
   pod 'Firebase/Analytics'
end

target 'PacketTunnelProvider' do
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
  end
end
