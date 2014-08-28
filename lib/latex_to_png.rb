require "latex_to_png/version"

#precisa do programa texi2dvi
#sudo apt-get install texinfo
#e depois
#sudo apt-get install texlive
# e depois iamgeMagik com extensão para dev, para a gem rmagik
#sudo apt-get install imagemagick libmagickcore-dev

module LatexToPng
  raise "You need install ImageMagick dependency." if %x(hash convert 2>/dev/null || { echo >&2 "I require ImageMagick but it's not installed.  Aborting."; exit 1; }) == 1
  raise "You need install latex dependency." if %x(hash latex 2>/dev/null || { echo >&2 "I require latex but it's not installed.  Aborting."; exit 1; }) == 1
  raise "You need install dvips dependency." if %x(hash dvips 2>/dev/null || { echo >&2 "I require dvips but it's not installed.  Aborting."; exit 1; }) == 1

    ROOT_LIB = File.dirname __FILE__
    class Convert
    		attr_accessor :dirname , :filename, :basename, :png_file

    		def initialize filename
    			@filename = filename
    			@basename = File.basename filename.split(".")[0]
    			@dirname =  File.dirname filename
    		end


    		def to_png
        		@png_file =  open(%x(bash #{ROOT_LIB}/shell/convert.sh #{@filename}))
      	end  

      	private
      	
      	def move_to_dir
      		"cd #{@dirname}"
      	end 
  	end
end

