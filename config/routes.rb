
  
require 'sidekiq/web'

require 'sidekiq/cron/web'


  Mnygo::Application.routes.draw do

  
  resources :mnto_details
  resources :mntos
  resources :activities
  resources :vuelto_details
  resources :vueltos
  resources :distritos
  resources :provins
  resources :dptos
  resources :viaticolgv_details
  resources :pexes
  resources :viaticotbks
  resources :lvt_details
  resources :lvtsn
  resources :program_examen
  resources :program_exms
  resources :paymentnotice_details
  resources :payment_notices
  resources :autoviatics
  resources :tecnic_revisions
  resources :exmautorizs
  resources :antecedents
  resources :tipo_tramits
  resources :tramits
  resources :proyecto_exams
  resources :proyecto_minero_exams
  resources :proyectominero3s
  resources :proyectominero2s
  resources :supplier_types
  resources :tipocustomers
  resources :couts
  resources :inventarios
  resources :color_vehis
  resources :clase_cats
  resources :config_vehis
  resources :tipo_unidads
  resources :conductors
  resources :cdocuments
  resources :autoviaticos
  resources :supplier_details
  resources :tipoproveedors
  resources :contactopms
  resources :contactopmdetails
  resources :proyecto_mineros
  resources :rqdetails
  resources :requerimientos
  resources :almacens
  resources :almacens
  resources :vacations
  resources :telecredito_details
  resources :telecreditos
  resources :products_grupos
  resources :products_lines
  resources :egresos
  resources :inasists
  resources :manifestships
  resources :cpagar_details
  resources :cpagars
  resources :contratos
  resources :cotizacions
  resources :assistances


  resources :tipocargues
  resources :tickets
  resources :tipocars
  resources :eesses
  resources :lgcs
  resources :service_extensions
  resources :quotation_details
  resources :horas_mes
  resources :tipofaltantes
  resources :faltantes
  resources :tipoventa
  resources :creditos
  resources :varillajes
  resources :afericions
  resources :ventaisla_details
  resources :ventaislas
  resources :tanques
  resources :tanks
  resources :tanks
  resources :islands
  resources :islands
  resources :sellvales
  resources :venta
  resources :ccostos
  resources :destinos
  resources :viatico_details
  resources :quintos
  resources :fiveparameters
  resources :tms

  resources :payrollbonis
  resources :categoria
  resources :bankdetails
  resources :remisions
  resources :valors
  resources :loan_details
  resources :loans
  resources :grado_instruccions
  resources :tipotrabajadors
  resources :ocupacions
  resources :payroll_details
  resources :type_payrolls
  resources :type_payrolls
  resources :payrolls
  resources :categoria
  resources :parameter_details
  resources :parameters
  resources :afps
  resources :dato_laws
  resources :cierres
  resources :gastos
  resources :cegresos
  resources :notacredits
  resources :tipocambios
  resources :ubicas
  resources :bank_acounts
  resources :banks
  resources :bank_acounts
  resources :numeras
  resources :concepts
  resources :quotations
  resources :tranportorders
  resources :ubications
  resources :purchases
  resources :documents
  resources :servicebuys
  
  resources :instruccions
  resources :puntos
  resources :manifests
  resources :trucks
  resources :marcas
  resources :modelos
  resources :subcontrats
  resources :unidads
  resources :payments
  resources :ajusts
  resources :viaticos 

  resources :employees
  resources :pumps
  resources :supplier_payments
  resources :inventory_details
  resources :inventories
  resources :payment_methods
  resources :deliveryships
  resources :declarations 
  resources :inventarios  
  resources :customer_payments
  resources :gastos 
  resources :cierres 
  resources :manifestships

  resources :viaticos do
   
        resources :viatico_details, except: [:index,:show], controller:  "viaticos/viatico_details" do
        collection { get :new2 }    
        collection { get :search_viatico_viatico_details }
        collection { get :agregar }    
      end 


  end
 resources :vueltos do
   
        resources :vuelto_details, except: [:index,:show], controller:  "vueltos/vuelto_details" do
        collection { get :new2 }    
      
        collection { get :agregar }    
      end 


  end


   resources :viaticolgvs do
   
        resources :viaticolgv_details, except: [:index,:show], controller:  "viaticolgvs/viaticolgv_details" do
        collection { get :new2 }   
        collection { get :new3 }    

        collection { get :search_viatico_viatico_details }
        collection { get :agregar } 
      end 

      collection { get :reportes1}
      collection { get :reportes2}
      collection { get :reportes3}


      collection { get :reportes5}

      collection { get :reportes6}
      collection { get :reportes7}
      collection { get :reportes8}




  end



 
   resources :viaticotbks do
    collection { get :search }
    resources :viaticotbk_details, except: [:index,:show], controller: "viaticotbks/viaticotbk_details"

   


  end

 resources :mntos do
   
        resources :mnto_details, except: [:index,:show,:editmultiple], controller:  "mntos/mnto_details" do
       
         collection do 
          put :editmultiple      
          put :updatemultiple      
        end 
 

      end 

  end

  resources :suppliers  do
    resources :supplier_details, except: [:index,:show], controller: "suppliers/supplier_details"
  end

  resources :telecreditos do
    resources :telecredito_details, except: [:index,:show], controller: "telecreditos/telecredito_details"
     collection { post :newtelecredito }
  end

  resources :assistances do 
       collection { get :search }
  end 


  resources :cotizacions do 
       collection { get :search }
  end 


 resources :couts do 
       
        collection { get :update_compro}
        collection { get :buscar}


  end 


  get 'search_manifests', to: 'manifests#search'

  post 'add_manifest', to: 'manifests#add_manifest'


  resources :serviceorders do
     collection { get :update_serviceext }
     collection { get :search }
  end 
  resources :customer_payments do
    collection do
      get 'update_monedas', to: "customer_payments#update_monedas "
    end 
  end 
  
  resources :facturas do 
    collection { get :reportes}
    collection { get :reportes2}
    collection { get :reportes3}
    collection { get :reportes4} #Reporte ventas

    collection { get :reportes5} #Reporte ventas
    
    collection { get :reportes03}
    collection { get :reportes04}
    collection { get :reportes05}
    collection { get :exportxls }
    collection { get :rpt_ccobrar2 }
    collection { get :rpt_ccobrar3}
    collection { get :rpt_ccobrar2_pdf }
    collection { get :rpt_ccobrar3_pdf }
    collection { get :rpt_ccobrar5_pdf }
    collection { get :reportep01 }
    collection { get :rpt_cobranzas_pdf }
    collection { get :reportes_st_1} #Reporte ventas
    collection { get :reportes_st_2} #Reporte ventas
    collection { get :reportes_st_3} #Reporte ventas
    
    collection { get :rpt_cpagar2_pdf } 

    collection {get :rpt_compras1_pdf }
    collection {get :rpt_ingresos_all_pdf}
  
    collection {get :rpt_compras2_pdf }
    collection {get :rpt_ingresos2_all_pdf}

    collection {get :rpt_compras3_pdf }
    collection {get :rpt_ingresos3_all_pdf}

    collection {get :rpt_facturas1_all }
    
    collection {get :rpt_purchase2_all }

    collection {get :rpt_salidas_pdf }
    collection {get :rpt_salidas_all_pdf}
    collection { get  :reporte_asistencia1 }

    collection { get  :reporte_asistencia2 }
    collection { get  :reporte_asistencia3 }

    collection {get :rpt_ost_3 }
    collection {get :rpt_conductor_pdf  }
    collection {get :guias1_pdf }
    collection {get :guias1 }
    
    collection {get :rpt_purchase6  }
    collection {get :rpt_purchase60  }
    collection {get :rpt_purchase61  }
    collection {get :rpt_purchase62  }

    collection { get  :rpt_cpagar40  }
    collection { get  :rpt_cpagar4_pdf}
    collection { get  :rpt_monitoreo}
    collection { get  :do_gestion}
    collection { get  :rpt01}

    collection { get  :rpt_ost_2}
    collection { get  :rpt_ost_2_pdf}


     collection { get  :rpt_purchase_all2b}

      collection { get  :rpt_coti_1 }
      collection { get  :rpt_coti_1_pdf }

      collection { get  :rpt_ventas_pdf }

       collection { get  :rpt_st_pdf }

     collection { get  :rpt_viatico_1 }

      collection { get  :reportes_detraccion }

       collection { get :rpt_examen01 }  
       collection { get :rpt_pex_1 }  

    collection { get  :rpt_viatico_10 }
    collection { get  :rpt_viatico_20 }
    collection { get  :rpt_viatico_30 }



    end 

  resources :voideds do
    collection { post :anular } 


   
   end 

  
    
  resources :stocks do
    collection { get :rpt_stocks5 }  
    collection { get :rpt_stocks6 }  
    collection { get :download_campaign_export }  
   end 
   

  resources :assistances do 
   collection { post :import }

  end  


  resources :activities do 
   collection { post :import }

  end  


  resources :conductors do 
   collection { post :import }

  end  
  resources :requerimientos  do
      collection { get  :do_gestion}
  end 
  
  resources :ventaislas  do
    resources :ventaisla_details, except: [:index,:show], controller: "ventaislas/ventaisla_details"
  end 

  resources :proyecto_exams do
    resources :proyectoexam_details, except: [:index,:show], controller: "proyecto_exams/proyectoexam_details"
     
     collection { post :import }


  end

  
  resources :quotations  do
    resources :quotation_details, except: [:index,:show], controller: "quotations/quotation_details"
  end 
  
  
   resources :facturas do
    resources :factura_details, except: [:index,:show], controller: "facturas/facturas_details"
     collection { post :discontinue }
     collection { post :discontinue2 }
     collection { post :categoria }
    
    collection do 
       put :discontinue 
       put :discontinue2
       put :categoria
       
    end 
    collection { post :print }

    
  end 
    
  resources :dptos do 
   collection { post :import }

  end  


  resources :provins do 
   collection { post :import }

  end  
  resources :distritos do 
   collection { post :import }

  end  

  
  resources :viaticos do 
    collection { get :rpt_viatico_pdf    }
    collection { get :update_inicial}
  end 

  resources :sellvales  do
    collection { post :import }
  end 
  
  resources :tipocambios  do
    collection { post :import }
  end 
    
    
  resources :gastos  do
    collection { post :import }
  end 
    
  resources :tickets  do
    collection { post :import }
  end 
  
  resources :ajust_details  do
    collection { post :import }
  end 
  
  resources :inventarios  do
    collection { post :import }
    collection { post :import2 }
    collection { post :import3 }
  end 
  resources :deliverymines   

    namespace :inventory do
      resources :suppliers
      resources :overviews
      resources :purchase_orders
      resources :receivings
      resources :adjustments
    end


resources :tranportorders do
  collection { get :search   }
  collection { post :rpt_ost_3 } 
end 

resources :tranportorders do

 collection do 
    get  "rpt_ost_2"
  end 
