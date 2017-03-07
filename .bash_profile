# The purpose of this file is to show an example of some basic, useful, easy to use and modify scripts that make my daily life easier.
# Feel free to copy and use this profile on your own machine. Just remember to change file names/paths.
# This is set up for a OSX/Mac folder structure.

# This simply echoes the message out to the terminal to confirm that the bash profile has been loaded.
echo '************************************************'
echo '************* Bash Profile Sourced *************'

# Reload/open bash
# This needs to be run each time you edit your bash file
alias reload=". ~/.bash_profile"
# This can be run to open your bash file for editing. Edit "sub" for your choice of IDE
alias openbash="sub $HOME/.bash_profile"

# Variables to point to various folders and make the functions more useful
# Variables are defined without a $, but are called with $ (ex: mainrepo vs. $mainrepo)
# Branches
mainrepo='main-repo-name'
mainrepo2='second-main-repo-name'

# Sprint variable. Update as needed. Meant for your current working branch.
sprint="Sprint-03-02-17"

# Submodules
submodule1="path/to/submodule"
submodule2="path/to/deeper/submodule"

# This should be the name of the folder where your repos live
sites="Sites"

# start a simple server in the folder you cd into, just pass in a port
# EXAMPLE simple 8000
alias simple="python -m SimpleHTTPServer"

# Use sub to load a project or file into Sublime Text. Can be modified for your favorite IDE
# EXAMPLE: sub $mainrepo
sub() {
	cd ~/$sites
	open $1 -a "Sublime Text"
}

# Open up project in Submlime Text and launch a server on port specified
# EXAMPLE: open mainrepo 8000
open(){
	sub $1
	simple $2
}

# Use atom to load project Atom
atom() {
	cd ~/$sites
  open $1 -a "Atom"
}

# Open up project in Atom and launch a server on port specified
# EXAMPLE: open mainrepo 8000
open(){
	atom $1
	simple $2
}

# Pull Submodule Branch
# Allows pull of single submodule and is used in main repo pull function below
# EXAMPLE: pullsub $mainrepo $submodule
pullsub(){
	cd ~/$sites/$1/$2
	git pull origin $3
	echo $2 ' pulled **************************************'
}

# Pull Branch
# EXAMPLE: pull $mainrepo $sprint
pull(){
	cd ~/$sites/$1
	# Checks if branch exists on remote and if true, it fetch/merges the changes
	if git ls-remote --exit-code . origin/${2}; then
  		git pull origin $2
	fi
	# Checks if the submodule exists, if true, navigate there
	if [ -d "${HOME}/${sites}/${1}/${submodule}" ]; then
		cd ~/$sites/$1/$submodule
		# Checks if branch exists on remote and if true, it fetch/merges the changes
		if git ls-remote --exit-code . origin/${2}; then
	  		pullsub $1 $submodule $2
	  fi
	fi
	if [ -d "${HOME}/${sites}/${1}/${submodule2}" ]; then
		cd ~/$sites/$1/$submodule2
		if git ls-remote --exit-code . origin/${2}; then
  			pullsub $1 $submodule2 $2
  	fi
	fi
}

# Checkout Submodule Branch
# Allows checkout of single submodule and is used in main repo checkout function below
# EXAMPLE: checkoutsub $mainrepo $submodule
checkoutsub(){
	cd ~/$sites/$1/$2
  git checkout $3
	git pull origin $3
	cd ~/$sites/$1
	echo $2 'checked out **************************************'
}

# Checkout All Branches
# EXAMPLE: checkout $mainrepo $sprint
checkout(){
	cd ~/$sites/$1
	# Checks if branch exists on remote and if true, it does a checkout
	if git ls-remote --exit-code . origin/${2}; then
  	git checkout $2
		git pull origin $2
	fi
	# Checks if the submodule exists, if true, navigate there
	if [ -d "${HOME}/${sites}/${1}/${submodule}" ]; then
		cd ~/$sites/$1/$submodule
		# Checks if branch exists on remote and if true, it does a checkout
		if git ls-remote --exit-code . origin/${2}; then
  		checkoutsub $1 $submodule $2
  	fi
	fi
	if [ -d "${HOME}/${sites}/${1}/${submodule2}" ]; then
		cd ~/$sites/$1/$submodule2
		# Checks if branch exists on remote and if true, it does a checkout
		if git ls-remote --exit-code . origin/${2}; then
  		checkoutsub $1 $submodule2 $2
  	fi
	fi
}

# New Main Branch
# EXAMPLE: newbranch $mainrepo branchname
newbranch(){
	cd ~/$sites/$1
	git checkout -b $2
	git pull origin $2
}

# New Submodule Branch
# EXAMPLE: newbranchsub $mainrepo $submodule branchname
newbranchsub(){
	cd ~/$sites/$1/$2
	git checkout -b $3
	git pull origin $3
}

# Create new branches for all main branches that share submodules
# To call: newbranches newbranchname
# EXAMPLE: newbranches Sprint-2-2-17
newbranches(){
	cd ~/$sites/$mainrepo
	git checkout master
	git pull origin master
	git submodule foreach git checkout master
	git submodule foreach git pull origin master
	git submodule foreach git checkout -b $1
	git submodule foreach git push -u origin $1
	git checkout -b $1
	git push -u origin $1

	# Creates new branch on second main repo that shares the submodules
	cd ~/$sites/$mainrepo2
	git checkout master
	git pull origin master
	git checkout -b $1
	git push -u origin $1
}

# Update and push pointers to master. Keeps submodule pointers up to date
# EXAMPLE: pushpointers $mainrepo "commit message"
pushpointers(){
	cd ~/$sites/$1
	git checkout master
	git pull origin master
	git submodule foreach git checkout master
	git submodule foreach git pull origin master
	if [ -d "${HOME}/${sites}/${1}/${submodule}" ]; then
  	git add $submodule
		echo $submodule ' files added **************************************'
	fi
	if [ -d "${HOME}/${sites}/${1}/${submodule2}" ]; then
  	git add $submodule2
		echo $submodule2 ' files added **************************************'
	fi
	git commit -a -m $3
	git push origin master
}

# Webserver
alias startweb="sudo apachectl start"
alias restartweb="sudo apachectl restart"
alias stopweb="sudo apachectl stop"

# Show/Hide hidden folders
# option + click on the finder icon and relaunch finder for this to take effect
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles FALSE"

# Restart the laptop camera when it fails
alias camera='sudo killall VDCAssistant'
