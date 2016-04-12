# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'latex_to_png/version'

Gem::Specification.new do |spec|
  spec.name          = "latex_to_png"
  spec.version       = LatexToPng::VERSION
  spec.authors       = ["luizamboni"]
  spec.email         = ["luizamboni2002@hotmail.com"]
  spec.summary       = %q{Conversor de documentos Latex em imagens}
  spec.description   = %q{Conversor de documentos Latex em imagens, via shell script}
  spec.homepage      = "https://github.com/luizamboni/latex_to_png"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.requirements << "latex"
  spec.requirements << "dvips"
  spec.requirements << "imageMagik"
  spec.requirements << "libmagickcore-dev"
  spec.requirements << "texlive"
  spec.requirements << "texlive-latex-extra"
  spec.requirements << "texinfo"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

end
