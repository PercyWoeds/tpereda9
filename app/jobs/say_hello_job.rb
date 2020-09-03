class SayHelloJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
     puts "say hello "
  end
end
