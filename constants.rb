### Constants:

class Enum
	def self.keys
		return constants
	end
	
	def self.values
		return @values ||= constants.map { |const| const_get(const) }
	end
end

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
	
	SINGLE_BENEFIT_REGEX = /[A-Za-z0-9\(\)\+]+/
	
end