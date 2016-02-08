require_relative 'tokens'

class Parser
	
	class ParserException < StandardError
		def initialize(msg)
			@message = msg
		end
		
		def message
			return @message
		end
	end
	
	
	
	#break conditions down as we turn string array into token objects
	attr_accessor :conditions, :row, :tokens
		
	def initialize(row)
		@row = row
		@conditions = row.condition
		TokenConstants::INITIAL_CLEANUP.each { |key, value| @conditions = @conditions.gsub(key, value).strip }
		@tokens = []
	end
	
	def parse_age
		if not conditions.match(TokenConstants::AGE_REGEX)
			return false
		end

		str = gulp_token(TokenConstants::AGE_REGEX)
		
		if str[/(\(\w*\))/] then return false end #don't support Age(benefit)<x
		
		tok = AgeToken.new
		tok.operator = str[/<|>/]
		tok.age = Integer(str[/\d+/])
		
		tokens.push tok
	end

	def parse_occ
		if conditions.match(TokenConstants::OCC_REGEX)
			str = gulp_token(TokenConstants::OCC_REGEX)
		elsif conditions.match(TokenConstants::OCC_TPD_REGEX)
			str = gulp_token(TokenConstants::OCC_TPD_REGEX)
		else
			return false
		end

		tok = OccToken.new
		tok.operator = str[/(=|<>)/]
		#how to get letters???
		tokens.push tok
	end
	
	def print
		puts row.id
		puts conditions
		p tokens
		puts
	end

	#remove and return
	def gulp_token(regex)
		str = conditions[regex]
		conditions.gsub(regex, " ")
		return str
	end

end