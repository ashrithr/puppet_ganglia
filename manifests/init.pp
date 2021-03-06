# == Class: ganglia
#
# This module will install and manages ganglia, which is  is a scalable distributed
# monitoring system for high-performance computing systems such as clusters and Grids.
#
# === Parameters
#
# None
#
# === Variables
#
# None
#
# === Requires
#
# Nothing.
#
# === Sample Usage
#
# To setup ganglia client:
#
# class {'ganglia::client':
#   cluster => 'hadoop_cluster',
#   owner => 'ankus',
#   unicast_targets => [ {'ipaddress' => '${controllerip}', 'port' => '8649'} ],
#   network_mode  => 'unicast',
# }
#
# (Or) if data is available from hiera
# include ganglia::client
#
# To setup ganglia server and webserver:
#
# class {'ganglia::server':
#     gridname => 'hadoop',
# }
# include ganglia::webserver
#
# (Or) if data is available from hiera
# include ganglia::server
#
# === Authors
#
# Ashrith <ashrith@cloudwick.com>

class ganglia {

  package {'rrdtool':
    ensure => 'installed',
  }

}