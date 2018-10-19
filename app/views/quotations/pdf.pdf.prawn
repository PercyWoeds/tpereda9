pdf.font "Helvetica"
pdf.font "Helvetica"

pdf.text "Company: #{@quotation.company.name}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Fecha : #{@quotation.code}", :size => 18, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Code: #{@quotation.code}", :size => 13, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@quotation.payable_amount)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "IGV : #{money(@quotation.tax_amount)}", :size => 15, :style => :bold, :spacing => 4
pdf.text "Total: #{money(@quotation.total_amount)}", :size => 15, :style => :bold, :spacing => 4

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "supplier information", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Name: #{@quotation.supplier.name}", :size => 13, :spacing => 4

if @quotation.supplier.email and @quotation.supplier.email != ""
  pdf.text "Email: #{@quotation.supplier.email}", :size => 13, :spacing => 4
end


if @quotation.supplier.phone1 and @quotation.supplier.phone1 != ""
  pdf.text "Phone 1: #{@quotation.supplier.phone1}", :size => 13, :spacing => 4
end

if @quotation.supplier.phone2 and @quotation.supplier.phone2 != ""
  pdf.text "Phone 2: #{@quotation.supplier.phone2}", :size => 13, :spacing => 4
end

if @quotation.supplier.address1 and @quotation.supplier.address1 != ""
  pdf.text "Address 1: #{@quotation.supplier.address1}", :size => 13, :spacing => 4
end

if @quotation.supplier.address2 and @quotation.supplier.address2 != ""
  pdf.text "Address 2: #{@quotation.supplier.address2}", :size => 13, :spacing => 4
end

if @quotation.supplier.city and @quotation.supplier.city != ""
  pdf.text "City: #{@quotation.supplier.city}", :size => 13, :spacing => 4
end

if @quotation.supplier.state and @quotation.supplier.state != ""
  pdf.text "State: #{@quotation.supplier.state}", :size => 13, :spacing => 4
end

if @quotation.supplier.zip and @quotation.supplier.zip != ""
  pdf.text "ZIP: #{@quotation.supplier.zip}", :size => 13, :spacing => 4
end

if @quotation.supplier.country and @quotation.supplier.country != ""
  pdf.text "Country: #{@quotation.supplier.country}", :size => 13, :spacing => 4
end

pdf.text "______________________________________________________________________", :size => 13, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

pdf.text "Details", :size => 15, :style => :bold, :spacing => 4
pdf.text " ", :size => 13, :spacing => 4

for product in @quotation.get_products()
  pdf.text "#{product.name} - Precio: #{money(product.price)} - Quantity: #{product.quantity} - Discount: #{money(product.discount)} - Total: #{money(product.total)}", :size => 13, :spacing => 4
end

pdf.text " ", :size => 13, :spacing => 4

pdf.text "Subtotal: #{money(@quotation.payable_amount)}", :size => 13, :spacing => 4
pdf.text "Tax: #{money(@quotation.tax_amount)}", :size => 13, :spacing => 4
pdf.text "Total: #{money(@quotation.total_amount)}", :size => 13, :spacing => 4

pdf.draw_text "Company: #{@quotation.company.name} - Created with: #{getAppName()} - #{getAppUrl()}", :at => [pdf.bounds.left, pdf.bounds.bottom - 20]