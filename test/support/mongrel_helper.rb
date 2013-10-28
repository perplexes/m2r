require 'timeout'

module MongrelHelper
  attr_accessor :pid

  def setup
    check_mongrel
    `cd example && m2sh load -config mongrel2.conf --db config.sqlite`
    self.pid = Process.spawn("bundle exec foreman start --procfile=example/Procfile", pgroup: 0, out: "/dev/null", err: "/dev/null")
    wait_until_mongrel_responsive
  end

  def wait_until_mongrel_responsive
    client = Net::HTTP.new('localhost', 6767)
    timeout(5) do
      begin
        client.start
      rescue Errno::ECONNREFUSED
        sleep(0.1)
        retry
      end
    end
  end

  def teardown
    Process.kill("SIGTERM", pid) if pid
    sleep 1
  end

  def check_mongrel
    skip("You must install mongrel2 to run this test") if `which mongrel2`.empty?
  end

end
