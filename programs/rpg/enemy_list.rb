
class Unit
	attr_reader :name
	attr_reader :current_hp
	attr_reader :current_mp
	attr_reader :atk
	attr_reader :dfc
	attr_reader :spd
	attr_accessor :next_command
	attr_accessor :target
	attr_accessor :next_spell
	attr_reader :item_pouch
	attr_accessor :next_item
	attr_accessor :spells

	def initialize(name, max_hp, max_mp, atk, dfc, spd, item_pouch, spells)
		@name = name
		@max_hp = max_hp
		@max_mp = max_mp
		@atk = atk
		@dfc = dfc
		@spd = spd
		
		@current_hp = @max_hp
		@current_mp = @max_mp
		@next_command = nil
		@target = nil
		@next_spell = nil
		@item_pouch = item_pouch
		@next_item = nil
		@spells = spells
	end

	def damage(mag)
		@current_hp -= mag
		if @current_hp < 0
			@current_hp = 0
		end
	end

	def heal(mag)
		if @current_hp + mag > @max_hp
			mag = @max_hp - @current_hp
		end
		@current_hp += mag
		mag
	end

	def use_mp(mag)
		@current_mp -= mag
		if @current_mp < 0
			@current_mp = 0
		end
	end

	def gain_mp(mag)
		if @current_mp + mag > @max_mp
			mag = @max_mp - @current_mp
		end
		@current_mp += mag
		mag
	end

	def is_dead
		@current_hp <= 0
	end
end

class PlayerUnit < Unit
	attr_accessor :weapon
	attr_accessor :armor

	def initialize(name, max_hp, max_mp, atk, dfc, spd, item_pouch, spells, armor, exp)
		super(name, max_hp, max_mp, atk, dfc, spd, item_pouch, spells)
		@weapon = nil
		@armor = armor
		@exp = exp
	end	
	
	def get_total_atk
		@atk + @weapon.get_atk
	end

	def get_total_def
		@dfc + @armor.get_dfc
	end
end

class EnemyUnit < Unit
end

###########################
#Enemies
###########################

class EvilBird < Unit
	MAX_HP = 12
	MAX_MP = 0
	ATK = 13
	DFC = 2
	SPD = 3
	ITEM_POUCH = nil
	SPELLS = nil 
	EXP = 1
	GOLD = 2

	def initialize(name)
		super(name, MAX_HP, MAX_MP, ATK, DFC, SPD, ITEM_POUCH, SPELLS) 
	end

	def set_commands(player_units, enemy_units)
		@next_command = "attack"
		target = rand(player_units.length)
		@target = player_units[target]
	end
end

class GiantBeetle < Unit
	MAX_HP = 9 
	MAX_MP = 0
	ATK = 10
	DFC = 1
	SPD = 7
	ITEM_POUCH = nil
	SPELLS = nil 
	EXP = 1
	GOLD = 1

	def initialize(name)
		super(name, MAX_HP, MAX_MP, ATK, DFC, SPD, ITEM_POUCH, SPELLS) 
	end

	def set_commands(player_units, enemy_units)
		command = rand(8)
		if command < 7
			@next_command = "attack"
			target = rand(player_units.length)
			@target = player_units[target]
		else
			@next_command = "run"
		end
	end
end

class BabyChimera < Unit
	MAX_HP = 21
	MAX_MP = 3
	ATK = 15
	DFC = 4
	SPD = 5
	ITEM_POUCH = nil
	SPELLS = [Glendol.new] 
	EXP = 3
	GOLD = 2

	def initialize(name)
		super(name, MAX_HP, MAX_MP, ATK, DFC, SPD, ITEM_POUCH, SPELLS) 
	end

	def set_commands(player_units, enemy_units)
		command = rand(3)
		if command < 2
			@next_command = "attack"
			target = rand(player_units.length)
			@target = player_units[target]
		else
			@next_command = "spell"
			@next_spell = "@spells[0]"
			if player_units.length == 1
				@target = player_units[0]
			else
				@player_units.sort_by{|unit| unit.hp}	
				max = player_units.length * 4
				target = rand(max)
				if target > max * 3 / 4
					@target = player_units[0]
				else
					target = rand(player_units.length - 1)
					@target = player_units[target + 1]
				end
			end
		end
	end
end

class CreateEnemies
	def self.get_enemies(area)

		if area == "normal1"
			select = rand(14)
			if select < 4
				[[EvilBird.new("Evil Bird"), EvilBird.new("Evil Bird 2")], "2 Evil Birds"]
			elsif select < 8
				[[EvilBird.new("Evil Bird")], "An Evil Bird"]
			elsif select < 10
				[[GiantBeetle.new("Giant Beetle"), GiantBeetle.new("Giant Beetle 2"), GiantBeetle.new("Giant Beetle 3")], "3 Giant Beetles"] 	
			elsif select < 11
				[[GiantBeetle.new("Giant Beetle"), GiantBeetle.new("Giant Beetle 2"), GiantBeetle.new("Giant Beetle 3"), GiantBeetle.new("Giant Beetle 4")], "4 Giant Beetles"]
			elsif select < 12
				[[EvilBird.new("Evil Bird"), GiantBeetle.new("Giant Beetle"), EvilBird.new("Evil Bird 2")], "2 Evil Birds and a Giant Beetle"]
			elsif select < 14
				[[BabyChimera.new("Baby Chimera")], "A Baby Chimera"]
			end
		end
	end
end








