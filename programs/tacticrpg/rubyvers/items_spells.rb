
#########################################
#ITEMS
#########################################

class Herb
	MAX_HEAL = 30
	NAME = "herb"

	def use(unit, target, dialogueBox) 
		mag = target.heal(MAX_HEAL)
		dialogueBox.appendText("#{target.name} heals #{mag} HP!")
	end

	def getName
		NAME
	end

	def getAName
		"a " + NAME
	end

	def getTargetType
		return "self"
	end
	
	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(player_units)	
	end	
end

class FireSeal
	MAX_DAMAGE = 20
	NAME = "fire seal"
	attr_accessor :target

	def use(unit, target, dialogueBox)
		mag = target.damage(MAX_DAMAGE)
		dialogueBox.appendText("It does #{MAX_DAMAGE} damage to #{target.name}!") 
	end

	def getName
		NAME		
	end	

	def getAName
		"a " + NAME
	end	

	def getTargetType
		return "all"
	end

	def get_target(battle, player_units, enemy_units, dead_units)
		enemy_units
	end	
end


########################################
#SPELLS
########################################

class Lotia
	MP = 3
	MAX_HEAL = 30
	NAME = "lotia"

	def use(unit, target, dialogueBox)
		mag = target.heal(MAX_HEAL)
		dialogueBox.appendText("#{target.name} heals #{mag} hp!")
	end
	
	def getName
		NAME
	end

	def getTargetType
		return "self"
	end

	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(player_units)	
	end	
end

class Lotiola
	MP = 6
	MAX_HEAL = 60
	NAME = "lotia"
	attr_accessor :target

	def initialize
		@target = nil
	end

	def use(unit)
		mag = @target.heal(MAX_HEAL)
		puts "#{@target.name} heals #{mag} hp!"
		sleep(1)	
		@target = nil
	end

	def getName
		NAME
	end	

	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(player_units)	
	end	
end

class Lotiolalum
	NAME = "lotiolalum"

	def getName
		NAME
	end
end

class Glendol
	MP = 3
	MAX_DAMAGE = 14
	NAME = "glendol"
	attr_accessor :target

	def initialize
		@target = nil
	end

	def use(unit, target, dialogueBox)
		target.damage(MAX_DAMAGE)
		dialogueBox.appendText("#{target.name} takes #{MAX_DAMAGE} damage!")
	end
	
	def getName
		NAME
	end

	def getTargetType
		"all"
	end

	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(enemy_units)	
	end	
end

class Glendola
	NAME = "glendola"

	def getName
		NAME
	end
end

class Gladia
	NAME = "gladia"

	def getName
		NAME
	end
end

########################################
#WEAPONS/ARMOR
########################################

class WoodenSword
	NAME = "wooden sword"
	ATK = 4
	HIT = 90
	VALUE = 40

	def get_atk
		ATK
	end

	def get_hit
		HIT
	end

	def get_value
		VALUE
	end
end

class Clothes
	DFC = 3

	def get_def
		DFC
	end
end






