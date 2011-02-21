require 'thread'

require 'live_ast/reader'
require 'live_ast/parser'
require 'live_ast/evaler'
require 'live_ast/linker'
require 'live_ast/loader'
require 'live_ast/error'

module LiveAST
  NATIVE_EVAL = Kernel.method(:eval)  #:nodoc:

  class << self
    #
    # For use in noninvasive mode (<code>require 'live_ast/base'</code>).
    #
    # Equivalent to <code>obj.to_ast</code>.
    #
    def ast(obj)  #:nodoc:
      case obj
      when Method, UnboundMethod
        Linker.find_method_ast(obj.owner, obj.name, *obj.source_location)
      when Proc
        Linker.find_proc_ast(obj)
      else
        raise TypeError, "No AST for #{obj.class} objects"
      end
    end

    #
    # Flush unused ASTs from the cache. See README.rdoc before doing
    # this.
    #
    def flush_cache
      Linker.flush_cache
    end

    #
    # For use in noninvasive mode (<code>require 'live_ast/base'</code>).
    #
    # Equivalent to <code>Kernel#ast_eval</code>.
    #
    def eval(*args)  #:nodoc:
      Evaler.eval(args[0], *args)
    end

    #
    # For use in noninvasive mode (<code>require 'live_ast/base'</code>).
    #
    # Equivalent to <code>Kernel#ast_load</code>.
    #
    def load(file, wrap = false)  #:nodoc:
      Loader.load(file, wrap)
    end
  end
end
