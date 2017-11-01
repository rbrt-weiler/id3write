#!/usr/bin/ruby -w

# Script for pushing ID3 information into MP3 files.

# MP3 files must be named according to the "trackno - title.mp3" scheme.
# ID3 information is written using the external programs mp3info and id3v2.
# Artist and album can be passed using the parameters -a and -l.

# (c) 2003 Robert Weiler
# Released under the MIT license. <https://opensource.org/licenses/MIT>

class MP3
	@@count      = 0
	@@count_good = 0
	@@mp3list    = Hash.new

	def MP3.counter
		return [@@count, @@count_good, @@mp3list.length]
	end

	def MP3.retag
		if (@@mp3list.length > 0)
			@@mp3list = @@mp3list.sort
			@@mp3list.each {
				|key, value|
				puts "Editing #{value[3]}..."
				puts "\tDeleting the old tags..."
				`mp3info -d "#{key}"`
				`id3v2 -d "#{key}"`
				puts "\tWriting new tags..."
				`mp3info -a "#{value[0]}" -l "#{value[1]}" -n "#{value[2]}" -t "#{value[3]}" -c "ID3v1 by id3write.rb" "#{key}"`
				`id3v2 -a "#{value[0]}" -A "#{value[1]}" -T "#{value[2]}/#{@@mp3list.length}" -t "#{value[3]}" -c "ID3v2 by id3write.rb" "#{key}"`
				@@count_good += 1
			}
			return true
		else
			return false
		end
	end

	attr_reader :filename, :artist, :album, :track, :title, :retagable

	def initialize(filename, artist, album)
		@@count += 1

		@track     = nil
		@title     = nil
		@retagable = false

		@filename = filename
		@artist   = artist
		@album    = album

		if (@filename =~ /^(\d+) - (.+?)\.mp3$/i)
			@track     = $1
			@title     = $2
			@retagable = true
		end

		@@mp3list[@filename] = [@artist, @album, @track, @title] if (@retagable)
	end
end

args = ''
ARGV.each { |value|   args = args << value << " " }

if (args =~ /-a "(.*?)"/  or  args =~ /-a (\w+)/)
	artist = $1
else
	print 'Artist?  '
	artist = $stdin.gets
end

if (args =~ /-l "(.*?)"/  or  args =~ /-l (\w+)/)
	album = $1
else
	print 'Album?   '
	album = $stdin.gets
end

Dir['*'].each { |value|   MP3.new(value, artist.chomp, album.chomp) if (value =~ /.+?\.mp3$/i) }

if (MP3.counter[2] > 0)
	MP3.retag
	puts "\n#{MP3.counter[1]} out of #{MP3.counter[0]} MP3 files were tagged."
else
	puts 'No MP3 files found in current directory.'
end

