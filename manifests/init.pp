# @summary
#   Install and configure Elephant Shed
#
# @example Install PowerDNS-Admin
#   class { '::elephant_shed':
#     pgadmin_email     => 'pgadmin@example.com',
#     pgadmin_password  => 'strongpassword',
#   }
#
# @param pgadmin_email
#   Specifies the login email address for accessing pgadmin4.
# @param pgadmin_password
#   Specifes the password for $pgadmin_email.
class elephant_shed(
  String[1] $pgadmin_email,
  String[1] $pgadmin_password,
  ) {

  contain elephant_shed::install

}
