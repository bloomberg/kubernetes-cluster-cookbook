Vagrant.configure('2') do |config|
  config.vm.box = 'centos-7.1'

  config.vm.provision :chef_solo do |chef|
    chef.http_proxy = ENV.fetch('http_proxy', nil)
    chef.https_proxy = ENV.fetch('https_proxy', nil)
    chef.no_proxy = ENV.fetch('no_proxy', nil)
    chef.run_list = %w(webops-base::default)
    chef.json.merge!(
      chef_client: {
        config: {
          http_proxy: chef.http_proxy,
          https_proxy: chef.https_proxy,
          no_proxy: chef.no_proxy
        }
      }
    )
  end
end
