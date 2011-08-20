commentary.vim
==============

Comment stuff out.  Use `\\\` to comment out a line (takes a count),
`\\` to comment out the target of a motion (for example, `\\ap` to
comment out a paragraph), and `\\` in visual mode to comment out the
selection.  That's it.

Install [repeat.vim](https://github.com/tpope/vim-repeat) to enable
repeating with `.` the line commenting map `\\\`.

I wrote this because 5 years after Vim added support for mapping an
operator, I still couldn't find a commenting plugin that leveraged that
feature (I overlooked
[tcomment.vim](https://github.com/tomtom/tcomment_vim)).  Striving for
minimalism, the first version weighed in at just 35 lines of code.

Oh, and it uncomments, too.

Installation
------------

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-commentary.git

Once help tags have been generated, you can view the manual with
`:help commentary`.

FAQ
---

> My favorite file type isn't supported!

Relax!  You just have to adjust `'commentstring'`:

    autocmd FileType apache set commentstring=#\ %s

> What if I want custom maps?

Fly by the seat of your pants and map directly to the `\` maps:

    xmap gc  \\
    nmap gc  \\
    nmap gcc \\\

Contributing
------------

See the contribution guidelines for
[pathogen.vim](https://github.com/tpope/vim-pathogen#readme).

Self-Promotion
--------------

Like commentary.vim? Follow the repository on
[GitHub](https://github.com/tpope/vim-commentary) and vote for it on
[vim.org](http://www.vim.org/scripts/script.php?script_id=3695).  And if
you're feeling especially charitable, follow [tpope](http://tpo.pe/) on
[Twitter](http://twitter.com/tpope) and
[GitHub](https://github.com/tpope).

License
-------

Distributable under the same terms as Vim itself.  See `:help license`.
