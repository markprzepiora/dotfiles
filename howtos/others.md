# Grab Bag Cheat Sheat

## Renaming MP3s using ExifTool

This will rename all MP3s in the current directory:

    exiftool -ext MP3 '-filename<$Artist - $Album - $OnlyTrack - $Title.Extension' .

To do a dry-run, use `testname` instead of `filename`:

    exiftool -ext MP3 '-testname<$Artist - $Album - $OnlyTrack - $Title.Extension' .
