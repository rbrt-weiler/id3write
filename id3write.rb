#!/usr/bin/ruby -w

# Skript zum schnellen ID3-Taggen von MP3s.

# Die MP3s müssen nach dem Schema "Tracknr - Liedname.mp3" benannt sein.
# ID3v1-Tags werden mit dem Programm mp3info geschrieben, ID3v2-Tags werden
# mit dem Programm id3v2 geschrieben.
# Künstler und Album können an der Shell mit den Parametern -a und -l
# angegeben werden.

# (c) 2003 Robert Weiler <http://www.robwei.de/>
# GPL'ed <http://www.gnu.org/licenses/gpl.html>
# Dieses Skript kommt OHNE JEGLICHE GEWÄHRLEISTUNG.



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
				puts "Bearbeite #{value[3]}..."
				puts "\tLoeschen des alten Tags..."
				`mp3info -d "#{key}"`
				`id3v2 -d "#{key}"`
				puts "\tNeuen Tag schreiben..."
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
	print 'Kuenstler?  '
	artist = $stdin.gets
end

if (args =~ /-l "(.*?)"/  or  args =~ /-l (\w+)/)
	album = $1
else
	print 'Album?      '
	album = $stdin.gets
end

Dir['*'].each { |value|   MP3.new(value, artist.chomp, album.chomp) if (value =~ /.+?\.mp3$/i) }

if (MP3.counter[2] > 0)
	MP3.retag
	puts "\n#{MP3.counter[1]} von #{MP3.counter[0]} MP3s wurden umbenannt."
else
	puts 'Im aktuellen Verzeichnis wurden keine MP3s gefunden.'
end