end 

  resources :serviceorders do 

    collection { post  :dograbarins }  
    collection do 
      put :discontinue 
    end 
  end 


  resources :purchaseorders do 
    collection { get :search   }
    collection { get :receive    }
    collection { post :newfactura }
  
  end 
  
  resources :deliveries do
    collection { get :search   }
    collection { post :import }
    

    collection do 
      put :editmultiple      
      put :updatemultiple      
    end 

  end 
  resources :compros do
    collection { post :import  }
  end 
  
  resources :suppliers do
    collection { post :import  }
    collection { post :new2  }
    collection { get :search_ruc  }
  end 

  resources :orders do 
    collection { post :payment  }
    collection { post :imprimir }        
    collection { post :pagar }        
    collection { post :create }        
  end 

  resources :facturas do
    collection { get :search  }
    
    collection { get :generar  }
    collection { post :import }
    collection { get :excel }

    collection do 
      put :discontinue 
    end 
    
  end 
  resources :stores  do 
    collection { post :search }    
  end 

  resources :inventories  do 
    collection { get :addCategory  }    
  end 
  resources :marcas do 
       collection { post :import  }
  end 
  resources :modelos do 
       collection { post :import  }
  end 


  resources :carts
  get 'store/index'

  resources :line_items

  resources :items do
    collection { get :update}
  end 

  get '/404', :to => "errors#not_found"
  get '/422', :to => "errors#unacceptable"
  get '/500', :to => "errors#internal_error" 

  

  if Rails.env.production?
    get '404', to: 'application#page_not_found'
    get '422', to: 'application#server_error'
    get '500', to:  'application#server_error'
end


  resources :carts

  devise_for :users, :controllers => { 
    register: 'new_user_registration' ,
    logout: 'destroy_user_session',
    login: 'user_session'
  }

  devise_scope :user  do 
        match '/sessions/user', to: 'devise/sessions#create', via: :post
  end 


  


  resources :company_user do
    collection { post :new_company_use }
  end 
  
  resources :products   do
    collection { post :import }
    collection { get :search }
    get :who_bought, on: :member
  end 
  resources :products_categories   do
    collection { post :import }

  end 

  resources :customers do
    resources :addresses
    collection { post :import }
    collection { post :import2 }
    collection { post :csv }
  end 
  
  resources :purchases do
     collection { post :datos  }
     collection { get :search } 
     collection { post :import }
     collection { get  :rpt01 } 

  end 
  
  resources :payrolls, only: [:index, :show] do
    resource :download, only: [:show]
  end

  resources :ajusts do
    collection { post :import }
  end 
  
  resources :employees do

       collection { post :import }

       collection { get :update_distritos}
     
      
  end 

get 'employees/update_provincias', as: 'update_provincias'

match 'employees/ac_distritos/:company_id' => 'employees#ac_distritos', via: [:get, :post]

resources :employees


  resources :trucks do
    collection { post :import }
  end 
  
  resources :parameters do
      resources :parameter_details, except: [:index,:show], controller: "parameters/parameter_details"
  end 
  
  resources :loans do
      resources :loan_details, except: [:index,:show], controller: "loans/loan_details"
  end 
 
 
  resources :payrolls do   
  
  resources :payroll_details, except: [:index,:show,:editmultiple], controller: "payrolls/payroll_details"do 
    collection do 
      put :editmultiple      
      put :updatemultiple      
    end 
 end
end 



  resources :pexes do 
   collection { post :import }

  end  


  #Manifiesto busqueda de guias

  get 'search_mines', to: 'deliveries#search'
  post 'add_mine', to: 'delliveries#add_mine'

  get 'my_declarations', to: 'declarations#my_deliveries'
 # get 'search_friends', to: 'deliveries#search'

  get 'search_serviceorders', to: 'purchases#search_serviceorders'
  post 'add_serviceorders', to: 'purchases#add_serviceorders'

  post 'add_friend', to: 'deliveries#add_friend'
  post 'items/update', to: 'items#update'


  # Reports
  match 'companies/reports/monthly_profits/:company_id' => 'reports#monthly_profits', via: [:get, :post]
  match 'companies/reports/profits/:company_id' => 'reports#profits' , via: [:get, :post]
  match 'companies/reports/view_monthly_divisions/:company_id/:division_id' => 'reports#report_view_monthly_divisions', via: [:get, :post]
  match 'companies/reports/monthly_divisions/:company_id' => 'reports#report_monthly_divisions', via: [:get, :post]
  match 'companies/reports/divisions/:company_id' => 'reports#report_divisions', via: [:get, :post]
  match 'companies/reports/view_monthly_locations/:company_id/:location_id' => 'reports#report_view_monthly_locations', via: [:get, :post]
  match 'companies/reports/monthly_locations/:company_id' => 'reports#report_monthly_locations', via: [:get, :post]
  match 'companies/reports/locations/:company_id' => 'reports#report_locations', via: [:get, :post]
  match 'companies/reports/view_monthly_customers/:company_id/:customer_id' => 'reports#report_view_monthly_customers', via: [:get, :post]
  match 'companies/reports/monthly_customers/:company_id' => 'reports#report_monthly_customers', via: [:get, :post]
  match 'companies/reports/customers/:company_id' => 'reports#report_customers', via: [:get, :post]
  match 'companies/reports/view_monthly_products/:company_id/:product_id' => 'reports#report_view_monthly_products', via: [:get, :post]
  match 'companies/reports/monthly_products/:company_id' => 'reports#report_monthly_products', via: [:get, :post]
  match 'companies/reports/products/:company_id' => 'reports#report_products', via: [:get, :post]
  match 'companies/reports/report_products/:company_id' => 'reports#report_products', via: [:get, :post]

  match 'companies/reports/view_monthly_sellers/:company_id/:user_id' => 'reports#report_view_monthly_sellers', via: [:get, :post]
  match 'companies/reports/monthly_sellers/:company_id' => 'reports#report_monthly_sellers', via: [:get, :post]
  match 'companies/reports/sellers/:company_id' => 'reports#report_sellers', via: [:get, :post]
  match 'companies/reports/monthly_sales/:company_id' => 'reports#report_monthly_sales', via: [:get, :post]
  match 'companies/reports/rpt_guias_1/:company_id' => 'reports#rpt_guias_1', via: [:get, :post]
  match 'companies/reports/rpt_guias_2/:company_id' => 'reports#rpt_guias_2', via: [:get, :post]
  match 'companies/reports/rpt_guias_3/:company_id' => 'reports#rpt_guias_3', via: [:get, :post]
  match 'companies/reports/rpt_guias_4/:company_id' => 'reports#rpt_guias_4', via: [:get, :post]

  match 'companies/reports_guias/:company_id' => 'reports#reports_guias', via: [:get, :post]
  match 'companies/reports/rpt_ost_1/:company_id' => 'reports#rpt_ost_1', via: [:get, :post]
  match 'companies/reports/rpt_ost_2/:company_id' => 'reports#rpt_ost_2', via: [:get, :post]
  match 'companies/reports/rpt_ost_3/:company_id' => 'reports#rpt_ost_3', via: [:get, :post]

   match 'companies/reports/rpt_coti_all/:company_id' => 'reports#rpt_coti_all', via: [:get, :post]
