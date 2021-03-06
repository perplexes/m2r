define :ruby do
  version        = params[:version]
  home_dir       = params[:home]
  ruby_dir       = "#{home_dir}/#{version}"
  ruby_build_dir = "#{home_dir}/ruby-build"
  rubygems       = params[:rubygems]
  owner          = params[:owner]
  bin_dir        = "#{ruby_dir}/bin"
  ruby_bin       = "#{bin_dir}/ruby"
  gem_bin        = "#{bin_dir}/gem"

  if params[:exports]
    hash = params[:exports].inject(node.set){|memo, step| memo[step] }
    hash['ruby_computed'] = {
      'ruby_dir' => ruby_dir,
      'bin_dir'  => bin_dir,
      'gem_bin'  => gem_bin,
      'ruby_bin' => ruby_bin,
    }
  end

  git ruby_build_dir do
    repository "https://github.com/sstephenson/ruby-build.git"
    reference "master"
    action :sync
    user owner
    group owner
  end

  execute "install ruby #{ruby_dir}" do
    command "#{ruby_build_dir}/bin/ruby-build #{version} #{ruby_dir}"
    user owner
    group owner
    not_if { File.exists?(ruby_dir) }
  end

  profile_file = "#{home_dir}/.bashrc"
  ruby_block "append ruby path #{ruby_dir}" do
    path_definition = "export PATH=$HOME/#{version}/bin:$PATH"
    block do
      original_content = File.open(profile_file, 'r').read
      File.open(profile_file, 'w') do |f|
        f.puts "# Generated by chef"
        f.puts path_definition
        f.puts original_content
      end
    end
    not_if { File.read(profile_file).include?(path_definition) }
  end

  if rubygems
    execute "install rubygems - #{bin_dir}" do
      user owner
      cwd home_dir
      command "#{bin_dir}/gem update --system #{rubygems}"
      not_if %Q{test $(#{bin_dir}/gem --version) = "#{rubygems}"}
    end
  end

  execute "#{bin_dir}/gem install bundler --no-ri --no-rdoc" do
    user owner
    not_if "#{bin_dir}/gem list | grep -q bundler"
  end

end
