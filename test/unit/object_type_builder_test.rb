require File.expand_path('../gir_ffi_test_helper.rb', File.dirname(__FILE__))

describe GirFFI::Builder::Type::Object do
  before do
    GirFFI.setup :Regress
  end

  describe "#setup_method" do
    it "sets up singleton methods defined in a class's parent" do
      info = get_introspection_data 'Regress', 'TestSubObj'
      assert_nil info.find_method "static_method"
      parent = info.parent
      assert_not_nil parent.find_method "static_method"

      b = GirFFI::Builder::Type::Object.new(info)
      b.setup_method "static_method"
      pass
    end
  end

  describe "#find_property" do
    it "finds a property specified on the class itself" do
      builder = GirFFI::Builder::Type::Object.new(
        get_introspection_data('Regress', 'TestObj'))
      prop = builder.find_property("int")
      assert_equal "int", prop.name
    end
  end
end
