class Api::V1::BaseController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :doorkeeper_authorize!

  protected

  def current_resource_owner
    @owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
