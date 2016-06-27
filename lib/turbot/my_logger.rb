class MyLogger
  attr_reader :logger

  def initialize(fname)
    @logger = Logger.new(fname)
  end

  def log(level, msg, stdout: false)
    logger.log(level, msg)
    puts msg if stdout
  end

  def info(msg, stdout: false)
    log(Logger::INFO, msg, stdout: stdout)
  end

  def method_missing(meth, *args, &blk)
    logger.send(meth, *args, &blk)
  end
end
