class ActiveRecord::Base
  def self.paginate_with_filters(filters, options)
    filters.reject!{ |k,v| v.blank? }
    conditions = filters.empty? ? {} : {:conditions => filters}
    self.paginate(conditions.merge(options))
  end
end
