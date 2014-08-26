require "spec_helper"


describe "" do 
	it "dirname do arquivo" do 
	
		image = LatexToPng::Convert.new("spec/support/flux.tex")
		# image.to_png
		expect(image.dirname).to eq "spec/support"
		expect(image.basename).to eq "flux"


	end

	it "dirname do arquivo" do 
	
		image = LatexToPng::Convert.new("spec/support/blank.tex")
		image.to_png
		expect(image.png_file.class).to eq StriongIO
	end


end