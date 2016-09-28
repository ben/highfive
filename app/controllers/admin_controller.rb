class AdminController < ApplicationController
  before_action :requires_login, except: [:login]

  def index
  end

  def login
  end

  private

  def requires_login
    redirect_to '/admin/login' unless false
  end
end
