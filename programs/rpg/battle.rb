
require './items_spells'
require './enemy_list'

class BattleManager
	def initialize(player_units, area)
		enemy_units = CreateEnemies.get_enemies(area)
		@enemy_units = enemy_units[0]
		@enemy_names = enemy_units[1]
		@player_units = player_units
		@dead_units = Array.new
		@dead_enemies = Array.new
	end

	def main
		puts "\n\n\n\n\n\n#{@enemy_names} appeared!"
		sleep(1)
		until @enemy_units.empty? or @player_units.empty? 
			command = menu
			@enemy_units.each {|enemy|
				enemy.set_commands(@player_units, @enemy_units)
			}
			puts

			@action_order = Array.new
			if command == "run"
				try = rand(2)
				if try == 0
					puts "Successfully ran away!"
					break
				else
					puts "The escape was surrounded!"
					sleep(1.25)
				end
			else
				@player_units.each {|unit| @action_order.push(unit)}
			end	
			@enemy_units.each {|unit| @action_order.push(unit)}
			@action_order = @action_order.sort_by {|unit| unit.spd}
			@action_order = @action_order.reverse

			@action_order.each {|unit|
				if !unit.is_dead 
					if unit.next_command == "run"
						@enemy_units.delete(unit)
						puts "#{unit.name} ran away!"
						sleep(0.5)
					else
						action(unit)
					end
				end
			}
		end
		if @enemy_units.empty?
			puts "\nAll enemies are defeated!"
		elsif @player_units.empty?
			puts "\nYou are defeated!"
		end	
	end

	def action(unit)
		if unit.next_command == "attack"
			target = unit.target
			damage = apply_damage(unit, target)
			puts "#{unit.name} inflicts #{damage} damage to #{target.name}!"
			sleep(1)
			if target.is_dead
				puts "#{unit.name} defeated #{target.name}!"
				sleep(1)
			end
			unit.target = nil

		elsif unit.next_command == "spell"
			puts "#{unit.name} casts #{unit.next_spell.get_name}"
			unit.next_spell.use(unit)
			unit.next_spell = nil

		else 
			puts "#{unit.name} uses #{unit.next_item.get_a_name}!"
			sleep(0.5)
			unit.next_item.use(unit)
			unit.item_pouch.delete(unit.next_item)
			unit.next_item = nil
		end		

		unit.next_command = nil
		@enemy_units.each {|enemy|
			if enemy.is_dead
				@dead_enemies.push(enemy)
			end
		}
		@dead_enemies.each {|enemy|
			if @enemy_units.include?(enemy)
				@enemy_units.delete(enemy)
			end
		}
		
		@player_units.each {|unit|
			if unit.is_dead
				@dead_units.push(unit)
			end
		}
		@dead_units.each {|unit|
			if @player_units.include?(unit)
				@player_units.delete(unit)
			end
		}
	end

	def menu 
		display_stats
		puts "(F)ight (S)tatus"
		puts "(T)emp (R)un"
		command = gets.chomp
		if command.capitalize.start_with?('F')
			@player_units.each {|unit|
				ready = false
				until ready
					display_stats
					puts "#{unit.name}"
					puts "(A)ttack (S)pell"
					puts "(I)tem   (B)ack"
					command = gets.chomp
					if command.capitalize.start_with?('A')
						target = desg_target(@enemy_units)
						if target
							unit.next_command = "attack"
							unit.target = target
							ready = true
						end	

					elsif command.capitalize.start_with?('S')
						spells = unit.spells
						puts "#{unit.name}'s spells:"
						index = 0
						spells.each {|spell|
							index += 1
							puts "(#{index}) " + spell.get_name
						}

						selection = gets.chomp.to_i
						if selection > 0
							spell = spells[selection - 1]
							target = spell.get_target(self, @player_units, @enemy_units, @dead_units)
							if target
								unit.next_command = "spell"
								unit.next_spell = spell
								spell.target = target
								ready = true
							end
						end

					elsif command.capitalize.start_with?('I')
						items = unit.item_pouch
						puts "#{unit.name}'s pouch:"
						items.each {|item|
							puts item.get_name
						}

						selection = gets.chomp
						is_item = false
						item_index = 0
						items.each {|item|
							if item.get_name == selection
								target = item.get_target(self, @player_units, @enemy_units, @dead_units)
								if target
									unit.next_item = item
									unit.next_command = "item"
									item.target = target
									ready = true
								end
								break
							end
							item_index += 1
						}

					elsif command.capitalize.start_with?('B')
						command = menu
						break
					end
				end
			}
		elsif command.capitalize.start_with?('R')
			command = "run"
		elsif command.capitalize.start_with?('S')
			@enemy_units.each {|enemy|
				puts "#{enemy.name} is watching you cautiously."
			}
			command = menu
		else 
			command = menu
		end
		command
	end

	def apply_damage(unit, enemy)
		damage_mag = unit.atk - enemy.dfc
		enemy.damage(damage_mag)
		damage_mag
	end

	def
		apply_heal(unit)
		heal_mag = 28
		heal_mag = unit.heal(heal_mag)
		heal_mag
	end

	def desg_target(target_list)
		if target_list.length == 1
			return target_list[0]
		else
			index = 0
			target_list.each {|enemy|
				index += 1
				puts "(#{index}) " + enemy.name
			}
			selection = gets.chomp.to_i
			if selection > 0
				return target_list[selection - 1]
			else
				return nil
			end
		end
	end

	def display_stats
		puts
		names = ""
		hp = ""
		mp = ""
		all_players = @player_units.dup.concat(@dead_units)
		all_players.each {|unit|
			names += unit.name
			hp += "HP: #{unit.current_hp}"
			mp += "MP: #{unit.current_mp}"
			(0..10 - names.length).each {
				names += " "
			}
			(0..10 - hp.length).each {
				hp += " "
			}
			(0..10 - mp.length).each {
				mp += " "
			}
		}
		puts "*******************"
		puts names
		puts hp
		puts mp
		puts "*******************"
	end
end

terry_item_pouch = [Herb.new, Herb.new, Herb.new, FireSeal.new]
miana_item_pouch = [Herb.new, Herb.new]
miana_spells = [Lotia.new, Glendol.new]
terry = PlayerUnit.new("Terry", 30, 0, 9, 4, 7, terry_item_pouch, [], Clothes.new, 0) 
miana = PlayerUnit.new("Miana", 24, 13, 5, 3, 9, miana_item_pouch, miana_spells, Clothes.new, 0)
player_units = Array.new
player_units.push(terry)
player_units.push(miana)

BattleManager.new(player_units, "normal1").main

