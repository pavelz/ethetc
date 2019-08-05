#!ruby

require 'httparty'
require 'cryptocompare'

require 'pg'


db = PG.connect(dbname: 'grafana')

  Beth = 2.0
  Teth = 13.48
  Betc = 3.79
  Tetc = 13.95


while(1) do
  eth_data = HTTParty.get('https://etc.2miners.com/api/stats')
  etc_data = HTTParty.get('https://etc.2miners.com/api/stats')

  eth_difficulty = eth_data['nodes'].first['difficulty']
  etc_difficulty = etc_data['nodes'].first['difficulty']

  eth_hashrate = eth_data['hashrate']
  etc_hashrate = etc_data['hashrate']

  eth_avg_time = eth_data['nodes'].first['avgBlockTime']
  etc_avg_time = etc_data['nodes'].first['avgBlockTime']

  puts "avg: eth: #{eth_avg_time} - #{etc_avg_time}"

  eth_calc_hashrate = eth_difficulty.to_i / eth_avg_time.to_f
  puts "eth caclulated hashrate: #{eth_calc_hashrate}"

  etc_calc_hashrate = etc_difficulty.to_i / etc_avg_time.to_f
  puts "etc caclulated hashrate: #{etc_calc_hashrate}"

  puts "ETH difficulty: #{eth_difficulty} - #{eth_hashrate}"
  puts "ETC difficulty: #{etc_difficulty} - #{etc_hashrate}"

  b_eth_per_min = eth_avg_time.to_f / 60
  b_etc_per_min = etc_avg_time.to_f / 60

  eth_per_min = b_eth_per_min * Beth
  etc_per_min = b_etc_per_min * Betc

  puts "eth per min: #{eth_per_min}"
  puts "etc per min: #{etc_per_min}"

  etc_exchange_rate = Cryptocompare::Price.find('ETC', 'USDT')['ETC']['USDT']
  puts "ETC Exchange rate #{etc_exchange_rate}"

  eth_exchange_rate = Cryptocompare::Price.find('ETH', 'USDT')['ETH']['USDT']
  puts "ETH Exchange rate #{eth_exchange_rate}"

  eth_profitability_per_min = eth_per_min * eth_exchange_rate.to_f
  etc_profitability_per_min = etc_per_min * etc_exchange_rate.to_f

  puts "Eth profitability per min: #{eth_profitability_per_min}"
  puts "Etc profitability per min: #{etc_profitability_per_min}"


  db.exec("insert into  coin_profitability(profitability, token_name ) values(%f, 'eth')" % [eth_profitability_per_min.round(9)])
  db.exec("insert into  coin_profitability(profitability, token_name ) values(%f, 'etc')" % [etc_profitability_per_min.round(9)])
  sleep(60)
end

exit(0)
