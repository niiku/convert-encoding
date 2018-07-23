# convert-encoding.sh
Converts the encoding/charset of all files matching a pattern inside a directory. Please feel free to issue improvements. This script runs in bash only. For Windows, you need cygwin or MinGW. 

# Getting convert-encoding.sh
Simply execute the following:

```
wget https://raw.githubusercontent.com/niiku/convert-encoding/master/convert-encoding.sh
chmod +x convert-encoding.sh
```

# Usage
`Usage: ./convert-encoding.sh [-p] [-d] [-s] [-e]`

## Arguments
```
  -p, --pattern           File pattern
  -d, --detect            Auto detect source encoding
                          You must ether provide this argument or -s
  -s, --source-encoding   Encoding of source files
  -e, --encoding          Target encoding
  -v, --verbose           Prints filenames, source and target encoding
  -t, --dry-run           No conversion happens. Always verbose
  -h, --help              Shows this help output
```

# Examples

To convert all *.java files inside a directory from a unknown encoding to UTF-8
```
$ cd /path/to/directory/with/files
$ /path/to/convert-encoding.sh -p *.java -d -e UTF-8
```

## Dry-Run

If you want to check which files would be converted and what their detected encoding is, simply add `-t` or `--dry-run` as argument:

```
$ cd /path/to/directory/with/files
$ /path/to/convert-encoding.sh -p *.php -d -e UTF-8 -t
```
### Example output ###
```
niiku@machine $ /path/to/convert-encoding.sh -p *.php -d -t -e UTF-8
Dry-Run...
Source encoding: us-ascii; target encoding: UTF-8; ./index.php
```

## Define source charset
To define the source charset/encoding, simply add `-s` or `--source-encoding` argument

```
$ cd /path/to/directory/with/files
$ /path/to/convert-encoding.sh -p *.php -d -s ISO-8859-1 -e UTF-8
```

# Sources
Base script: https://gist.github.com/akost/2304819

How to handle arguments: https://stackoverflow.com/a/14203146
