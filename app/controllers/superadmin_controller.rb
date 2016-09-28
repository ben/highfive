class SuperadminController < ApplicationController
  before_action :requires_login, except: [:login, :login_attempt]

  def index
  end

  def login
  end

  def login_attempt
    if params[:password] == (ENV['SUPERADMIN_PASSWORD'] || '')
      puts '!!! MATCH'
    end
    redirect_to '/superadmin'
  end

  private

  def requires_login
    redirect_to '/superadmin/login' unless logged_in?
  end

  def logged_in?
    false
  end
end
