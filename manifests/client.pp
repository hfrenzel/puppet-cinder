# == Class: cinder::client
#
# Installs Cinder python client.
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure state for package.
#   Defaults to 'present'.
#
class cinder::client(
  $package_ensure = 'present',
  $package_name   = $::cinder::params::client_package,
) {

  include ::cinder::deps
  include ::cinder::params

  package { 'python-cinderclient':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => ['openstack', 'cinder-support-package'],
  }

  include '::openstacklib::openstackclient'
}
