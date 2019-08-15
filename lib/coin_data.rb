require 'httparty'

module CoinData
  @@server_api = 'https://etc.2miners.com/api/stats'

  def get_var(var)
    self.class.instance_variable_get(var.to_sym)
  end

  def B
    get_var(:@B)
  end

  def T
    get_var(:@T)
  end

  def Cname
    get_var(:@C_name)
  end

  def fetch_data
    HTTParty.get(@@server_api)
  end

  def difficulty
    @data['nodes'].first['difficulty']
  end

  def hash_rate
    @data['hashrate']
  end

  def avg_time
    @data['nodes'].first['avgBlockTime']
  end

  def calc_hashrate
    difficulty.to_i / avg_time.to_f
  end

  def per_min
    avg_time.to_f / 60
  end


  def curr_per_min
    B * per_min
  end

  def exchange_rate
    rate = Cryptocompare::Price.find(Cname, 'USDT')[Cname]['USDT']
    sleep(60) # not to spam and be blocked
    rate
  end
  
  def profitability
    exchange_rate / curr_per_min
  end
  
  def record_data
    db.exec("insert into  coin_profitability(profitability, token_name ) values(%f, %s)" % [eth_profitability_per_min.round(9), Cname.downcase]) # downcase is a hack ?
  end
end
