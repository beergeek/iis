require 'spec_helper'
describe 'iis' do
  context 'all defaults' do
    let :facts do
      {
        'kernel'  => 'windows',
        'os'      => { 'family' => 'windows' },
      }
    end

    it do is_expected.to contain_class('iis') end
    it do is_expected.to compile.with_all_deps end
    it do
      is_expected.to contain_dsc_windowsfeature('IIS').with(
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Server',
      )
    end
    it do
      is_expected.to contain_dsc_windowsfeature('ASP').with(
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-ASP',
        'require'    => 'Dsc_windowsfeature[IIS]',
      )
    end
    it do
      is_expected.to contain_dsc_windowsfeature('ASP.Net_4.5').with(
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Asp-Net45',
        'require'    => 'Dsc_windowsfeature[IIS]',
      )
    end
    it do
      is_expected.to contain_dsc_windowsfeature('IIS_Management_Console').with(
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Mgmt-Console',
        'require'    => 'Dsc_windowsfeature[IIS]',
      )
    end
    it do
      is_expected.to contain_dsc_windowsfeature('IIS_Script_And_Tools').with(
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Scripting-Tools',
        'require'    => 'Dsc_windowsfeature[IIS]',
      )
    end
  end
end
