class BaseSerializer

  def initialize(object)
    @object = object
  end

  def attributes
    raise NotImplementedError, "Subclasses must implement an attributes method"
  end

  def json
    attributes.
      stringify_keys.
      deep_transform_keys{ |k| k.camelize(:lower) }.
      to_json
  end

end