match 'companies/reports/rpt_coti_1_pdf/:company_id' => 'reports#rpt_coti_1_pdf', via: [:get, :post]

        
  match 'companies/reports_compras/:company_id' => 'reports#reports_compras', via: [:get, :post]
  match 'companies/reports/reports_cpagar/:company_id' => 'reports#reports_cpagar', via: [:get, :post]
  match 'companies/reports/reports_cventas/:company_id' => 'reports#reports_cventas', via: [:get, :post]
  match 'companies/reports/reports_calmacen/:company_id' => 'reports#reports_calmacen', via: [:get, :post]
  match 'companies/reports/reports_basedatos/:company_id' => 'reports#reports_basedatos', via: [:get, :post]
  match 'companies/reports/reports_basedatosexm/:company_id' => 'reports#reports_basedatosexm', via: [:get, :post]
  
  match 'companies/reports/reports_cexamen/:company_id' => 'reports#reports_cexamen', via: [:get, :post]
  match 'companies/reports/rpt_conductor_pdf/:company_id' => 'reports#rpt_conductor_pdf', via: [:get, :post]
 
  match 'companies/reports/reports_iconsultas/:company_id' => 'reports#reports_iconsultas', via: [:get, :post]
  
  
  match 'companies/reports/reports_lgc/:company_id' => 'reports#reports_lgc', via: [:get, :post]

  match 'companies/reports/product_all/:company_id' => 'reports#product_all', via: [:get, :post]
  match 'companies/reports/rpt_serviceorder_all/:company_id' => 'reports#rpt_serviceorder_all', via: [:get, :post]
  match 'companies/reports/rpt_purchases_all/:company_id' => 'reports#rpt_purchases_all', via: [:get, :post]
  match 'companies/reports/rpt_purchase2_all/:company_id' => 'reports#rpt_purchase2_all', via: [:get, :post]
  match 'companies/reports/rpt_purchase3_all/:company_id' => 'reports#rpt_purchase3_all', via: [:get, :post]
  match 'companies/reports/rpt_purchase4_all/:company_id' => 'reports#rpt_purchase4_all', via: [:get, :post]
  match 'companies/reports/rpt_purchase5_all/:company_id' => 'reports#rpt_purchase5_all', via: [:get, :post]
  match 'companies/reports/rpt_purchase6_all/:company_id' => 'reports#rpt_purchase6_all', via: [:get, :post]
   match 'companies/reports/rpt_purchase_all2/:company_id' => 'reports#rpt_purchase_all2', via: [:get, :post]
  match 'companies/reports/rpt_purchase60_all/:company_id' => 'reports#rpt_purchase60_all', via: [:get, :post]
  match 'companies/reports/rpt_purchase61_all/:company_id/:usuario' => 'reports#rpt_purchase61_all', via: [:get, :post]

  match 'companies/reports/rpt_purchaseorder_all/:company_id' => 'reports#rpt_purchaseorder_all', via: [:get, :post]
  match 'companies/reports/rpt_purchaseorder2_all/:company_id' => 'reports#rpt_purchaseorder2_all', via: [:get, :post]
  match 'companies/reports/rpt_purchaseorder3_all/:company_id' => 'reports#rpt_purchaseorder3_all', via: [:get, :post]
  match 'companies/reports/rpt_purchaseorder4_all/:company_id' => 'reports#rpt_purchaseorder4_all', via: [:get, :post]


  match 'companies/reports/reports_ccobrar/:company_id' => 'reports#reports_ccobrar', via: [:get, :post]  

  match 'companies/reports/rpt_cpagar1_all/:company_id' => 'reports#rpt_cpagar1_all', via: [:get, :post]  
  match 'companies/reports/rpt_cpagar2_pdf/:company_id' => 'reports#rpt_cpagar2_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_cpagar3_pdf/:company_id' => 'reports#rpt_cpagar3_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_cpagar4_pdf/:company_id' => 'reports#rpt_cpagar4_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_cpagar5_pdf/:company_id' => 'reports#rpt_cpagar5_pdf', via: [:get, :post]  

  match 'companies/reports/rpt_ccobrar2_pdf/:company_id' => 'reports#rpt_ccobrar2_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar3_pdf/:company_id' => 'reports#rpt_ccobrar3_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar4_pdf/:company_id' => 'reports#rpt_ccobrar4_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar5_pdf/:company_id' => 'reports#rpt_ccobrar5_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar6_pdf/:company_id' => 'reports#rpt_ccobrar6_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar7_pdf/:company_id' => 'reports#rpt_ccobrar7_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar8_pdf/:company_id' => 'reports#rpt_ccobrar8_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar9_pdf/:company_id' => 'reports#rpt_ccobrar9_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar10_pdf/:company_id' => 'reports#rpt_ccobrar10_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_ccobrar11_pdf/:company_id' => 'reports#rpt_ccobrar11_pdf', via: [:get, :post]  

  match 'companies/reports/rpt_calmacen1_pdf/:company_id' => 'reports#rpt_calmacen1_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen2_pdf/:company_id' => 'reports#rpt_calmacen2_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen3_pdf/:company_id' => 'reports#rpt_calmacen3_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen4_pdf/:company_id' => 'reports#rpt_calmacen4_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen5_pdf/:company_id' => 'reports#rpt_calmacen5_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen6_pdf/:company_id' => 'reports#rpt_calmacen6_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen7_pdf/:company_id' => 'reports#rpt_calmacen7_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_calmacen8_pdf/:company_id' => 'reports#rpt_calmacen8_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen9_pdf/:company_id' => 'reports#rpt_calmacen9_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen10_pdf/:company_id' => 'reports#rpt_calmacen10_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen11_pdf/:company_id' => 'reports#rpt_calmacen11_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen12_pdf/:company_id' => 'reports#rpt_calmacen12_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen13_pdf/:company_id' => 'reports#rpt_calmacen13_pdf', via: [:get, :post]

  match 'companies/reports/rpt_calmacen14_pdf/:company_id' => 'reports#rpt_calmacen14_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen15_pdf/:company_id' => 'reports#rpt_calmacen15_pdf', via: [:get, :post]
  match 'companies/reports/rpt_calmacen16_pdf/:company_id' => 'reports#rpt_calmacen16_pdf', via: [:get, :post]
  
   match 'companies/reports/rpt_calmacen20_pdf/:company_id' => 'reports#rpt_calmacen20_pdf', via: [:get, :post]  
 
  match 'companies/reports/rpt_cajust1_pdf/:company_id' => 'reports#rpt_cajust1_pdf', via: [:get, :post]
  match 'companies/reports/rpt_viatico_pdf/:company_id' => 'reports#rpt_viatico_pdf', via: [:get, :post]
  
  match 'companies/reports/rpt_facturas_all/:company_id' => 'reports#rpt_facturas_all', via: [:get, :post]
  match 'companies/reports/rpt_facturas_dt/:company_id' => 'reports#rpt_facturas_dt', via: [:get, :post]
  

  match 'companies/reports/rpt_facturas_all2/:company_id' => 'reports#rpt_facturas_all2', via: [:get, :post]
  match 'companies/reports/rpt_facturas_res/:company_id' => 'reports#rpt_facturas_res', via: [:get, :post]
  match 'companies/reports/rpt_st_res/:company_id' => 'reports#rpt_st_res', via: [:get, :post]



  match 'companies/reports/rpt_facturas_3/:company_id' => 'reports#rpt_facturas_3', via: [:get, :post]
  match 'companies/reports/rpt_facturas_4/:company_id' => 'reports#rpt_facturas_4', via: [:get, :post]
  match 'companies/reports/rpt_facturas_5/:company_id' => 'reports#rpt_facturas_5', via: [:get, :post]
  match 'companies/reports/rpt_facturas_monitoreo/:company_id' => 'reports#rpt_facturas_monitoreo', via: [:get, :post]

  
  match 'companies/reports/rpt_purchase_all/:company_id' => 'reports#rpt_purchase_all', via: [:get, :post]
  match 'companies/reports/rpt_product_all/:company_id' => 'reports#rpt_product_all', via: [:get, :post]

  match 'companies/reports/sales/:company_id' => 'reports#report_sales', via: [:get, :post]
  match 'companies/reports/:company_id' => 'reports#reports', via: [:get, :post]

  match 'companies/reports/rpt_caja2_pdf/:company_id' => 'reports#rpt_caja2_pdf', via: [:get, :post]
  match 'companies/reports/rpt_viatico_pdf/:company_id' => 'reports#rpt_viatico_pdf', via: [:get, :post]
  
  match 'companies/reports/reports_parte/:company_id' => 'reports#reports_parte', via: [:get, :post]    
  match 'companies/reports/rpt_parte_1/:company_id' => 'reports#rpt_parte_1', via: [:get, :post]    
  match 'companies/reports/rpt_parte_2/:company_id' => 'reports#rpt_parte_2', via: [:get, :post]    
  match 'companies/reports/rpt_parte_3/:company_id' => 'reports#rpt_parte_3', via: [:get, :post]    

  match 'companies/reports/rpt_st_all/:company_id' => 'reports#rpt_st_all', via: [:get, :post]    
  match 'companies/reports/rpt_st_all2/:company_id' => 'reports#rpt_st_all2', via: [:get, :post]    
  match 'companies/reports/rpt_st_all3/:company_id' => 'reports#rpt_st_all3', via: [:get, :post]  

  match 'companies/reports/rpt_examen01_pdf/:company_id' => 'reports#rpt_examen01_pdf', via: [:get, :post]  
  match 'companies/reports/rpt_pex_1/:company_id' => 'reports#rpt_pex_1', via: [:get, :post]  


  match 'companies/reports/reports_caja/:company_id' => 'reports#reports_caja', via: [:get, :post]    
  
  match 'companies/reports/rpt_caja_1/:company_id' => 'reports#rpt_caja_1', via: [:get, :post]    
  
  match 'companies/reports/rpt_caja_2/:company_id' => 'reports#rpt_caja_2', via: [:get, :post]    
  
  match 'companies/reports/rpt_caja_3/:company_id' => 'reports#rpt_caja_3', via: [:get, :post]    
  
  match 'companies/reports/rpt_caja_4/:company_id' => 'reports#rpt_caja_4', via: [:get, :post]    
  
  match 'companies/reports/rpt_caja_5/:company_id' => 'reports#rpt_caja_5', via: [:get, :post]    
  
  match 'companies/reports/rpt_caja_6/:company_id' => 'reports#rpt_caja_6', via: [:get, :post]    
  

  # Company users

  match 'company_users/ac_users' => 'company_users#ac_users', via: [:get, :post]
  match 'new_company_use', to: 'company_users#new', via: [:get]
  match 'company_list', to: 'company_users#list_users', via: [:get, :post] 
  resources :company_users
  
  match 'compros/list_items/:company_id' => 'compros#list_items', via: [:get, :post]
  match 'compros/ac_products/:company_id' => 'compros#ac_products', via: [:get, :post]
  
  match 'compros/ac_unidads/:company_id' => 'compros#ac_unidads', via: [:get, :post]

  match 'compros/ac_user/:company_id' => 'compros#ac_user', via: [:get, :post]
  match 'compros/ac_purchases/:company_id' => 'compros#ac_purchases', via: [:get, :post]
  match 'compros/ac_suppliers/:company_id' => 'compros#ac_suppliers', via: [:get, :post]


  match 'compros/new/:company_id' => 'compros#new', via: [:get, :post]
  match 'compros/do_email/:id' => 'compros#do_email', via: [:get, :post]
  match 'compros/email/:id' => 'compros#email', via: [:get, :post]
  match 'compros/pdf/:id' => 'compros#pdf', via: [:get, :post]
  match 'companies/compros/:company_id' => 'compros#list_compros', via: [:get, :post]
  resources :compros 

  # Invoices
  match 'invoice/add_kit/:company_id' => 'invoices#add_kit', via: [:get, :post]
  match 'invoices/list_items/:company_id' => 'invoices#list_items', via: [:get, :post]
  match 'invoices/ac_kit/:company_id' => 'invoices#ac_kit', via: [:get, :post]
  match 'invoices/ac_products/:company_id' => 'invoices#ac_products', via: [:get, :post]
  match 'invoices/ac_user/:company_id' => 'invoices#ac_user', via: [:get, :post]
  match 'invoices/ac_customers/:company_id' => 'invoices#ac_customers', via: [:get, :post]
  match 'invoices/new/:company_id' => 'invoices#new', via: [:get, :post]
  
  match 'invoices/do_email/:id' => 'invoices#do_email', via: [:get, :post]
  match 'invoices/do_process/:id' => 'invoices#do_process', via: [:get, :post]
  match 'invoices/email/:id' => 'invoices#email', via: [:get, :post]
  match 'invoices/pdf/:id' => 'invoices#pdf', via: [:get, :post]
  match 'companies/invoices/:company_id' => 'invoices#list_invoices', via: [:get, :post]
  resources :invoices

# Invoices
  match 'output/add_kit/:company_id' => 'outputs#add_kit', via: [:get, :post]
  match 'outputs/list_items/:company_id' => 'outputs#list_items', via: [:get, :post]
  match 'outputs/ac_kit/:company_id' => 'outputs#ac_kit', via: [:get, :post]
  match 'outputs/ac_products/:company_id/:almacen_id' => 'outputs#ac_products', via: [:get, :post]
  match 'outputs/ac_user/:company_id' => 'outputs#ac_user', via: [:get, :post]
  match 'outputs/ac_customers/:company_id' => 'outputs#ac_customers', via: [:get, :post]
  match 'trucks/ac_placas/:company_id' => 'trucks#ac_placas', via: [:get, :post]
  match 'outputs/new/:company_id/:almacen_id' => 'outputs#new', via: [:get, :post]
  
  match 'outputs/do_email/:id' => 'outputs#do_email', via: [:get, :post]
  match 'outputs/do_process/:id' => 'outputs#do_process', via: [:get, :post]
  match 'outputs/go_salidas/:id' => 'outputs#go_salidas', via: [:get, :post]

  match 'outputs/email/:id' => 'outputs#email', via: [:get, :post]
  match 'outputs/pdf/:id' => 'outputs#pdf', via: [:get, :post]
  match 'outputs/rpt_salidas_all_pdf/:id' => 'outputs#rpt_salidas_all_pdf', via: [:get, :post]
  match 'outputs/rpt_salidas2_all_pdf/:id' => 'outputs#rpt_salidas2_all_pdf', via: [:get, :post]
  match 'outputs/rpt_salidas3_all_pdf/:id' => 'outputs#rpt_salidas3_all_pdf', via: [:get, :post]
  match 'outputs/rpt_salidas4_all_pdf/:id' => 'outputs#rpt_salidas4_all_pdf', via: [:get, :post]
  
  match 'companies/outputs/:company_id' => 'outputs#list_outputs', via: [:get, :post]
  
  resources :outputs

# Invoices
  
  match 'bankdetails/list_items/:company_id' => 'bankdetails#list_items', via: [:get, :post]
  match 'bankdetails/new/:company_id' => 'bankdetails#new', via: [:get, :post]
  match 'bankdetails/rpt_salidas_all_pdf/:id' => 'bankdetails#rpt_bankdetails_all_pdf', via: [:get, :post]
  match 'companies/bankdetails/:company_id' => 'bankdetails#index', via: [:get, :post]
  resources :bankdetails


