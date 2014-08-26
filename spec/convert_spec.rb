require "spec_helper"

describe "" do 

	after(:each) do
		`rm #{ROOT_DIR_SPEC}/support/flux.png`
	end

	it "dirname do arquivo" do 
	
		image = LatexToPng::Convert.new("#{ROOT_DIR_SPEC}/support/flux.tex")
		
		expect(image.dirname).to eq "#{ROOT_DIR_SPEC}/support"
		expect(image.basename).to eq "flux"


	end

	it "dirname do arquivo" do 
	
		image = LatexToPng::Convert.new("#{ROOT_DIR_SPEC}/support/flux.tex")
		image = image.to_png
		expect(image.class).to eq File
	end


end