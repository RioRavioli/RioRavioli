require 'rubygame'
require './game_state.rb'

#Runs the game. 
class Main
	include Rubygame

	#Sets up the screen.
	def initialize
		@screen = Screen.new([640, 400], 0, [])
		@screen.title = "RPG"
	end


	def run
		#Intial setup before entering game loop.
		running = true
		events = EventQueue.new
		events.enable_new_style_events
		clock = Clock.new
		clock.target_framerate = 60
		gameState = StartUp.new(@screen)
		bgm = nil

		#Game loop.
		#All actions are taken every frame.
		while running
			events.each { |event|
				case event
				when Events::KeyPressed
					gameState.addKey(event.key)
				when Events::KeyReleased
					gameState.releaseKey(event.key)
				end
			}
			
			gameState.updateKeys
			gameState.updateBackground
			gameState.updateSprites
			gameState = gameState.updateGameState
			if bgm != gameState.bgm
				bgm = gameState.bgm
				#bgm.play
			end
			@screen.update
			clock.tick
		end
	end
end

Rubygame.init
Main.new.run
Rubygame.quit
