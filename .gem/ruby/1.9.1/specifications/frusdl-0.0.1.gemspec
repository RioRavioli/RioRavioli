# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "frusdl"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bjorn De Meyer"]
  s.date = "2008-12-04"
  s.email = "beoran@gmail.com"
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = "http://frusdl.rubyforge.org"
  s.require_paths = ["lib"]
  s.rubyforge_project = "frusdl"
  s.rubygems_version = "1.8.11"
  s.summary = "FFI bindings to SDL, SDL_image, SDL_ttf, SDL_mixer, SGE and SFL_gfx"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, [">= 0.2.0"])
    else
      s.add_dependency(%q<ffi>, [">= 0.2.0"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0.2.0"])
  end
end
