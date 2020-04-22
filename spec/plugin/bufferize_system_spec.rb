require 'spec_helper'

describe ":BufferizeSystem" do
  specify "opens the output of !cat in its own buffer" do
    IO.write('example.txt', 'Example contents')
    vim.edit 'test.txt'
    vim.command 'BufferizeSystem cat example.txt'

    output = buffer_contents('Bufferize: echo system("cat example.txt")')

    expect(output).to include 'Example contents'
  end
end
