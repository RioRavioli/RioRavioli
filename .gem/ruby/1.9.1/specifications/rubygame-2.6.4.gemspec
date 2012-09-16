# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubygame"
  s.version = "2.6.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Croisant"]
  s.date = "2010-04-15"
  s.email = "jacius@gmail.com"
  s.extra_rdoc_files = ["doc/windows_install.rdoc", "doc/custom_sdl_load_paths.rdoc", "doc/keyboard_symbols.rdoc", "doc/macosx_install.rdoc", "doc/managing_framerate.rdoc", "doc/surface_palettes.rdoc", "doc/getting_started.rdoc", "README", "LICENSE", "CREDITS", "ROADMAP", "NEWS"]
  s.files = ["doc/windows_install.rdoc", "doc/custom_sdl_load_paths.rdoc", "doc/keyboard_symbols.rdoc", "doc/macosx_install.rdoc", "doc/managing_framerate.rdoc", "doc/surface_palettes.rdoc", "doc/getting_started.rdoc", "README", "LICENSE", "CREDITS", "ROADMAP", "NEWS"]
  s.homepage = "http://rubygame.org/"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8")
  s.requirements = ["SDL       >= 1.2.7", "SDL_gfx   >= 2.0.10 (optional)", "SDL_image >= 1.2.3  (optional)", "SDL_mixer >= 1.2.7  (optional)", "SDL_ttf   >= 2.0.6  (optional)"]
  s.rubyforge_project = "rubygame"
  s.rubygems_version = "1.8.11"
  s.summary = "Clean and powerful library for game programming"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0.7.0"])
      s.add_runtime_dependency(%q<ruby-sdl-ffi>, [">= 0.1.0"])
    else
      s.add_dependency(%q<rake>, [">= 0.7.0"])
      s.add_dependency(%q<ruby-sdl-ffi>, [">= 0.1.0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0.7.0"])
    s.add_dependency(%q<ruby-sdl-ffi>, [">= 0.1.0"])
  end
end
