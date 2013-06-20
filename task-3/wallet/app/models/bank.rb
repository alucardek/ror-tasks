class Bank
  def initialize(bank)
    raise(IllegalArgument) if bank.nil?
    bank.each do |name, account_number|
      raise(IllegalArgument) if account_number.size != 32
      @name = name
      @account_number = account_number
    end

  end

  def display
    @name.to_s + ": " + @account_number.to_s
  end

  attr_reader :name, :account_number

end