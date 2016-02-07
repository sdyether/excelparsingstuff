class Validator

	ENCODING = 'UTF-8'
	PATH = 'C:\dev\oowb-valid\velma.xls'
	WORKSHEET_NAME = 'PP15.5 Clean'

	attr_accessor :rows, :error_rows
	
	def initialize(rows = [], error_rows = [])
	
		@rows = rows
		@error_rows = error_rows
		Spreadsheet.client_encoding = ENCODING
		book = Spreadsheet.open PATH
		sheet = book.worksheet WORKSHEET_NAME

		sheet.drop(1).each_with_index do |row, index | #ignore header row

			if row_malformed?(row)
				error_rows.push(index + 2)
				next
			end
			
			if category_row?(row) 
				next
			end

			rows.push(ERow.new(row[0], row[1], row[2], row[3] ))
		end
		
		print_errors
		
	end
	
	def print_errors
		print "The following spreadsheet rows did not contain sufficient data:\n"
		p error_rows
	end

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
end