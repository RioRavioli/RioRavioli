require 'rubygame'
require './unitSprites.rb'
require './overworld.rb'
require './battle_manager.rb'
require './text.rb'
require './enemy_list.rb'

#Current list of game states:
#  StartUp
#  Map1
#  Menu
#  Battle
#
#Game state classes must all contain:
#	attr_reader :bgm
#	addKey(key)
#	update(), return gameState

#Game state:
#Defaults
module GameState
	SQUARE_SIZE = 40
	BOARD_SIZE_X = 16 
	BOARD_SIZE_Y = 10
	SCREEN_CENTER_X = 320
	SCREEN_CENTER_Y = 160
	WALK_FRAMES = 20

	attr_reader :bgm
	attr_reader :sprites


	#Sets the screen for the visuals to be drawn on.
	def initialize(screen, hero)
		@screen = screen
		@hero = hero
		#keyIdle* manages when key presses get registered.
		@keyIdle = true
		@keyIdleCount = 0
		@keyIdleMax = 0
		@keysPressed = [] 
		@sprites = []
		@nextGameState = self
	end


	def addKey(key)
		@keysPressed.push(key)
	end

	
	#Sets whether keys are released to released.
	def releaseKey(key)
		@keysPressed.delete(key)
	end


	#Updates various implementation mechanics of a game state.
	#Returns the next game state that was updated during another update.
	def updateGameState
		#Updates the duration in which a user input has no immediate action.
		if !@keyIdle
			@keyIdleCount = @keyIdleCount + 1
			if @keyIdleCount == @keyIdleMax
				@keyIdle = true
				@keyIdleCount = 0
				@keyIdleMax = 0
			end
			if !@hero.sprite.walking and @keyIdleCount == 8
				@keyIdle = true
				@keyIdleCount = 0
				@keyIdleMax = 0
			end
		end
		returnState = @nextGameState
		@nextGameState = self
		return returnState
	end


	#Take action when a key is pressed.
	def updateKeys
		if !@keysPressed.empty?
			key = @keysPressed.pop
			initX = @initPosX + @hero.sprite.posx / SQUARE_SIZE 
			initY = @initPosY + @hero.sprite.posy / SQUARE_SIZE 
			direction = 0
			case key.to_s
			when "u"
				direction = "right"
				checkX = initX + SCREEN_CENTER_X / SQUARE_SIZE + 1  
				checkY = initY + SCREEN_CENTER_Y / SQUARE_SIZE  
			when "o"
				direction = "left"
				checkX = initX + SCREEN_CENTER_X / SQUARE_SIZE - 1  
				checkY = initY + SCREEN_CENTER_Y / SQUARE_SIZE  
			when "e" 
				direction = "down"
				checkX = initX + SCREEN_CENTER_X / SQUARE_SIZE  
				checkY = initY + SCREEN_CENTER_Y / SQUARE_SIZE + 1 
			when "period"
				direction = "up"
				checkX = initX + SCREEN_CENTER_X / SQUARE_SIZE  
				checkY = initY + SCREEN_CENTER_Y / SQUARE_SIZE - 1 
			when "t"
				if @keyIdle
					@nextGameState = Menu.new(@screen, self) 
				end
			end
			if direction != 0
				move = true
				tile = @background[checkY][checkX]
				@noMove.each { |noMove|
					if tile == noMove
						move = false
					end
				}
				movement(direction, key, move)
			end
		end
	end


	#Updates and redraws the background.
	def updateBackground
		drawMap()
	end


	#Update each sprite that is present on the map.
	def updateSprites
		@sprites.sort! { |a, b| (b.depth or 0) <=> (a.depth or 0) }
		@sprites.each { |sprite|
			sprite.update
			sprite.draw(@screen)
		}
	end


	def redrawSection(initX, initY, dx, dy)
		absoluteX = @initPosX + @hero.sprite.posx / SQUARE_SIZE
		absoluteY = @initPosY + @hero.sprite.posy / SQUARE_SIZE
		(initY...dy).each { |y|
			(initX...dx).each { |x|
				tile = @background[absoluteY + y][absoluteX + x]
				@tiles[tile].blit(@screen, [x * SQUARE_SIZE - @hero.sprite.posx % SQUARE_SIZE, y * SQUARE_SIZE - @hero.sprite.posy % SQUARE_SIZE], nil)
			}
		}
	end


