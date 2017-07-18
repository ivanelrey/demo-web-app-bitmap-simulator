class BitmapEditor
  require './lib/file_manager'
  require './lib/bitmap'

  def run(file)
    return "Something went wrong with your file." if file.nil? || !File.exists?(file)

    f = FileManager.new(file)
    f.read_file
    
    # Check the file, if there are any errors print them and exit, otherwise execute the commands.
    if f.errors_found_in_file.any?
      f.errors_found_in_file
    elsif !f.show_command_included
      "To print your created bitmap you must add the command 'S'."
    else
      @b = Bitmap.new(f.given_cols_number, f.given_rows_number, f.init_colour)
      execute_commands(file,f)
      @b.bitmap
    end 

  end

  def execute_commands(file,f)
    

    File.open(file).each do |line|
      line = line.gsub(/\s+/m, ' ').strip.split(" ")
      case line[0]
      when f.init_bitmap
        @b.create_bitmap
      when f.colour_pixel
        @b.draw_pixel(line[1].to_i, line[2].to_i, line[3])
      when f.draw_vertical_segment
        @b.draw_vertical_segment(line[1].to_i, line[2].to_i, line[3].to_i, line[4])
      when f.draw_horizontal_segment
        @b.draw_horizontal_segment(line[1].to_i, line[2].to_i, line[3].to_i, line[4])
      when f.draw_diagonal_segment
        @b.draw_diagonal_segment(line[1].to_i, line[2].to_i, line[3].to_i, line[4].to_i, line[5])
      when f.fill
        @b.fill_command(line[1].to_i, line[2].to_i, line[3])
      when f.clear
        @b.clear_bitmap
      when f.show_command
        puts "------------------------- Command 'S' executed -------------------------"
        @b.print_bitmap
      end
    end
  end

end