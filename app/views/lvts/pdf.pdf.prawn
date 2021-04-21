

pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@lvt.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@lvt.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@lvt.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@lvt.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@lvt.supplier.name}", :size => 13, :spacing => 4

if @lvt.supplier.email and @lvt.supplier.email != ""
  pdf.text "Email: #{@lvt.supplier.email}", :size => 13, :spacing => 4
end

if @lvt.supplier.account and @lvt.supplier.account != ""
  pdf.text "Account: #{@lvt.supplier.account}", :size => 13, :spacing => 4
end

if @lvt.supplier.phone1 and @lvt.supplier.phone1 != ""
  pdf.text "Phone 1: #{@lvt.supplier.phone1}", :size => 13, :spacing => 4
end

if @lvt.supplier.phone2 and @lvt.supplier.phone2 != ""
  pdf.text "Phone 2: #{@lvt.supplier.phone2}", :size => 13, :spacing => 4
end

if @lvt.supplier.address1 and @lvt.supplier.address1 != ""
  pdf.text "Address 1: #{@lvt.supplier.address1}", :size => 13, :spacing => 4
end

if @lvt.supplier.address2 and @lvt.supplier.address2 != ""
  pdf.text "Address 2: #{@lvt.supplier.address2}", :size => 13, :spacing => 4
end

if @lvt.supplier.city and @lvt.supplier.city != ""
  pdf.text "City: #{@lvt.supplier.city}", :size => 13, :spacing => 4
end

if @lvt.supplier.state and @lvt.supplier.state != ""
  pdf.text "State: #{@lvt.supplier.state}", :size => 13, :spacing => 4
end

if @lvt.supplier.zip and @lvt.supplier.zip != ""
  pdf.text "ZIP: #{@lvt.supplier.zip}", :size => 13, :spacing => 4
end

if @lvt.supplier.country and @lvt.supplier.country != ""
  pdf.text "Country: #{@lvt.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @lvt.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@lvt.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@lvt.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@lvt.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@lvt.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@lvt.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    