module SharedWorld
  def rows_hash_to_nested_hash(rows_hash)
    def add(keys, hash, value)
      key = keys.shift
      if keys.empty?
        hash[key] = value
      else
        hash[key] ||= {}
        add(keys, hash[key], value)
      end
    end

    hash = {}

    rows_hash.each do |key, value|
      add(key.split('.'), hash, value) if value.present?
    end

    hash
  end

  def instantiate_object(model_name, object)
    Object.const_get(model_name).new(object)
  end
end

World(SharedWorld)