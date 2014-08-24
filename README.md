<<<<<<< HEAD
###History
---
This is version 5.0.0 of CMDFetch. CMDFetch is a clone of screenfetch/screenfo for Windows written in Lua. CMDFetch was written as a batch file and distributed with proprietary binaries until version 2.0.0. Version 2.0.0 and later are written in Lua with no proprietary dependencies Version 2.1.5 was re-written from the bottom up as version 3.0.0 with several new features. Version 4 was a feature clone of Version 3 with a cleaner code base, but it never saw completion. Version 5 is a rewrite of Version 4 with a modified feature set. Versions 3.0.0 to 4.0.0 are source independent of versions predating 2.0.0 like Winfetch, but are a continuation of the project and contain fragments of code from versions after 2.0.0.  Versions 5.0.0 and after are source independent of all previous versions, but functionally comparable.
=======
###Notes
---
Binaries built with srlua, use one if you trust me I guess, or wrap one yourself from the srlua source. I'd appreciate any comments on this, for those brave enough to run the binary or wrap the modified source themselves. Differences include the removal of the crunchbang from the top of the file, srlua doesn't like that and it isn't used, and the removal of the error to stdout pipe, that will probably cause an error if you don't have bbLean installed, please let me know. The binary currently is not cooperating with the "Now Playing" line. It is recommended that you use the source and not the binary.

###History
---
This is version 3.0.2 of CMDFetch. CMDFetch is a clone of screenfetch/screenfo for Windows written in Lua. CMDFetch was written as a batch file and distributed with proprietary binaries until version 2.0.0. Version 2.1.5 was re-written from the bottom up as version 3.0.0 with several new features. Version 2.1.5 can be obtained at http://sourceforge.net/projects/cmdfetch/ and versions 2.1.4 and under can be obtained at http://cmdfetch.inb4u.com/. CMDFetch was originally written before screenfetch supported Cygwin, to this day it retains features that screenfetch doesn't have. Version 3.0.0 is source independant of versions predating 2.0.0 like Winfetch, but is a continuation of the project and contains fragments of code from versions after 2.0.0. 

###Changelog
---
+  Version 3.0.2
   Small bug fixes
+  Version 3.0.1
   Won't error if lua socket isn't present, will automatically disable the now playing line if it can't load it.
>>>>>>> a9d68a46d9331341072428e602de4427424c0a59

###Arguments:
---
```
<<<<<<< HEAD
  -0, --nocolor         Force the use of zero colors
  -1, --18color         Force the use of 18 colors
  -2, --256color        Force the use of 256 colors
  -a, --align           Align the information into columns
  -b, --block [#>0]     Use a stripe step as high and as wide as the argument
  -c, --color color     Change the color of the logo
                            See --help color for formatting help
  -h, --help            
  -l, --logo logo       Change the logo
                            windows8, windows7, linux, mac (defaults to 7 or 8)
  -L, --lefty           Toggle the switching of logo and information
  -s, --stripe [dir]    Stripe the colors for the logo à la screenfo
                            vertical, horizontal, none
  -v, --vert alignment  Align the shorter column vertically
                            center,top,bottom (defaults to center)
  -m, --margin #,#      Set the padding around the logo
=======
  -h, --help            Write what you're looking at to the output
  -c, --color COLOR     Change the color of the logo
                             red, yellow, green, blue, violet
                             black, white, none, cyan, rainbow
  -l, --logo LOGO       Change the logo
                             windows8, windows7, none
  -b, --bright          Use only bright colors
  -d, --dull            Use only dull colors
      --showWarning     Show the Ansicon/Cygwin PTY warning.
  -a, --align           Align the lines
  -s, --stripe [4>#>-1] stripe the colors for the logo in the manner of screenfo
                            Argument: 0: do not stripe (auto)
                                      1: stripe vertically
                                      2: stripe horizontally
                                      3: stripe diagonally
  -B, --block [#>0]     use a stripe step as high and/or as wide as the argument
                            Default: 1
  -L, --lefty           Flip the logo and information
  -C, --center          Center information vertically relative to logo
  -2, --256color        Use 256 colors
  -1, --18color         Force use of 18 colors, do not allow automatic switching
  -D, --down            Position the logo at the bottom of the information
>>>>>>> a9d68a46d9331341072428e602de4427424c0a59
```

