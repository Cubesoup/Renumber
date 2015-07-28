# Renumber
command line utility that saves me a lot of typing, but not very frequently.

If you have a bunch of files whose names begin with two digit numeric identifiers,
this program will renumber them in order. For example, if I have a directory
containing

  01. Artist1 - Song1.mp3
  02. Artist2 - Song2.flac
  03 - Song?
  04slfjsalfj.pdf
  not_numbered.txt

running

  renumber --num 5

in the directory will result in

  05. Artist1 - Song1.mp3
  06. Artist2 - Song2.flac
  07 - Song?
  08slfjsalfj.pdf
  not_numbered.txt

you can also do it to a directory you aren't currently in with --dir <directory>.