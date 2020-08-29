class NotifyLateInvoiceJob < ActiveJob::Base
  queue_as :default

  

  def perform(user, invoice)
      # Confirm that nothing has changed since the job was scheduled
      if invoice.late? && !invoice.notified?
        InvoiceMailer.with(user: user, invoice: invoice).late_reminder_email

        # Track state for things that should only happen once
        invoice.update(notified: true)
      end
    end

    
end
