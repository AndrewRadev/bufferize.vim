## Usage

The plugin exposes the `:Bufferize` command, which runs the given command and shows its output in a temporary buffer. For example:

``` vim
:Bufferize messages
:Bufferize digraphs
:Bufferize map
:Bufferize command
```

All of these are examples of useful commands, whose output you can now freely explore in a proper Vim buffer.

You can provide any command sequence, with arguments and all. For instance, if you run the following command in this file:

``` vim
:Bufferize ilist Bufferize
```

you'll get a buffer with all lines that contain "Bufferize". A lot of other commands output to the Vim console, and you can just feed them to the `:Bufferize` command. If you run `:Bufferize command Bufferize`, you'll see that the command is hooked up to the `bufferize#Run` function. You can then

``` vim
:Bufferize function bufferize#Run
```

To get a listing of the function in a buffer and explore its source code.

### BufferizeTimer

If you have a recent enough Vim that has `+timers` and `+lambda` (Vim 8 will do, but you can even use 7.4 with any of the later patches), you can also run the `:BufferizeTimer` command, which will do the same thing, but will also auto-update the buffer with the contents in the provided time interval. For instance:

``` vim
BufferizeTimer 500 messages
```

This will run the `:messages` command every 500ms and update its output in the bufferize buffer.

## Contributing

Pull requests are welcome, but take a look at [CONTRIBUTING.md](https://github.com/AndrewRadev/bufferize.vim/blob/master/CONTRIBUTING.md) first for some guidelines.
