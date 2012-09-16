module Frusdl
  module Wrap  
    module ClassMethods  
      def make_struct_reader(name, sname = nil)
        method_name = name.to_sym
        struct_name = sname ? sname.to_sym : method_name 
        define_method(method_name) do
          return @struct[struct_name]
        end
      end
          
      def make_struct_writer(name, sname = nil)
        method_name = "#{name}=".to_sym
        struct_name = sname ? sname.to_sym : name.to_sym 
        define_method(method_name) do | value |
          return @struct[struct_name] = value
        end
      end
      
      def struct_accessor(name, sname = nil)
        make_struct_reader name, sname
        make_struct_writer name, sname
      end
          
      def struct_reader(name, sname = nil)
        make_struct_reader name, sname
      end
    end
    
    # From here it's instance methods
    
    # Initializes the pointer and struct members
    def initialize_pointer(ptr, klass)
      @pointer = ptr
      @struct  = klass.new(ptr)
      # define an accessor when this is called
      unless self.respond_to? :pointer 
        self.klass.attr_reader(:pointer)
      end  
    end
    
    def self.included(base)
      base.extend(Frusdl::Wrap::ClassMethods)
      # Also extend with class methods
    end    
        
        
  end
end  
