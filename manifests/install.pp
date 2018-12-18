# elephant_shed::install
#
# @summary Set dpkg preseed and install elephant shed.
#
# @api private
class elephant_shed::install {

  apt::source { 'credativ':
    comment  => 'This is the credativ repo, packages.credativ.com',
    location => 'https://packages.credativ.com/public/postgresql/',
    release  => 'stretch-stable',
    repos    => 'main',
    key      => {
      source => 'https://packages.credativ.com/public/postgresql/aptly.key',
      id     => 'F797920785697B85B92E8034C86768840A59F867',
    },
  }

  debconf { 'pgadmin4-apache2-email':
    package => 'pgadmin4-apache2',
    item    => 'pgadmin4/email',
    type    => 'string',
    value   => $::elephant_shed::pgadmin_email,
    seen    => true,
  }

  debconf { 'pgadmin4-apache2-password':
    package => 'pgadmin4-apache2',
    item    => 'gadmin4/password',
    type    => 'password',
    value   => $::elephant_shed::pgadmin_password,
    seen    => true,
  }

  package { 'elephant-shed':
    ensure  => installed,
    require => [
      Apt::Source['credativ'],
      Class['Apt::Update'],
      Debconf['pgadmin4-apache2-email'],
      Debconf['pgadmin4-apache2-password'],
    ],
  }

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => $::elephant_shed::postgresql_version,
  }

  class { 'postgresql::server':
  }

}
