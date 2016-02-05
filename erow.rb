class ERow
	attr_accessor :id, :condition, :message, :actuarial_validation
		
	def initialize(id, condition, message, actuarial_validation)
		@id = id
		@condition = condition
		@message = message
		@actuarial_validation = actuarial_validation
	end
	
	def print
		puts id, condition, message, actuarial_validation, "\n"
	end
	
	def pretty_print
		puts id.format, condition.format, message.format, actuarial_validation.format.capitalize, "\n"
	end
	
	def to_s
		return id.format + " | " + condition.format + " | " + message.format[0..50].gsub(/\s\w+$/,'...') + " | " + actuarial_validation.format.capitalize
	end
	
	def get_category
		return id[0].upcase
	end

end