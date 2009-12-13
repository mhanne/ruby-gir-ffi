#
# Exploratory program to see what kind of method_missing we would need in a
# module. In the end, this code would have to be generated by the Builder,
# or be provided by a mixin.
#

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'girffi'
require 'girffi/builder'

module GirFFI
  class ITypeInfo
    def to_ffi
      return :pointer if pointer?
      return GirFFI::IRepository.type_tag_to_string(tag).to_sym
    end
  end
end

module Gtk
  module Lib
    extend FFI::Library
    ffi_lib "gtk-x11-2.0"
  end

  def self.g_namespace
    "Gtk"
  end

  private_class_method :g_namespace

  def self.method_missing method, *arguments
    @@builder ||= GirFFI::Builder.new

    go = @@builder.function_introspection_data g_namespace, method.to_s

    # TODO: Unwind stack of raised NoMethodError to get correct error
    # message.
    return super if go.nil?
    return super if go.type != :function

    sym = go.symbol
    argtypes = go.args.map {|a| a.type.to_ffi}
    rt = go.return_type.to_ffi

    puts "attach_function :#{sym}, [#{argtypes.map {|a| ":#{a}"}.join ", "}], :#{rt}"

    Lib.module_eval do
      attach_function sym, argtypes, rt
    end

    code = @@builder.function_definition go
    puts code

    eigenclass = class << self; self; end
    eigenclass.class_eval code

    puts self.public_methods - Module.public_methods - ['method_missing']
    self.send method, *arguments
  end
end

Gtk.init 0, nil
Gtk.flub
