module GirFFI
  # The InOutPointer class handles conversion between ruby types and
  # pointers for arguments with direction :inout.
  class InOutPointer < FFI::Pointer
    def initialize ptr, type, ffi_type
      super ptr
      @ffi_type = ffi_type
      @value_type = type
    end

    def to_value
      value = self.send "get_#{@ffi_type}", 0
      adjust_value_out value
    end

    private

    def adjust_value_out value
      if @value_type == :gboolean
        (value != 0)
      else
        value
      end
    end

    def self.from type, value
      return from_utf8 value if type == :utf8

      value = adjust_value_in type, value

      ffi_type = type_to_ffi_type type
      ptr = AllocationHelper.safe_malloc(FFI.type_size ffi_type)
      ptr.send "put_#{ffi_type}", 0, value

      self.new ptr, type, ffi_type
    end

    def self.from_array type, array
      return nil if array.nil?
      ptr = InPointer.from_array(type, array)
      self.from :pointer, ptr
    end

    class << self
      def type_to_ffi_type type
        ffi_type = GirFFI::Builder::TAG_TYPE_MAP[type] || type
        ffi_type = :int32 if type == :gboolean
        ffi_type
      end

      def adjust_value_in type, value
        if type == :gboolean
          (value ? 1 : 0)
        else
          value
        end
      end

      private

      def from_utf8 value
        ptr = InPointer.from :utf8, value
        self.from :pointer, ptr
      end
    end
  end
end

