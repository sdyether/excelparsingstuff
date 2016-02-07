require_relative 'parser'

class OccParser < Parser

	attr_accessor :token
	
	def initialize(row)
		super(row)
	end
	
	class OccParserException < ParserException; end
	
	class OccToken < Token
		attr_accessor :operator, :letters
		
		def initialize(operator = nil, letters = [])
			super(TokenConstants::OCC_INT_REF)
			@operator = operator
			@letters = letters
		end
		
	end

	def parse
		if not conditions.match(TokenConstants::OCC_REGEX)
			return false
		end
		
		str = gulp_token(TokenConstants::OCC_REGEX)

		tok = AgeToken.new
		tok.operator = str[/\<|\>/]
		tok.age = Integer(str[/\d+/])
		
		tokens.push tok
	end
end