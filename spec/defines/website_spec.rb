require 'spec_helper'
describe 'iis::website' do
  let :title do
    'puppet.puppet.vm'
  end
  let :pre_condition do
    'class { "iis": }'
  end

  context 'all defaults' do
    let :facts do
      {
        kernel: 'windows',
        os:     { 'family' => 'windows' },
      }
    end

    it do
      is_expected.to contain_file('C:\inetpub\puppet.puppet.vm').with(
        'ensure' => 'directory',
        'before' => 'Dsc_xwebapppool[puppet.puppet.vm]',
      )
    end

    it do
      is_expected.to contain_acl('C:\inetpub\puppet.puppet.vm').with(
        'purge'                    => false,
        'permissions'              => [
          {
            'identity'    => 'S-1-5-17',
            'rights'      => %w[read execute],
            'perm_type'   => 'allow',
            'child_types' => 'all',
            'affects'     => 'all',
          },
          {
            'identity'    => 'IIS APPPOOL\puppet.puppet.vm',
            'rights'      => %w[read execute],
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
          },
        ],
        'inherit_parent_permissions' => false,
      )
    end

    it do
      is_expected.to contain_dsc_xwebapppool('puppet.puppet.vm').with(
        'dsc_ensure'                    => 'Present',
        'dsc_name'                      => 'puppet.puppet.vm',
        'dsc_managedruntimeversion'     => 'v4.0',
        'dsc_logeventonrecycle'         => 'Memory',
        'dsc_restartmemorylimit'        => 1000,
        'dsc_restartprivatememorylimit' => 1000,
        'dsc_identitytype'              => 'ApplicationPoolIdentity',
        'dsc_state'                     => 'Started',
        'before'                        => 'Dsc_xwebsite[puppet.puppet.vm]',
      )
    end

    it do
      is_expected.to contain_dsc_xwebsite('puppet.puppet.vm').with(
        'dsc_ensure'        => 'Present',
        'dsc_name'          => 'puppet.puppet.vm',
        'dsc_state'         => 'Started',
        'dsc_physicalpath'  => 'C:\inetpub\puppet.puppet.vm',
        'dsc_bindinginfo'   => [
          {
            'protocol'  => 'HTTP',
            'port'      => 80,
            'hostname'  => 'puppet.puppet.vm',
          },
        ],
      )
    end
  end

  context 'with app' do
    let :params do
      {
        app_name: 'myapp',
        app_path: 'C:\\sites\\puppet\\app',
      }
    end
    let :facts do
      {
        kernel: 'windows',
        os:     { 'family' => 'windows' },
      }
    end

    it do
      is_expected.to contain_dsc_xwebapplication('myapp').with(
        'dsc_ensure'        => 'Present',
        'dsc_name'          => 'myapp',
        'dsc_physicalpath'  => 'C:\sites\puppet\app',
        'dsc_webapppool'    => 'puppet.puppet.vm',
        'dsc_website'       => 'puppet.puppet.vm',
        'require'           => 'Dsc_xwebsite[puppet.puppet.vm]',
      )
    end
  end

  context 'with different permission on website directory' do
    let :facts do
      {
        kernel: 'windows',
        os:     { 'family' => 'windows' },
      }
    end
    let :params do
      {
        website_directory_acl: {
          group: 'S-1-5-18',
          inherit_parent_permissions: true,
          owner: 'S-1-5-18',
          permissions: [
            {
              'identity' => 'NT SERVICE\TrustedInstaller',
              'rights' => [ 'full' ],
              'affects' => 'self_only',
              'is_inherited' => true,
            },
            {
              'identity' => 'NT SERVICE\TrustedInstaller',
              'rights' => [ 'full' ],
              'child_types' => 'containers',
              'affects' => 'children_only',
              'is_inherited' => true,
            }
          ]
        },
      }
    end

    it do
      is_expected.to contain_acl('C:\inetpub\puppet.puppet.vm').with(
        'group'                      => 'S-1-5-18',
        'inherit_parent_permissions' => true,
        'owner'                      => 'S-1-5-18',
        'permissions'                => [
          {
            'identity'     => 'NT SERVICE\TrustedInstaller',
            'rights'       => %w[full],
            'affects'      => 'self-only',
            'is_inherited' => true
          },
          {
            'identity'     => 'NT SERVICE\TrustedInstaller',
            'rights'       => %w[full],
            'child_types'  => 'containers',
            'affects'      => 'children_only',
            'is_inherited' => true
          },
        ],
      )
    end
  end
end
