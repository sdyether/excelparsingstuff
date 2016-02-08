class Token
	attr_accessor :interface_reference

	def initialize(ref = nil)
		@interface_reference = ref
	end
end

class OccToken < Token
	attr_accessor :operator, :letters
	
	def initialize(operator = nil, letters = [])
		super(TokenConstants::OCC_INT_REF)
		@operator = operator
		@letters = letters
	end
	
end

class AgeToken < Token
	attr_accessor :operator, :age
	
	def initialize(operator = nil, age = nil)
		super(TokenConstants::AGE_INT_REF)
		@operator = operator
		@age = age
	end
	
end