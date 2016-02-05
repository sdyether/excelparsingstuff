require_relative 'parser'

class AgeParser < Parser

	attr_accessor :token
	
	def initialize(row)
		super(row)
	end
	
	class AgeParserException < ParserException; end
	
	class AgeToken < Token
		attr_accessor :operator, :age
		
		def initialize(operator = nil, age = nil)
			super(TokenConstants::AGE_INT_REF)
			@operator = operator
			@age = age
		end
		
	end

	def parse

	
		if contains_token?(TokenConstants::AGE_TOKENS)
			str = gulp_token(TokenConstants::AGE_TOKENS)
			str.slice! "age"
			str.strip!
			tok = AgeToken.new
			case str[0]
			when ">", "<"
				tok.operator = str[0]
			else
				raise AgeParserException.new('Unexpected operator for row: ' + @row.id) 
			end
			str.slice! 0
			str.strip!
			tok.age = Integer(str)
			tokens.push tok
		else
			return false
		end
	end
end