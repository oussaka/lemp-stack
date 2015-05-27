dir = File.dirname(File.expand_path(__FILE__))

require 'yaml'
require "#{dir}/puphpet/ruby/deep_merge.rb"

configValues = YAML.load_file("#{dir}/puphpet/config.yaml")

if File.file?("#{dir}/puphpet/config-custom.yaml")
  custom = YAML.load_file("#{dir}/puphpet/config-custom.yaml")
  configValues.deep_merge!(custom)
end

data = configValues['vagrantfile']

Vagrant.require_version '>= 1.6.0'

eval File.read("#{dir}/puphpet/vagrant/Vagrantfile-#{data['target']}")


Vagrant.configure("2") do |config|
  data["synced_folder"].each do |d|
      # run: "always" for executed in every up and provision
      # config.vm.provision "shell", run: "always"
      #   inline: "echo Hello, World"
      # config.vm.provision "shell" do |s|
      #   s.inline = "echo hello"
      # end

      config.vm.provision "shell" do |s|
        s.path  = "./scripts/h5ai.sh"
        # s.args  = d[1]['target']
        s.args  = d
      end
  end
end
