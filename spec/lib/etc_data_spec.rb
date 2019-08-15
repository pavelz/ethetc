require 'etc_data'

RSpec.describe EtcData do
  it 'should return false' do
    expect(EthData).to receive(:hello).once.and_return(false)
    etc = EtcData.new
    expect(etc.hello).to eq(false)
  end
end

