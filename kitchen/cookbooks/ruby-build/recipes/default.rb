package "git-core" do
  action :install
end

%w[git-core zlib1g-dev libssl-dev libreadline-dev libxml2-dev libxslt1-dev libmysqlclient-dev].each do |name|
  package name do
    action :install
  end
end
