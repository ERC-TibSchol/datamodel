usage() {
	echo -e "== list to xml ==	 
transform a list of values into a series of xml fragments

usage: list2xml.sh -i pathToList -p pathToPattern -o outputfile

pathToList: a textfile containing one value per line
pathToPatern: a XML file which will be output for each line in \$pathToList, with the placeholders \$VALUE being replaced by the value of the line in \$pathToList"
echo ""
}

sedesc() {
	# https://stackoverflow.com/questions/407523/escape-a-string-for-a-sed-replace-pattern
	value=$1
	printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g' | sed -e 's/\r//g'
}
export -f sedesc

lc() {
	echo "$1" | tr '[:upper:]' '[:lower:]'
}
export -f lc

uc() {
	echo "$1" | tr '[:lower:]' '[:upper:]'
}
export -f uc

nb() {
	echo "$1" |sed 's/ //g'
}
export -f nb

cnt() { echo $#; }
export -f cnt

mkSeq() {
	flags=$1
	i=1;
	noFlags=`cnt $flags`
	seq=""
	for flag in $flags; do 
		seq="$seq @FLAG=\"$flag\""; 
		if [ $i -lt $noFlags ]; then 
			seq="$seq or "
		fi
		((i++))
	done
	echo $seq
}
export -f mkSeq 

processFlags() {
	flags=$1
	patternfile=$2
	flagsseq=$(mkSeq "$flags")
	echo "<_>$flagsseq</_>"
	#xmlstarlet ed -d "//INCLUDE[@FLAG=($flagsseq)]" $patternfile
}

export -f processFlags

mkInstance() {
	if [ $# == 1 ];
	then
		local sourceClassArity=""
		local directName="$1"
		local reverseName="$1"
		local targetClassArity=""
		local flags=""
		
	else 
		local sourceClassArity="$1"
		local directName="$2"
		local reverseName="$3"
		local targetClassArity="$4"
		local flags="$5"
	fi
	local directName_ESC=$(sedesc "$directName")
	local directName_LC=$(lc "$directName_ESC")
	local directName_NB=$(nb "$directName_ESC")
	local reverseName_ESC=$(sedesc "$reverseName")
	local reverseName_LC=$(lc "$reverseName_ESC")
	local reverseName_NB=$(nb "$reverseName_ESC")
	
	processFlags "$flags" "$patternfile"
	cp "$patternfile" "$patternfile.tmp"

	while read patternLine; do 
		echo -n "$patternLine" | \
			sed "s/\${DIRECTNAME}/$directName_ESC/g" | \
			sed "s/\${DIRECTNAME_NB}/$directName_NB/g" | \
			sed "s/\${DIRECTNAME_LC}/$directName_LC/g" | \
			sed "s/\${DIRECTNAME_UC}/$directName_UC/g" | \
			sed "s/\${REVERSENAME}/$reverseName_ESC/g" | \
			sed "s/\${REVERSENAME_NB}/$reverseName_NB/g" | \
			sed "s/\${REVERSENAME_LC}/$reverseName_LC/g" | \
			sed "s/\${REVERSENAME_UC}/$reverseName_UC/g" | \
			sed "s/\${SOURCECLASS_ARITY}/$sourceClassArity/g" | \
			sed "s/\${TARGETCLASS_ARITY}/$targetClassArity/g"			
	done < "$patternfile.tmp"
	rm "$patternfile.tmp"
}
export -f mkInstance



while getopts 'i:p:o:h' OPTION
do
case ${OPTION} in 
	i) export inputfile="$OPTARG" ;;
	o) export outputfile="$OPTARG" ;;
	p) export patternfile="$OPTARG" ;;
	h) export help="help!" ;;
esac
done

if [ ! -z $help ]; then usage; exit 0; fi

if [ -z $inputfile ]; then echo -e "-i missing: filename of list of values\n"; usage; exit 1; fi
if [ -z $patternfile ]; then echo -e "-p missing: filename of pattern\n"; usage; exit 1; fi
if [ -z $outputfile ]; then echo -e "-o missing: filename of output\n"; usage; exit 1; fi

tmpOutputfile="$outputfile.tmp"

echo "<_>" > $tmpOutputfile
csvtool call mkInstance $inputfile >> $tmpOutputfile	

echo "</_>" >> $tmpOutputfile
xmllint --format $tmpOutputfile -o $outputfile
rm $tmpOutputfile
