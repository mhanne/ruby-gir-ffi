require File.expand_path('test_helper.rb', File.dirname(__FILE__))
require 'girffi/builder'

class BuilderTest < Test::Unit::TestCase
  context "A Builder building GObject::Object" do
    setup do
      @builder ||= nil
      return if @builder
      @builder = GirFFI::Builder.new
      @builder.build_object 'GObject', 'Object', 'NS1'
    end

    should "create the correct set of methods for the object" do
      ms = NS1::GObject::Object.instance_methods(false)
      [ "add_toggle_ref", "add_weak_pointer", "force_floating",
	"freeze_notify", "get_data", "get_property", "get_qdata", "notify",
	"remove_toggle_ref", "remove_weak_pointer", "run_dispose",
	"set_data", "set_data_full", "set_property", "set_qdata",
	"set_qdata_full", "steal_data", "steal_qdata", "thaw_notify",
	"watch_closure", "weak_ref", "weak_unref"
      ].each do |m|
	assert_contains ms, m
      end
    end
  end

  context "A Builder" do
    setup do
      @builder = GirFFI::Builder.new
    end

    context "looking at Gtk.main" do
      setup do
	@go = @builder.function_introspection_data 'Gtk', 'main'
      end
      # TODO: function_introspection_data should not return introspection data if not a function.
      should "have correct introspection data" do
	gir = GirFFI::IRepository.default
	gir.require "Gtk", nil
	go2 = gir.find_by_name "Gtk", "main"
	assert_equal go2, @go
      end

      should "build correct definition of Gtk.main" do
	code = @builder.function_definition @go
	assert_equal "def main\nLib.gtk_main\nend", code
      end

      should "attach function to Whatever::Lib" do
	mod = Module.new
	mod.const_set :Lib, libmod = Module.new
	libmod.module_eval do
	  extend FFI::Library
	  ffi_lib "gtk-x11-2.0"
	end

	@builder.attach_ffi_function mod, @go
	assert_contains libmod.public_methods, "gtk_main"
      end
    end
  end
end