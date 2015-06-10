platform :ios , '8.2'
#use_frameworks!

target 'Headlines' do
	pod 'MWFeedParser', '~> 1.0.1'
	pod 'DZReadability', '~> 0.2.2'
	pod 'HTMLReader', '~> 0.7.1'
	pod 'AutoCoding', '~> 2.2.1'
	pod 'REKit', '~> 1.0.2'
    pod 'AFNetworking', '~> 2.5.4'
end

target 'HeadlinesTests' do

end

target 'Headlines WatchKit Extension' do
	pod 'MWFeedParser', '~> 1.0.1'
	pod 'AutoCoding', '~> 2.2.1'
	pod 'REKit', '~> 1.0.2'
	pod 'HTMLReader', '~> 0.7.1'
    pod 'AFNetworking', '~> 2.5.4'
end

target 'Headlines WatchKit App' do

end

post_install do |add_app_extension_macro|
    add_app_extension_macro.project.targets.each do |target|
        if target.name.include?("Headlines WatchKit Extension")
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'AF_APP_EXTENSIONS=1']
            end
        end
    end
end