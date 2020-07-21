# frozen_string_literal: true

class AddScopeToDebates < ActiveRecord::Migration[5.2]
  def change
    add_reference :decidim_debates_debates, :decidim_scope, foreign_key: true, index: true
  end
end
