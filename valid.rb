require 'spreadsheet'
require_relative 'erow'
require_relative 'age_parser'
require_relative 'validator'

# Globals

TOP_LEVEL_SPLITTERS = ["AND", "And"] 

### Helper Methods:

class Enum
	def self.keys
		return constants
	end
	
	def self.values
		return @values ||= constants.map { |const| const_get(const) }
	end
end

class String
	#compress newlines, tabs, successive spaces, leading and trailing whitespace/ANDS
	def format
		str = self.gsub(/\n/," ").gsub(/\t/," ").squeeze(" ").strip
		TOP_LEVEL_SPLITTERS.each do |splitter| 
			if str.start_with? splitter or str.end_with? splitter
				str.slice! splitter
			end
		end
		return str.strip
	end
	
	def format!
		replace(format)
	end
end

class Array
	def format
		self.each { |a| a.format! if a.respond_to? :format! }
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
	AGE_REGEX = /Age\s*(\<|\>)\s*\d+/i
	AGE_INT_REF = "dummy.age.ref"
	
	#todo monday - move these into constants class, do occ letter regex
	OCC_REGEX = ["Occ_Letter=", "Occ_Letter<>"]
	OCC_LETTER_INT_REF = "dummy.occ.letter"
end



v = Validator.new

epic_fails = []
#start processing rows
v.rows.each do |row|
	
	case row.get_category
	when Category::MINIMUM_ENTRY_AGE, Category::MAXMIUM_ENTRY_AGE
		ap = AgeParser.new(row)
		if not ap.parse
			epic_fails.push(row.id)
		end
	end
end

p epic_fails




