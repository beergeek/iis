require 'spec_helper'
describe 'iis::website', :type => :define do
  let :pre_condition do
    'class { "iis": }'
  end
  let :facts do
    {
      :kernel => 'windows',
      :os     => { 'family' => 'windows' }
    }
  end

  context "basic" do
    let :title do
      'test.me.com'
    end
    let :params do
      {
        :app_name => 'test.me.com'
      }
    end

    it do is_expected.to contain_class('iis') end
    it do
      is_expected.to contain_dsc_file('C:\\inetpub\\test.me.com').with({
        'dsc_ensure'          => 'Present',
        'dsc_destinationpath' => 'C:\\inetpub\\test.me.com',
        'dsc_recurse'         => false,
        'dsc_type'            => 'Directory',
        'before'              => 'Dsc_xwebapppool[test.me.com]',
      })
    end
    it do
      is_expected.to contain_dsc_xwebapppool('test.me.com').with({
        'dsc_ensure'                    => 'Present',
        'dsc_name'                      => 'test.me.com',
        'dsc_managedruntimeversion'     => 'v4.0',
        'dsc_logeventonrecycle'         => 'Memory',
        'dsc_restartmemorylimit'        => 1000,
        'dsc_restartprivatememorylimit' => 1000,
        'dsc_identitytype'              => 'ApplicationPoolIdentity',
        'dsc_state'                     => 'Started',
        'before'                        => 'Dsc_xwebsite[test.me.com]',
      })
    end
    it do
      is_expected.to contain_dsc_xwebsite('test.me.com').with({
        'dsc_ensure'        => 'Present',
        'dsc_name'          => 'test.me.com',
        'dsc_state'         => 'Started',
        'dsc_physicalpath'  => 'C:\\inetpub\\test.me.com'
      })
    end
    it do
      is_expected.to contain_dsc_xwebapplication('test.me.com').with({
        'dsc_ensure'        => 'Present',
        'dsc_name'          => 'test.me.com',
        'dsc_webapppool'    => 'test.me.com',
        'dsc_physicalpath'  => 'C:\\inetpub\\test.me.com'
      })
    end
  end


end