private
	#Draws the background.
	def drawMap()
		initX = @initPosX + @hero.sprite.posx / SQUARE_SIZE 
		initY = @initPosY + @hero.sprite.posy / SQUARE_SIZE 
		(-1...BOARD_SIZE_X + 2).each { |x|
			(-1...BOARD_SIZE_Y + 2).each { |y|
				tile = @background[initY + y][initX + x]
				@tiles[tile].blit(@screen, [x * SQUARE_SIZE - @hero.sprite.posx % SQUARE_SIZE, y * SQUARE_SIZE - @hero.sprite.posy % SQUARE_SIZE], nil)
			}
		}
	end


	#Manages directional key input.
	def movement(direction, key, move)
		@keysPressed.push(key)
		if !@hero.sprite.walking and @keyIdleCount == 7 
			if move
				@keyIdleMax = WALK_FRAMES + 7
				@hero.sprite.move(direction)
			end
		end
		if @keyIdle
			@enemyCounter = @enemyCounter - 1
			puts @enemyCounter
			@hero.sprite.animate(direction)
			if @hero.sprite.walking and @enemyCounter > 0
				@keyIdleMax = WALK_FRAMES
				if move
					@hero.sprite.move(direction)
				end
			end
		end
		if move
			@keyIdle = false
		end
	end	


	def reset
		@keysPressed = []
	end
end


#Game state:
#Start up
class StartUp
	include GameState

	def initialize(screen)
		heroSpells = [[Lotia.new, true], [Lotiola.new, false], [Lotiolalum.new, false], [Glendol.new, true], [Glendola.new, false], [Gladia.new, true], [Lotia.new, false], [Lotia.new, false], [Lotia.new, false], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true], [Lotia.new, true]]
		heroItemPouch = [Herb.new, Herb.new, Herb.new, FireSeal.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new, Herb.new]
		@hero = Hero.new("Hero", 30, 5, 9, 4, 7, heroItemPouch,  heroSpells, Clothes.new, 0) 
		super(screen, @hero)
	end


	#Takes next action for key presses in this game state.
	def updateKeys
		if !@keysPressed.empty?
			key = @keysPressed.pop
			@keysPressed.push(key)
			case key.to_s
			when "t" 
				@nextGameState = Map1.new(@screen, @hero)
			end
		end
	end


	def updateBackground
	end


	def updateSprites
	end


	def updateGameState
		returnState = @nextGameState
		@nextGameState = self
		return returnState
	end
end


