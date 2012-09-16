# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-sdl-ffi"
  s.version = "0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Croisant"]
  s.date = "2011-03-05"
  s.description = "Ruby-SDL-FFI is a low-level binding to SDL and related libraries\nusing Ruby-FFI. It provides very basic access to SDL from\nRuby without the need for a compiled C wrapper. It aims to\nbe platform and Ruby implementation independent.\n"
  s.email = "jacius@gmail.com"
  s.homepage = "http://github.com/jacius/ruby-sdl-ffi/"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8")
  s.requirements = ["SDL       >= 1.2.13", "SDL_image >= 1.2.7  (optional)", "SDL_gfx   >= 2.0.13 (optional)", "SDL_mixer >= 1.2.8  (optional)", "SDL_ttf   >= 2.0.9  (optional)"]
  s.rubyforge_project = "ruby-sdl-ffi"
  s.rubygems_version = "1.8.11"
  s.summary = "Ruby-FFI bindings to SDL"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nice-ffi>, [">= 0.2"])
    else
      s.add_dependency(%q<nice-ffi>, [">= 0.2"])
    end
  else
    s.add_dependency(%q<nice-ffi>, [">= 0.2"])
  end
end
