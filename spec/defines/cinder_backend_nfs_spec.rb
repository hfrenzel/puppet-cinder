require 'spec_helper'

describe 'cinder::backend::nfs' do

  let(:title) {'hippo'}

  let :params do
    {
      :nfs_servers                 => ['10.10.10.10:/shares', '10.10.10.10:/shares2'],
      :nfs_mount_attempts          => '4',
      :nfs_mount_options           => 'vers=3',
      :nfs_shares_config           => '/etc/cinder/other_shares.conf',
      :nfs_disk_util               => 'du',
      :nfs_sparsed_volumes         => true,
      :nfs_mount_point_base        => '/cinder_mount_point',
      :nfs_used_ratio              => '0.7',
      :nfs_oversub_ratio           => '0.9',
      :nas_secure_file_operations  => 'auto',
      :nas_secure_file_permissions => 'false',
      :nfs_snapshot_support        => 'true',
      :nfs_qcow2_volumes           => 'true',
    }
  end

  describe 'nfs volume driver' do

    it 'configures nfs volume driver' do
      is_expected.to contain_cinder_config('hippo/volume_backend_name').with(
        :value => 'hippo')
      is_expected.to contain_cinder_config('hippo/volume_driver').with_value(
        'cinder.volume.drivers.nfs.NfsDriver')
      is_expected.to contain_cinder_config('hippo/nfs_shares_config').with_value(
        '/etc/cinder/other_shares.conf')
      is_expected.to contain_cinder_config('hippo/nfs_mount_attempts').with_value(
        '4')
      is_expected.to contain_cinder_config('hippo/nfs_mount_options').with_value(
        'vers=3')
      is_expected.to contain_cinder_config('hippo/nfs_sparsed_volumes').with_value(
        true)
      is_expected.to contain_cinder_config('hippo/nfs_mount_point_base').with_value(
        '/cinder_mount_point')
      is_expected.to contain_cinder_config('hippo/nfs_disk_util').with_value(
        'du')
      is_expected.to contain_cinder_config('hippo/nfs_used_ratio').with_value(
        '0.7')
      is_expected.to contain_cinder_config('hippo/nfs_oversub_ratio').with_value(
        '0.9')
      is_expected.to contain_cinder_config('hippo/nas_secure_file_operations').with_value(
        'auto')
      is_expected.to contain_cinder_config('hippo/nas_secure_file_permissions').with_value(
        'false')
      is_expected.to contain_cinder_config('hippo/nfs_snapshot_support').with_value(
        'true')
      is_expected.to contain_cinder_config('hippo/nfs_qcow2_volumes').with_value(
        'true')
      is_expected.to contain_file('/etc/cinder/other_shares.conf').with(
        :content => "10.10.10.10:/shares\n10.10.10.10:/shares2",
        :require => 'Anchor[cinder::install::end]',
        :notify  => 'Anchor[cinder::service::begin]'
      )
    end
  end

  describe 'nfs backend with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'hippo/param1' => {'value' => 'value1'}}})
    end

    it 'configure nfs backend with additional configuration' do
      is_expected.to contain_cinder_config('hippo/param1').with({
        :value => 'value1',
      })
    end
  end

  describe 'nfs backend with cinder type' do
    before :each do
      params.merge!({:manage_volume_type => true})
    end
    it 'should create type with properties' do
      should contain_cinder_type('hippo').with(:ensure => :present, :properties => ['volume_backend_name=hippo'])
    end
  end

end
