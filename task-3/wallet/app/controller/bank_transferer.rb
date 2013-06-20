module BankTransferer
  def bank_transfer_up(money, bank_name)
    @external_bank.transfer_money_up(money, bank_name)
  end

  def bank_transfer_back(account_number, bank_name, money)
    @external_bank.transfer_money_back(account_number, bank_name, money)
  end
end