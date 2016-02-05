require 'spreadsheet'
require_relative 'erow'
require_relative 'age_parser'

# Globals

ENCODING = 'UTF-8'
PATH = 'C:\dev\oowb-valid\velma.xls'
WORKSHEET_NAME = 'PP15.5 Clean'
TOP_LEVEL_SPLITTERS = ["AND", "And"] 

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
	#compress newlines, tabs, successive spaces, leading and trailing whitespace/ANDS
	def format
		str = self.gsub(/\n/," ").gsub(/\t/," ").squeeze(' ').strip
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
	AGE_REGEX = /Age\s*(\<|\>)/i
	AGE_INT_REF = "dummy.age.ref"
	
	OCC_LETTER_TOKENS = ["Occ_Letter=", "Occ_Letter<>"]
	OCC_LETTER_INT_REF = "dummy.occ.letter"
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
epic_fails = []
#start processing rows
rows_to_process.each do |row|
	
	case row.get_category
	when Category::MINIMUM_ENTRY_AGE, Category::MAXMIUM_ENTRY_AGE
		ap = AgeParser.new(row)
		if not ap.parse
			epic_fails.push(row.id)
		end
	end
end

p epic_fails




