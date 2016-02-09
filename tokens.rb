class Token
	attr_accessor :interface_reference

	def initialize(ref = nil)
		@interface_reference = ref
	end
end

class OccToken < Token
	attr_accessor :operator, :letters
	
	VALID_OCC_LETTERS = ["AAA", "AA", "A", "B", "C", "D", "E", "HD"]
	
	def initialize(operator = nil, letters = [])
		super(TokenConstants::OCC_INT_REF)
		@operator = operator
		letters.each { |l| if not VALID_OCC_LETTERS.contains?(l) then raise "Invalid Occupation letter" end }
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