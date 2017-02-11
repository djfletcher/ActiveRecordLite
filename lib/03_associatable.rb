require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    defaults = {
      class_name: name.to_s.camelcase,
      primary_key: :id,
      foreign_key: "#{name.to_s.singularize}_id".to_sym
    }

    merged = defaults.merge(options)

    @class_name = merged[:class_name]
    @foreign_key = merged[:foreign_key]
    @primary_key = merged[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})

    defaults = {
      class_name: name.singularize.camelcase,
      primary_key: :id,
      foreign_key: "#{self_class_name.singularize.underscore}_id".to_sym
    }

    merged = defaults.merge(options)

    @class_name = merged[:class_name]
    @foreign_key = merged[:foreign_key]
    @primary_key = merged[:primary_key]
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(name) do
      owner_id = self.send(options.foreign_key)
      results = options.model_class.where(options.primary_key => owner_id)
      results.first
    end
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
