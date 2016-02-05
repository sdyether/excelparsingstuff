class Parser
	
	class ParserException < StandardError
		def initialize(msg)
			@message = msg
		end
		
		def message
			return @message
		end
	end
	
	class Token
		attr_accessor :interface_reference

		def initialize(ref = nil)
			@interface_reference = ref
		end
	end
	
	#break conditions down as we turn string array into token objects
	attr_accessor :conditions, :row, :tokens
		
	def initialize(row)
		@row = row
		@conditions = row.condition.format
		TOP_LEVEL_SPLITTERS.each { |s| if @conditions.include? s then  @conditions = @conditions.split(s).format end }
		@tokens = []
	end
	
	def print
		puts row.id
		puts conditions
		p tokens
		puts
	end
	
	def contains_token?(token_struct)
		@conditions.each do |cond|
			token_struct.each do |token|
				if cond.downcase.include? token.downcase
					return true
				end
			end
		end
		
		return false
	end
	
	#remove and return
	def gulp_token(token_struct)
		@conditions.each do |cond|
			token_struct.each do |token|
				if cond.downcase.include? token.downcase
					#delete token, leftover AND, and return string token
					@conditions.delete cond
					@conditions.format
					return cond.downcase
				end
			end
		end
	end

end