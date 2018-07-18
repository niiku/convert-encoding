#!/bin/bash

function usage() {
    echo "Usage: ./convert-encoding.sh [-p] [-d] [-s] [-e]"
    echo ""
    echo "Converts file encoding/charset of multiple files inside the current"
    echo "directory matching a pattern."
    echo ""
    echo "Uses 'file -i' and 'iconv' under the hood"
    echo ""
    echo "Example usage for automated encoding detection"
    echo "This converts all *.java files from unknown charset to UTF-8"
    echo "./convert-encoding.sh -p *.java -d -e UTF-8"
    echo ""
    echo "Example usage for defined source encoding/charset"
    echo "This converts all *.xml files from ISO-8859-1 to UTF-8"
    echo "./convert-encoding.sh -p *.xml -s ISO-8859-1 -e UTF-8"
    echo ""
    echo "Arguments:"
    echo "  -p, --pattern           File pattern"
    echo "  -d, --detect            Auto detect source encoding/charset"
    echo "                          You must ether provide this argument or -s"
    echo "  -s, --source-encoding   Encoding/charset of source files"
    echo "  -e, --encoding          Target encoding/charset"
    echo "  -v, --verbose           Prints filenames, source and target encoding"
    echo "  -t, --dry-run           No conversion happens. Always verbose"
    echo "  -h, --help              Shows this help output"
    exit 0
}

# Get arguments
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    help=true
    shift # past argument
    ;;
    -p|--pattern)
    file_pattern="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--detect)
    detect=true
    shift # past argument
    ;;
    -d|--detect)
    detect=true
    shift # past argument
    ;;
    -s|--source-encoding)
    defined_source_encoding="$2"
    shift # past argument
    shift # past argument
    ;;
    -e|--encoding)
    encoding="$2"
    shift # past argument
    shift # past value
    ;;
    -v|--verbose)
    verbose=true
    shift # past argument
    ;;
    -t|--dry-run)
    dry_run=true
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac

done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Check help
if [ "$help" == true ]
then
    usage
fi

# Validate arguments
valid_arguments=true

if [ -z ${file_pattern+x} ]
then
    valid_arguments=false
    echo "Missing argument -p, --pattern"
fi

if [ -z ${encoding+x} ]
then
    valid_arguments=false
    echo "Missing argument -e, --encoding"
fi

if [ -z ${detect+x} ] && [ -z ${defined_source_encoding+x} ]
then
    valid_arguments=false
    echo "Either argument -d, --detect or -s, --source-encoding must be set"
fi

if [ "${valid_arguments}" == "false" ]
then
    echo ""
    usage
fi

if [ "$dry_run" == "true" ]
then
    echo "Dry-Run..."
fi

# Convert encoding
for file in $(find . -type f -name "$file_pattern")
do
    # Check if a a source encoding is given
    if [ -z ${defined_source_encoding+x} ]
    then
        # If not, determine encoding
        source_encoding=$(file -i $file | grep -oP 'charset=\K.*')
    else
        source_encoding=${defined_source_encoding}
    fi

    # If verbose or dry run, print source and target encoding
    if [ "${verbose}" == "true" ] || [ "$dry_run" == "true" ]
    then
        echo "Source encoding: ${source_encoding}; target encoding: ${encoding}; ${file}"
    fi
    # Don't execute if it's a dry-run
    if [ -z ${dry_run+x} ]
    then
        # Move file
        mv $file $file.icv
        # convert moved file back to it's original name
        iconv -f $source_encoding -t utf-8 $file.icv > $file
        # remove moved file
        rm -f $file.icv
    fi
done
