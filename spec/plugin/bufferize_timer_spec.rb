require 'spec_helper'

describe ":BufferizeTimer" do
  specify "opens the output of :ls in its own buffer" do
    vim.edit 'test1.txt'
    vim.command 'BufferizeTimer 500 ls'

    output = buffer_contents('Bufferize: ls')

    expect(output).to include 'test1.txt'
  end

  specify "refreshes the output of :ls after a set time period" do
    vim.command 'edit test1.txt'
    vim.command 'BufferizeTimer 500 ls'
    vim.command 'split test2.txt'

    # initially, only test1
    output = buffer_contents('Bufferize: ls')
    expect(output).to include 'test1.txt'
    expect(output).not_to include 'test2.txt'

    # after 500ms, both:
    output = buffer_contents('Bufferize: ls')
    expect(output).to include 'test1.txt'
    expect(output).to include 'test2.txt'
  end
end
