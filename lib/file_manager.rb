class FileManager 
	require 'json'
	attr_accessor :init_colour, :init_bitmap, :colour_pixel, :draw_vertical_segment,
                  :draw_horizontal_segment,:draw_diagonal_segment, :show_command, :clear, :max_rows, :max_columns, :file,
                  :errors_found_in_file, :given_rows_number, :given_cols_number, :show_command_included, :fill

	def initialize(file)
		@file = file
		@errors_found_in_file = Array.new
		init_settings
		remove_blank_lines_from_file
	end

	def init_settings
	    file = File.read ("./lib/settings.json")
	    if file.nil?
	      puts "Please provide correct settings.json file."
	    end
	    data = JSON.parse(file)
	    @init_bitmap = data["init_bitmap"]
	    @clear = data["clear"]
	    @colour_pixel = data["colour_pixel"]
	    @draw_vertical_segment = data["draw_vertical_segment"]
	    @draw_horizontal_segment = data["draw_horizontal_segment"]
	    @show_command = data["show_command"]
	    @init_colour = data["init_colour"]
	    @max_columns = data["max_columns"]
    	@max_rows = data["max_rows"]
    	@draw_diagonal_segment = data["draw_diagonal_segment"]
    	@fill = data["fill"]
  	end

  	def remove_blank_lines_from_file
    	File.write(@file, File.readlines(@file).reject { |s| s.strip.empty? }.join)
  	end

  	def read_file
  		File.open(@file, "r").each_with_index do |line, line_number|
	      line_number = line_number + 1
	      line = line.gsub(/\s+/m, ' ').strip.split(" ")
	      if line_number == 1 and line[0] != @init_bitmap # if the first commans is not "I"
	      	@errors_found_in_file << "First command must be 'I' to initialize the bitmap."
	      	return
	      end
	      check_line(line, line_number)
	  	end
  	end

  	def check_line(line,line_number)
		case line[0]
		when @init_bitmap
			check_init_command(line, line_number)
		when @colour_pixel
	  		check_colour_pixel_command(line, line_number)
		when @draw_vertical_segment
	  		check_draw_vertical_segment_command(line, line_number)
		when @draw_horizontal_segment
	  		check_draw_horizontal_segment_command(line, line_number)
		when @clear
	  		check_clear_command(line, line_number)
		when @show_command
			check_show_command(line, line_number)
		when @draw_diagonal_segment
			check_draw_diagonal_segment_command(line, line_number)
		when @fill
			check_fill_command(line, line_number)
		else
		  	if (line[0] != line[0].upcase)
				@errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("found_lower_case")}"
			else
		    	@errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("unrecognized_command")}"
		  	end
		end		
	end

	def check_init_command(line, line_number)
	    if line_number != 1
	      @errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("wrong_line_to_init")}"
	      return
	    end
		if check_params_size(line.size - 1, 2, line_number) #line.size = command + params
  			check_param_is_int_and_in_range(1, @max_columns, line_number, line[1])
      		check_param_is_int_and_in_range(1, @max_rows, line_number, line[2])
      		@given_rows_number = line[2].to_i
		    @given_cols_number = line[1].to_i
		    @errors_found_in_file.any? ? @bitmap_initialized = false : @bitmap_initialized = true
    	end
	end

	def check_colour_pixel_command(line, line_number)
	    if check_params_size(line.size - 1, 3, line_number) and @bitmap_initialized 
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[1])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[2])
	      check_colour_param_is_capital_letter(line[3], line_number)
	    end
  	end

  	def check_draw_vertical_segment_command(line, line_number)
	    if check_params_size(line.size - 1, 4, line_number) and @bitmap_initialized
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[1])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[2])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[3])
	      check_colour_param_is_capital_letter(line[4], line_number)
	    end
  	end

  	def check_draw_horizontal_segment_command(line, line_number)
	    if check_params_size(line.size - 1, 4, line_number) and @bitmap_initialized
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[1])
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[2])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[3])
	      check_colour_param_is_capital_letter(line[4], line_number)
	    end
  	end

  	def check_draw_diagonal_segment_command(line, line_number)
	    if check_params_size(line.size - 1, 5, line_number) and @bitmap_initialized
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[1])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[2])
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[3])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[4])
	      check_if_pixels_create_diagonal_line(line[1], line[2], line[3], line[4], line_number)
	      check_colour_param_is_capital_letter(line[5], line_number)
	    end
  	end

  	def check_fill_command(line, line_number)
	    if check_params_size(line.size - 1, 3, line_number) and @bitmap_initialized
	      check_param_is_int_and_in_range(1, @given_cols_number, line_number, line[1])
	      check_param_is_int_and_in_range(1, @given_rows_number, line_number, line[2])
	      check_colour_param_is_capital_letter(line[3], line_number)
	    end
  	end

  	def check_clear_command(line, line_number) 
	    check_params_size(line.size - 1, 0, line_number)
	end

	def check_show_command(line, line_number)
	    check_params_size(line.size - 1, 0, line_number)
	    @show_command_included = true
	end

	def check_params_size(params_size, valid_params_size, line_number)
		if params_size != valid_params_size
			@errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " +  "#{Errors.fetch("invalid_parameters")}#{valid_params_size} "
      		false
    	else
      		true
		end
	end

	def check_param_is_int_and_in_range(min_number, max_number, line_number, param)
	    if param_is_integer?(param)
	      if !param.to_i.between?(min_number, max_number)
	        @errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("wrong_param")}'#{param}'. " + "#{Errors.fetch("not_in_range")} " + "(#{min_number} .. #{max_number})"
	      end
	    else
	      @errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("wrong_param")}'#{param}'." + "#{Errors.fetch("not_an_integer")} "
	    end
  	end

  	def check_colour_param_is_capital_letter(colour_param, line_number)
    	if !(colour_param.length == 1 && colour_param.between?("A", "Z"))
      		@errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("wrong_param")}'#{colour_param}'." + "#{Errors.fetch("not_a_capital_letter")}"
    	end
  	end

  	def check_if_pixels_create_diagonal_line(x1, y1, x2, y2, line_number)
  		dif_x = (x1.to_i - x2.to_i).abs
  		dif_y = (y1.to_i - y2.to_i).abs
  		if dif_x != dif_y
			@errors_found_in_file << "#{Errors.fetch("error_in_line")}#{line_number}: " + "#{Errors.fetch("wrong_pixels_for_diagonal")}"
  		end
  	end

  	def param_is_integer?(param)
    	!!(param !~ /\D/) 
  	end

  	def show_errors
	    if @errors_found_in_file.any?
	      @errors_found_in_file.each do | error |
	        puts error
	      end
	    end
	end

	Errors = {
    "error_in_line" => "ERROR in line ",
    "found_lower_case" => "A command must be a capital letter.",
    "unrecognized_command" => "Unrecognised command :(.",
    "wrong_line_to_init" => "You can initialize the bitmap only in the first line.",
    "found_command_before_init" => "Before any action you must initialize your bitmap.",
    "invalid_parameters" => "Number of parameters for this command is ",
    "wrong_param" => "Wrong param ",
    "not_in_range" => "The current param must be in range",
    "not_an_integer" => "The current param must be a positive integer.",
    "not_a_capital_letter" => "Param must be a Capital letter (A .. Z).",
    "wrong_pixels_for_diagonal" => "The given pixels are not on the same diagonal line." 
  }.freeze

end