#Game state:
#Map1
class Map1
	include GameState

	attr_reader :initPos_X
	attr_reader :initPos_Y


	def initialize(screen, hero)
		super(screen, hero)
		#Grass
		@tiles = Hash.new
		@tiles["G"] = Rubygame::Surface.load("visuals/background/grass.png")

		#Forest
		@tiles["FRT"] = Rubygame::Surface.load("visuals/background/forest_right_top.png")
		@tiles["FLT"] = Rubygame::Surface.load("visuals/background/forest_left_top.png")
		@tiles["FMT"] = Rubygame::Surface.load("visuals/background/forest_middle_top.png")
		@tiles["FM2T"] = Rubygame::Surface.load("visuals/background/forest_middle2_top.png")

		@tiles["FRB"] = Rubygame::Surface.load("visuals/background/forest_right_bottom.png")
		@tiles["FLB"] = Rubygame::Surface.load("visuals/background/forest_left_bottom.png")
		@tiles["FMB"] = Rubygame::Surface.load("visuals/background/forest_middle_bottom.png")
		@tiles["FM2B"] = Rubygame::Surface.load("visuals/background/forest_middle2_bottom.png")

		@tiles["FRM"] = Rubygame::Surface.load("visuals/background/forest_right_middle.png")
		@tiles["FRM2"] = Rubygame::Surface.load("visuals/background/forest_right_middle2.png")
		@tiles["FLM"] = Rubygame::Surface.load("visuals/background/forest_left_middle.png")
		@tiles["FLM2"] = Rubygame::Surface.load("visuals/background/forest_left_middle2.png")

		@tiles["FMM"] = Rubygame::Surface.load("visuals/background/forest_middle_middle.png")
		@tiles["FM2M"] = Rubygame::Surface.load("visuals/background/forest_middle2_middle.png")
		@tiles["FMM2"] = Rubygame::Surface.load("visuals/background/forest_middle_middle2.png")
		@tiles["FM2M2"] = Rubygame::Surface.load("visuals/background/forest_middle2_middle2.png")

		@tiles["FLBE"] = Rubygame::Surface.load("visuals/background/forest_left_bottom_extension.png")
		@tiles["FBRE"] = Rubygame::Surface.load("visuals/background/forest_bottom_right_extension.png")
		@tiles["FRBE"] = Rubygame::Surface.load("visuals/background/forest_right_bottom_extension.png")
		@tiles["FBLE"] = Rubygame::Surface.load("visuals/background/forest_bottom_left_extension.png")

		@tiles["FTLE"] = Rubygame::Surface.load("visuals/background/forest_top_left_extension.png")
		@tiles["FRTE"] = Rubygame::Surface.load("visuals/background/forest_right_top_extension.png")
		@tiles["FTRE"] = Rubygame::Surface.load("visuals/background/forest_top_right_extension.png")
		@tiles["FLTE"] = Rubygame::Surface.load("visuals/background/forest_left_top_extension.png")

		#Ocean
		@tiles["O"] = Rubygame::Surface.load("visuals/background/ocean.png")

		#Sets up the map.
		@background = Overworld.getMap 
		@noMove = ["O"]
		@bgm = Rubygame::Sound.load("music.wav")
		@initPosX = 5 
		@initPosY = 5
		@sprites.push(@hero.sprite)
		@enemyCounter = 0
		resetEnemyCounter
	end


	#Resets the number of steps until next enemy appearance.
	def resetEnemyCounter
		@enemyCounter = 3 + rand(19)
	end


	#Keeps track of the steps taken for enemy encounters. If the steps reach 0, a battle sequence
	#is initiated.
	def updateGameState
		nextGameState = super
		if @enemyCounter == 0
			@nextGameState = Battle.new(self, @hero, @screen)
			reset
			resetEnemyCounter
		end
		return nextGameState
	end
end


class Menu
	include GameState

	#Creates the menu boxes.
	def initialize(screen, map)
		@map = map
		super(screen)
		@boxPriority = []
		@text = DescriptionBox.new(["Do you want to continue playing?"], @screen) 
		@test = OptionBox.new(420, 350, 9, 3, 18, 16, 50, 20, [["Yes", "No"]], @screen)
		@boxPriority.push(@text)
		@boxPriority.push(@test)
		@redraw = true
	end


	#Controls menu navigation.
	def updateKeys
		if !@keysPressed.empty?
			key = @keysPressed.pop
			@keysPressed.push(key)
			case key.to_s
			when "u"
				@test.changeOption(1, 0)
				@keysPressed.pop
			when "o"
				@test.changeOption(-1, 0)
				@keysPressed.pop
			when "period"
				@test.changeOption(0, -1)
				@keysPressed.pop
			when "e"
				@test.changeOption(0, 1)
				@keysPressed.pop
			when "t"
				aOptions(@boxPriority.pop)
				@keysPressed.pop
			when "h" 
				@nextGameState = @map
			end
		end
	end


	#Draws all the menu boxes.
	def updateBackground
		if @redraw
			@map.updateBackground
			@map.sprites.each { |sprite|
				sprite.draw(@screen)
			}
			@boxPriority.each { |box|
				box.draw
			}
			@redraw = false
		end
	end


	def updateSprites
	end


	def updateGameState
		return @nextGameState
	end


private
	#Controls the action when A is pressed.
	def aOptions(box)
		case box
		when @test
			choice = @test.getOption
			if choice == "Yes"
				@text.setText(["Okay you may resume the game.", "Have fun..."])
			else
				@text.setText(["You may continue anyways."])
			end
		when @text
			if @text.next
				@boxPriority.push(box)
			else
				@nextGameState = @map
			end
		end
		@redraw = true
	end
end

