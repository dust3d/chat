class PostsController < ApplicationController
  include ApplicationHelper
  before_filter :login_required, :except => [:create]
  delegate :link_to, :auto_link, :sanitize, :to => 'ActionController::Base.helpers'
  protect_from_forgery :except => [:create]

  def index
    @posts = Post.order('created_at DESC').includes(:user)
    respond_to do |format|
      format.html
      format.json { render :json => @posts.collect {|post| {:profile_image_url => post.user.profile_image_url,:twitter_login => post.user.login, :name => post.user.name, :message => sanitize(auto_link(auto_image(post.message), :html => { :target => '_blank' }), :tags => %w(a img), :attributes => %w(href src alt target)), :time_ago => post.created_at} } }
    end
  end

  def create
    if current_user.present?
      user = current_user
      body = params[:post].present? ? params[:post][:message] : params[:message]
    else
      user = User.find_by_twitter_id(params[:user_id])
      body = params[:message]
    end
    msg = sanitize(
            auto_link(
              auto_image(
                auto_mention(body)
              ), :html => { :target => '_blank' }
            ), :tags => %w(a img mark), :attributes => %w(href src alt target)
          )
          post = Post.new(:message => msg, :lat => params[:lat], :lon =>params[:lon])
    if post.valid?
      post.save!
      user.posts << post
      post_data = {
        :command           => :broadcast,
        :body              => msg,
        :name              => user.name,
        :profile_image_url => user.profile_image_url,
        :location          => post.location,
        :twitter_login     => user.login,
        :type              => :to_channels_without_signature, 
        :channels          => 'groupon_go'
      }
      Pusher["groupon_go_#{ Rails.env }"].trigger!('new_post', post_data)
    end
    render :nothing => true
  end

end
