class ChatsController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => :post
  respond_to :json
  include ApplicationHelper
  delegate :link_to, :auto_link, :sanitize, :to => 'ActionController::Base.helpers'

  def index
   @posts = Post.paginate :page => params[:page], :order => 'created_at DESC'
   respond_to do |format|
     format.html
     format.json { render :json => @posts.collect {|post| {:profile_image_url => post.user.profile_image_url,:twitter_login => post.user.login, :name => post.user.name, :chat_input => sanitize(auto_link(auto_image(post.chat_input), :html => { :target => '_blank' }), :tags => %w(a img), :attributes => %w(href src alt target)), :time_ago => post.created_at} } }
   end
  end
  
  def send_data
    msg = sanitize(auto_link(auto_image(params[:chat_input]), :html => { :target => '_blank' }), :tags => %w(a img), :attributes => %w(href src alt target))
    @post = current_user.posts.create!(:chat_input => msg)
    post_data = {
      :command           => :broadcast,
      :body              => msg,
      :name              => current_user.name,
      :profile_image_url => current_user.profile_image_url,
      :twitter_login     => current_user.login,
      :type              => :to_channels_without_signature, 
      :channels          => 'groupon_go'
    }
    Pusher['groupon_go'].trigger!('new_post', post_data)
    #render :juggernaut => {:type => :send_to_channels, :channels => ['web']} do |page|
    #  page.insert_html :top, 'chat_data', "<li>#{h params[:chat_input]}</li>"
    #end
    render :nothing => true
  end
  
end