# Viaticos
  
  match 'viaticos/list_items/:company_id' => 'viaticos#list_items', via: [:get, :post]
  match 'viaticos/ac_documentos/:company_id' => 'viaticos#ac_documentos', via: [:get, :post]
  match 'viaticos/ac_cajas/:company_id' => 'viaticos#ac_cajas', via: [:get, :post]
  match 'viaticos/ac_osts/:company_id' => 'viaticos#ac_osts', via: [:get, :post]
  match 'viaticos/ac_employees/:company_id' => 'viaticos#ac_employees', via: [:get, :post]
  match 'viaticos/ac_user/:company_id' => 'viaticos#ac_user', via: [:get, :post]
  match 'viaticos/ac_customers/:company_id' => 'viaticos#ac_customers', via: [:get, :post]
  match 'viaticos/new/:company_id' => 'viaticos#new', via: [:get, :post]
  match 'viaticos/new2/:company_id' => 'viaticos#new2', via: [:get, :post]
  match 'viaticos/do_email/:id' => 'viaticos#do_email', via: [:get, :post]
  match 'viaticos/do_process/:id' => 'viaticos#do_process', via: [:get, :post]
  match 'viaticos/email/:id' => 'viaticos#email', via: [:get, :post]
  match 'viaticos/pdf/:id' => 'viaticos#pdf', via: [:get, :post]
  match 'companies/viaticos/:id' => 'viaticos#list_viaticos', via: [:get, :post]
  
  match 'viaticos/rpt_viatico_pdf/:company_id' => 'viaticos#rpt_viatico_pdf', via: [:get, :post]
  match 'viaticos/rpt_viatico_pdf' => 'viaticos#rpt_viatico_pdf', via: [:get, :post]
  match 'viaticos/reportxls/:company_id' => 'viaticos#reportxls', via: [:get]



# Viatico tbk 
  
  match 'viaticotbks/list_items/:company_id' => 'viaticotbks#list_items', via: [:get, :post]
  match 'viaticotbks/ac_documentos/:company_id' => 'viaticotbks#ac_documentos', via: [:get, :post]
  match 'viaticotbks/ac_cajas/:company_id' => 'viaticotbks#ac_cajas', via: [:get, :post]
  match 'viaticotbks/ac_osts/:company_id' => 'viaticotbks#ac_osts', via: [:get, :post]
  match 'viaticotbks/ac_employees/:company_id' => 'viaticotbks#ac_employees', via: [:get, :post]
  match 'viaticotbks/ac_user/:company_id' => 'viaticotbks#ac_user', via: [:get, :post]
  match 'viaticotbks/ac_customers/:company_id' => 'viaticotbks#ac_customers', via: [:get, :post]
  match 'viaticotbks/new/:company_id' => 'viaticotbks#new', via: [:get, :post]
  match 'viaticotbks/new2/:company_id' => 'viaticotbks#new2', via: [:get, :post]
  match 'viaticotbks/do_email/:id' => 'viaticotbks#do_email', via: [:get, :post]
  match 'viaticotbks/do_process/:id' => 'viaticotbks#do_process', via: [:get, :post]
  match 'viaticotbks/email/:id' => 'viaticotbks#email', via: [:get, :post]
  match 'viaticotbks/pdf/:id' => 'viaticotbks#pdf', via: [:get, :post]
  match 'companies/viaticotbks/:id' => 'viaticotbks#list_viaticos', via: [:get, :post]
  
  match 'viaticotbks/rpt_viatico_pdf/:company_id' => 'viaticotbks#rpt_viatico_pdf', via: [:get, :post]
  match 'viaticotbks/rpt_viatico_pdf' => 'viaticotbks#rpt_viatico_pdf', via: [:get, :post]
  match 'viaticotbks/reportxls/:company_id' => 'viaticotbks#reportxls', via: [:get]
  match 'viaticotbks/search' => 'viaticotbks#search', via: [:get, :post]



# Viaticos
  
  match 'viaticolgvs/list_items/:company_id' => 'viaticolgvs#list_items', via: [:get, :post]
  match 'viaticolgvs/ac_documentos/:company_id' => 'viaticolgvs#ac_documentos', via: [:get, :post]
  match 'viaticolgvs/ac_cajas/:company_id' => 'viaticolgvs#ac_cajas', via: [:get, :post]
  match 'viaticolgvs/ac_osts/:company_id' => 'viaticolgvs#ac_osts', via: [:get, :post]
  match 'viaticolgvs/ac_employees/:company_id' => 'viaticolgvs#ac_employees', via: [:get, :post]
  match 'viaticolgvs/ac_user/:company_id' => 'viaticolgvs#ac_user', via: [:get, :post]
  match 'viaticolgvs/ac_customers/:company_id' => 'viaticolgvs#ac_customers', via: [:get, :post]
  match 'viaticolgvs/new/:company_id' => 'viaticolgvs#new', via: [:get, :post]
  match 'viaticolgvs/new2/:company_id' => 'viaticolgvs#new2', via: [:get, :post]

  match 'viaticolgvs/do_email/:id' => 'viaticolgvs#do_email', via: [:get, :post]
  match 'viaticolgvs/do_process/:id' => 'viaticolgvs#do_process', via: [:get, :post]
  match 'viaticolgvs/email/:id' => 'viaticolgvs#email', via: [:get, :post]
  match 'viaticolgvs/pdf/:id' => 'viaticolgvs#pdf', via: [:get, :post]
  match 'companies/viaticolgvs/:company_id' => 'viaticolgvs#list_viaticos', via: [:get, :post]
  
  match 'viaticolgvs/rpt_viatico_pdf/:company_id' => 'viaticolgvs#rpt_viatico_pdf', via: [:get, :post]
  match 'viaticolgvs/rpt_viatico_pdf' => 'viaticolgvs#rpt_viatico_pdf', via: [:get, :post]
  match 'viaticolgvs/reportxls/:company_id' => 'viaticolgvs#reportxls', via: [:get]




get 'search', to: 'viaticotbks#search'

post 'add_friend', to: 'viaticotbks#add_friend'

  resources :viaticotbks 

 match 'couts/newviatico/:id' => 'couts#newviatico', via: [:get, :post]

 match 'couts/new2/:id' => 'couts#new2', via: [:get, :post]
 match 'couts/list_couts/:id' => 'couts#list_couts', via: [:get, :post]
 match 'couts/newviatico2/:id' => 'couts#newviatico2', via: [:get, :post]

 match 'cout/pdf/:id' => 'couts#pdf', via: [:get, :post]
 match 'cout/pdf1/:id' => 'couts#pdf1', via: [:get, :post]

  match 'companies/couts/do_cargar/:company_id' => 'couts#do_cargar', via: [:get, :post]
  match 'couts/do_crear/:id'   => 'couts#do_crear', via: [:get, :post]
  match 'companies/couts/do_cargar2/:company_id' => 'couts#do_cargar2', via: [:get, :post]
  match 'couts/do_crear2/:id'   => 'couts#do_crear2', via: [:get, :post]
  match 'vueltos/list_items3/:id' => 'vueltos#list_items3', via: [:get, :post]
  match 'vueltos/ac_couts/:company_id' => 'vueltos#ac_couts', via: [:get, :post]  
  match 'vueltos/pdf/:id' => 'vueltos#pdf', via: [:get, :post]
  match 'vueltos/pdf2/:id' => 'vueltos#pdf2', via: [:get, :post]
  

match 'vueltos/do_process/:id' => 'vueltos#do_process', via: [:get, :post]
  

  resources :couts 
# lgv
  
  match 'lgvs/list_items/:company_id' => 'lgvs#list_items', via: [:get, :post]
  match 'lgvs/list_items2/:company_id' => 'lgvs#list_items2', via: [:get, :post]
  
  match 'lgvs/ac_documentos/:company_id' => 'lgvs#ac_documentos', via: [:get, :post]
  match 'lgvs/ac_compros/:company_id' => 'lgvs#ac_compros', via: [:get, :post]
  match 'lgvs/ac_user/:company_id' => 'lgvs#ac_user', via: [:get, :post]
  match 'lgvs/ac_customers/:company_id' => 'lgvs#ac_customers', via: [:get, :post]
  match 'lgvs/new/:company_id' => 'lgvs#new', via: [:get, :post]
  
  match 'lgvs/do_email/:id' => 'lgvs#do_email', via: [:get, :post]
  match 'lgvs/do_process/:id' => 'lgvs#do_process', via: [:get, :post]
  match 'lgvs/email/:id' => 'lgvs#email', via: [:get, :post]
  match 'lgvs/pdf/:id' => 'lgvs#pdf', via: [:get, :post]
  
  match 'lgvs/rpt_lgv2_pdf/:id' => 'lgvs#rpt_lgv2_pdf', via: [:get, :post]
  match 'companies/lgvs/:id' => 'lgvs#list_lgvs', via: [:get, :post]
  resources :lgvs 



  match 'lvts/list_items/:company_id' => 'lvts#list_items', via: [:get, :post]
  match 'lvts/list_items2/:company_id' => 'lvts#list_items2', via: [:get, :post]
  
  match 'lvts/ac_documentos/:company_id' => 'lvts#ac_documentos', via: [:get, :post]
  match 'lvts/ac_compros/:company_id' => 'lvts#ac_compros', via: [:get, :post]
  match 'lvts/ac_user/:company_id' => 'lvts#ac_user', via: [:get, :post]
  match 'lvts/ac_customers/:company_id' => 'lvts#ac_customers', via: [:get, :post]
  match 'lvts/new/:company_id' => 'lvts#new', via: [:get, :post]
  
  match 'lvts/do_email/:id' => 'lvts#do_email', via: [:get, :post]
  match 'lvts/do_process/:id' => 'lvts#do_process', via: [:get, :post]
  match 'lvts/email/:id' => 'lvts#email', via: [:get, :post]
  match 'lvts/pdf/:id' => 'lvts#pdf', via: [:get, :post]
  
  match 'lvts/rpt_lgv2_pdf/:id' => 'lvts#rpt_lgv2_pdf', via: [:get, :post]
  match 'companies/lvts/:id' => 'lvts#list_lvts', via: [:get, :post]
  resources :ltvs




