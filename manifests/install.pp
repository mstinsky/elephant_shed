# elephant_shed::install
#
# @summary Set dpkg preseed and install elephant shed.
#
# @api private
class elephant_shed::install {

  $preseed_location = '/var/cache/debconf/elephant_shed.preseed'

  apt::source { 'credativ':
    comment  => 'This is the credativ repo, packages.credativ.com',
    location => 'https://packages.credativ.com/public/postgresql/',
    release  => 'stretch-stable',
    repos    => 'main',
    key      => {
      source => 'https://packages.credativ.com/public/postgresql/aptly.key',
      id     => 'DF8FEB3BFD2B5A37B0D1FC419344AE88610AAE1F',
    },
  }

  file { $preseed_location:
    ensure  => file,
    mode    => '0644',
    content => epp("${module_name}/elephant_shed.preseed.epp"),
  }

  package { 'elephant-shed':
    ensure  => installed,
    require => [
      Apt::Source['credativ'],
      File[$preseed_location],
    ],
  }

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '10.6',
  }

  class { 'postgresql::server':
  }

  user { 'root':
    groups  => [
      'elephant-shed',
    ],
    require => Package['elephant-shed'],
  }
}
