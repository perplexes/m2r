require 'timeout'

module MongrelHelper
  attr_accessor :pid

  def setup
    check_mongrel
    Process.spawn("bundle exec foreman start --procfile=example/Procfile", pgroup: true, out: "/dev/null", err: "/dev/null")
    self.pid = read_pid_from_file('example/tmp/mongrel2.pid')
  end

  def teardown
    Process.kill("SIGTERM", pid) if pid
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
end
