class BaseSerializer

  def initialize(object)
    @object = object
  end

  def attributes
    raise NotImplementedError, "Subclasses must implement an attributes method"
  end

  def json
    attributes.
      deep_transform_keys{ |k| k.to_s.camelize(:lower) }.
      to_json
  end

end
