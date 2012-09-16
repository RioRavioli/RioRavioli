class BattleManager
	STANDARD_ANI_LENGTH = 45
	STANDARD_ANI_LENGTH_2 = 90
	EXTENDED_ANI_LENGTH = 135
	STAT_UPDATE = 70

	#Total rounds per turn.
	ROUND_COUNT = 4

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
		@deadUnits = []
		@ran = false
		@spellCasted = false
		@itemUsed = false

		#Type: int
		#The current round
		@currentRound = 0
	end


	def setBox(box)
		@dialogueBox = box
	end


	#Sets up a turn.
	def setBattle
		@actionUnits = []
		@enemyUnits.each { |enemy|
			enemy.roundCommand = [["Attack", [@hero]], ["Attack", [@hero]], ["Attack", [@hero]], ["Attack", [@hero]]]
		}
		setRound
		@currentRound = 0
	end


	#Checks for end of turn.
	#Return: boolean
	def isTurnEnded
		return @currentRound == ROUND_COUNT
	end


	#Starts a new action for the next unit.
	def updateAction
		if (isRoundEnded)
			setRound
		else
			unit = @actionUnits.pop
			@actionUnits.push(unit)
			command = unit.roundCommand[@currentRound]
			puts unit.name + "   " + unit.current_hp.to_s + "   " + command[0] + "   " + @currentRound.to_s + "   " + @actionUnits.length.to_s
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
		end
			actionLength = @actionLength
			@actionLength = @actionUnits.length
		return actionLength == @actionLength
	end


	#Checks for changes in the present units.
	def checkChanges
		if @deadUnits.include?(@hero)
			@dialogueBox.setText(["#{@hero.name} will be revived by through his prayers."])
			return "finish"
		elsif @ran
			@dialogueBox.setText(["#{@hero.name} successfully ran away!"])
			return "finish"
		else
			@deadUnits.each { |unit|
				@enemyUnits.delete(unit)
				@actionUnits.delete(unit)
		  	}
			if @enemyUnits.length == 0
				@dialogueBox.setText(["#{@hero.name} defeated all enemies!", "#{@hero.name} gains 1 exp!"])
				return "finish"
			end
			return "combat"
		end
	end


private
   #Sets up the next round.
   def setRound
		@enemyUnits.each { |unit|
			@actionUnits.push(unit)
		}
		@actionUnits.push(@hero)
		@actionLength = @actionUnits.length
		@currentRound += 1
	end


	#Controls the flow of events during the attack sequence.
	def attack
		unit = @actionUnits.pop
		if @actionFrame == 0
			@actionFrameLength = STANDARD_ANI_LENGTH_2
			target = unit.roundCommand[@currentRound][1][0]
			validTarget = !@deadUnits.include?(target)
			if (validTarget)
				damage = applyDamage(unit, target)
				@dialogueBox.setText(["#{unit.name} attacked #{target.name}!", "#{target.name} takes #{damage.to_s} damage!"]) 
				if target.current_hp == 0
					@deadUnits.push(target)
					@dialogueBox.appendText("#{target.name} died!") 
					@actionFrameLength = EXTENDED_ANI_LENGTH
				end
			else
				@dialogueBox.setText(["#{unit.name} attacked #{target.name}!", "But #{target.name} is no longer present!"]) 
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
		targets = unit.roundCommand[@currentRound][2]
		multipleTargets = targets.length > 1
		validTarget = true

		if @actionFrame == 0 
			item = unit.roundCommand[@currentRound][1] 
			if (multipleTargets)
				targets.each { |unit|
					if (@deadUnits.include?(unit))
						targets.delete(unit)
					end
				}
			end
			target = targets[0]
			if !@itemUsed
				@actionFrameLength = STANDARD_ANI_LENGTH_2
				if (!multipleTargets)
					validTarget = !@deadUnits.include?(target)
				end
				@dialogueBox.setText(["", "#{unit.name} used #{item.getName}!"])
				@itemUsed = true
				
			else
				@actionFrameLength = STANDARD_ANI_LENGTH
			end
			item.use(unit, target, validTarget, @dialogueBox)
			unit.itemPouch.delete(item)
			@dialogueBox.next
			if target.current_hp == 0
				@deadUnits.push(target)
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
		targets = unit.roundCommand[@currentRound][2]
		multipleTargets = targets.length > 1
		validTarget = true

		if @actionFrame == 0
			if !@spellCasted
				@actionFrameLength = STANDARD_ANI_LENGTH_2
			else
				@actionFrameLength = STANDARD_ANI_LENGTH
			end
			spell = unit.roundCommand[@currentRound][1]
			if (multipleTargets)
				targets.each { |unit|
					if (@deadUnits.include?(unit))
						targets.delete(unit)
					end
				}
			end
			target = targets[0]
			if !@spellCasted 
				if unit.current_mp < spell.class::MP
					@dialogueBox.setText(["", "#{unit.name} casted #{spell.getName}!"])
					@dialogueBox.appendText("But #{unit.name} did not have enough MP!")
					unit.roundCommand[@currentRound][2] = []
					@spellCasted = false
				else
					@dialogueBox.setText(["", "#{unit.name} casted #{spell.getName}!"])
					unit.use_mp(spell.class::MP)
					@spellCasted = true
				end
				if (!multipleTargets)
					validTarget = !@deadUnits.include?(target)
				end
			end
			if @spellCasted
				spell.use(unit, target, validTarget, @dialogueBox)
				if target.current_hp == 0
					@deadUnits.push(target)
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

		if @actionFrame == STANDARD_ANI_LENGTH || @actionFrame == STANDARD_ANI_LENGTH_2 + 1
			@dialogueBox.next
		end

		if @actionFrame == @actionFrameLength
			@actionFrame = 0
			targets.delete_at(0)
			if targets.length <= 0
				@actionUnits.pop
				@spellCasted = false
			end
		end
	end

	
	#Checks for end of round.
	#Returns: boolean
	def isRoundEnded
		return @actionUnits.empty?
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
