# frozen_string_literal: true

module Paginable
  protected

  def current_page
    (params[:page] || 1).to_i
  end

  def count
    (params[:count] || 20).to_i
  end

  def meta_attributes(collection, extra_meta = {})
    {
      current_page: collection.current_page,
      totalItems: collection.total_count,
      itemPerPage: collection.limit_value
    }.merge(extra_meta)
  end
end
