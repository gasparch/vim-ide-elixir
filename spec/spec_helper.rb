# frozen_string_literal: true

require 'rspec/expectations'
require 'tmpdir'
require 'vimrunner'
require 'vimrunner/rspec'
require 'pry'

class Buffer
  def initialize(vim, type)
    #@mix_file = "mix.exs"
    #@test_helper = "test/test_helper.exs"
    #
    #write_mix_exs

    if type == :ctags
      @file = "fixture.#{type}"
    else
      puts "do not know type #{type}"
      exit!(123)
    end

    @vim = vim
  end

  def get_ctags_convertion(content, leave='v')
    File.write(@file, content) if content

    @vim.command "let b:content=readfile('#{@file}')"
    @vim.command 'echo join(vimide#elixir#tagbarFilter(b:content), "\n")'
  end

  def messages_clear
    @vim.command ':messages clear'
  end

  def messages
    @vim.command ':messages'
  end

  private

  def with_file(content = nil)
    edit_file(content)

    yield if block_given?

    @vim.write
    IO.read(@file)
  end

  def edit_file(content)
    File.write(@file, content) if content

    @vim.edit @file
    @vim.normal ':set ft=elixir<CR>'
  end

end

class Differ
  def self.diff(result, expected)
    instance.diff(result, expected)
  end

  def self.instance
    @instance ||= new
  end

  def initialize
    @differ = RSpec::Support::Differ.new(
      object_preparer: -> (object) do
        RSpec::Matchers::Composable.surface_descriptions_in(object)
      end,
      color: RSpec::Matchers.configuration.color?
    )
  end

  def diff(result, expected)
    @differ.diff_as_object(result, expected)
  end
end

RSpec::Matchers.define :be_ctags_output do |expected_result, options='v'|
  buffer = Buffer.new(VIM, :ctags)

  expected_result = expected_result.gsub(/\n$/, '')

  match do |code|
    #result = buffer.get_ctags_convertion(code) 
    #p "-<<<<--------------------------"
    #p result
    #p "---------------------------"
    #p expected_result
    #p "->>>>--------------------------"
    #
    #byebug

    buffer.get_ctags_convertion(code) == expected_result
  end

  failure_message do |code|
    buffer.messages_clear
    result = buffer.get_ctags_convertion(code)
    messages = buffer.messages

    <<~EOM
    Vim echo messages:
    #{messages}

    Diff:
    #{Differ.diff(result, expected_result)}
    EOM
  end
end

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  config.start_vim do
    VIM = Vimrunner.start_gvim
    VIM.add_plugin(File.expand_path('..', __dir__), 'autoload/vimide.vim')
    VIM.add_plugin(File.expand_path('..', __dir__), 'autoload/vimide/elixir.vim')
    VIM
  end
end

RSpec.configure do |config|
  config.order = :random

  # Run a single spec by adding the `focus: true` option
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true
end
