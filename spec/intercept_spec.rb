RSpec.describe Intercept do
  class TestMessage
    attr_accessor :to, :bcc, :subject

    def initialize(to, bcc, subject)
      @to = to; @bcc = bcc; @subject = subject
    end
  end

  let(:white_list) { Proc.new { [Regexp.new('^\\S+@me.in$'), Regexp.new('^\\S+@me.com$')] } }
  let(:mapper) { Proc.new { { Regexp.new('^\\S+.g.p@you.com$') => 'g.p@you.in' } } }
  let(:replace) { Proc.new { %w(g.p@me.in k.@me.in) } }
  let(:suffix) { Proc.new { '_testing' } }

  let(:interceptor_description) {
    {
      interception: [
        {
          fields: [:to],
          strategy: {
            name: :white_list,
            args: white_list,
            fallback: {
              name: :mapper,
              args: mapper,
              fallback: {
                name: :replace,
                args: replace
              }
            }
          }
        },
        {
          fields: [:cc, :bcc],
          strategy: {
            name: :white_list,
            args: white_list,
            fallback: {
              name: :mapper,
              args: mapper
            }
          }
        }
      ],
      decoration: [
        {
          fields: [:subject],
          decorator: {
            name: :add_suffix,
            args: suffix
          }
        }
      ]
    }
  }

  let(:callback) { :delivering_message }

  let(:interceptor) { InterceptBuilder.build_worker(callback, interceptor_description) }

  it 'has a version number' do
    expect(Intercept::VERSION).not_to be nil
  end

  it 'responds to callback method' do
    expect(interceptor.respond_to? callback).to eq true
  end

  it 'when white_list is enough' do
    message = TestMessage.new(%w(a@a.a a@me.in b@b.b a@me.com), %w(a@a.a a@me.in b@b.b a@me.com), 'some_subject')
    interceptor.delivering_message(message)
    expect(message.to).to eq(%w(a@me.in a@me.com))
    expect(message.bcc).to eq(%w(a@me.in a@me.com))
  end

  it 'when mapper is enough' do
    message = TestMessage.new(%w(a@a.a 1.g.p@you.in b@b.b 1.g.p@you.com), %w(a@a.a 1.g.p@you.in b@b.b 1.g.p@you.com), 'some_subject')
    interceptor.delivering_message(message)
    expect(message.to).to eq(%w(g.p@you.in))
    expect(message.bcc).to eq(%w(g.p@you.in))
  end

  it 'when fallback is needed' do
    message = TestMessage.new(%w(a@a.a 1.a.p@you.in b@b.b 1.a.p@you.com), %w(a@a.a 1.a.p@you.in b@b.b 1.a.p@you.com), 'some_subject')
    interceptor.delivering_message(message)
    expect(message.to).to eq(%w(g.p@me.in k.@me.in))
    expect(message.bcc).to eq([])
  end

  it 'when add_suffix decorator is used' do
    message = TestMessage.new(%w(a@a.a a@me.in b@b.b a@me.com), %w(a@a.a a@me.in b@b.b a@me.com), 'some_subject')
    interceptor.delivering_message(message)
    expect(message.subject).to eq('some_subject_testing')
  end
end
