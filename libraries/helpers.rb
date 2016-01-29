#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

module KubernetesCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    def flannel_network?
      if File.exist?('/bin/etcdctl')
        cmd = shell_out!('etcdctl get coreos.com/network/config | sed "/^$/d"', {:returns => [0,2,4]})
        cmd.stderr.empty? && (cmd.stdout != /^Error/)
      else
        puts 'etcdctl is not available'
      end
    end
  end
end

Chef::Recipe.send(:include, KubernetesCookbook::Helpers)
