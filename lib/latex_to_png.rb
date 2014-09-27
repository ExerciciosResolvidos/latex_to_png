require "latex_to_png/version"
require 'tempfile'
require "erb"



#precisa do programa texi2dvi
#sudo apt-get install texinfo
#e depois o Latex
#sudo apt-get install texlive
# e depois iamgeMagik com extensão para dev, para a gem rmagik
#sudo apt-get install imagemagick libmagickcore-dev
begin
    if %x(hash convert 2>/dev/null || { echo >&2 "I require ImageMagick but it's not installed."; exit 1; })
      raise RuntimeError,"You need install ImageMagick dependency. Run 'sudo apt-get install imagemagick libmagickcore-dev'"
    end
    if %x(hash latex 2>/dev/null || { echo >&2 "I require latex but it's not installed."; exit 1; })
      raise RuntimeError,"You need install latex dependency. Run 'sudo apt-get install texlive texlive-latex-extra'"
    end
    if %x(hash dvips 2>/dev/null || { echo >&2 "I require dvips but it's not installed."; exit 1; })
      raise RuntimeError,"You need install dvips dependency. Run 'sudo apt-get install texinfo'"
    end
rescue Exception => e
    puts e
    # raise Gem::Installer::ExtensionBuildError 
end

module LatexToPng
  


  ROOT_LIB = File.dirname __FILE__


  class Convert

		attr_accessor :dirname , :filename, :basename, :png_file, :template_path

		def initialize opts={ filename: nil, formula: nil, template_path: nil }
      
      @filename = opts[:filename]  if opts[:filename]
			@basename = File.basename opts[:filename].split(".")[0] if opts[:filename]
			@dirname =  File.dirname opts[:filename]  if opts[:filename]

      @template_path = opts[:template_path] if opts[:template_path]
      @formula = opts[:formula] if opts[:formula]
		end

		def to_png
      if @formula
        doc = ERB.new(File.read("#{ROOT_LIB}/templates/equation.erb"))
        doc = doc.result(@formula.send(:binding))
        tmp_file = Tempfile.new("formula")
        tmp_file.write doc
        tmp_file.close
        # debugger
        @filename = tmp_file.path
      else
        @filename
  	  end

    name = @filename.split("/").last.split(".").first 
    dirname =  File.dirname @filename
    basename = @filename.gsub(".tex",'')

    %x(cd #{dirname}; latex #{@filename} >> convert.log)
    %x(cd #{dirname}; dvips -q #{name}.dvi  >> convert.log)
    %x(cd #{dirname}; convert -density 200x200 #{name}.ps #{basename}.png  >> convert.log)
    %x(cd #{dirname}; rm #{name}.dvi #{name}.log #{name}.aux #{name}.ps convert.log)
    
    @png_file = open(@filename.gsub("flex","png"))


    end  

  	private
  	
  	def move_to_dir
  		"cd #{@dirname}"
  	end 

  end
end

