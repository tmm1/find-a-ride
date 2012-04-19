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

RSpec::Matchers.define :have_content_type do |content_type|
  chain :with_charset do |charset|
    @charset = charset
  end

  match do |response|
    _, content, charset = *content_type_header.match(/^(.*?)(?:; charset=(.*))?$/).to_a

    if @charset
      @charset == charset && content == content_type
    else
      content == content_type
    end
  end

  failure_message_for_should do |response|
    if @charset
      "Content type #{content_type_header.inspect} should match #{content_type.inspect} with charset #{@charset}"
    else
      "Content type #{content_type_header.inspect} should match #{content_type.inspect}"
    end
  end

  failure_message_for_should_not do |model|
    if @charset
      "Content type #{content_type_header.inspect} should not match #{content_type.inspect} with charset #{@charset}"
    else
      "Content type #{content_type_header.inspect} should not match #{content_type.inspect}"
    end
  end

  def content_type_header
    response.headers['Content-Type']
  end
end
