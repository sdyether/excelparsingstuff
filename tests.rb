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