REQUIRED_RUBY_VERSION='2.6.5'
APP_DIR = File.expand_path("~/automatic-deployed/project")
require 'tmpdir'

def main 
	#install_ruby

	install_required_gems(APP_DIR)
	#setup_systemd_service
end



def install_ruby
	current_dir = Dir.pwd
	Dir.mktmpdir do |directory|
		Dir.chdir(directory)
		check_run('wget','-O','ruby-install-0.7.0.tar.gz','http://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz')
		check_run('tar', '-xzvf','ruby-install-0.7.0.tar.gz')
		Dir.chdir('ruby-install-0.7.0')
		check_run('sudo','make','install')
	end
	Dir.chdir(current_dir)
	check_run('ruby-install','-L')
	check_run('ruby-install','--jobs=4','ruby',REQUIRED_RUBY_VERSION)
end


def check_run (*args)
	comand = args.join(' ')
	result = system(*args)
	unless result
		puts "Comand #{comand} finished with error"
		exit(1)
	end
end

def install_required_gems(application_directory)
	#check_run("bundler -v")		

	Dir.chdir(application_directory)

	bundle_path = File.expand_path("~/.rubies/ruby-#{REQUIRED_RUBY_VERSION}/bin/bundler")
	#check_run("bundle","install")
	check_run(bundle_path,"install")	
end

def patch_path
	ENV['PATH'] = File.expand_path('~/.rubies/ruby-#{REQUIRED_RUBY_VERSION}')
end

def setup_systemd_service
template = File.read(File.expand_path('application.service.erb',__dir__))
#path = ENV['path']
#bundle_path = File.join(ruby_instalation_path,'bundle')
#clojure = binding
#baked_template = ERB.new(template).result(clojure)
#puts baked_template
#file_path = File.join(__dir__,'application.service')
#File.write(file_path,baked_template)
#check_run('sudo','mv',file_path,'/etc/systemd/system')
#check_run ('sudo','systemctl','daemon-reload')
end

def enable_systemd_service
	check_run('sudo','systemctl','enable',SERVICE_NAME)
end

if __FILE__== $0
	main
end
