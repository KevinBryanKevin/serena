# serena
An exciting news game.

# Installation and Setup

In order to run this on your computer, you need to make sure you have the latest version of XCode installed. You will also need to have `git` installed (though this normally already comes with XCode).

1. Open Terminal (Launchpaid -> Terminal)
2. Navigate to your `Documents` directiory by running the command:
```
cd ~/Documents
```
3. Clone the repository by running:
```
git clone https://github.com/RSPiOS/serena.git
```
4. Launch XCode and run the workspace in the newly created `serena` directory.

# Downloading the latest code.
0. First, change directory into your repository. If you followed the instructions above, this should be as simple as doing `cd ~/Documents/serena`.
1. First, if you've made no local changes, run `git reset --hard HEAD`. The command will make sure your code matches the latest version on your computer.
2. Now run `git pull` to pull the latest changes from github.

# Submitting Changes
In order to submit changes, make sure you regiously follow the following procedure. 

1. Make sure that your current app compiles (ie, run it in the simulator) before making any changes.
2. Always run `git pull` in your repository before making any changes!
3. If you get any merge conflicts, resolve them. Also make sure the app runs.
4. Make changes to the code.
5. Make sure the app runs.
6. Commit your changes by running `git add .` and `git commit -am "<SOME MESSAGE TO SAVE>"`
7. Run `git pull` in case someone else made changes.
8. Finally, run `git push` to put your code on github!
