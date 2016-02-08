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
	
	def get_category
		return id[0].upcase
	end

end