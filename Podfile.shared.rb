platform :ios, "16.0"
use_frameworks!

def configure_post_install
	post_install do |installer|
	  installer.pods_project.targets.each do |target|
	    target.build_configurations.each do |config|
	      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
	    end
	  end
	  yield installer if block_given?
	end
end

@checksum = "dummy-checksum-to-prevent-merge-conflicts"
