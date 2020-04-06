require 'ldclient-rb'

class LaunchDarklyController

	def get_feature_flag(feature_flag, current_user)
		ld_client = LaunchDarkly::LDClient.new(ENV['SDK_KEY'])
		show_feature = ld_client.variation(feature_flag, {key: current_user.email}, false) 
		show_feature
	end
end