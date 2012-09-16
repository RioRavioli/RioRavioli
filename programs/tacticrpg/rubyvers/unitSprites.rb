
#Sprite for units
#All subunits must have the following:
class UnitSprite
	include Rubygame::Sprites::Sprite

	attr_reader :posx
	attr_reader :posy
	attr_reader :walking

	def initialize(posx, posy)
		@currentImage = @imageIdle1
		@posx = posx
		@posy = posy
		@action = "idle"
		@animation = "idle"
		@frameCountMov = 0
		@frameCountAni = 0
		@walking = false
	end

	def image
		return @currentImage 
	end

	def rect
		return Rubygame::Rect.new(320, 160, 40, 40) 
	end

	def move(direction)
		@action = direction
		@frameCountMov = 0
		@frameMax = 20
		@walking = true
	end

	def animate(direction)
		if @animation == direction
			@frameCountAni = @frameCountAni % 40
		else
			@frameCountAni = 0
		end
		@animation = direction
	end
	
	def depth
		return (0 - @posy)
	end

	def update
		#Update sprite position.
		case @action
		when "right"
			@posx = @posx + 2
		when "left"
			@posx = @posx - 2
		when "up"
			@posy = @posy - 2
		when "down"
			@posy = @posy + 2
		when "idle"
			@walking = false
		end
		
		#Update animation.
		case @animation
		when "down"
			moveAnimation(@imageDown1, @imageDown2)
		when "right"
			moveAnimation(@imageRight1, @imageRight2)
		when "left"
			moveAnimation(@imageLeft1, @imageLeft2)
		when "up"
			moveAnimation(@imageUp1, @imageUp2)
		when "idle"
			if @frameCountAni == 60
				@frameCountAni = 0
			elsif @frameCountAni < 30
				@currentImage = @imageIdle1
			else
				@currentImage = @imageIdle2
			end
		end
		#puts @frameCount
		#puts @frameCountAni

		#Advance frames, and check for end.
		@frameCountAni = @frameCountAni + 1
		if @action != "idle"
			@frameCountMov = @frameCountMov + 1
			if @frameCountMov == @frameMax
				@action = "idle"
				@frameCountMov = 0
				@frameMax = 0
			end
		end
	end

private
	def moveAnimation(image, image2)
			if @frameCountAni == 300
				@animation = "idle"
				@frameCountAni = 0
			elsif @frameCountAni / 20 % 2 == 0
				@currentImage = image
			else
				@currentImage = image2
			end
	end
end

class HeroSprite < UnitSprite
	SCREEN_CENTER_X = 320
	SCREEN_CENTER_Y = 160
	SQUARE_SIZE = 40

	def initialize(posx, posy)
		@imageIdle1 = Rubygame::Surface.load("visuals/hero/hero_idle_1.png")
		@imageIdle2 = Rubygame::Surface.load("visuals/hero/hero_idle_2.png")
		@imageDown1 = Rubygame::Surface.load("visuals/hero/hero_down_1.png")
		@imageDown2 = Rubygame::Surface.load("visuals/hero/hero_down_2.png")
		@imageRight1 = Rubygame::Surface.load("visuals/hero/hero_right_1.png")
		@imageRight2 = Rubygame::Surface.load("visuals/hero/hero_right_2.png")
		@imageLeft1 = Rubygame::Surface.load("visuals/hero/hero_left_1.png")
		@imageLeft2 = Rubygame::Surface.load("visuals/hero/hero_left_2.png")
		@imageUp1 = Rubygame::Surface.load("visuals/hero/hero_up_1.png")
		@imageUp2 = Rubygame::Surface.load("visuals/hero/hero_up_2.png")
		super(posx, posy)
	end

	def rect
		return Rubygame::Rect.new(SCREEN_CENTER_X, SCREEN_CENTER_Y, SQUARE_SIZE, SQUARE_SIZE) 
	end

end
