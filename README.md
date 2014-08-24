###History
---
This is version 5.0.0 of CMDFetch. CMDFetch is a clone of screenfetch/screenfo for Windows written in Lua. CMDFetch was written as a batch file and distributed with proprietary binaries until version 2.0.0. Version 2.0.0 and later are written in Lua with no proprietary dependencies Version 2.1.5 was re-written from the bottom up as version 3.0.0 with several new features. Version four was a feature clone of Version three with a cleaner code base, but it never saw completion. Version five is a rewrite of Version four with a modified feature set. Versions 3.0.0 to 4.0.0 are source independent of versions predating 2.0.0 like Winfetch, but are a continuation of the project and contain fragments of code from versions after 2.0.0.  Versions 5.0.0 and after are source independent of all previous versions, but functionally comparable.

###Arguments:
---
```
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
```

###Requires:
---
+  A lua interpreter:
   https://code.google.com/p/luaforwindows/
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
	<img src="https://raw.githubusercontent.com/hal-ullr/cmdfetch/master/screenshots/1.png" alt="CMDFetch"/>
	<img src="https://raw.githubusercontent.com/hal-ullr/cmdfetch/master/screenshots/2.png" alt="CMDFetch"/>
	<img src="https://raw.githubusercontent.com/hal-ullr/cmdfetch/master/screenshots/3.png" alt="CMDFetch"/>
</p>
###Changelog
---