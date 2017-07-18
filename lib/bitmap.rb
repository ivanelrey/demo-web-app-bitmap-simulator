class Bitmap
	attr_accessor :rows_number, :cols_number, :init_colour, :bitmap

	def initialize(rows_number,cols_number,init_colour)
		@rows_number = rows_number
		@cols_number = cols_number
		@init_colour = init_colour
	end

	def create_bitmap
		@bitmap = Array.new(@cols_number.to_i){Array.new(@rows_number.to_i){ @init_colour } }
	end

	def draw_pixel(x,y,colour)
		@bitmap[y.to_i-1][x.to_i-1] = colour
	end

	def draw_vertical_segment(column, start_row_pixel, end_row_pixel, colour)
		if end_row_pixel < start_row_pixel
	      start_row_pixel,end_row_pixel = end_row_pixel,start_row_pixel
	    end
	    for row_pixel in (start_row_pixel..end_row_pixel)
	      draw_pixel(column,row_pixel,colour)
	    end
	end

	def draw_horizontal_segment(start_col_pixel, end_col_pixel, row, colour)
	   	if end_col_pixel < start_col_pixel
	      start_col_pixel,end_col_pixel = end_col_pixel,start_col_pixel
	    end
	    for col_pixel in (start_col_pixel..end_col_pixel)
	      draw_pixel(col_pixel,row,colour)
	    end
	end

	def draw_diagonal_segment(x1, y1, x2, y2, colour)
		if x1 > x2 and y1 > y2
			x1,x2 = x2,x1
			y1,y2 = y2,y1
		elsif x1 > x2 and y1 < y2
			x1,x2 = x2,x1
			y1,y2 = y2,y1
		end
			
		if x1 <= x2 and y1 <= y2
			for pixel_position in (x1..x2)
	      		draw_pixel(pixel_position,y1,colour)
	      		y1 = y1 + 1
	      	end
	    elsif x1 < x2 and y1 > y2
	    	for pixel_position in (x1..x2)
	      		draw_pixel(pixel_position,y1,colour)
	      		y1 = y1 - 1
	      	end
	    end
	end

	def fill_command(x1, y1 , colour)
		old = bitmap[y1-1][x1-1]
		@bitmap.each_with_index do |row,indexx|
	      row.each_with_index do |cell,indexy|
	      	if indexx == y1 -1 
	        	if cell == old
	        		@bitmap[indexx][indexy] = colour
	        	end
	      	end
	      end
	    end
	    @bitmap.each_with_index do |row,indexx|
	      row.each_with_index do |cell,indexy|
	      	if indexy == x1 -1 
	        	if cell == old
	        		@bitmap[indexx][indexy] = colour
	        	end
	      	end
	      end
	    end
	end

	def clear_bitmap
		create_bitmap # Reinitilialize the bitmap
	end

	def print_bitmap
    	@bitmap.each do |row|
	      row.each do |cell|
	        print cell 
	      end
	      puts
	    end
  	end
  	
end