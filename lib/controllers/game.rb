class Game
  attr_accessor :player, :shoe, :continue, :deck_num

  def initialize(bankroll)
    deck_choices = [2, 4, 6, 8]
    @deck_num = deck_num_prompter(deck_choices)
    @shoe = Shoe.new(deck_num)
    @continue = 'y'
    @player = Player.new(Prompt.name_prompt, bankroll)
  end

  def deck_num_prompter(deck_choices)
    decision_made = 0
    until deck_choices.include? decision_made
      decision_made = Prompt.deck_num_prompt(deck_choices)
    end
    decision_made
  end

  def start
    Message.greeting(deck_num)
    do_game
    Message.broke_message(player.bankroll) if player.broke?
    Message.exit_message
  end

  def do_game
    while continue == 'y' && !player.broke?
      player.hands.clear
      round = Round.new(deck_num, shoe, player)
      round.do_round
      self.continue = Prompt.play_again_prompt
      if shoe.current_cards.count <= 15
        shoe.shuffle_up(deck_num)
        Message.shuffle_message
      end
    end
  end
end
