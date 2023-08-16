# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'iOSTemplate' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod "RxSwift"
  pod "RxCocoa"
  pod "Alamofire"
  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'Parchment', '~> 3.2'  # Pods for iOSTemplate
  pod 'Kingfisher'
  
  target 'iOSTemplateTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'iOSTemplateUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
      end
    end
  end

end
