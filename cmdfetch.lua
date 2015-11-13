#!/bin/lua
----  CMDFetch v.5.0.0
----  See "cmdfetch --help" or "cmdfetch -h" for documentation
----  Made by Hal in Lua 5.2 for Windows 7 or 8 with or without Cygwin
----  Thanks to Zanthas and the rest of the original CMDFetch team
----  Thanks to KittyKatt and the makers of screenfo

xpcall(function() require("socket") end,nil)
xpcall(function() require("socket/socket") end,nil)





local help = (
[[Write an OS logo to the output with relevant information.

  -0, --nocolor         Force the use of zero colors
  -1, --18color         Force the use of 18 colors
  -2, --256color        Force the use of 256 colors
  -a, --align           Align the information into columns
  -b, --block [#>0]     Use a stripe step as high and as wide as the argument
  -c, --color color     Change the color of the logo
                            See --help color for formatting help
  -h, --help            
  -l, --logo logo       Change the logo
                            windows8, windows7, linux, mac, none
  -L, --lefty           Toggle the switching of logo and information
  -s, --stripe [dir]    Stripe the colors for the logo à la screenfo
                            vertical, horizontal, none
  -v, --vert alignment  Align the shorter column vertically
                            center,top,bottom (defaults to center)
  -m, --margin #,#      Set the padding around the logo

v.5.0.2 by Hal, Zanthas, tested (and approved) by KittyKatt, other people]])

local colorhelp = (
[[The following patterns are acceptable:

  16-255:
      Ex. ←[38;5;87m87←[0m; ←[1;31m9←[0m
  black,red,green,yellow,blue,magenta,cyan,white:
      Ex. ←[0;33myel←[1;33mlow←[0m; ←[0;34mbl←[1;34mue←[0m
  List:
      Ex. ←[1;30m8←[0m,←[38;5;52m52←[0m,←[0;31mred←[0m,←[1;31mlightred←[0m
  none:
      Ex. none
  rainbow:
      Ex. ←[1;31mr←[1;33ma←[1;32mi←[1;36mn←[1;34mb←[1;35mo←[1;31mw←[0m

If you are seeing arrows followed by brackets, numbers, and semicolons
you have no color support in your terminal.]])





local fhost,fport = "localhost","3333"
local mhost,mport = "localhost","6600"

local options = {
	align = true,
	lefty = true,
	bars = true,
	bright = false,
	dull = false,
	vert = "center",
	logo = true,
	info = true,
	margins = {1,2},
	stripe = 0,
	block = 1,
}

local order = {
	"Name","OS","Uptime","Kernel","Now Playing","Visual Style","Memory",
	"Disk Space","CPU","GPU"
}




local logos = {
	windows8 = {	"                         ....::::",
					"                 ....::::::::::::",
					"        ....:::: ::::::::::::::::",
					"....:::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					"................ ................",
					":::::::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					":::::::::::::::: ::::::::::::::::",
					"'''':::::::::::: ::::::::::::::::",
					"        '''':::: ::::::::::::::::",
					"                 ''''::::::::::::",
					"                         ''''::::"},
	windows7 = {	'        ,.=:!!t3Z3z.,               ',
					'       :tt:::tt333EE3               ',
					'       Et:::ztt33EEEL @Ee.,      ..,',
					'      ;tt:::tt333EE7 ;EEEEEEttttt33#',
					'     :Et:::zt333EEQ. $EEEEEttttt33QL',
					'     it::::tt333EEF @EEEEEEttttt33F ',
					'    ;3=*^```"*4EEV :EEEEEEttttt33@. ',
					'    ,.=::::!t=., ` @EEEEEEtttz33QF  ',
					'   ;::::::::zt33)   "4EEEtttji3P*   ',
					'  :t::::::::tt33.:Z3z..  `` ,..g.   ',
					'  i::::::::zt33F AEEEtttt::::ztF    ',
					' ;:::::::::t33V ;EEEttttt::::t3     ',
					' E::::::::zt33L @EEEtttt::::z3F     ',
					'{3=*^```"*4E3) ;EEEtttt:::::tZ`     ',
					'             ` :EEEEtttt::::z7      ',
					'                 "VEzjt:;;z>*`      '},
	none = {		""}
}

local colormaps = {
	windows8 = {
		{{1,33}},{{1,33}},{{1,33}},{{1,33}},{{1,33}},{{1,33}},{{1,33}},
		{{1,33}},{{1,33}},{{1,33}},{{1,33}},{{1,33}},{{1,33}},{{1,33}},
		{{1,33}},{{1,33}},{{1,33}}
	},
	windows7 = {
		{{1,36}},{{1,36}},{{1,21},{2,15}},{{1,20},{2,16}},{{1,20},{2,16}},
		{{1,19},{2,17}},{{1,18},{2,18}},{{4,16},{1,2},{2,18}},{{4,17},{2,19}},
		{{4,17},{3,6},{2,4},{3,9}},{{4,16},{3,20}},{{4,15},{3,21}},
		{{4,15},{3,21}},{{4,14},{3,22}},{{4,14},{3,22}},{{4,16},{3,20}},
	},
	none = {
		{{1,1}}
	}
}

local colornames = {
	windows8 = {"lightcyan"},
	windows7 = {"red","green","yellow","blue"},
	linux = {"yellow","lightblack","white"},
	mac = {"green","yellow","lightred","red","magenta","blue"},
	none = {}
}

local colors = {
	"black","red","green","yellow","magenta","blue","cyan","white"
}






local function getwmic(alias,key)
	for line in io.popen(("wmic %s get %s"):format(alias,key)):lines() do
		if not line:lower():match(key) then
			return (line:gsub("%s"," "))
		end
	end
end





local ostype,depth = os.getenv("TERM") and "cygwin" or "windows"

do
	--  Automatic color depth tests
	if ostype == "cygwin" then
		depth = "16" --os.getenv("TERM") == "cygwin" and "16" or "256"
	else
		depth = os.getenv("ANSICON") and "16" or "0"
	end
end

local reset = depth == "0" and "" or "\027[0m"

local logo = getwmic("os","caption"):match("7") and "windows7" or "windows8"





local function getcolor(x)
	if type(x) == "number" then
		return x < 16 and (
			("\027[%s;3%sm"):format(x<8 and 0 or 1,x%8)
		) or (
			("\027[38;5;%sm"):format(x)
		)
	elseif type(x) == "string" then
		for _,color in pairs(colors) do
			if x == color or x == "light"..color then
				return depth ~= "0" and ("\027[%s;3%sm"):format(
					(x:match("light") and 1 or 0),
					({
						["black"]=0,["red"]=1,["green"]=2,["yellow"]=3,
						["blue"]=4,["magenta"]=5,["cyan"]=6,["white"]=7
					})[(x:gsub("light",""))]
				) or ""
			end
		end
	elseif x == nil then
		return ""
	end
end





do
	local flags = {{_,{}}}
	for i = 1,#arg do
		if arg[i]:sub(1,1) == "-" then
			table.insert(flags,{arg[i],{}})
		else
			table.insert(flags[#flags][2],arg[i])
		end
	end
	for _,args in pairs(flags) do
		if args[1] == "-h" or args[1] == "--help" then
			if args[2][1] == "color" then
				print((colorhelp:gsub("←","\027")))
			elseif not args[2][1] then
				print(help)
			else
				print(("Invalid argument for %s: %s"):format(args[1],args[2]))
			end
			os.exit()
		elseif args[1] == "-0" or args[1] == "--nocolor" then
			depth = "0"
		elseif args[1] == "-1" or args[1] == "--18color" then
			depth = "16"
		elseif args[1] == "-2" or args[1] == "--256color" then
			depth = "256"
		elseif args[1] == "-l" or args[1] == "--logo" then
			if colornames[string.lower(args[2][1])] then
				logo = string.lower(args[2][1])
			end
		elseif args[1] == "-v" or args[1] == "--vert" then
			if args[2][1] == "center" or args[2][1] == "top" or args[2][1] == "bottom" then
				options.vert = args[2][1]
			end
		elseif args[1] == "-c" or args[1] == "--color" then
			local args = table.concat(args[2]," ")
			if args:match(",") then
				for i,_ in pairs(colornames) do
					colornames[i] = {}
				end
				args = args:gsub("%s","")
				for color in args:gmatch("[^,]+") do
					color = tonumber(color) or color
					if getcolor(color) then
						for i,_ in pairs(colornames) do
							table.insert(colornames[i],color)
						end
					else
						print(("Invalid color: %s"):format(color))
						os.exit()
					end
				end
			elseif args == "none" then
				for i,_ in pairs(colornames) do
					colornames[i] = {}
				end
			elseif args == "rainbow" then
				for i,_ in pairs(colornames) do
					colornames[i] = {
						"lightred","lightyellow","lightgreen","lightcyan",
						"lightblue","lightmagenta"
					}
				end	
			else
				local done
				for _,color in pairs(colors) do
					if string.lower(args) == color then
						for i,_ in pairs(colornames) do
							colornames[i] = {color,"light"..color}
						end
						done = true
					end
				end
				if not done then
					print(("Invalid color: %s"):format(args))
					os.exit()
				end
			end
		elseif args[1] == "-m" or args[1] == "--margin" then
			if (args[2][1] or ""):match("%d,%d") == args[2][1] and args[2][1] then
				local l,r = args[2][1]:match("(%d),(%d)")
				options.margins = {tonumber(l),tonumber(r)}
			else
				print(("Invalid margin format: %s"):format(args[2][1]))
				os.exit()
			end
		elseif args[1] == "-s" or args[1] == "--stripe" then
			local tab = {vertical=1,horizontal=2,none=0}
			if tab[args[2][1]] then
				options.stripe = tab[args[2][1]]
			else
				print(("Invalid stripe format: "):format(args[2][1]))
				os.exit()
			end
		elseif args[1] == "-b" or args[1] == "--block" then
			if tonumber(args[2][1]) and (tonumber(args[2][1]) or 0) > 0 then
				options.block = tonumber(args[2][1])
			else
				print(("Invalid block format: "):format(args[2][1]))
				os.exit()
			end
		elseif args[1] == "-a" or args[1] == "--align" then
			options.align = not options.align
		elseif args[1] == "-L" or args[1] == "--lefty" then
			options.lefty = not options.lefty
		end
	end
end





local function caps(str)
	return string.upper(str:sub(1,1))..string.lower(str:sub(2))
end

local function ctrim(str)
	return ((str or ""):gsub("\027%[[%d;]+m",""))
end

local function maplogo(logo)
	local len,out = logos[logo][1]:len(),{}
	for i,line in pairs(logos[logo]) do
		local d = 1
		for _,pair in pairs(colormaps[logo][i]) do
			local w = pair[2]
			local color = colornames[logo][pair[1]]
			if not color then
				local n,a = colornames[logo],pair[1]
				color = colornames[logo][a%#n == 0 and #n or a%#n]
			end
			out[i] = (out[i] or "")..getcolor(color)..line:sub(d,d+w-1)
			d = d + w
		end
	end
	return out
end

--11223344
--abcdefgh

local function stripelogo(logo)
	local stripe,block,log = options.stripe,options.block,logos[logo]
	local lc = colornames[logo]
	local out = {}
	if stripe == 1 then
		for x = 1,math.ceil(log[1]:len()/block) do
			for y = 1,#log do
				local color = getcolor(lc[x%#lc == 0 and #lc or x%#lc])
				out[y] = (out[y] or "")..color..log[y]:sub(x*block-(block-1),x*block)
			end
		end
	elseif stripe == 2 then
		for y = 0,math.ceil(#log/block) do
			for yo = 1,block do
				local color = getcolor(lc[(y+1)%#lc == 0 and #lc or (y+1)%#lc])
				if log[y*block+yo] then
					out[y*block+yo] = (out[y*block+yo] or "")..color..log[y*block+yo]
				end
			end
		end
	end
	return out
end

local function trim(str,len)
	return (str:len() <= len) and str or str:sub(0,len-3).."..."
end

local function colorscale(value,max)
	if depth == "256" then
		local scale = math.min(math.floor(value/(max/11))+1,11)
		return getcolor(16+math.min(scale-1,5)*36+math.min(11-scale,5)*6)
	elseif depth == "16" then
		return getcolor(({
			"green","yellow","red"
		})[math.min(math.floor(value/(max/3))+1,3)])
	else
		return ""
	end
end

local function bar(percent)
	local barwidth = math.floor(10*percent/100+0.5)
	return ("[%s%s%s%s]"):format(
		colorscale(percent,100),("="):rep(barwidth),reset,
		("-"):rep(10-barwidth)
	)
end

local function tn(...)
	local out = {...}
	for i,v in pairs(out) do out[i] = tonumber(v) end
	return unpack(out)
end

local function uptime()
	local lastBootUp = getwmic("os","lastbootuptime")
	local pattern="(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)"
	local y,m,d,h,mi,s=tn((lastBootUp):match(pattern))
	local up = {}
	up.days,up.hours,up.mins,up.secs = os.date("!%j %H %M %S",os.time()-os.time{
		year=y,month=m,day=d,hour=h,minu=mi,sec=s
	}):match("(.+)%s(.+)%s(.+)%s(.+)")
	up.days = up.days - 1
	for a,b in pairs(up) do
		up[a] = tonumber(b)
	end
	return up
end

local function plural(n)
	return n ~= 1 and "s" or ""
end

local function getos()
	return getwmic("os","caption")
end

local function getkernel()
	return ostype == "windows" and (
		os.getenv("OS").." "..getwmic("os","version")
	) or (
		io.popen("uname -sr"):read()
	)
end

local function getname()
	local name = os.getenv(ostype == "cygwin" and "USER" or "USERNAME")
	local domain = os.getenv(ostype == "cygwin" and "HOSTNAME" or "USERDOMAIN")
	if depth == "256" then
		return ("\027[38;5;178m%s\027[1;37m@\027[38;5;240m%s"):format(
			name,domain..reset
		)
	elseif depth == "16" then
		return ("\027[0;33m%s\027[0;37m@\027[0;30m%s"):format(
			name,domain..reset
		)
	else
		return ("%s@%s"):format(name,domain)
	end
end

local function getfoobar()
	local foobar = socket.connect(fhost,fport)
	if foobar then
		local out
		repeat out = foobar:receive() until out:match("111")
		foobar:close()
		return out:match(".+|.+|.+|.+|.+|.+|(.+)|.+|.+|.+|.+|(.+)|")
	end
end

local function getmpd()
	local mpd = socket.connect(mhost,mport)
	if mpd then
		mpd:send("currentsong\r\n")
		local artist,track
		repeat
			local line,err = mpd:receive()
			local tag,value = line:match("(.-): (.+)")
			artist = artist or (tag == "Artist" and value)
			track = track or (tag == "Title" and value)
		until line == "OK" or line:match("ACK") or (not line)
		mpd:close()
		return artist,track
	end
end

local function getsong()
	if not socket then return "N/A - N/A" end
	foobar,mpd = {getfoobar()},{getmpd()}
	local artist = foobar[1] or mpd[1] or "N/A"
	local track = foobar[2] or mpd[2] or "N/A"
	return ("%s - %s"):format(artist,track)
end

local function getmemory()
	local ram = getwmic("os","totalvisiblememorysize")
	local freeram = getwmic("os","freephysicalmemory")
	local usedram = math.floor(((ram - freeram)/1024)+.5)
	local ram = math.floor((tonumber(ram)/1024)+.5)
	local percentage = math.floor((usedram/ram*100)*10+0.5)/10
	
	local width = (usedram..ram..percentage):len()+8
	local bar = bar(usedram/ram*100)
	local space = (" "):rep(24-width)
	
	local color = colorscale(usedram,ram) or ""
	local format = "%s%s%s/%s MB (%s%s%%%s) %s"
	
	return format:format(color,usedram,reset,ram,color,percentage,reset,space..bar)
end

local function getuptime()
	local uptime = uptime()
	local out = "%s day%s %s hour%s %s min%s %s second%s"
	local days,hours,mins,secs
	days,hours,mins,secs = uptime.days,uptime.hours,uptime.mins,uptime.secs
	return out:format(
		getcolor("lightwhite")..days..reset,plural(days),
		(colorscale(uptime.hours,24) or "")..hours..reset,plural(hours),
		(colorscale(uptime.mins,60) or "")..mins..reset,plural(mins),
		(colorscale(uptime.secs,60) or "")..secs..reset,plural(secs)
	)
end

local function getspace()
	local space,out = io.popen("wmic logicaldisk get freespace,size"),{}
	local drives,max = {},0
	for line in space:lines() do
		if line:match("%d") then
			local freespace,size = line:match("(%d+)%s+(%d+)")
			local usedspace = size-freespace
			local total = math.floor(size/1024^3*10+0.5)/10
			local used = math.floor(usedspace/1024^3*10+0.5)/10
			local percent = math.floor(used/total*1000+0.5)/10
			local color = colorscale(used,total) or ""
			
			local width = (used..total..percent):len()+8
			local bar = bar(used/total*100)
			local space = (" "):rep(24-width)
			local format = "%s%s%s/%s GB (%s%s%%%s) %s"
			
			table.insert(out,format:format(
				color,used,reset,total,color,percent,reset,space..bar
			))
		end
	end
	return unpack(out)
end

local function getcpu()
	for line in io.popen("wmic cpu get loadpercentage,name"):lines() do
		if line:match("%d") then
			local usage,name = line:match("(%d+)%s+(.+)")
			name = name:gsub("%s+"," "):gsub("%([RTM]+%)","")
			
			local color = colorscale(tonumber(usage),100) or ""
			local usage = tonumber(usage)
			local space,bar = (" "):rep(17-string.len(usage)),bar(usage)
			
			local format = "Usage: %s%s%%%s%s%s"
			return format:format(color,usage,reset,space,bar),name
		end
	end
end

local function getgpu()
	local gpu,gpulines = io.popen("wmic path Win32_VideoController get caption"),{}
	for line in gpu:lines() do
		if line and not line:lower():find("caption") and line:find("%w") then
			line = line:gsub("%(Microsoft Corporation %- WDDM 1%.0%)","")
			table.insert(gpulines,(line:gsub("%s+"," "):gsub("%([RTM]+%)","")))
		end
	end
	return unpack(gpulines)
end

function getvs()
    local theme,dir1,dir2
    dir1 = [[HKCU\Software\Microsoft\Windows\CurrentVersion\ThemeManager]]
	dir2 = [[HKCU\Software\Microsoft\Windows\CurrentVersion\Themes]]
	local key = 'cmd /c "2>nul reg query '..dir1..' /v DllName"'
	for line in io.popen(key):lines() do
		if line:match("DllName") then
			return line:match("([^\\]+)%.msstyles")
		end
	end
	--  There isn't a visual style found
	--  This is often the case when using Windows Classic
	local key = 'cmd /c "2>nul reg query '..dir2..' /v CurrentTheme"'
	for line in io.popen(key):lines() do
		if line:match("CurrentTheme") then
			--  This is more difficult
			--  Reads the .theme file to determine the theme
			return caps(line:match("(%w+)%.theme"))
		end
	end
end





local format = {
	["Name"] = getname,	["OS"] = getos,	["Uptime"] = getuptime,
	["Kernel"] = getkernel,	["Now Playing"] = getsong,
	["Memory"] = getmemory,	["Disk Space"] = getspace, ["CPU"] = getcpu,
	["Visual Style"] = getvs, ["GPU"] = getgpu
}





local infocolor = colornames[logo][1]

local information,info = {},{}

for _,v in pairs(order) do
	table.insert(information,{v..":",{format[v]()}})
end

if options.align then
	local longest = 0
	for _,l in pairs(order) do
		longest = math.max(longest,string.len(l))
	end
	for _,v in pairs(information) do
		v[1] =  (" "):rep((longest+1)-v[1]:len())..v[1]
	end
end

for _,e in pairs(information) do
	table.insert(info,getcolor(infocolor)..e[1]..reset.." "..e[2][1])
	for i = 2,#e[2] do
		table.insert(info,(" "):rep(e[1]:len())..reset.." "..e[2][i])
	end
end

local c1,c2 = _,info

if options.stripe == 0 then
	c1 = maplogo(logo)
else
	c1 = stripelogo(logo)
end

if options.lefty then
	c2,c1 = c1,c2
	local max = 0
	for i = 1,#c1 do
		max = math.max(max,ctrim(c1[i]):len())
	end
	for i = 1,#c1 do
		c1[i] = c1[i]..(" "):rep(max-ctrim(c1[i]):len())
	end
end

if options.vert ~= "top" then
	local unit
	if options.vert == "center" then
		unit = math.floor((math.max(#c1,#c2)-math.min(#c1,#c2))/2)
	elseif options.vert == "bottom" then
		unit = math.max(#c1,#c2)-math.min(#c1,#c2)
	end
	local smaller = ({[#c1]=c1,[#c2]=c2})[math.min(#c1,#c2)]
	if unit ~= 0 then
		for i = #smaller,1,-1 do
			smaller[i+unit] = smaller[i]
			smaller[i] = nil
		end
	end
end

for i = 1,math.max(#c1,#c2) do
	local m1,m2 = unpack(options.margins)
	m1,m2 = (" "):rep(m1),(" "):rep(m2)
	print(m1..(c1[i] or (" "):rep(ctrim(c1[#c1]):len()))..m2..(c2[i] or ""))
end

io.write("\027[0m")
