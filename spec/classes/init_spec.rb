require 'spec_helper'
describe 'iis' do

  context "fails on non-Winbloz" do
    let(:facts) {
      {
        'kernel'  => 'linux',
        'os'      => { 'family' => 'RedHat' }
      }
    }

    it 'is_expected.to explode' do
      expect { catalogue }.to raise_error(Puppet::Error, /This class is only for Windows/)
    end
  end

  context 'all defaults' do
    let(:facts) {
      {
        'kernel'  => 'windows',
        'os'      => { 'family' => 'windows' }
      }
    }
    it { is_expected.to contain_class('iis') }
    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_dsc_windowsfeature('IIS').with({
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Server',
      })
    }
    it {
      is_expected.to contain_dsc_windowsfeature('ASP').with({
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-ASP',
        'require'    => 'Dsc_windowsfeature[IIS]',
      })
    }
    it {
      is_expected.to contain_dsc_windowsfeature('ASP.Net_4.5').with({
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Asp-Net45',
        'require'    => 'Dsc_windowsfeature[IIS]',
      })
    }
    it {
      is_expected.to contain_dsc_windowsfeature('IIS_Management_Console').with({
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Mgmt-Console',
        'require'    => 'Dsc_windowsfeature[IIS]',
      })
    }
    it {
      is_expected.to contain_dsc_windowsfeature('IIS_Script_And_Tools').with({
        'dsc_ensure' => 'Present',
        'dsc_name'   => 'Web-Scripting-Tools',
        'require'    => 'Dsc_windowsfeature[IIS]',
      })
    }
  end
end
