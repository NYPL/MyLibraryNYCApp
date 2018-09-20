module LogWrapper 

	# Wrapper module server's as a wrapper to 
	# add output to the log file. 
	# The method log take's in 2 parameters.
	# A string passed in as level and a hash
	# passed in as message. Please look at 
	# examples from the user.rb model. 

	def self.log(level,message)

	severity_levels = 
	    {
		'DEBUG' => 0,
		'INFO' => 1,
		'WARN' => 2,
		'ERROR' => 3,
		'FATAL' => 4,
		'UNKNOWN' => 5 
	   }

	message['timestamp'] = Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
	message['level'] = level

	Rails.logger.add(severity_levels['level'],message.to_json)

	end 

end 