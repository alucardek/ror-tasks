class Account
  def initialize(account)
    raise(IllegalArgument) if account.nil?
    account.each do |currency, money|
      @currency = currency
      @money = money
    end
  end

  def display
    @money.to_s + " " + @currency.to_s.upcase
  end

  attr_accessor :money
  attr_reader :currency


end