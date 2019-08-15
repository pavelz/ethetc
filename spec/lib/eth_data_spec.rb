require 'eth_data'

RSpec.describe EthData do
  it 'should be fine' do
    a = nil
    a = EthData.new
    expect(a.hi).to eq(true)
    expect(EthData.hello).to eq(false)
  end
end

