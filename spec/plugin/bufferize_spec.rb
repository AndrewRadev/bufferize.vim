require 'spec_helper'

describe ":Bufferize" do
  specify "opens the output of :ls in its own buffer" do
    vim.edit 'test.txt'
    vim.command 'Bufferize ls'

    output = buffer_contents('Bufferize: ls')

    expect(output).to include 'test.txt'
  end
end
