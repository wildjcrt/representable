module Representable
  module HashMethods
    def create_representation_with(doc, options, format)
      hash  = filter_keys_for!(represented, options) # FIXME: this modifies options and replicates logic from Representable.
      bin   = representable_bindings_for(format, options).first

      Collect::Hash[*bin.default_render_fragment_functions].(hash, {doc: doc, user_options: options, binding: bin, represented: represented})
    end

    def update_properties_from(doc, options, format)
      hash  = filter_keys_for!(doc, options)
      bin   = representable_bindings_for(format, options).first

      value = Collect::Hash[*bin.default_parse_fragment_functions].(hash, fragment: hash, document: doc, binding: bin, represented: represented, user_options: options)

      represented.replace(value)
    end

  private
    def filter_keys_for!(hash, options)
      excluding = options[:exclude]
      # TODO: use same filtering method as in normal representer in Representable#create_representation_with.
      return hash unless props = options.delete(:exclude) || options.delete(:include)
      hash.reject { |k,v| excluding ? props.include?(k.to_sym) : !props.include?(k.to_sym) }
    end
  end
end
