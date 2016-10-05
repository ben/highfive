class TangocardController < ApplicationController
  include AdminTeam
  layout 'admin'

  before_action :requires_login

  def index
  end

  def enable
  end
end
