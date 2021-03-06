require 'gir_ffi/builder/type/registered_type'
require 'gir_ffi/builder/type/with_layout'
require 'gir_ffi/builder/type/with_methods'

module GirFFI
  module Builder
    module Type

      # Implements the creation of a class representing one of the types
      # whose C representation is a struct, i.e., :object and :struct.
      class StructBased < RegisteredType
        include WithMethods
        include WithLayout

        def pretty_print
          buf = "class #{@classname}\n"
          buf << pretty_print_methods
          buf << "end"
        end

        private

        def setup_class
          setup_layout
          setup_constants
          stub_methods
          setup_gtype_getter
          setup_field_accessors
        end

        def layout_superclass
          FFI::Struct
        end
      end
    end
  end
end
