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
		if not conditions.match(TokenConstants::AGE_REGEX)
			return false
		end
		
		str = gulp_token(TokenConstants::AGE_REGEX)

		tok = AgeToken.new
		tok.operator = str[/\<|\>/]
		tok.age = Integer(str[/\d+/])
		
		tokens.push tok
	end
end