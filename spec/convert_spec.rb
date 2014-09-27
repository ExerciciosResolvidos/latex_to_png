require "spec_helper"

describe "" do 

	after(:each) do
		# %x(rm #{ROOT_DIR_SPEC}/support/*.png)
	end

	it "dirname do arquivo" do 
	
		image = LatexToPng::Convert.new(filename: "#{ROOT_DIR_SPEC}/support/flux.tex")
		
		expect(image.dirname).to eq "#{ROOT_DIR_SPEC}/support"
		expect(image.basename).to eq "flux"


	end

	it "dirname do arquivo" do 
	
		image = LatexToPng::Convert.new(filename: "#{ROOT_DIR_SPEC}/support/flux.tex")
		image = image.to_png
		expect(image.class).to eq File
	end

	it "dirname do arquivo com \\cancel" do 
	
		image = LatexToPng::Convert.new(filename: "#{ROOT_DIR_SPEC}/support/cancel_example.tex")
		image = image.to_png
		expect(image.class).to eq File
	end
	
	it "formula com usando template" do 
	
		image = LatexToPng::Convert.new(formula: "\\frac{a}{b}")
		image = image.to_png
		expect(image.class).to eq File
	end


end