# Declarations
  
  match 'declarations/list_items/:company_id' => 'invoices#list_items', via: [:get, :post]
  match 'declarations/ac_kit/:company_id' => 'invoices#ac_kit', via: [:get, :post]
  match 'invoices/ac_products/:company_id' => 'invoices#ac_products', via: [:get, :post]
  match 'invoices/ac_user/:company_id' => 'invoices#ac_user', via: [:get, :post]
  match 'invoices/ac_customers/:company_id' => 'invoices#ac_customers', via: [:get, :post]
  match 'invoices/new/:company_id' => 'invoices#new', via: [:get, :post]
  
  match 'invoices/do_email/:id' => 'invoices#do_email', via: [:get, :post]
  match 'invoices/do_process/:id' => 'invoices#do_process', via: [:get, :post]
  match 'invoices/email/:id' => 'invoices#email', via: [:get, :post]
  match 'invoices/pdf/:id' => 'invoices#pdf', via: [:get, :post]
  match 'companies/invoices/:company_id' => 'invoices#list_invoices', via: [:get, :post]
  resources :invoices

 match 'assistances/index/1' => 'assistances#index', via: [:get, :post]
  
  # Facturas Ventas
  
  match 'facturas/list_items/:company_id' => 'facturas#list_items', via: [:get, :post]
  match 'facturas/list_items2/:company_id' => 'facturas#list_items2', via: [:get, :post] , :layout => false
  match 'facturas/list_items3/:company_id' => 'facturas#list_items3', via: [:get, :post] , :layout => false
  
  match 'facturas/ac_services/:company_id' => 'facturas#ac_services', via: [:get, :post]
  match 'facturas/ac_user/:company_id' => 'facturas#ac_user', via: [:get, :post]
  match 'facturas/ac_customers/:company_id' => 'facturas#ac_customers', via: [:get, :post]
  match 'facturas/ac_guias/:company_id' => 'facturas#ac_guias', via: [:get, :post]
  match 'facturas/ac_sts/:company_id'    => 'facturas#ac_sts', via: [:get, :post]
  match 'facturas/ac_st/:company_id'    => 'facturas#ac_st', via: [:get, :post] 


  match 'facturas/new/:company_id' => 'facturas#new', via: [:get, :post]
  match 'facturas/new2/:company_id' => 'facturas#new2', via: [:get, :post]
  match 'facturas/export/:company_id' => 'facturas#export', via: [:get, :post]
  match 'facturas/export2/:company_id' => 'facturas#export2', via: [:get, :post]
  match 'facturas/export3/:company_id' => 'facturas#export3', via: [:get, :post]
  match 'facturas/export4/:company_id' => 'facturas#export4', via: [:get, :post]

  match 'facturas/rpt_facturas_all/:company_id' => 'facturas#rpt_facturas_all_pdf', via: [:get, :post]
  match 'facturas/rpt_facturas_all2/:company_id' => 'facturas#rpt_facturas_all2_pdf', via: [:get, :post]
  
  match 'facturas/rpt_ccobrar2_pdf/:company_id' => 'facturas#rpt_ccobrar2_pdf', via: [:get, :post]
  match 'facturas/rpt_ccobrar3_pdf/:company_id' => 'facturas#rpt_ccobrar3_pdf', via: [:get, :post]

  match 'companies/facturas/generar/:company_id' => 'facturas#generar', via: [:get, :post]

  match 'companies/facturas/generar3/:company_id' => 'facturas#generar3', via: [:get, :post]
  match 'facturas/generar4/:company_id' => 'facturas#generar4', via: [:get, :post]
  match 'facturas/generar5/:company_id' => 'facturas#generar5', via: [:get, :post]
  match 'facturas/rpt_ost_3/:company_id' => 'facturas#rpt_ost_3', via: [:get, :post]
  match 'facturas/rpt_conductor_pdf/:company_id' => 'facturas#rpt_conductor_pdf', via: [:get, :post]
  
  
  match 'facturas/newfactura2/:factura_id' => 'facturas#newfactura2', via: [:get, :post]
  match 'facturas/do_anular/:id' => 'facturas#do_anular', via: [:get, :post]
  match 'facturas/do_email/:id' => 'facturas#do_email', via: [:get, :post]
  match 'facturas/do_process/:id' => 'facturas#do_process', via: [:get, :post]
  match 'facturas/print/:id' => 'facturas#print', via: [:get, :post]
  match 'facturas/sendmail/:id' => 'facturas#sendmail', via: [:get, :post]
  match 'facturas/email/:id' => 'facturas#email', via: [:get, :post]
  match 'facturas/pdf/:id' => 'facturas#pdf', via: [:get, :post]
  match 'companies/facturas/:company_id' => 'facturas#list_invoices', via: [:get, :post]
  resources :facturas


  match 'autoviaticos/do_process/:id' => 'autoviaticos#do_process', via: [:get, :post]
   match 'autoviaticos/do_anular/:id' => 'autoviaticos#do_anular', via: [:get, :post]
  match 'autoviaticos/pdf/:id' => 'autoviaticos#pdf', via: [:get, :post]
  resources :autoviaticos

  match 'cotizacions/do_anular/:id' => 'cotizacions#do_anular', via: [:get, :post]
  match 'cotizacions/do_cancelar/:id' => 'cotizacions#do_anular', via: [:get, :post]

 match 'cotizacions/do_process/:id' => 'cotizacions#do_process', via: [:get, :post]
 match 'cotizacions/pdf/:id' => 'cotizacions#pdf', via: [:get, :post]
 match 'cotizacions/pdf2/:id' => 'cotizacions#pdf2', via: [:get, :post]



  match 'assistances/generar/:id' => 'assistances#generar', via: [:get, :post]
  match 'assistances/generar1/:id' => 'assistances#generar1', via: [:get, :post]
  match 'assistances/generar2/:id' => 'assistances#generar2', via: [:get, :post]
  match 'assistances/generar3/:id' => 'assistances#generar3', via: [:get, :post]


  match 'assistances/do_process/:id' => 'assistances#do_process', via: [:get, :post]
  resources :assistances

# Guias
  
  match 'deliveries/list_items/:company_id' => 'deliveries#list_items', via: [:get, :post]
  match 'deliveries/ac_services/:company_id' => 'deliveries#ac_services', via: [:get, :post]
  match 'deliveries/ac_unidads/:company_id' => 'deliveries#ac_unidads', via: [:get, :post]
  match 'deliveries/ac_user/:company_id' => 'deliveries#ac_user', via: [:get, :post]
  match 'deliveries/ac_customers/:company_id' => 'deliveries#ac_customers', via: [:get, :post]
  match 'deliveries/ac_guias/:company_id' => 'deliveries#ac_guias', via: [:get, :post]
  match 'deliveries/new/:company_id' => 'deliveries#new', via: [:get, :post]
  match 'deliveries/do_unir/:company_id' => 'deliveries#do_unir', via: [:get, :post]
  match 'deliveries/do_guias/:company_id' => 'deliveries#do_guias', via: [:get, :post]
  match 'deliveries/newguia/:id' => 'deliveries#newguia', via: [:get, :post]
  
  match 'companies/deliveries/unir/:company_id' => 'deliveries#unir', via: [:get, :post]

  match 'deliveries/do_email/:id' => 'deliveries#do_email', via: [:get, :post]
  match 'deliveries/do_process/:id' => 'deliveries#do_process', via: [:get, :post]
  match 'deliveries/do_anular/:id' => 'deliveries#do_anular', via: [:get, :post]
  match 'deliveries/email/:id' => 'deliveries#email', via: [:get, :post]
  match 'deliveries/pdf/:id' => 'deliveries#pdf', via: [:get, :post]
  match 'deliveries/guias1/:company_id' => 'deliveries#guias1', via: [:get, :post]
  match 'deliveries/guias2/:company_id' => 'deliveries#guias2', via: [:get, :post]
  match 'deliveries/guias3/:company_id' => 'deliveries#guias3', via: [:get, :post]
  match 'deliveries/guias4/:company_id' => 'deliveries#guias4', via: [:get, :post]

  match 'companies/deliveries/:company_id' => 'deliveries#list_deliveries', via: [:get, :post]
  resources :deliveries

