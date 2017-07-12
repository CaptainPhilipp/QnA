# frozen_string_literal: true

class AddAuthenticationNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :oauth_authorizations, :provider, false
    change_column_null :oauth_authorizations, :uid, false
  end
end
