class SleepStrategy
  attr_reader :min, :variance

  def self.no_sleep
    new(min: 0, variance: 0)
  end

  def initialize(min: 30, variance: 30)
    @min = min
    @variance = variance
  end

  def sleep
    Kernel.sleep(min + rand(variance))
  end
end
