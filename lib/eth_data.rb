require 'coin_data'

class EthData
  include CoinData
  def initialize
    @data = fetch_data()
  end

end
