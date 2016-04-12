require "latex_to_png/version"
require "erb"
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

      def memory_dir= dir
        @dir = dir
      end

      def memory_dir
        @dir || "/dev/shm/latex_to_png"
      end

    end

    #or formula or filepath
		def initialize opts={ filepath: nil, formula: nil, size: nil }

      @filepath = opts[:filepath]  if opts[:filepath]
      @size = (opts[:size] || 10).to_i
      @formula = opts[:formula] if opts[:formula]

      %x(
        mkdir -p #{klass.memory_dir}
      )

		end

    def size_in_points size_in_pixels
      size = Sizes.invert[size_in_pixels]
      return (size.nil?)? size_in_points("#{size_in_pixels.to_i + 1}px") : size
    end

    def klass
      self.class
    end

    def from_formula formula, size
# debugger

      tmp_file = File.new("#{klass.memory_dir}/#{SecureRandom.hex}", 'w')
      tmp_file.write mount_tex(formula)
      tmp_file.close

# debugger
      # tmp_file = Tempfile.new("formula")
      # tmp_file.write  mount_tex(formula)
      # tmp_file.close
      # debugger
      filepath = tmp_file.path

      convert(filepath,size )

    end

    def mount_tex formula
       klass.template.result(Formula.new( formula ).instance_eval { binding })
    end


    def from_estatic filepath, size
      name = filepath.split("/").last.split(".").first

      %x(
        cp #{filepath} #{klass.memory_dir}/#{name}
      )
      convert(filepath, size )
    end

    def convert filepath, size
      name = filepath.split("/").last.split(".").first
      dirname =  File.dirname filepath
      density = ((300/10)*size).to_i
# debugger
        #convert for .dvi
        # dvi to .ps
        # .ps to .png "q*" option is to run quietly

        # %x(
        #   mkdir -p #{memory_dir} && mount -t tmpfs -o size=60m tmpfs #{memory_tex}
        #
        # )

      %x(
        cd #{klass.memory_dir}; latex -halt-on-error #{name} &&
        dvips -q* -E #{name}.dvi &&
        convert -density #{density}x#{density} #{name}.ps #{name}.png  1>&2 >/dev/null
        )
# debugger
         #
        #  %x(
        #    cd #{dirname}; latex -halt-on-error #{filepath} &&
        #    dvips -q* -E #{name}.dvi &&
        #    convert -density #{density}x#{density} #{name}.ps #{name}.png  1>&2 > /dev/null
        #    )

        #  Thread.new {
        #     %x(cd #{dirname}; rm -f #{name}.dvi #{name}.log #{name}.aux  #{name}.ps &)
        #  }.run()
        #  png_path = "#{filepath.gsub(/.tex$/,"")}.png"

         Thread.new {
            %x(cd #{klass.memory_dir}; rm -f #{name} #{name}.dvi #{name}.log #{name}.aux  #{name}.ps &)
         }.run()
# debugger
         png_path = "#{klass.memory_dir}/#{name}.png"

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
