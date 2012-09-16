#!/usr/bin/env ruby

require "rubygame"
require "rubygame/ftor"


include Rubygame
include Rubygame::Events
include Rubygame::EventActions
include Rubygame::EventTriggers


# Represents a modifiable Bézier curve.
class Curve

  def initialize( points, color=:white )
    @points = []
    points.each { |point| add_point( point ) }
    @color  = :white
    @steps  = 10
  end


  attr_accessor :points, :color, :steps


  # Draw the curve on the given Surface.
  def draw( surface )
    unless @points.empty?
      surface.draw_curve( @points, @color, @steps )
    end
  end


  # Draw the curve's control points on the given Surface,
  # as squares of the given color and size (even numbers work best).
  #
  def draw_points( surface, color=:red, size=2 )
    rect = Rect.new(0,0,size,size)
    @points.each do |point|
      rect.center = point.to_a
      surface.fill( color, rect )
    end
  end


  # Appends the given point to the list of control points.
  # +point+ must be an [x,y] array, Ftor, vector, or similar.
  #
  def add_point( point )
    @points << _make_point(point)
  end


  # Replaces the control point at the given index with the new point.
  # E.g. if index is 2, it sets @points[2] = new_point.
  #
  def replace_point( index, new_point )
    @points[index] = _make_point( new_point )
  end


  # Returns the index and coordinates of the control point nearest to
  # +pos+. +pos+ must be an [x,y] array, Ftor, vector, or similar.
  #
  def nearest_point( pos )
    pos = Ftor.new(pos[0], pos[1])
    pts = @points.to_enum(:each_with_index).collect{ |p,i| [i,p] }
    return pts.sort_by{ |index_and_point|
      point = index_and_point[1]
      (pos - point).magnitude
    }.first
  end


  private


  # Construct an integer Ftor version of the point.
  def _make_point( point )
    begin 
      Ftor.new(point[0].round, point[1].round)
    rescue NoMethodError
      raise ArgumentError, "Invalid point: #{point.inspect}"
    end
  end

end



class App
	include EventHandler::HasEventHandler

	attr_reader :screen, :clock, :queue


  def initialize
    @screen = Screen.new([640,480])

    @queue = EventQueue.new
    @queue.enable_new_style_events

    setup_clock
    setup_hooks

    @curve = Curve.new( [[5,5], [320,240], [635,4]], :white )

  end


  def go
		catch(:quit) do
			loop do
				step
			end
		end
  end


  private


	# Do everything needed for one frame.
	def step
		@queue.fetch_sdl_events
		@queue << @clock.tick
		@queue.each do |event|
			handle( event )
		end
	end  


  def setup_clock
    @clock = Clock.new
    @clock.target_framerate = 30
    @clock.calibrate
    @clock.enable_tick_events
  end


  def setup_hooks
		hooks = {
			:escape           => :quit,
			:q                => :quit,
			QuitRequested     => :quit,

			InputFocusGained  => :update_screen,
			WindowUnminimized => :update_screen,
			WindowExposed     => :update_screen,

      MousePressed      => :handle_mouse,
      MouseReleased     => :handle_mouse,
		}

		make_magic_hooks( hooks )
  end


	# Quit the app
	def quit
		throw :quit
	end


	# Refresh the whole screen.
	def update_screen
		@screen.update()
	end


  def handle_mouse( event )
    
  end


end