class Battle
	include GameState

	BATTLE_BACKGROUND = Rubygame::Surface.load("visuals/battle/battle.png")

	#Sets up all necessary components for a battle.
	def initialize(map, hero, screen)
		super(screen, hero)
		@map = map
		@bgm = nil
		@phase = "intro" 
		@frame = 0
		@statsBox = TextBox.new(450, 5, 10, 7, 26, 18, 60, 24, [[@hero.name, ""], ["HP", "MP"], [@hero.current_hp.to_s, @hero.current_mp.to_s]], @screen)
		@battleManager = BattleManager.new(@hero, @statsBox)
		@dialogueText = DialogueBox.new([@battleManager.enemyNames + " appeared!"], @screen)
		@battleManager.setBox(@dialogueText)
		@battleOptions = OptionBox.new(40, 30, 13, 5, 18, 18, 76, 22, [["Attack", "Magic"], ["Run", "Item"]], @screen)
		@battleStack = TextBox.new(15, 140, 12, 10, 18, 16, 0, 28, [["Attack"], ["Attack"], ["Lotia"], ["Magical Herb"]], @screen)
		@enemyUnits = nil
		@subMenuIndex = 0
		@subSelect = false
		@selectItemBox = nil
		@selectMagicBox = nil
		@menuStack = []
	end


	#Updates the battle, depending on the current phase.
	def updateBackground
		case @phase
		when "intro"
			intro
		when "menu"
			menu
		when "combat"
			combat
		when "finish"
			finish
		end
	end


	def updateSprites
	end


	#Controls the action taken due to key presses.
	def updateKeys
		if !@keysPressed.empty? and @phase == "menu"
			key = @keysPressed.pop
			case key.to_s
			when "u"
				menu = @menuStack.pop
				menu.changeOption(1, 0)
				@menuStack.push(menu)
			when "o"
				menu = @menuStack.pop
				menu.changeOption(-1, 0)
				@menuStack.push(menu)
			when "period"
				menu = @menuStack.pop
				if !menu.changeOption(0, -1)
					@subMenuIndex -= 1
					menu = cycleMenu(menu)
				end
				@menuStack.push(menu)
			when "e"
				menu = @menuStack.pop
				if !menu.changeOption(0, 1)
					@subMenuIndex += 1
					menu = cycleMenu(menu)
				end
				@menuStack.push(menu)
			when "t"
				menuAOption
			when "h"
				if (@menuStack.length > 1) 
					@menuStack.pop
					@hero.nextCommand.pop
				end
			end
		end
	end


	def updateGameState
		return @nextGameState
	end


