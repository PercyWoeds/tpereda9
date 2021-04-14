class CatfactMailerJob < ActiveJob::Base
 


  queue_as :default

  def perform(*args)
   
      HardWorkerExm.deliver_now
   
  end
end


end
