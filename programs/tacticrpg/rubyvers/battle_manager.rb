class BattleManager
	STANDARD_ANI_LENGTH = 45
	STANDARD_ANI_LENGTH_2 = 90
	EXTENDED_ANI_LENGTH = 135
	STAT_UPDATE = 70
	attr_reader :enemyUnits
	attr_reader :enemyNames

	#Sets up a new battle.
	def initialize(hero, statsBox)
		enemies = CreateEnemies.get_enemies
		@enemyUnits = enemies[0]
		@enemyNames = enemies[1]
		@hero = hero
		@dialogueBox = nil
		@statsBox = statsBox
		@actionUnits = []
		@inAction = false
		@actionFrame = 0
		@actionLength = 0
		@deadUnit = []
		@ran = false
		@spellCasted = false
		@itemUsed = false
	end

	def setBox(box)
		@dialogueBox = box
	end

	#Sets up a turn.
	def setBattle
		@enemyUnits.each { |enemy|
			enemy.nextCommand = ["Attack", [@hero]]
		}
		@actionUnits.push(@hero)
		@enemyUnits.each { |unit|
			@actionUnits.push(unit)
		}
		@actionLength = @actionUnits.length
	end

	#Checks for end of turn.
	def actionUnitsEmpty
		return @actionUnits.empty?
	end

	#Starts a new action for the next unit.
	def updateAction
		unit = @actionUnits.pop
		@actionUnits.push(unit)
		command = unit.nextCommand
		puts command[0]
		case command[0]
		when "Attack"
			attack
		when "Run"
			run
		when "Item"
			item
		when "Magic"
			magic
		end
		actionLength = @actionLength
		@actionLength = @actionUnits.length
		return actionLength == @actionLength
	end

	#Checks for changes in the present units.
	def checkChanges
		if @deadUnit[0] == @hero
			@dialogueBox.setText(["#{@hero.name} will be revived by through his prayers."])
			return "finish"
		elsif @ran
			@dialogueBox.setText(["#{@hero.name} successfully ran away!"])
			return "finish"
		else
			@deadUnit.each { |unit| @enemyUnits.delete(unit) }
			if @enemyUnits.length == 0
				@dialogueBox.setText(["#{@hero.name} defeated all enemies!", "#{@hero.name} gains 1 exp!"])
				return "finish"
			end
			return "combat"
		end
	end

private
	#Controls the flow of events during the attack sequence.
	def attack
		unit = @actionUnits.pop
		if @actionFrame == 0
			@actionFrameLength = STANDARD_ANI_LENGTH_2
			puts unit.nextCommand[1]
			target = unit.nextCommand[1][0]
			damage = applyDamage(unit, target)
			@dialogueBox.setText(["#{unit.name} attacked #{target.name}!", "#{target.name} takes #{damage.to_s} damage!"]) 
			if target.current_hp == 0
				@deadUnit.push(target)
				@dialogueBox.appendText("#{target.name} died!") 
				@actionFrameLength = EXTENDED_ANI_LENGTH
			end
		end
		if @actionFrame == STAT_UPDATE
			statsUpdate
		end
		@actionUnits.push(unit)
		@dialogueBox.draw
		@actionFrame = @actionFrame + 1
		if @actionFrame == @actionFrameLength
			@actionUnits.pop
			@actionFrame = 0
		end
		if @actionFrame == STANDARD_ANI_LENGTH || @actionFrame == STANDARD_ANI_LENGTH_2 + 1
			@dialogueBox.next
		end
		puts @actionFrame
	end

	#Controls the flow of events during a run sequence.
	def run
		if @actionFrame == 0
			if rand(2) == 0
				@ran = true 
				@actionUnits.pop
			end
			@dialogueBox.setText(["#{@hero.name} tried to run away but was surrounded!"])
			@actionFrameLength = STANDARD_ANI_LENGTH
		end
		@dialogueBox.draw
		@actionFrame += 1
		if @actionFrame == @actionFrameLength
			@actionUnits.pop
			@actionFrame = 0
		end
	end

	#Controls the flow of events during an item sequence.
	def item
		unit = @actionUnits.pop	
		targets = unit.nextCommand[2]
		if @actionFrame == 0 
			item = unit.nextCommand[1] 
			target = targets[0]
			if !@itemUsed
				@actionFrameLength == STANDARD_ANI_LENGTH_2
				@dialogueBox.setText(["", "#{unit.name} used #{item.getName}!"])
				@itemUsed = true
			else
				@actionFrameLength = STANDARD_ANI_LENGTH
			end
			item.use(unit, target, @dialogueBox)
			unit.itemPouch.delete(item)
			@dialogueBox.next
			if target.current_hp == 0
				@deadUnit.push(target)
				@dialogueBox.appendText("#{target.name} died!") 
				@actionFrameLength += STANDARD_ANI_LENGTH 
			end
		elsif @actionFrame == STAT_UPDATE
			statsUpdate
		end
		@actionUnits.push(unit)
		@dialogueBox.draw
		@actionFrame += 1
		if @actionFrame == STANDARD_ANI_LENGTH || @actionFrame == STANDARD_ANI_LENGTH_2 + 1
			@dialogueBox.next
		end
		if @actionFrame == @actionFrameLength
			@actionFrame = 0
			targets.delete_at(0)
			if targets.length == 0
				@actionUnits.pop	
				@itemUsed = false
			end
		end
	end

	#Controls the flow of events during a magic sequence.
	def magic
		unit = @actionUnits.pop
		targets = unit.nextCommand[2]
		if @actionFrame == 0
			if !@spellCasted
				@actionFrameLength = STANDARD_ANI_LENGTH_2
			else
				@actionFrameLength = STANDARD_ANI_LENGTH
			end
			spell = unit.nextCommand[1]
			target = targets[0]

			if !@spellCasted 
				if unit.current_mp < spell.class::MP
					@dialogueBox.setText(["", "#{unit.name} casted #{spell.getName}!"])
					@dialogueBox.appendText("But #{unit.name} did not have enough MP!")
					unit.nextCommand[2] = []
					@spellCasted = false
				else
					@dialogueBox.setText(["", "#{unit.name} casted #{spell.getName}!"])
					unit.use_mp(spell.class::MP)
					@spellCasted = true
				end
			end

			if @spellCasted
				spell.use(unit, target, @dialogueBox)
				if target.current_hp == 0
					@deadUnit.push(target)
					@dialogueBox.appendText("#{target.name} died!") 
					@actionFrameLength += STANDARD_ANI_LENGTH
				end
			end
			@dialogueBox.next
		elsif @actionFrame == STAT_UPDATE
			statsUpdate
		end
		@actionUnits.push(unit)
		@dialogueBox.draw
		@actionFrame += 1
		puts '                     ' + @actionFrameLength.to_s
		if @actionFrame == STANDARD_ANI_LENGTH || @actionFrame == STANDARD_ANI_LENGTH_2 + 1
			@dialogueBox.next
		end
		if @actionFrame == @actionFrameLength
			@actionFrame = 0
			targets.delete_at(0)
			puts '            ' + targets.length.to_s
			if targets.length <= 0
				@actionUnits.pop
				@spellCasted = false
			end
		end
	end

	#Calculates damage accordingly.
	def applyDamage(unit, target)
		damageMag = unit.atk - target.dfc
		target.damage(damageMag)
		return damageMag
	end

	#Updates the status box.
	def statsUpdate
		@statsBox.setList([[@hero.name], ["HP", "MP"], [@hero.current_hp.to_s, @hero.current_mp.to_s]])
		@statsBox.draw
	end
end
