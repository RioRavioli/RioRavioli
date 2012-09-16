
#########################################
#ITEMS
#########################################

class Herb
	MAX_HEAL = 30
	NAME = "herb"
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

	def get_name
		NAME
	end

	def get_a_name
		"a " + NAME
	end
	
	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(player_units)	
	end	
end

class FireSeal
	MAX_DAMAGE = 20
	NAME = "fire seal"
	attr_accessor :target

	def initialize
		@target = nil
	end

	def use(unit)
		@target.each {|indv|
			indv.damage(MAX_DAMAGE)
			puts "#{indv.name} takes #{MAX_DAMAGE} damage!"
			sleep(1)
			if indv.is_dead
				puts "#{indv.name} is dead!"
				sleep(1)
			end
		}
	end

	def get_name
		NAME		
	end	

	def get_a_name
		"a " + NAME
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
	attr_accessor :target

	def initialize
		@target = nil
	end

	def use(unit)
		mag = @target.heal(MAX_HEAL)
		unit.use_mp(MP)
		puts "#{@target.name} heals #{mag} hp!"
		sleep(1)	
		@target = nil
	end
	
	def get_name
		NAME
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
		unit.use_mp(MP)
		puts "#{@target.name} heals #{mag} hp!"
		sleep(1)	
		@target = nil
	end

	def get_name
		NAME
	end	

	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(player_units)	
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

	def use(unit)
		@target.damage(MAX_DAMAGE)
		unit.use_mp(MP)
		puts "#{@target.name} takes #{MAX_DAMAGE} damage!"
		sleep(1)	
		@target = nil
	end
	
	def get_name
		NAME
	end

	def get_target(battle, player_units, enemy_units, dead_units)
		battle.desg_target(enemy_units)	
	end	
end

class Glendola
end

class Gladia
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






