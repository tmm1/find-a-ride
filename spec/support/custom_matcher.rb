module CustomMatchers
  class BeValid

    def initialize

      @expected = []

    end

    def matches?(target)

      target.valid?

      @errors = target.errors.full_messages

      @errors.eql?(@expected)

    end

    def failure_message

      "validation failed with #{@errors.inspect}, expected no validation errors"

    end

    def negative_failure_message

      "validation succeeded, expected one or more validation errors"

    end

    def description

      "validate successfully"

    end

    def to_s(value)

      "#{@errors.inspect}"

    end

  end
  
  def be_valid

    BeValid.new

  end

end
