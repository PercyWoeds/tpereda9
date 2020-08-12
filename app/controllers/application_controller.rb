include UsersHelper


class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :checkUserInfo
  after_filter :return_errors, only: [:page_not_found, :server_error]
 
 def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end
  
   def page_not_found
         @status = 404
         @layout = "application"
         @template = "not_found_error"
    end

    def server_error
       @status = 500
       @layout = "error"
       @template = "internal_server_error"
    end
    
    
  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end


  
# rescue_from ActionController::RoutingError, :with => :route_not_found_error
#     rescue_from ActionController::BadRequest, :with => :bad_request_error
#     rescue_from StandardError, :with => :render_server_error

#     protected
#        def route_not_found_error
#           render "public/404", :status => 404
#        end

#        def bad_request_error
#           render "public/400", :status => 400
#        end

#        def render_server_error
#           render "public/500", :status => 500
#        end


	private
	def current_cart
	Cart.find(session[:cart_id])
	rescue ActiveRecord::RecordNotFound
	cart = Cart.create
	session[:cart_id] = cart.id
	cart
	end
	def return_errors
        respond_to do |format|
              format.html { render template: 'errors/' + @template, layout: 'layouts/' + @layout, status: @status }
              format.all  { render nothing: true, status: @status }
        end
    end
    

	
end
