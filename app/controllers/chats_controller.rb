class ChatsController < ApplicationController
  before_filter :login_required
  protect_from_forgery :except => :post
  respond_to :json
  include ApplicationHelper
  delegate :link_to, :auto_link, :sanitize, :to => 'ActionController::Base.helpers'

  def index
   @posts = Post.order('created_at DESC')
  end
  
  def users
    @users = User.select([:id, :name]).where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @users.map(&:attributes) }
    end
  end
  
  def send_data
    msg = sanitize(
            auto_link(
              auto_image(
                auto_mention(params[:chat_input])
              ), :html => { :target => '_blank' }
            ), :tags => %w(a img mark), :attributes => %w(href src alt target)
          )
          puts msg.inspect
    @post = current_user.posts.create!(:chat_input => msg, :lat => params[:lat], :lon => params[:lon])
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