###Requires:
---
+  A lua interpreter:
   https://code.google.com/p/luaforwindows/
<<<<<<< HEAD
   After installation you can use "lua cmdfetch.lua" to run cmdfetch
   in your favorite Unix shell or CMD.
   [ http://www.mediafire.com/?eku77kh2i9f14pm ] 
   This is a packaged Lua binary, keeps the footprint small.
+  A method of ANSI escape codes:
   http://adoxa.altervista.org/ansicon/
   This is an application that adds ANSI escape codes to CMD
   >NOTE: Any Cygwin PTY will do instead of this. 
   >The Cygwin Terminal or "Mintty" is installed with
   >the Cygwin base and works fine, you can use Lua in cygwin. As of v.4.0.0,
   >this is the recommended course of action.
   >After you download it, run it and you can use it as you would CMD

+  Lua Socket if you want the "Now Playing" line to work.
+  Foobar Control Server if you want the "Now Playing" line to work with foobar.
   https://code.google.com/p/foo-controlserver/

###Screenshots:
---
<p align="center">
	<img src="http://hal-ullr.github.com/cmdfetch/screenshots/1.png" alt="CMDFetch"/>
	<img src="http://hal-ullr.github.com/cmdfetch/screenshots/2.png" alt="CMDFetch"/>
	<img src="http://hal-ullr.github.com/cmdfetch/screenshots/3.png" alt="CMDFetch"/>
</p>
###Changelog
---
=======
   This will install Lua in Windows.
   After installation you can use "lua source.lua" to run cmdfetch
   in your favorite shell or CMD.
   [ http://www.mediafire.com/?eku77kh2i9f14pm ] 
   This is a packaged Lua binary, keeps the footprint ultra small.
   Unzip it into this directory, and you can start it
   with "lua source.lua" from your favorite shell or CMD.
+  A method of ANSI escape codes:
   http://adoxa.3eeweb.com/ansicon/ This is an application that adds ANSI escape codes to CMD
   >NOTE: Any Cygwin PTY will do instead of this, and you can use
   >another shell. The Cygwin Terminal or "Mintty" is installed with
   >the Cygwin base and works fine, you can use a Cygwin built Lua, too
   >After you download it, run it and you can use it as you would CMD

+  Lua Socket if you want the "Now Playing" line to work. If you don't want to install LuaSocket,
   Just remove the "Now Playing" bit in the ```usedLines``` table at the top of the script.
+  Foobar Control Server if you want the "Now Playing" line to work with foobar. Get it here: https://code.google.com/p/foo-controlserver/

###Screenshots:
---

<p align="center">
	CMDFetch with all lines enabled in the config and the help page
	<img src="http://goput.it/u29z.png" alt="CMDFetch"/>
</p>
<p align="center">
	CMDFetch in bash in cmd, plain config and no arguments
	<img src="http://goput.it/g3kw.png" alt="CMDFetch"/>
</p>
<p align="center">
	CMDFetch in cmd with ansicon, plain config and no arguments
	<img src="http://goput.it/h3po.png" alt="CMDFetch"/>
</p>
<p align="center">
	CMDFetch in urxvt, plain config and a few arguments
	<img src="http://goput.it/2jvh.png" alt="CMDFetch"/>
</p>
<p align="center">
	CMDFetch in urxvt, plain config and a few arguments
	<img src="http://goput.it/2jvh.png" alt="CMDFetch"/>
</p>
<p align="center">
	CMDFetch in mintty with a Windows 8 logo and a few arguments. 256 color support visible.
	<img src="http://goput.it/5lal.png" alt="CMDFetch"/>
</p>
<p align="center">
	CMDFetch in urxvt with all lines enabled in the config and several arguments. 256 color support visible
	<img src="http://goput.it/0miy.png" alt="CMDFetch"/>
</p>
>>>>>>> a9d68a46d9331341072428e602de4427424c0a59
