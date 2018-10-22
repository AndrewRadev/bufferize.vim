require 'spec_helper'

describe ":Bufferize" do
  specify "opens the output of :ls in its own buffer" do
    vim.edit 'test.txt'
    vim.command 'Bufferize ls'

    output = buffer_contents('Bufferize: ls')

    expect(output).to include 'test.txt'
  end

  specify "opens the output of a complicated command" do
    write_file 'test.txt', <<~EOF
      describe("foo") do
        it("bars") do
        end
      end
    EOF
    vim.edit 'test.txt'
    vim.write

    vim.command 'Bufferize g/\v(describe|it)\(/'

    output = buffer_contents('Bufferize: g/\v(describe|it)\(/')
    expect(output).to include 'describe("foo")'
    expect(output).to include 'it("bars")'

    vim.search('"bars"')
    vim.normal 'dd'
    vim.command 'Bufferize g/\v(describe|it)\(/'

    output = buffer_contents('Bufferize: g/\v(describe|it)\(/')
    expect(output).to include 'describe("foo")'
    expect(output).not_to include 'it("bars")'
  end
end
