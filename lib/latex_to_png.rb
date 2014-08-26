require "latex_to_png/version"

#precisa do programa texi2dvi
#sudo apt-get install texinfo
#e depois
#sudo apt-get install texlive
# e depois iamgeMagik com extensão para dev, para a gem rmagik
#sudo apt-get install imagemagick libmagickcore-dev

module LatexToPng

  class Convert
  		attr_accessor :dirname , :filename, :basename, :png_file

  		def initialize filename
  			@filename = filename
  			@basename = File.basename filename.split(".")[0]
  			@dirname =  File.dirname filename
  		end


  		def to_png
  			debugger
      		@png_file =  open(%x(. lib/shell/convert.sh #{@filename}))
    	end  

    	private
    	
    	def move_to_dir
    		"cd #{@dirname}"
    	end 
	end
end
