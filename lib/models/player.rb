class Player
  attr_accessor :bankroll, :name, :hands

  def initialize(player_name, bankroll)
    @bankroll = bankroll.to_f
    @name = player_name
    @hands = []
  end

  def enough_in_bankroll?(bet, decision)
    case decision
    when 'd', 'sp'
      return true if bankroll >= bet
      return false
    end
    true
  end

  def withdraw_from_bankroll(amount)
    self.bankroll -= amount
  end

  def add_to_bankroll(amount)
    self.bankroll += amount
  end

  def broke?
    bankroll < 5.0
  end

  def there_are_split_hands?
    hands.count > 1
  end
end
