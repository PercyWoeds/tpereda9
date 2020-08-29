class SayHelloJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
