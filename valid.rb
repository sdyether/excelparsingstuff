require 'spreadsheet'
require_relative 'erow'

ENCODING = 'UTF-8'
PATH = 'C:\dev\oowb-valid\validation.xls'
WORKSHEET_NAME = 'PP15.5 Clean'


### Helper Methods:

def row_malformed?(row)
	#assures prescense of id, condition, message, actuarial
	(0..3).each do |n|
		if row[n].nil?
			return true
		end
	end
	return false
end

def category_row?(row)
	return (row[0].length == 1)
end

class Enum
	def self.keys
		return constants
	end
	
	def self.values
		return @values ||= constants.map { |const| const_get(const) }
	end
end

class String
	#compress newlines, tabs, successive spaces, leading and trailing whitespace
	def format
		return self.gsub(/\n/," ").gsub(/\t/," ").squeeze(' ').strip
	end
	
	def format!
		replace(format)
	end
end

class Array
	def format
		self.each { |a| a.format! if a.respond_to? :format! }
	end
	
	def remove_ands_and_format
		self.each do |a|
			a.trim!
			 if a[0..2].equals "AND" or a[-1..-3].equals "AND"
				a.slice! "AND"
			end
			a.trim!
		end
	end
end

### Constants:

class Category < Enum
	MINIMUM_ENTRY_AGE = 'A'
	MAXMIUM_ENTRY_AGE = 'B'
	MAXIMUM_SUM_INSURED = 'C'
	OCCUPATIONS = 'D'
	BENEFIT_PERIOD = 'E'
	PARENT_CHILD = 'F'
	MAXIMUM_SUM_INSURED_OF_BENEFITS = 'G'
	PREMIUM_TYPE = 'I'
	LOADINGS = 'J'
	EXCLUSIVE_BENEFITS = 'K'
	MINIMUM_SUM_INSURED = 'L'
	MISCELLANEOUS = 'M'
end

class TokenConstants < Enum
	
	OCC_LETTER = ["Occ_Letter=", "Occ_Letter<>"]
end

class Parser

	SPLIT_ON = 'AND'
	
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

	end
	
	#break conditions down as we turn string array into token objects
	attr_accessor :conditions, :row
		
	def initialize(row)
		@row = row
		@conditions = row.conditions.format.split(SPLIT_ON).format
	end
	
	def print
		puts row.id
		puts conds
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
					@conditions.remove_ands_and_format
					return cond.downcase
				end
			end
		end
	end

end

class AgeParser < Parser

	class AgeParserException < ParserException
		def initialize(msg)
			super(msg)
		end
	end
	
	AGE = ["Age<", "Age>"]
	AGE_INT_REF = "dummy.age"

	class AgeToken < Token
		attr_accessor :operator, :age
		
		def initialize(operator = nil, age = nil)
			interface_reference = AGE_INT_REF
			@operator = operator
			@age = age
		end
	end

	def initialize(row)
		super(row)
	end
	
	def parse()
		if contains_token?(AGE)
			str = gulp_token
			str.slice! "age"
			str.trim!
			case str[0]
			tok = AgeToken.new
			when ">", "<"
				tok.operator = str[0]
			else
				raise AgeParserException.new('Unexpected operator for row: ' + @row.id) 
			end
			str.slice! 0
			str.trim!
			tok.age = Integer(str)
		else
			return false
		end
	end
end


#setup
Spreadsheet.client_encoding = ENCODING
book = Spreadsheet.open PATH
sheet = book.worksheet WORKSHEET_NAME

rows_to_process = []
erronous_rows = []
sheet.drop(1).each_with_index do |row, index | #ignore header row

	if row_malformed?(row)
		erronous_rows.push(index + 2)
		next
	end
	
	if category_row?(row) 
		next
	end

	rows_to_process.push(ERow.new(row[0], row[1], row[2], row[3] ))
end

p erronous_rows

#start processing rows
rows_to_process[5..7].each do |row|

	
	case row.get_category
	when Category::MINIMUM_ENTRY_AGE, Category::MAXMIUM_ENTRY_AGE
		puts row.id
		ap = AgeParser.new(row)
		ap.parse
		ap.print

	end
end





