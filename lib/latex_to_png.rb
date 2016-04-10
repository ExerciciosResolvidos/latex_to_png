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

require "latex_to_png/sizes"

module LatexToPng

  Formula = Struct.new(:formula)

  class Convert

		attr_accessor  :filepath

    class << self

      def template
        return @doc if @doc
        @doc = ERB.new(File.read("#{ File.dirname __FILE__}/templates/equation.erb"))
        @doc
      end

    end

    #or formula or filepath
		def initialize opts={ filepath: nil, formula: nil, size: nil }

      @filepath = opts[:filepath]  if opts[:filepath]
      @size = (opts[:size] || 10).to_i
      @formula = opts[:formula] if opts[:formula]

		end

    def size_in_points size_in_pixels
      size = Sizes.invert[size_in_pixels]
      return (size.nil?)? size_in_points("#{size_in_pixels.to_i + 1}px") : size
    end

    def from_formula formula, size


      tmp_file = Tempfile.new("formula")
      tmp_file.write  mount_tex(formula)
      tmp_file.close
      # debugger
      filepath = tmp_file.path

      convert(filepath,size )

    end

    def mount_tex formula
       self.class.template.result(Formula.new( formula ).instance_eval { binding })
    end


    def from_estatic filepath, size

      convert(filepath, size )
    end

    def convert filepath, size,
      name = filepath.split("/").last.split(".").first
      dirname =  File.dirname filepath
      density = ((300/10)*size).to_i
# debugger
        #convert for .dvi
        # dvi to .ps
        # .ps to .png "q*" option is to run quietly

         %x(
           cd #{dirname}; latex -halt-on-error #{filepath} &&
           dvips -q* -E #{name}.dvi &&
           convert -density #{density}x#{density} #{name}.ps #{name}.png  1>&2 > /dev/null
           )

         Thread.new {
            %x(cd #{dirname}; rm -f #{name}.dvi #{name}.log #{name}.aux  #{name}.ps &)
         }.run()

         png_path = "#{filepath.gsub(/.tex$/,"")}.png"

         if File.exist?(png_path)
           return open(png_path)
         else
           raise StandardError("Image not generated")
         end
    end


		def to_png
      if @formula
        from_formula @formula, @size

      else
        from_estatic @filepath, @size
  	  end
    end

  end
end