# serviceorders
  
  match 'serviceorders/list_items/:company_id' => 'serviceorders#list_items', via: [:get, :post]
  match 'serviceorders/ac_services/:company_id' => 'serviceorders#ac_services', via: [:get, :post]
  match 'serviceorders/ac_unidads/:company_id' => 'serviceorders#ac_unidads', via: [:get, :post]
  match 'serviceorders/ac_user/:company_id' => 'serviceorders#ac_user', via: [:get, :post]
  match 'serviceorders/ac_customers/:company_id' => 'serviceorders#ac_customers', via: [:get, :post]
  match 'serviceorders/ac_suppliers/:company_id' => 'serviceorders#ac_suppliers', via: [:get, :post]

  match 'serviceorders/new/:company_id' => 'serviceorders#new', via: [:get, :post]
  match 'serviceorders/do_grabar_ins/:id' => 'serviceorders#do_grabar_ins', via: [:get, :post]

  match 'serviceorders/do_email/:id' => 'serviceorders#do_email', via: [:get, :post]
  match 'serviceorders/do_process/:id' => 'serviceorders#do_process', via: [:get, :post]
  match 'serviceorders/do_anular/:id' => 'serviceorders#do_anular', via: [:get, :post]
  match 'serviceorders/email/:id' => 'serviceorders#email', via: [:get, :post]  
  match 'serviceorders/pdf/:id' => 'serviceorders#pdf', via: [:get, :post]

  match 'serviceorders/rpt_serviceorder_all_pdf/:id' => 'serviceorders#rpt_serviceorder_all_pdf', via: [:get, :post]
  match 'serviceorders/receive/:id' => 'serviceorders#receive', via: [:get, :post]
  
  match 'companies/serviceorders/receive_orderservice/:company_id' => 'serviceorders#list_receive_serviceorders', via: [:get, :post]  
  match 'companies/serviceorders/:company_id' => 'serviceorders#list_serviceorders', via: [:get, :post]
  resources :serviceorders
  
  match 'cpagars/ac_user/:company_id' => 'cpagars#ac_user', via: [:get, :post]
  match 'cpagars/ac_purchases/:company_id' => 'cpagars#ac_purchases', via: [:get, :post]
  match 'cpagars/ac_suppliers/:company_id' => 'cpagars#ac_suppliers', via: [:get, :post]


  match 'purchaseorders/list_items/:company_id' => 'purchaseorders#list_items', via: [:get, :post]
  match 'purchaseorders/ac_products/:company_id' => 'purchaseorders#ac_products', via: [:get, :post]
  match 'purchaseorders/ac_unidads/:company_id' => 'purchaseorders#ac_unidads', via: [:get, :post]
  match 'purchaseorders/ac_user/:company_id' => 'purchaseorders#ac_user', via: [:get, :post]
  match 'purchaseorders/ac_purchases/:company_id' => 'purchaseorders#ac_purchases', via: [:get, :post]
  match 'purchaseorders/ac_suppliers/:company_id' => 'purchaseorders#ac_suppliers', via: [:get, :post]

  match 'purchaseorders/new/:company_id' => 'purchaseorders#new', via: [:get, :post]
  match 'purchaseorders/newfactura/:company_id' => 'purchaseorders#newfactura', via: [:get, :post]  

  match 'purchaseorders/receive/:id' => 'purchaseorders#receive', via: [:get, :post]
  match 'purchaseorders/do_email/:id' => 'purchaseorders#do_email', via: [:get, :post]
  match 'purchaseorders/do_process/:id' => 'purchaseorders#do_process', via: [:get, :post]
  match 'purchaseorders/do_grabar_ins/:id' => 'purchaseorders#do_grabar_ins', via: [:get, :post]
  match 'purchaseorders/do_cerrar/:id' => 'purchaseorders#do_cerrar', via: [:get, :post]

  match 'purchaseorders/email/:id' => 'purchaseorders#email', via: [:get, :post]
  match 'purchaseorders/pdf/:id' => 'purchaseorders#pdf', via: [:get, :post]
  match 'purchaseorders/rpt_purchaseorder_all/:id' => 'purchaseorders#rpt_purchaseorder_all', via: [:get, :post]
  match 'purchaseorders/rpt_purchaseorder2_all/:id' => 'purchaseorders#rpt_purchaseorder2_all', via: [:get, :post]
  match 'purchaseorders/rpt_purchaseorder3_all/:id' => 'purchaseorders#rpt_purchaseorder3_all', via: [:get, :post]
  match 'purchaseorders/rpt_purchaseorder4_all/:id' => 'purchaseorders#rpt_purchaseorder4_all', via: [:get, :post]
 
  match 'companies/purchaseorders/receive/:company_id' => 'purchaseorders#list_receiveorders', via: [:get, :post]
  match 'companies/purchaseorders/:company_id' => 'purchaseorders#list_purchaseorders', via: [:get, :post]

  resources :purchaseorders

  match 'ajusts/list_items/:company_id' => 'ajusts#list_items', via: [:get, :post]
  match 'ajusts/ac_products/:company_id' => 'ajusts#ac_products', via: [:get, :post]
  match 'ajusts/ac_unidads/:company_id' => 'ajusts#ac_unidads', via: [:get, :post]
  match 'ajusts/ac_user/:company_id' => 'ajusts#ac_user', via: [:get, :post]
  match 'ajusts/ac_purchases/:company_id' => 'ajusts#ac_purchases', via: [:get, :post]
  match 'ajusts/ac_suppliers/:company_id' => 'ajusts#ac_suppliers', via: [:get, :post]
  match 'ajusts/rpt_ajust_all_pdf/:id' => 'ajusts#rpt_ajust_all_pdf', via: [:get, :post]
  
  match 'ajusts/new/:company_id' => 'ajusts#new', via: [:get, :post]
  match 'ajusts/do_email/:id' => 'ajusts#do_email', via: [:get, :post]
  match 'ajusts/do_process/:id' => 'ajusts#do_process', via: [:get, :post]
  match 'ajusts/email/:id' => 'ajusts#email', via: [:get, :post]
  match 'ajusts/pdf/:id' => 'ajusts#pdf', via: [:get, :post]
  match 'companies/ajusts/:company_id' => 'ajusts#list_ajusts', via: [:get, :post]
  resources :ajusts 


  match 'receiveorders/list_items/:company_id' => 'receiveorders#list_items', via: [:get, :post]
  match 'receiveorders/ac_products/:company_id' => 'receiveorders#ac_products', via: [:get, :post]
  match 'receiveorders/ac_unidads/:company_id' => 'receiveorders#ac_unidads', via: [:get, :post]
  match 'receiveorders/ac_user/:company_id' => 'receiveorders#ac_user', via: [:get, :post]
  match 'receiveorders/new/:company_id' => 'receiveorders#new', via: [:get, :post]
  

  match 'receiveorders/do_email/:id' => 'receiveorders#do_email', via: [:get, :post]
  match 'receiveorders/do_process/:id' => 'receiveorders#do_process', via: [:get, :post]
  match 'receiveorders/email/:id' => 'receiveorders#email', via: [:get, :post]
  match 'receiveorders/pdf/:id' => 'receiveorders#pdf', via: [:get, :post]
  match 'companies/receiveorders/:company_id' => 'receiveorders#list_receiveorders', via: [:get, :post]
  resources :receiveorders
  

  match 'movements/list_items/:company_id' => 'movements#list_items', via: [:get, :post]
  match 'movements/ac_products/:company_id' => 'movements#ac_products', via: [:get, :post]
  match 'movements/ac_unidads/:company_id' => 'movements#ac_unidads', via: [:get, :post]
  match 'movements/ac_user/:company_id' => 'movements#ac_user', via: [:get, :post]
  match 'movements/ac_purchases/:company_id' => 'movements#ac_purchases', via: [:get, :post]
  match 'movements/new/:company_id' => 'movements#new', via: [:get, :post]
  
  match 'movements/do_email/:id' => 'movements#do_email', via: [:get, :post]
  match 'movements/do_process/:id' => 'movements#do_process', via: [:get, :post]
  match 'movements/email/:id' => 'movements#email', via: [:get, :post]
  match 'movements/pdf/:id' => 'movements#pdf', via: [:get, :post]
  match 'companies/movements/:company_id' => 'movements#list_movements', via: [:get, :post]
  resources :movements

  
    # Purchases
  
  match 'purchases/list_items/:company_id' => 'purchases#list_items', via: [:get, :post]  
  match 'purchases/ac_products/:company_id' => 'purchases#ac_products', via: [:get, :post]
  match 'purchases/ac_user/:company_id' => 'purchases#ac_user', via: [:get, :post]
  match 'purchases/ac_suppliers/:company_id' => 'purchases#ac_suppliers', via: [:get, :post]
  match 'purchases/new/:company_id' => 'purchases#new', via: [:get, :post]  
  match 'purchases/new2/:company_id' => 'purchases#new2', via: [:get, :post]  
  match 'purchases/edit/:company_id' => 'purchases#edit', via: [:get, :post]  

  
  match 'purchases/newfactura/:id' => 'purchases#newfactura', via: [:get, :post]  
  match 'purchases/newfactura2/:id' => 'purchases#newfactura2', via: [:get, :post]  

  match 'purchases/do_email/:id' => 'purchases#do_email', via: [:get, :post]
  match 'purchases/do_process/:id' => 'purchases#do_process', via: [:get, :post]
  match 'purchases/email/:id' => 'purchases#email', via: [:get, :post]
  match 'purchases/pdf/:id' => 'purchases#pdf', via: [:get, :post]
  match 'purchases/search/:id' => 'purchases#search', via: [:get, :post]
  match 'purchases/cargar/:id'   => 'purchases#cargar', via: [:get, :post]
  match 'purchases/cargar2/:id'   => 'purchases#cargar2', via: [:get, :post]

match 'purchases/do_crear/:id'   => 'purchases#do_crear', via: [:get, :post]
 
  match 'purchases/do_crear2/:id'   => 'purchases#do_crear2', via: [:get, :post]

  match 'purchases/ingresos/:id'   => 'purchases#ingresos', via: [:get, :post]
  match 'purchases/list_ingresos/:id'   => 'purchases#list_ingresos', via: [:get, :post]

  match 'purchases/buscaringresos/:id'   => 'purchases#buscaringresos', via: [:get, :post]
  match 'purchases/search_ingresos/:id'   => 'purchases#search_ingresos', via: [:get, :post]
  match 'purchases/rpt01/:id' => 'purchases#rpt01', via: [:get, :post]  
 


  match 'facturas/rpt_cpagar2_pdf/:company_id' => 'facturas#rpt_cpagar2_pdf', via: [:get, :post]
  match 'purchases/rpt_cpagar3_pdf/:company_id' => 'purchases#rpt_cpagar3_pdf', via: [:get, :post]
  match 'purchases/rpt_cpagar4_pdf/:company_id' => 'purchases#rpt_cpagar4_pdf', via: [:get, :post]
  match 'purchases/rpt_cpagar5_pdf/:id' => 'purchases#rpt_cpagar5_pdf', via: [:get, :post]

  match 'purchases/rpt_ingresos_all_pdf/:id' => 'purchases#rpt_ingresos_all_pdf', via: [:get, :post]
  match 'purchases/rpt_ingresos2_all_pdf/:id' => 'purchases#rpt_ingresos2_all_pdf', via: [:get, :post]
  match 'purchases/rpt_ingresos3_all_pdf/:id' => 'purchases#rpt_ingresos3_all_pdf', via: [:get, :post]
  match 'purchases/rpt_ingresos4_all_pdf/:id' => 'purchases#rpt_ingresos4_all_pdf', via: [:get, :post]
  
  match 'purchases/rpt_purchase_all/:id' => 'purchases#rpt_purchase_all', via: [:get, :post]

  match 'purchases/rpt_purchase2_all/:id' => 'purchases#rpt_purchase2_all', via: [:get, :post]
  match 'purchases/rpt_purchase3_all/:id' => 'purchases#rpt_purchase3_all', via: [:get, :post]
  match 'purchases/rpt_purchase4_all/:id' => 'purchases#rpt_purchase4_all', via: [:get, :post]
   match 'purchases/rpt_purchase_all2/:id' => 'purchases#rpt_purchase_all2', via: [:get, :post]
 
  match 'purchases/rpt_compras1_pdf/:company_id' => 'purchases#rpt_compras1_pdf', via: [:get, :post]


  match 'companies/purchases/:company_id' => 'purchases#list_purchases', via: [:get, :post]  
  match 'companies/purchases/:company_id/:status_id' => 'purchases#list_purchases', via: [:get, :post]  
  
  resources :purchases
  
  match 'quotations/do_anular/:id' => 'quotations#do_anular', via: [:get, :post]
  match 'quotations/do_process/:id' => 'quotations#do_process', via: [:get, :post]
  match 'quotations/pdf/:id' => 'quotations#pdf', via: [:get, :post]
  match 'companies/quotations/:company_id' => 'quotations#list_quotations', via: [:get, :post]  
  match 'quotations/new/:company_id' => 'quotations#new', via: [:get, :post]  
  match 'quotations/do_email/:id' => 'quotations#do_email', via: [:get, :post]
  resources :quotations
  
  match 'manifests/do_process/:id' => 'manifests#do_process', via: [:get, :post]
  match 'manifests/do_anular/:id' => 'manifests#do_anular', via: [:get, :post]
  match 'manifests/do_cancelar/:id' => 'manifests#do_cancelar', via: [:get, :post]
  
  match 'manifests/pdf/:id' => 'manifests#pdf', via: [:get, :post]
  match 'tranportorders/pdf2/:id' => 'tranportorders#pdf2', via: [:get, :post]

  match 'tranportorders/cargar/:id'   => 'tranportorders#cargar', via: [:get, :post]
  match 'tranportorders/newost/:id'   => 'tranportorders#newost', via: [:get, :post]

  match 'tranportorders/do_crear/:id'   => 'tranportorders#do_crear', via: [:get, :post]

  
  
  match 'manifests/do_email/:id' => 'manifests#do_email', via: [:get, :post]
  match 'manifests/sendmail/:id' => 'manifests#sendmail', via: [:get, :post]
  match 'manifests/sendcancelar/:id' => 'manifests#sendcancelar', via: [:get, :post]

  resources :manifests 


  match 'exmautorizs/do_email/:id' => 'exmautorizs#do_email', via: [:get, :post]
  match 'exmautorizs/sendmail/:id' => 'exmautorizs#sendmail', via: [:get, :post]
  match 'exmautorizs/sendcancelar/:id' => 'exmautorizs#sendcancelar', via: [:get, :post]
  resources :exmautorizs

  match 'requerimientos/do_process/:id' => 'requerimientos#do_process', via: [:get, :post]
  match 'requerimientos/do_anular/:id' => 'requerimientos#do_anular', via: [:get, :post]
  match 'requerimientos/do_cancelar/:id' => 'requerimientos#do_cancelar', via: [:get, :post]
  
  match 'requerimientos/pdf/:id' => 'requerimientos#pdf', via: [:get, :post]
  match 'requerimientos/do_email/:id' => 'requerimientos#do_email', via: [:get, :post]
  match 'requerimientos/sendmail/:id' => 'requerimientos#sendmail', via: [:get, :post]
  match 'requerimientos/sendcancelar/:id' => 'requerimientos#sendcancelar', via: [:get, :post]

  


  match 'suppliers/new2/:company_id/'   => 'suppliers#new2', via: [:get, :post]
  match 'suppliers/pdf/:company_id/'   => 'suppliers#pdf', via: [:get, :post]


  match 'suppliers/search_ruc/:company_id/'   => 'suppliers#search_ruc', via: [:get, :post]

  resources :suppliers 

  match 'tranportorders/rpt_ost1_pdf/:company_id' => 'tranportorders#rpt_ost1_pdf', via: [:get, :post]
  match 'tranportorders/rpt_ost2_pdf/:company_id' => 'tranportorders#rpt_ost2_pdf', via: [:get, :post]
  match 'tranportorders/rpt_ost3_pdf/:company_id' => 'tranportorders#rpt_ost3_pdf', via: [:get, :post]
  
  match 'tranportorders/do_process/:id' => 'tranportorders#do_process', via: [:get, :post]
  match 'tranportorders/do_anular/:id' => 'tranportorders#do_anular', via: [:get, :post]
   match 'tranportorders/do_anular2/:id' => 'tranportorders#do_anular2', via: [:get, :post]
   match 'tranportorders/sendcancelar/:id' => 'tranportorders#sendcancelar', via: [:get, :post]
  match 'tranportorders/pdf/:id' => 'tranportorders#pdf', via: [:get, :post]
  match 'tranportorders/do_email/:id' => 'tranportorders#do_email', via: [:get, :post]
 

  # supplier payments

  match 'supplier_payments/list_items/:company_id' => 'supplier_payments#list_items', via: [:get, :post]  
  match 'supplier_payments/ac_products/:company_id' => 'supplier_payments#ac_products', via: [:get, :post]
  match 'supplier_payments/ac_documentos/:company_id' => 'supplier_payments#ac_documentos', via: [:get, :post]
  match 'supplier_payments/ac_user/:company_id' => 'supplier_payments#ac_user', via: [:get, :post]
  match 'supplier_payments/ac_suppliers/:company_id' => 'supplier_payments#ac_suppliers', via: [:get, :post]
  match 'supplier_payments/new/:company_id' => 'supplier_payments#new', via: [:get, :post]  

  match 'supplier_payments/do_email/:id' => 'supplier_payments#do_email', via: [:get, :post]
  match 'supplier_payments/do_process/:id' => 'supplier_payments#do_process', via: [:get, :post]
  match 'supplier_payments/email/:id' => 'supplier_payments#email', via: [:get, :post]
  match 'supplier_payments/pdf/:id' => 'supplier_payments#pdf', via: [:get, :post]
  match 'supplier_payments/search/:id' => 'supplier_payments#search', via: [:get, :post]
  match 'supplier_payments/rpt_purchases_all/:id' => 'supplier_payments#rpt_purchases_all', via: [:get, :post]
  match 'supplier_payments/rpt_cpagar4_pdf/:id' => 'supplier_payments#rpt_cpagar4_pdf', via: [:get, :post]

  match 'companies/supplier_payments/:company_id' => 'supplier_payments#list_supplierpayments', via: [:get, :post]  
  resources :supplier_payments

