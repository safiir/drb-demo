require 'drb/drb'

URL = "druby://localhost:8787"

class Logger
  include DRb::DRbUndumped

  def initialize(n, fname)
    @name = n
    @filename = fname
  end

  def log(message)
    File.open(@filename, "a") do |f|
      f.puts("#{Time.now}: #{@name}: #{message}")
    end
  end

end

class LoggerFactory
  def initialize(bdir)
    Dir.mkdir(bdir) unless File.exist?(bdir)
    @basedir = bdir
    @loggers = {}
  end

  def get_logger(name)
    if !@loggers.has_key? name
      fname = name.gsub(/[.\/]/, "_").untaint
      @loggers[name] = Logger.new(name, @basedir + "/" + fname)
    end
    return @loggers[name]
  end

end

FRONT_OBJECT = LoggerFactory.new("dlog")

DRb.start_service(URL, FRONT_OBJECT)
DRb.thread.join