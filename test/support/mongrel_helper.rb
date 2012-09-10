require 'timeout'

module MongrelHelper
  attr_accessor :pid

  def setup
    check_mongrel
    `cd example && m2sh load -config mongrel2.conf --db config.sqlite`
    self.pid = Process.spawn("bundle exec foreman start --procfile=example/Procfile", pgroup: 0, out: "/dev/null", err: "/dev/null")
    wait_for_pid('example/tmp/mongrel2.pid')
  end

  def teardown
    Process.kill("SIGTERM", pid) if pid
    sleep 1
  end

  def check_mongrel
    skip("You must install mongrel2 to run this test") if `which mongrel2`.empty?
  end

  def read_pid_from_file(pidfile)
    pid = nil
    Timeout.timeout(5) do
      loop do
        begin
          pid = File.read(pidfile)
          break unless pid.empty?
        rescue Errno::ENOENT
          sleep(0.25)
          next
        end
      end
      pid.to_i
    end
  rescue Timeout::Error
    raise "Unable to read PID from file #{pidfile}."
  end
  alias :wait_for_pid :read_pid_from_file
end
