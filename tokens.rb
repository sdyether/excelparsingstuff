require_relative 'parser_exception'

class Token
	attr_accessor :interface_reference

	def initialize(ref = nil)
		@interface_reference = ref
	end
end

class BenefitToken < Token
	attr_accessor :name
end

class PremiumToken < Token
	attr_accessor :operator, :name
end

class OccToken < Token
	attr_accessor :operator
	attr_reader :letters
	
	VALID_OCC_LETTERS = ["AAA", "AA", "A", "B", "C", "D", "E", "HD"]
	
	def initialize(operator = nil, letters = [])
		super(TokenConstants::OCC_INT_REF)
		@operator = operator
		@letters = letters
	end
	
	def letters=(letters)
		letters.each do |l| 
			if not VALID_OCC_LETTERS.include?(l) then raise ParserException.new "Invalid Occupation letter" end 
		end
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