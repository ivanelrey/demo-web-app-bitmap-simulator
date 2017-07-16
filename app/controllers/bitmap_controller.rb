class BitmapController < ApplicationController
	require './lib/bitmap_editor.rb'

	def show
		#@output = Array.new()
		@commands_in_show = ""
		if File.exists?('./examples/show.txt')
			bitmap = BitmapEditor.new
			@output = bitmap.run('./examples/show.txt')
			@commands_in_show = File.read('./examples/show.txt')
		end
	end

	def run_commands
		File.open('./examples/show.txt', 'w') do |f|
			f.write post_params[:commands]
		end
		redirect_to root_path
	end

	private
    def post_params
        params.require(:input).permit(:commands)
    end
end
