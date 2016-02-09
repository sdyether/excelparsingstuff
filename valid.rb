require 'spreadsheet'
require_relative 'erow'
require_relative 'parser'
require_relative 'parser_exception'
require_relative 'validator'
require_relative 'constants'
require_relative 'tests'

#Tests.run_all_tests

v = Validator.new
parsers = []
cant_parse = []
v.rows.each do |row|

	p = Parser.new(row)
	begin
		
		p.parse_age
		p.parse_occ
		#p.print
	
		if p.dont_parse 
			cant_parse.push(p.row.id)
			next
		end
		
		case row.get_category
		when Category::MINIMUM_ENTRY_AGE, Category::MAXMIUM_ENTRY_AGE, Category::OCCUPATIONS
			if  p.parse_single_benefit and p.finished?
				parsers.push p
			else
				cant_parse.push(p.row.id)
				next
			end
		end
	
		
	rescue ParserException
		cant_parse.push(p.row.id)
		next
	end

end

puts "Can't Parse:"
puts cant_parse
puts "=" * 100
parsers.each { |x| x.print }