private	
	#Controls the animation for the battle intro.
	def intro
		@frame = @frame + 1
		if @frame == 1 or @frame == 40 
			@screen.fill([0, 0, 0])
		elsif @frame == 10 or @frame == 60
			@map.updateBackground
			@map.sprites.each { |sprite|
				sprite.draw(@screen)
			}
		elsif @frame ==  220
			@frame = 0
			stats
			setMenu
		elsif @frame > 120
			@dialogueText.draw
		end
	end


	#Sets up the menu phase.
	def setMenu
		@phase = "menu"
		@dialogueText.setText(["What will you do?"])
		@menuStack.push(@battleOptions)
		@enemyUnits = @battleManager.enemyUnits
		@hero.nextCommand = []
	end


	#Sets up the combat phase.
	def setCombat
		@phase = "combat"
		@battleManager.setBattle
		@battleOptions.reset
		@map.redrawSection(0, 0, 11, 3)
		BATTLE_BACKGROUND.blit(@screen, [188, 106], nil)
		@menuStack = []
	end


	#Updates the menu phase.
	def menu
		@map.redrawSection(0, 0, 11, 3)
		@dialogueText.draw
		@menuStack.each { |menu|
			menu.draw
		}
		BATTLE_BACKGROUND.blit(@screen, [188, 106], nil)
		@battleStack.draw
	end


	#Updates the combat phase.
	def combat
		if @battleManager.actionUnitsEmpty
			setMenu
		else
			unitChange = !@battleManager.updateAction
			if unitChange
				@phase = @battleManager.checkChanges
				puts @phase
			end
		end
	end


	#Updates the finish phase.
	def finish
		@frame = @frame + 1
		done = false
		if @frame % 120 == 0 
			done = !@dialogueText.next
		end
		if done
			@frame = 0
			@nextGameState = @map
		else
			@dialogueText.draw
		end
	end


	#Draws the stat box.
	def stats
		@statsBox.setList([[@hero.name], ["HP", "MP"], [@hero.current_hp.to_s, @hero.current_mp.to_s]])
		@statsBox.draw
	end


	#Controls the menu flow when A is pressed.
	def menuAOption
		menu = @menuStack.pop
		@menuStack.push(menu)
		option = menu.getOption
		case option
		when "Magic"
			@hero.nextCommand.push(option)
			@selectMagicBox = OptionBox.new(15, 5, 34, 7, 18, 15, 128, 26, createNextMagicSublist, @screen)
			@menuStack.push(@selectMagicBox)
		when "Attack"
			@hero.nextCommand.push(option) 
			if @enemyUnits.length > 1
				@selectEnemyBox = OptionBox.new(242, 5, 15, 7, 18, 15, 128, 26, createEnemyList, @screen)
				@menuStack.push(@selectEnemyBox)
			else
				setCombat
				@hero.nextCommand.push([@enemyUnits[0]])
			end
		when "Run"
			@hero.nextCommand.push(option)
			setCombat
		when "Item"
			@hero.nextCommand.push(option)
			@subMenuIndex = 0
			@selectItemBox = OptionBox.new(15, 5, 34, 7, 18, 15, 128, 26, createNextItemSublist, @screen)
			@menuStack.push(@selectItemBox)
		else
			if (option != "")
				if (option.class < Unit)
					@hero.nextCommand.push([option])
					setCombat
				else
					targetType = option.getTargetType
					case targetType
					when "self"
						@hero.nextCommand.push(option)
						@hero.nextCommand.push([@hero])
						setCombat
					when "all"
						@hero.nextCommand.push(option)
						targets = []
						@enemyUnits.each { |unit| targets.push(unit) }
						@hero.nextCommand.push(targets)
						setCombat
					when "enemy"
						@hero.nextCommand.push(option)
						if @enemyUnits.length > 1
							@selectEnemyBox = OptionBox.new(242, 5, 15, 7, 18, 15, 128, 26, createEnemyList, @screen)
							@menuStack.push(@selectEnemyBox)
						else
							setCombat
							@hero.nextCommand.push([@enemyUnits[0]])
						end
					end
				end
			end
		end
	end


	#Creats a sublist of items to be displayed.
	def createNextItemSublist
		itemPouch = @hero.itemPouch
		#Checks for appropriate index.
		if @subMenuIndex * 9 >= itemPouch.length
			@subMenuIndex = 0
		elsif @subMenuIndex < 0
			@subMenuIndex = (itemPouch.length - 1) / 9
		end

		totalList = []
		list = []
		(@subMenuIndex * 9...(@subMenuIndex + 1) * 9).each { |index|
			if (itemPouch[index] == nil)
				list.push("")
			else
				list.push(itemPouch[index])
			end
			if (list.length == 3)
				totalList.push(list)
				list = []
			end
		}
		return totalList
	end


	def createNextMagicSublist
		spells = @hero.spells
		#Checks for appropriate index.
		if @subMenuIndex * 9 >= spells.length
			@subMenuIndex = 0
		elsif @subMenuIndex < 0
			@subMenuIndex = (spells.length - 1) / 9
		end

		totalList = []
		list = []
		(@subMenuIndex * 9...(@subMenuIndex + 1) * 9).each { |index|
			if (spells[index][1])
				list.push(spells[index][0])
			else
				list.push("")
			end
			if (list.length == 3)
				totalList.push(list)
				list = []
			end
		}
		return totalList
	end


	def createEnemyList
		enemyList = []
		@enemyUnits.each { |enemy|
			enemyList.push([enemy])
		}
		return enemyList
	end

	#Cycles through the menu.
	def cycleMenu(menu)
		if menu == @selectItemBox
			@selectItemBox = OptionBox.new(15, 5, 34, 7, 18, 15, 128, 26, createNextItemSublist, @screen)
			menu = @selectItemBox
		elsif menu == @selectMagicBox
			@selectMagicBox = OptionBox.new(15, 5, 34, 7, 18, 15, 128, 26, createNextMagicSublist, @screen)
			menu = @selectMagicBox
		end
		return menu
	end
end








