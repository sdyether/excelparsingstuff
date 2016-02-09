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
		p.parse_premium
		
		if p.finished? 
			parsers.push p 
			next 
		end
		#p.print
	
		if p.dont_parse 
			cant_parse.push(p.row.id)
			next
		end
		
		case row.get_category
		when Category::MINIMUM_ENTRY_AGE, Category::MAXMIUM_ENTRY_AGE, Category::OCCUPATIONS
			p.parse_single_benefit
		when Category::MAXIMUM_SUM_INSURED
			p.parse_max_sum
		end
	
		#finally
		if p.finished? 
			parsers.push p
		else
			cant_parse.push(p.row.id)
		end
		
	rescue ParserException
		cant_parse.push(p.row.id)
		next
	end

end

puts "Total: " + v.rows.size.to_s + "(" + (cant_parse.size + parsers.size).to_s + ") | Couldn't parse: " + cant_parse.size.to_s + " | Parsed: " + parsers.size.to_s + " (" + (100 * parsers.size/v.rows.size.to_f).round(2).to_s + "%)"
puts "Can't Parse:"
puts cant_parse
puts "=" * 100
parsers.each { |x| x.print }






