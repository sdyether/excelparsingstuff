require 'spreadsheet'
require_relative 'erow'
require_relative 'parser'
require_relative 'validator'

### Helper Methods:

class Enum
	def self.keys
		return constants
	end
	
	def self.values
		return @values ||= constants.map { |const| const_get(const) }
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

	INITIAL_CLEANUP = { 
	/\n/ => " ", 				#newlines
	/\t/ => " ",				#tabs
	/\s{2,}/ => " ",			#successive spaces
	/&/ => ",",					#ampersand in occ code lists
	/\s+and\s+/i => " ",		#condition delimiter
	/home duties/i => "HD" }	#stray occ code

	AGE_BENEFIT_REGEX = /(\A|\s)Age\s*(\(\w*\))+(<|>)\s*\d+/i
	AGE_REGEX = /(\A|\s)Age\s*(<|>)\s*\d+/i
	AGE_INT_REF = "dummy.age.ref"
	
	OCC_TPD_REGEX = /Occ_TPDLetter\s*(=|<>)\s*[A-Z]+\s*(,\s*[A-Z]+\s*)*(or\s*[A-Z]+\s*)*/i
	OCC_REGEX = /Occ_Letter\s*(=|<>)\s*[A-Z]+\s*(,\s*[A-Z]+\s*)*(or\s*[A-Z]+\s*)*/i
	OCC_INT_REF = "dummy.occ.letter"
end

class Tests

	def self.test_age_parser
		v = Validator.new
		v.rows.each do |row|
			p = AgeParser.new(row)
			if p.conditions[/\sAge/i] and not p.parse then printfail(p) end
		end
	end

	def self.test_occ
		v = Validator.new
		v.rows.each do |row|
			p = OccParser.new(row)
			if p.conditions[/occ.*letter/i] and not p.parse then printfail(p) end
		end
	end

	def self.test_and_split
		v = Validator.new
		v.rows.each do |row|
			p = Parser.new(row)
			if p.conditions[/and/i] then printfail(p) end
		end
	end
	
	def run_all_tests
		test_occ
		test_and_split
		test_age_parser
	end
	
	def self.printfail(parser)
		print "Error parsing: (" + caller_locations(1,1)[0].label + ")\n" + parser.row.id + "\n" +  parser.conditions + "\n\n" 
	end

end

#Tests.run_all_tests

v = Validator.new
parsers = []
v.rows.each do |row|

	p = Parser.new(row)
	p.parse_age
	p.parse_occ
	#p.print
	
	
	#case row.get_category
	#when Category::MINIMUM_ENTRY_AGE, Category::MAXMIUM_ENTRY_AGE

		
	parsers.push p	

end

parsers.each { |x| puts x.row.id + " " + x.conditions }






