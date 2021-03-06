require File.expand_path('../gir_ffi_test_helper.rb', File.dirname(__FILE__))

describe GirFFI::UserDefined::IPropertyInfo do
  it "has the attribute #property_type" do
    inf = GirFFI::UserDefined::IPropertyInfo.new
    inf.property_type = :foo
    inf.property_type.must_equal :foo
  end

  it "derives from GirFFI::UserDefined::IBaseInfo" do
    inf = GirFFI::UserDefined::IPropertyInfo.new
    inf.must_be_kind_of GirFFI::UserDefined::IBaseInfo
  end
end
