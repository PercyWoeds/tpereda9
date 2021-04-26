

pdf.font "Helvetica"


pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@viaticotbk.subtotal)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Tax: #{money(@viaticotbk.tax)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@viaticotbk.total)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Detraccion: #{money(@viaticotbk.detraccion)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Informacion proveedor ", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@viaticotbk.supplier.name}", :size => 13, :spacing => 4

if @viaticotbk.supplier.email and @viaticotbk.supplier.email != ""
  pdf.text "Email: #{@viaticotbk.supplier.email}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.account and @viaticotbk.supplier.account != ""
  pdf.text "Account: #{@viaticotbk.supplier.account}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.phone1 and @viaticotbk.supplier.phone1 != ""
  pdf.text "Phone 1: #{@viaticotbk.supplier.phone1}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.phone2 and @viaticotbk.supplier.phone2 != ""
  pdf.text "Phone 2: #{@viaticotbk.supplier.phone2}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.address1 and @viaticotbk.supplier.address1 != ""
  pdf.text "Address 1: #{@viaticotbk.supplier.address1}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.address2 and @viaticotbk.supplier.address2 != ""
  pdf.text "Address 2: #{@viaticotbk.supplier.address2}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.city and @viaticotbk.supplier.city != ""
  pdf.text "City: #{@viaticotbk.supplier.city}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.state and @viaticotbk.supplier.state != ""
  pdf.text "State: #{@viaticotbk.supplier.state}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.zip and @viaticotbk.supplier.zip != ""
  pdf.text "ZIP: #{@viaticotbk.supplier.zip}", :size => 13, :spacing => 4
end

if @viaticotbk.supplier.country and @viaticotbk.supplier.country != ""
  pdf.text "Country: #{@viaticotbk.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @viaticotbk.get_services()
  pdf.text "#{product.name} - Price: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@viaticotbk.subtotal)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@viaticotbk.tax)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@viaticotbk.total)}", :size => 13, :spacing => 4
pdf.text "Detraccion : #{money(@viaticotbk.detraccion)}", :size => 13, :spacing => 4
pdf.draw_text "Company: #{@viaticotbk.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]




    