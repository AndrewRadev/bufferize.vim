module Support
  module Vim
    def buffer_contents(bufname)
      vim.echo(%<join(getbufline('#{bufname}', 1, '$'), "\n")>)
    end
  end
end
