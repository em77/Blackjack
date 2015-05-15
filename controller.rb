require_relative 'model'
require_relative 'view'

class Game
end

class Split
	attr_reader :split_counter

	def initialize
		@split_counter = 2
	end

	if @split_counter == 2
		@decision = "sp"
		@split_bet1 = @base_bet
		until @decision != "sp"
			play(@split_hand1)
		end

		@decision = "sp"
		@split_bet2 = @base_bet
		until @decision != "sp"
			play(@split_hand2)
		end
		@split_hands << @split_hand1 << @split_hand2
	end
	if @split_counter >= 3
		@decision = "sp"
		@split_bet3 = @base_bet
		until @decision != "sp"
			play(@split_hand3)
		end
		@split_hands << @split_hand3
	end
	if @split_counter == 4
		@decision = "sp"
		@split_bet4 = @base_bet
		until @decision != "sp"
			play(@split_hand4)
		end
		@split_hands << @split_hand4
	end
end