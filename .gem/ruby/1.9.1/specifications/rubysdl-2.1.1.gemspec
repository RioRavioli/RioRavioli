# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rubysdl"
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ohbayashi Ippei"]
  s.date = "2009-12-02"
  s.description = "    Ruby/SDL is an extension library to use SDL(Simple DirectMedia\n    Layer). This library enables you to control audio, keyboard,\n    mouse, joystick, 3D hardware via OpenGL, and 2D video \n    framebuffer. Ruby/SDL is used by games and visual demos.\n"
  s.email = "ohai@kmc.gr.jp"
  s.extensions = ["extconf.rb"]
  s.files = ["extconf.rb"]
  s.homepage = "http://www.kmc.gr.jp/~ohai/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "rubysdl"
  s.rubygems_version = "1.8.11"
  s.summary = "The simple ruby extension library to use SDL"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
