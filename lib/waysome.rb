module Waysome

  class Transaction

    def initialize(name, &block)
      @name = name
      define_singleton_method(:run, &block)
      run(self)
    end

    def self.create name=nil, &block
      Transaction.new(name, &block)
    end

    def id number
      unless number.is_a? Integer
        puts "id takes a number"
        exit 1
      end
      @id = number
    end

    def execute bool
      unless [TrueClass, FalseClass].include? bool.class
        puts "id takes a bool"
        exit 1
      end

      @exec = bool
    end

    def register name
      unless [String, FalseClass].include? name.class
        puts "register takes a string or false"
        exit 1
      end
      return if name == false

      @register = name
    end

    alias old_method_missing method_missing
    def method_missing(meth, *args, &block)
      args = args.first.to_s.to_i if args.length == 1 and args.first.is_a? Symbol
      args.map! { |arg| (arg.is_a?(Proc) ? ({ pos: arg.call }) : arg) }
      @cmds ||= Array.new
      @cmds.push({ meth => args })
    end

    def to_hash
      flags = Hash.new
      flags[:EXEC] = @exec if @exec
      flags[:REGISTER] = @register if @register
      {
        TYPE: "transaction",
        UID: @id,
        FLAGS: flags,
        CMDS: @cmds
      }
    end

  end

end

