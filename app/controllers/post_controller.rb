class PostController < ApplicationController
  before_filter :login_required
  def index
    @posts = Post.paginate :page => params[:page], :order => :created_at
  end

  def post
    #Juggernaut.send_to_channels_without_sign(params[:chat_input], ['iphone'])
    #
    #render :juggernaut => {:type => :send_to_channels, :channels => ['web']} do |page|
    #  page.insert_html :top, 'chat_data', "<li>#{h params[:chat_input]}</li>"
    #end
    #render :nothing => true
    @post = Post.create(params[:post])
    #Pusher['groupon_go'].trigger!('post', {:post => params[:post]})
    redirect_to :controller => :chat, :action => :send_date, :post => @post
  end

end