# supplier payments
  
  match 'customer_payments/list_items/:company_id' => 'customer_payments#list_items', via: [:get, :post]  
  match 'customer_payments/ac_products/:company_id' => 'customer_payments#ac_products', via: [:get, :post]
  match 'customer_payments/ac_documentos/:company_id' => 'customer_payments#ac_documentos', via: [:get, :post]
  match 'customer_payments/ac_user/:company_id' => 'customer_payments#ac_user', via: [:get, :post]
  match 'customer_payments/ac_customers/:company_id' => 'customer_payments#ac_customers', via: [:get, :post]
  match 'customer_payments/new/:company_id' => 'customer_payments#new', via: [:get, :post]  
  match 'customer_payments/new1/:company_id' => 'customer_payments#new1', via: [:get, :post]  
  match 'companies/customer_payments/registrar/:company_id' => 'customer_payments#registrar', via: [:get, :post]

  match 'customer_payments/do_email/:id' => 'customer_payments#do_email', via: [:get, :post]
  match 'customer_payments/do_process/:id' => 'customer_payments#do_process', via: [:get, :post]
  match 'customer_payments/email/:id' => 'customer_payments#email', via: [:get, :post]
  match 'customer_payments/pdf/:id' => 'customer_payments#pdf', via: [:get, :post]
  match 'customer_payments/search/:id' => 'customer_payments#search', via: [:get, :post]
  match 'customer_payments/generar1/:company_id' => 'customer_payments#generar1', via: [:get, :post]
  match 'customer_payments/export1/:company_id' => 'customer_payments#export1', via: [:get, :post]

  match 'customer_payments/rpt_purchases_all/:id' => 'customer_payments#rpt_purchases_all', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar4_pdf/:id' => 'customer_payments#rpt_ccobrar4_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar5_pdf/:id' => 'customer_payments#rpt_ccobrar5_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar6_pdf/:id' => 'customer_payments#rpt_ccobrar6_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar7_pdf/:id' => 'customer_payments#rpt_ccobrar7_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar8_pdf/:id' => 'customer_payments#rpt_ccobrar8_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar9_pdf/:id' => 'customer_payments#rpt_ccobrar9_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar10_pdf/:id' => 'customer_payments#rpt_ccobrar10_pdf', via: [:get, :post]
  match 'customer_payments/rpt_ccobrar11_pdf/:id' => 'customer_payments#rpt_ccobrar11_pdf', via: [:get, :post]
  
  match 'companies/customer_payments/:company_id' => 'customer_payments#list_customerpayments', via: [:get, :post]  
  
  match 'companies/reports/rpt_ordenes1_pdf/:company_id' => 'reports#rpt_ordenes1_pdf', via: [:get, :post]

  match '/reports/rpt_viaticos_1/:id' => 'reports#rpt_viaticos_1', via: [:get, :post]

  
  match 'companies/reports/rpt_viatico_10/:id' => 'reports#rpt_viatico_10', via: [:get, :post]

  match 'companies/reports/rpt_viatico_20/:id' => 'reports#rpt_viatico_20', via: [:get, :post]

  match 'companies/reports/rpt_viatico_30/:id' => 'reports#rpt_viatico_30', via: [:get, :post]

  resources :customer_payments
  match 'inventories_detaisl/additems/:company_id' => 'additems#list', via: [:get, :post]  
  resources :inventory_details
   # Marca
  match 'marcas/create_ajax/:company_id' => 'marcas#create_ajax', via: [:get, :post]
  
  # Customers
  match 'customers/create_ajax/:company_id' => 'customers#create_ajax', via: [:get, :post]
  match 'customers/new/:company_id' => 'customers#new', via: [:get, :post]
  match 'companies/customers/:company_id' => 'customers#list_customers', via: [:get, :post]
  resources :customers

  # Divisions
  match 'divisions/new/:company_id' => 'divisions#new', via: [:get, :post]
  match 'companies/divisions/:company_id' => 'divisions#list_divisions', via: [:get, :post]
  resources :divisions

  match 'trucks/new/:company_id' => 'trucks#new', via: [:get, :post]
  match 'companies/trucks/:company_id' => 'trucks#index', via: [:get, :post]
  resources :trucks

  match 'servicebuys/new/:company_id' => 'servicebuys#new', via: [:get, :post]
  match 'companies/servicebuys/:company_id' => 'servicebuys#index', via: [:get, :post]
  resources :trucks

  match 'empsubs/new/:company_id' => 'empsubs#new', via: [:get, :post]
  match 'companies/empsubs/:company_id' => 'empsubs#index', via: [:get, :post]
  resources :empsubs
  
  match 'subcontrats/new/:company_id' => 'subcontrats#new', via: [:get, :post]
  match 'companies/subcontrats/:company_id' => 'subcontrats#index', via: [:get, :post]
  resources :subcontrats

  # Restocks
  match 'restocks/process/:id' => 'restocks#do_process', via: [:get, :post]
  match 'restocks/new/:company_id/:product_id' => 'restocks#new', via: [:get, :post]
  match 'companies/restocks/:company_id/:product_id' => 'restocks#list_restocks', via: [:get, :post]
  resources :restocks


  match '/stocks/rpt_stocks1/:company_id' => 'stocks#rpt_stocks1', via: [:get, :post]
  match '/stocks/rpt_stocks2/:company_id' => 'stocks#rpt_stocks2', via: [:get, :post]
  match '/stocks/rpt_stocks20/:company_id' => 'stocks#rpt_stocks20', via: [:get, :post]
  
  match '/stocks/rpt_stocks4/:company_id' => 'stocks#rpt_stocks4', via: [:get, :post]

  match '/stocks/do_stocks/:company_id' => 'stocks#do_stocks', via: [:get, :post]



  resources :stocks



  match '/tranportorders/do_stocks/:company_id' => 'tranportorders#do_stocks', via: [:get, :post]
  resources  :tranportorders 
    
  # Products kits
  match 'products_kits/list_items/:company_id' => 'products_kits#list_items', via: [:get, :post]
  match 'products_kits/new/:company_id' => 'products_kits#new', via: [:get, :post]
  match 'companies/products_kits/:company_id' => 'products_kits#list_products_kits', via: [:get, :post]
  resources :products_kits

  # Products Categories
  match 'products_categories/ac_categories/:company_id' => 'products_categories#ac_categories', via: [:get, :post]

  match 'products_categories/new/:company_id' => 'products_categories#new', via: [:get, :post]
  match 'companies/products_categories/:company_id' => 'products_categories#list_products_categories', via: [:get, :post]

  resources :products_categories


  match 'companies/products_lines/:company_id' => 'products_lines#index', via: [:get, :post]
  
  # Products
  match 'products/ac_products/:company_id' => 'products#ac_products', via: [:get, :post]
  match 'products/rpt_product_all/:company_id' => 'products#rpt_product_all', via: [:get, :post]

  match 'products/ac_categories/:company_id' => 'products#ac_categories', via: [:get, :post]
  match 'products/new/:company_id' => 'products#new', via: [:get, :post]
  match 'companies/products/:company_id' => 'products#list_products', via: [:get, :post]
  resources :products


  match 'services/ac_services/:company_id' => 'services#ac_services', via: [:get, :post]
  match 'services/new/:company_id' => 'services#new', via: [:get, :post]
  match 'companies/services/:company_id' => 'services#index', via: [:get, :post]
  resources :services

  match 'companies/marcas/:company_id' => 'marcas#index', via: [:get, :post]
  resources :marcas

  match 'companies/modelos/:company_id' => 'modelos#index', via: [:get, :post]
  resources :modelos

  match 'companies/unidads/:company_id' => 'unidads#index', via: [:get, :post]  
  resources :unidads


  match 'companies/almacens/:company_id' => 'almacens#index', via: [:get, :post]  
  resources :almacens

  match 'companies/instruccions/:company_id' => 'instruccions#index', via: [:get, :post]
  resources :unidads

  match 'companies/payments/:company_id' => 'payments#index', via: [:get, :post]
  resources :payments

  # Tanques
  match 'companies/tanks/:company_id' => 'tanks#index', via: [:get, :post]
  resources :tanks  

  match 'companies/pumps/:company_id' => 'pumps#index', via: [:get, :post]
  resources :pumps  

  match 'companies/employees/:company_id' => 'employees#index', via: [:get, :post]
  
  match 'employees/ac_employees/:company_id' => 'employees#ac_employees', via: [:get, :post]
  resources :employees  
  
  # Suppliers
  match 'suppliers/create_ajax/:company_id' => 'suppliers#create_ajax', via: [:get, :post]
  match 'suppliers/new/:company_id' => 'suppliers#new', via: [:get, :post]


  match 'companies/suppliers/:company_id' => 'suppliers#list_suppliers', via: [:get, :post]


  match 'companies/suppliers/:company_id/:id' => 'suppliers#list_suppliers', via: [:get, :post]


  resources :suppliers
  # Gastos
  match 'gastos/new/:company_id' => 'gastos#new', via: [:get, :post]
  match 'companies/gastos/:company_id' => 'gastos#list_gastos', via: [:get, :post]
  resources :gastos
  
  # Locations
  match 'locations/new/:company_id' => 'locations#new', via: [:get, :post]
  match 'companies/locations/:company_id' => 'locations#list_locations', via: [:get, :post]
  resources :locations
  
  # Companies
  match 'companies/export/:id' => 'companies#export', via: [:get, :post]
  match 'new_company', to: 'companies#new', via: [:get]
  match 'companies/start/:id' => 'companies#start', via: [:get, :post]
  match 'companies/faqs/:id' => 'companies#faqs', via: [:get, :post]
  match 'companies/charts/:id' => 'companies#charts', via: [:get, :post]
  match 'companies/license/:id' => 'companies#license', via: [:get, :post]
  match 'companies/components/:id' => 'companies#components', via: [:get, :post]
  match 'companies/components2/:id' => 'companies#components2', via: [:get, :post]
  
  match 'companies/cpagar/:id' => 'companies#cpagar', via: [:get, :post]
  match 'companies/parte/:id' => 'companies#parte', via: [:get, :post]
  match 'companies/ccobrar/:id' => 'companies#ccobrar', via: [:get, :post]
  match 'companies/showcase/:id' => 'companies#showcase', via: [:get, :post]
  match 'companies/planilla/:id' => 'companies#planilla', via: [:get, :post]
  match 'companies/mantenimiento/:id' => 'companies#mantenimiento', via: [:get, :post]
  match 'companies/bancos/:id' => 'companies#bancos', via: [:get, :post]
  match 'companies/examens/:id' => 'companies#examens', via: [:get, :post]
  match '/companies/examens01/:id' => 'companies#examens01', via: [:get, :post]
  match '/companies/examens02/:id' => 'companies#examens02', via: [:get, :post]

  match 'companies/combus/:id' => 'companies#combus', via: [:get, :post]
  resources :companies

  # Users packages
  resources :users_packages

  # Packages
  match 'payment/:slug' => 'packages#payment', via: [:get, :post]
  match 'pricing/:slug' => 'packages#pick_package', via: [:get, :post]
  match 'pricing' => 'packages#pricing', via: [:get, :post]
  resources :packages

  # Pages
  match 'p/:page_name' => 'pages#name_clean', via: [:get, :post]
  match 'dashboard' => 'pages#dashboard', via: [:get, :post]
  match 'err_not_found' => 'pages#err_not_found', via: [:get, :post]
  match 'quick_upload' => 'pages#quick_upload', via: [:get, :post]
  resources :pages

  # Users
  match 'err_perms' => 'users#err_perms', via: [:get, :post]
  match "register" => 'devise/registrations#new' , via: [:get, :post]
  match 'logout' => 'devise/sessions#destroy', via: [:get, :post]
  match 'login' => 'devise/sessions#new', via: [:get, :post]
  resources :users
  
  #Orders
  
  match 'companies/stores/:company_id' => 'stores#index', via: [:get, :post]
  resources :stores

  match 'orders/pdf/:id' => 'orders#pdf', via: [:get, :post]  
  match 'orders/new' => 'orders#new', via: [:get, :post]
  
  match "pagar" => "orders#new" , via: [:get]
  resources :orders

  
  match 'inventories/ac_categories/:company_id' => 'inventories#ac_categories', via: [:get, :post]
  match 'inventories/new/:company_id' => 'inventories#new', via: [:get, :post]  
  match 'inventories/do_email/:id' => 'inventories#do_email', via: [:get, :post]
  
  match 'inventories/email/:id' => 'inventories#email', via: [:get, :post]
  match 'inventories/pdf/:id' => 'inventories#pdf', via: [:get, :post]
  match 'companies/inventories/:company_id' => 'inventories#list_inventories', via: [:get, :post]
  match 'inventories/addAll/:company_id' => 'inventories#addAll', via: [:get, :post]
  resources :inventories

  match 'inventories/ac_categories/:company_id' => 'inventories#ac_categories', via: [:get, :post]
  match 'inventories/new/:company_id' => 'inventories#new', via: [:get, :post]  
  match 'inventories/do_email/:id' => 'inventories#do_email', via: [:get, :post]
  match 'inventarios/do_process/:id' => 'inventarios#do_process', via: [:get, :post]
  match 'inventarios/import4/:id' => 'inventarios#impor4', via: [:get, :post]

  match 'inventories/email/:id' => 'inventories#email', via: [:get, :post]
  match 'inventories/pdf/:id' => 'inventories#pdf', via: [:get, :post]
  match 'companies/inventarios/:company_id' => 'inventarios#index', via: [:get, :post]
  
  resources :inventarios

  match 'payrolls/do_process/:id' => 'payrolls#do_process', via: [:get, :post]  
  match 'payrolls/do_update/:id' => 'payrolls#do_update', via: [:get, :post]  
  match 'payrolls/do_pdf/:id' => 'payrolls#do_pdf', via: [:get, :post]  
  match 'payrolls/do_pdf2/:id' => 'payrolls#do_pdf2', via: [:get, :post]  
  match 'payrolls/do_pdf3/:id' => 'payrolls#do_pdf3', via: [:get, :post]  
  
  match 'payrollbonis/index/:id' => 'payrollbonis#index', via: [:get, :post]  
  match 'payrollboni/new/:payroll_id' => 'payrollbonis#new', via: [:get, :post]  
  resources :payrolls 

  match 'tranportorders/ac_osts/:company_id' => 'tranportorders#ac_osts', via: [:get, :post]
  resources :tranportorders
  # Sessions
  resources :sessions

  match 'ventaisla/ac_mangueras' => 'ventaislas#ac_mangueras', via: [:get, :post]
  resources :ventaislas
  

  
   match 'proyecto_exams/do_grabar/:proyecto_exam_id/:empleado_id/:proyecto_minero_id' => 'proyecto_exams#do_grabar', via: [:get, :post]
   match 'proyecto_exams/pdf/:id' => 'proyecto_exams#pdf', via: [:get, :post]
  match 'proyecto_exams/pdf2/:id' => 'proyecto_exams#pdf2', via: [:get, :post]


  resources :proyecto_exams 

   match 'contactopms/pdf/rpt_contactospm_pdf'=> 'contactopms#pdf', via: [:get, :post]
  resources :contactopms



