class ParserException < StandardError
	def initialize(msg)
		@message = msg
	end
	
	def message
		return @message
	end
end