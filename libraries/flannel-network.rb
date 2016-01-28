module Flannel
  module Network

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
