# ID3write

ID3write is a script for adding ID3 information to MP3 files, aka tagging.

## Description

ID3write can be used to tag all MP3 files in a directory with artist, album, track number and title information. Artist and album name can be passed via command line parameter or via input, track number and title are extracted from the filename. ID3write relies on the external tools `mp3info` and `id3v2` to delete old and add new ID3 tags.

ID3write was designed to work with filenames following the pattern `[trackno] - [title].mp3`, i.e. `12 - The Auld Triangle.mp3`. This would extract the value `12` as track number and `The Auld Triangle` as title. ID3write also tries to figure out how many tracks are in the directory in total, counting files that end with `.mp3`. That information is added to the corresponding ID3v2 field.

Please note that ID3write always searches for MP3 files in the current directory. You cannot pass a working directory to ID3write.

## Requirements

ID3write requires a Ruby interpreter and the two tools `mp3info` and `id3v2`. It was tested with Ruby 1.8 under Linux only.

## Options

| -a STRING | Used to pass the artist name via command line. |
| -l STRING | Used to pass the album name via command line.  |

## License

ID3write is released under the [MIT license](https://opensource.org/licenses/MIT).

## Copyright

ID3write is (c) 2003 Robert Weiler.

