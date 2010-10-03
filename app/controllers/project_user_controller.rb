class ProjectUserController < ApplicationController
  unloadable
  
  
  def index
  end
  
  # User self-registration
  def register
    redirect_to(home_url) && return unless Setting.self_registration? || session[:auth_source_registration]
    if request.get?
      session[:auth_source_registration] = nil
      @user = User.new(:language => Setting.default_language)
#      name = "user#{Time.now.hour}#{Time.now.min}#{Time.now.sec}"
#      @user.firstname = name
#      @user.lastname = name
#      @user.login = name
#      @user.mail = "#{name}@gmail.com"
      
      
      #@membership = Member.new
    else
      
      @user = User.new(params[:user])
      @user.admin = false
      @user.status = User::STATUS_ACTIVE
      
      project = Project.find(params[:project])
      
      if session[:auth_source_registration]
        @user.status = User::STATUS_ACTIVE
        @user.login = session[:auth_source_registration][:login]
        @user.auth_source_id = session[:auth_source_registration][:auth_source_id]
        
        if verify_recaptcha(:model => @user, :message => "Oh! It's error with reCAPTCHA!") && @user.save
          
          session[:auth_source_registration] = nil
          self.logged_user = @user
          flash[:notice] = l(:notice_account_activated)
          redirect_to :controller => 'my', :action => 'account'
        end
      else
        @user.login = params[:user][:login]
        @user.password, @user.password_confirmation = params[:password], params[:password_confirmation]
        
        register_automatically(@user, project)
      end
    end
  end
  
  
  
  # Automatically register a user
  #
  # Pass a block for behavior when a user fails to save
  def register_automatically(user, project, &block)
    # Automatic activation
    user.status = User::STATUS_ACTIVE
    user.last_login_on = Time.now
    
    
    
    
    
    if verify_recaptcha(:model => user, :message => "Oh! It's error with reCAPTCHA!") && user.save
      self.logged_user = user
#      membership = project.members.build
#      membership.user = user
#      membership.save
      
      
      
          sql = ActiveRecord::Base.connection();
          sql.execute "SET autocommit=1";
          sql.begin_db_transaction 
          sql.execute("INSERT INTO members (user_id, project_id, created_on, mail_notification) VALUES (#{@user.id},#{project.id},\"#{DateTime.now}\",0)")
          sql.commit_db_transaction
      

      
      
      
      
      flash[:notice] = l(:notice_account_activated)
      redirect_to :controller => 'my', :action => 'account'
    else
      yield if block_given?
    end
  end
  
  
  def account_pending
    flash[:notice] = l(:notice_account_pending)
    redirect_to :action => 'login'
  end
  
end
