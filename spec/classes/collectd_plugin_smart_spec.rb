require 'spec_helper'

describe 'collectd::plugin::smart', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end

  context ':ensure => present and :disks => [\'sda\']' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      { disks: ['sda'] }
    end
    it 'Will create /etc/collectd.d/10-smart.conf' do
      is_expected.to contain_file('smart.load').with(ensure: 'present',
                                                     path: '/etc/collectd.d/10-smart.conf',
                                                     content: "#\ Generated by Puppet\n<LoadPlugin smart>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"smart\">\n  Disk \"sda\"\n  IgnoreSelected false\n</Plugin>\n\n")
    end
  end

  context ':ensure => absent' do
    let :params do
      { disks: ['sda'], ensure: 'absent' }
    end
    it 'Will not create /etc/collectd.d/10-smart.conf' do
      is_expected.to contain_file('smart.load').with(ensure: 'absent',
                                                     path: '/etc/collectd.d/10-smart.conf')
    end
  end

  context ':manage_package => true on osfamily => RedHat' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      {
        manage_package: true
      }
    end
    it 'Will manage collectd-smart' do
      is_expected.to contain_package('collectd-smart').with(ensure: 'present',
                                                            name: 'collectd-smart')
    end
  end

  context ':manage_package => false on osfamily => RedHat' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      {
        manage_package: false
      }
    end
    it 'Will not manage collectd-smart' do
      is_expected.not_to contain_package('collectd-smart').with(ensure: 'present',
                                                                name: 'collectd-smart')
    end
  end

  context ':manage_package => undef on osfamily => RedHat with collectd 5.5 and up' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will manage collectd-smart' do
      is_expected.to contain_package('collectd-smart').with(ensure: 'present',
                                                            name: 'collectd-smart')
    end
  end

  context ':manage_package => undef on osfamily => RedHat with collectd 5.5 and below' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will not manage collectd-smart' do
      is_expected.not_to contain_package('collectd-smart').with(ensure: 'present',
                                                                name: 'collectd-smart')
    end
  end

  context ':disks is not an array' do
    let :params do
      { disks: 'sda' }
    end
    it 'Will raise an error about :disks being a String' do
      is_expected.to compile.and_raise_error(%r{String})
    end
  end
end