match 'exmautorizs/do_process/:id' => 'exmautorizs#do_process', via: [:get, :post]
match 'exmautorizs/do_anular/:id' => 'exmautorizs#do_anular', via: [:get, :post]
match 'exmautorizs/sendcancelar/:id' => 'exmautorizs#sendcancelar', via: [:get, :post]
match 'exmautorizs/pdf/:id' => 'exmautorizs#pdf', via: [:get, :post]
match 'exmautorizs/do_email/:id' => 'exmautorizs#do_email', via: [:get, :post]


match 'autoviatics/do_process/:id' => 'autoviatics#do_process', via: [:get, :post]
match 'autoviatics/do_anular/:id' => 'autoviatics#do_anular', via: [:get, :post]
match 'autoviatics/sendcancelar/:id' => 'autoviatics#sendcancelar', via: [:get, :post]
match 'autoviatics/pdf/:id' => 'autoviatics#pdf', via: [:get, :post]
match 'autoviatics/do_email/:id' => 'autoviatics#do_email', via: [:get, :post]

match 'payment_notices/list_items/:company_id' => 'payment_notices#list_items', via: [:get, :post]

match 'payment_notices/do_process/:id' => 'payment_notices#do_process', via: [:get, :post]
match 'payment_notices/do_anular/:id' => 'payment_notices#do_anular', via: [:get, :post]
match 'payment_notices/pdf/:id' => 'payment_notices#pdf', via: [:get, :post]


  # Frontpage
 # match 'dashboard' => 'pages#dashboard', via: [:get,s :post]

match 'conductors/pdf/:id' => 'conductors#pdf', via: [:get, :post]


match 'conductors/excel/:id' => 'conductors#excel', via: [:get, :post]

match '/proyecto_exams/:id/proyectoexam_details/:proyectoexam_detail_id' => 'proyecto_exams/proyectoexam_details#update', via: [:get, :post]



 match 'companies/couts/:company_id' => 'couts#do_cargar', via: [:get, :post]
  resources :cous 


  match 'viatico_details/ac_facturas/:company_id' => 'viatico_details#ac_facturas', via: [:get, :post]
  
 match 'viaticos/viatico_details/new2/:id'   => 'viaticos_viatico_details#new2', via: [:get, :post]


 match 'viaticolgvs/list_items2/:company_id' => 'viaticolgvs#list_items2', via: [:get, :post]
 match 'viaticolgvs/list_items3/:viaticolgv_id' => 'viaticolgvs#list_items3', via: [:get, :post]
 match 'companies/viaticolgvs/do_cargar2/:id'   => 'viaticolgvs#do_cargar2', via: [:get, :post]
 match 'viaticolgvs/newviatico2/:id' => 'viaticolgvs#newviatico2', via: [:get, :post]
 match 'viaticolgvs/do_crear2/:id'   => 'viaticolgvs#do_crear2', via: [:get, :post]

 match 'viaticos/new2/:id' => 'viaticos#new2', via: [:get, :post]
 match 'viaticos/list_viaticos/:id' => 'viaticos#list_viaticos', via: [:get, :post]

 match 'viaticos/newviatico2/:id' => 'viaticos#newviatico2', via: [:get, :post]
 match 'viaticos/do_crear/:id'   => 'viaticos#do_crear', via: [:get, :post]




match 'mntos/do_process/:id' => 'mntos#do_process', via: [:get, :post]
match 'mntos/do_anular/:id' => 'mntos#do_anular', via: [:get, :post]
match 'mntos/sendcancelar/:id' => 'mntos#sendcancelar', via: [:get, :post]
match 'mntos/do_cancelar/:id' => 'mntos#do_cancelar', via: [:get, :post]
match 'mntos/pdf/:id' => 'mntos#pdf', via: [:get, :post]


  
  mount Sidekiq::Web, at: '/sidekiq'

 


  root :to => "pages#frontpage"
  
end
