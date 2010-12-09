require File.expand_path('test_helper.rb', File.dirname(__FILE__))
require 'gir_ffi/g_object'

class HelperGObjectTypeTest < Test::Unit::TestCase
  context "The GObject module" do
    should "have type_init as a public method" do
      assert GirFFI::GObject.respond_to?('type_init')
    end

    should "not have g_type_init as a public method" do
      assert GirFFI::GObject.respond_to?('g_type_init') == false
    end

  end
  context "the type_init method" do
    should "not raise an error" do
      assert_nothing_raised do
	GirFFI::GObject.type_init
      end
    end
  end
end
