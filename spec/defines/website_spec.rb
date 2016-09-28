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
      is_expected.to contain_file('C:\\inetpub\\test.me.com').with({
        'ensure'  => 'directory',
        'recurse' => false,
        'before'  => 'Dsc_xwebapppool[test.me.com]',
      })
    end
    it do
      is_expected.to contain_acl('C:\\inetpub\\test.me.com').with({
          'purge'           => false,
          'permissions'     => [
            {
              'identity'    => 'S-1-5-17',
              'rights'      => ['read','execute'],
              'perm_type'   => 'allow',
              'child_types' => 'all',
              'affects'     => 'all',
            },
            {
              'identity'    => 'IIS APPPOOL\test.me.com',
              'rights'      => ['read','execute'],
              'perm_type'   => 'allow',
              'child_types' => 'all',
              'affects'     => 'all',
            },
            {
              'identity'    => 'BUILTIN\Users',
              'rights'      => ['read'],
              'perm_type'   => 'allow',
              'child_types' => 'all',
              'affects'     => 'all',
            }
          ],
          'inherit_parent_permissions' => false,
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
