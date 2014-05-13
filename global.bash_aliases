# This file is included by .bashrc, it contains aliases and functions

# Android
NDK_ROOT=$HOME/Developer/android-ndk-r9d

# System vars
export PATH=/usr/local/bin:/usr/local/sbin:$NDK_ROOT:$PATH
export EDITOR='emacs -nw'

# Android vars
export ADT_PATH=/Users/alexflint/Developer/adt-bundle-mac
export PATH=$PATH:$ADT_PATH/sdk:$ADT_PATH/sdk/platform-tools:$ADT_PATH/sdk/tools:$ADT_PATH/android-ndk-r8d

# Subversion vars
export SVN_EDITOR='emacs -nw'

# Homebrew vars
export HOMEBREW_GITHUB_API_TOKEN=30c748ccc487ff9720d1805dcd1595472dd614c4

# Go vars
export GOPATH=$HOME/Code/go

# Urbit vars
export URBIT_HOME=$HOME/Code/scratch/urbit/urb

# Helpful for adb pull'ing redwood datasets
export ADBDATA=/data/data/com.motorola.atap.androidplayer/files

alias l=ls
alias ll='ls -l'
alias la='ls -A'

alias igrep='grep -i'
alias aliasup='. ~/.bash_aliases'
alias scroll='watch -n 0.1 tail -n $LINES'

alias srch='brew search'
alias shw='brew list'
alias ins='brew install'

alias big='ds -sample 500'
alias ml='matlab -nojvm'
alias mld='matlab -Dgdb'

alias py=python
alias ipy='ipython --pylab=auto'

# open in chrome (even if default action for this file type is not to open in a web browser)
alias chrome='open -a "Google Chrome"'

# homebrew version of gdb (to avoid causing xcode conflicts)
export GDB7=/usr/local/Cellar/gdb/7.5/bin/gdb
alias gdb7=/usr/local/Cellar/gdb/7.5/bin/gdb

# Ogmento buildserver
export BS=172.16.20.3

# Amazon sticky-sync server
export AWS_STICKYSYNC=ec2-54-200-19-165.us-west-2.compute.amazonaws.com
alias sshst='ssh $AWS_STICKYSYNC'

# Cloudsigma benchmarks server
export BE=benchmarks.flybymedia.com
alias sshbe='ssh $BE'

# Join two pdfs with pdfjoin -o out.pdf in1.pdf in2.pdf ...
alias pdfjoin='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'


# Ruby stuff
#if which rbenv > /dev/null 2> /dev/null; then
#    eval "$(rbenv init -)";
#fi
export PATH=$PATH:/usr/local/Cellar/ruby/2.0.0-p353/bin

# In general the way to run something in 32 bit mode is with:
#   arch -i386 <binary name>
#
# However, by default the python executable in /usr/bin/python is
# just a wrapper that looks for the right python version and runs it.
# This means that 'arch -i386 python' usually just runs the wrapper
# in 32-bit mode, but the actual python binary gets run in 64 bit
# mode.
#
# The correct python-specific thing is to set
#   VERSIONER_PYTHON_PREFER_32_BIT=1
# and then run the python wrapper in /usr/bin/python
#
# However, this will fail if for any reason 'python' evaluates to
# an actual python executable (instead of a wrapper). This happened
# for example when I installed python as downloaded from python.org.
# Therefore the fully safe (and always harmless) thing to do is both.
function py32() {
    VERSIONER_PYTHON_PREFER_32_BIT=1 arch -i386 python $@
}
function ipy32() {
    VERSIONER_PYTHON_PREFER_32_BIT=1 arch -i386 ipython $@
}

# Run NCV python in explicit release or debug mode
function py32deb() {
    NCV_PYTHON_BUILD_CONFIG=Debug py32 $@
}
function ipy32deb() {
    NCV_PYTHON_BUILD_CONFIG=Debug ipy32 $@
}
function py32rel() {
    NCV_PYTHON_BUILD_CONFIG=Release py32 $@
}
function ipy32rel() {
    NCV_PYTHON_BUILD_CONFIG=Release ipy32 $@
}

# Show a diff between two images
function imdiff() {
    composite -compose minus $1 $2 /tmp/imdiff.png && ds /tmp/imdiff.png
}

function calc() {
    echo $@ | bc -l
}

# Colorize an SVN diff
function svndiff() {
    svn diff --diff-cmd diff -x -y $@ | colordiff;
}

# Display one or more images with sanity checking
function ds() {
    nfiles=0;
    for ((i=1; i<=$#; i++)); do
	if [ -e ${!i} ]; then
	    ((nfiles=$nfiles+1));
	    lastfile=${!i};
	fi
    done

		# Deal with PDFs
    shopt -s nocasematch;   # Turn off case sensitivity
    ext=${1##*.};
    if [ $ext == "pdf" ]; then
	evince $@;
	return;
    fi;

		# Deal with images
    if ((nfiles>1)); then
	dsall $*;
    elif ((nfiles==0)); then
	echo "File not found";
    elif identify $lastfile > /dev/null; then
	display $*;
    else
	echo "$lastfile is not an image";
    fi
}

# Display two images blended
function dsblend() {
    composite -blend 50% $1 $2 /tmp/dsblend.png && ds /tmp/dsblend.png
}

# Stich together a set of images (without resizing)
function dsall() {
    dsmontage -geometry 100% $*
}

# create a montage of a set of pictures
function dsmontage() {
    montage $* /tmp/dsmontage.png && display /tmp/dsmontage.png
}

# launch an ipython session and load data from the specified pickle into the local var 'D'
function ipydata() {
    ipy -i -c "import cPickle; D = cPickle.load(open('$1')); print '\n\n***\nData from $1 loaded into local var D'"
}

# run python with colorized tracebacks
function pyg() {
    ( py $* 3>&1 1>&2- 2>&3- ) | pygmentize -l pytb
}

function lntmp() {
    export NESTOR_BUILD=/Users/alexflint/Code/Nestor/dev/Nestor/tests/prj/MacOSX/testRunner/build
		export NESTOR_BUILD=/Users/alexflint/Code/Nestor/dev/Nestor/tests/prj/MacOSX/testRunner/DerivedData/testRunner/Build/Products
    sudo ln -s $NESTOR_BUILD/Release/debug /tmp/or
    sudo ln -s $NESTOR_BUILD/Debug/debug /tmp/od
}

function ve() {
    source $1/bin/activate
}

function seqall() {
    mkdir /tmp/seq
    rm /tmp/seq/*

    a=0; 
    for i in $1/*.pgm; do
        s=$(printf '%09d.pgm' $a);
	((a=a+1));
	ln -s $(pwd)/$i /tmp/seq/$s;
    done

    cd /tmp/seq
    ffmpeg -f image2 -r 60 -i %09d.pgm /tmp/preview.avi
    cd -
    echo "Created /tmp/preview.avi"
}
