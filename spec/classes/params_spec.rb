require 'spec_helper'
describe 'iis::params' do

  context "fails on non-Winbloz" do
    let :facts do
      {
        'kernel'  => 'linux',
        'os'      => { 'family' => 'RedHat' }
      }
    end

    it 'is_expected.to explode' do
      expect { catalogue }.to raise_error(Puppet::Error, /This class is only for Windows/)
    end
  end

  context "defaults" do
    let :facts do
      {
        'kernel'  => 'windows',
        'os'      => { 'family' => 'windows' }
      }
    end

    it do is_expected.to contain_class('iis::params') end
  end
end
