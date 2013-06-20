module StockTransactioner
  def check_out(param)
    case param
      when :stock_rates
        result = @external_stock_market.check_externally(:stock_rates)
      when :rates
        result = @external_stock_market.check_externally(:rates)
      else
        raise(IllegalArgument)
    end

    result
  end
end