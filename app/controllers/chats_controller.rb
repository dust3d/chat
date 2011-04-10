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
  
  def users
    @users = User.select([:id, :name]).where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @users.map(&:attributes) }
    end
  end
  
  def send_data
    if current_user.present?
      user = current_user
      body = params[:chat_input]
    else
      user = User.find(params[:id])
      body = params[:body]
    end
    msg = sanitize(
            auto_link(
              auto_image(
                auto_mention(body)
              ), :html => { :target => '_blank' }
            ), :tags => %w(a img mark), :attributes => %w(href src alt target)
          )

    if user.posts.create!(:chat_input => msg)
      post_data = {
        :command           => :broadcast,
        :body              => msg,
        :name              => user.name,
        :profile_image_url => user.profile_image_url,
        :twitter_login     => user.login,
        :type              => :to_channels_without_signature, 
        :channels          => 'groupon_go'
      }
      Pusher["groupon_go_#{ Rails.env }"].trigger!('new_post', post_data)
    end
    render :nothing => true
  end
  
end

