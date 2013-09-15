#!/bin/lua
--//--    Constants/Configuration    --//--
--[[
local                 usedLines = {"Name","Kernel","OS","Memory","Uptime",
                                   "Visual Style","Resolution","CPU","GPU","Disk Space",
                                   "bbLean Theme","Users","Now Playing","Terminal",
                                   "MoBo","Font","WM","Shell","Processes",
                                   "Music Player","IRC Client"}
]]
                      usedLines = {"Name","Kernel","OS","Memory","Uptime",
                                   "Visual Style","Resolution","CPU","GPU","Disk Space",
                                   "bbLean Theme","Now Playing","Terminal","Font",
                                   "WM","Shell","Music Player","IRC Client"}
local               fhost,fport = "localhost","3333"  --  Host and port for foobar
local               mhost,mport = "localhost","6600"  --  Host and port for MPD
local            dominantPlayer = "foobar"  --  Change to "mpd" to check for MPD first
local                 fancyData = true --  Use a more decorative format for numeric data
local              data256Color = false  --  Use 256 colors for data highlighting
local              auto256Color = false  --  Automatically use 256 color data if possible
local             excludedUsers = {}  --  A table of names to exclude from the Users list
local                resetColor = "\027[0m"  -- \027[0;37m is the default in Windows
local               brightColor = "\027[1;37m"  --  \027[1m is usable in a Cygwin PTY
local                      logo = "windows7"  --  Default logo
local                    bright = false  --  default state of the "bright" flag
local                      dull = false  --  default state of the "dull" flag
local                     align = false  --  default state of the "align"  flag
local                     lefty = false  --  default state of the "lefty" flag
local                      down = false  --  default state of the "down" flag 
local                    center = false  --  default state of the "center" flag
local                noNotFound = true  --  Don't show information when it isn't found
local               useCPUUsage = false  -- Show CPU usage
local                    stripe = 0  --  default state of the "stripe" flag
local                     block = 1  -- default state of the block size
local                     logos = {}
local                    colors = {}
                colors["black"] = {"\027[0;30m","\027[1;30m"}
                  colors["red"] = {"\027[0;31m","\027[1;31m"}
               colors["yellow"] = {"\027[0;33m","\027[1;33m"}
                colors["green"] = {"\027[0;32m","\027[1;32m"}
                 colors["blue"] = {"\027[0;34m","\027[1;34m"}
               colors["violet"] = {"\027[0;35m","\027[1;35m"}
                 colors["cyan"] = {"\027[0;36m","\027[1;36m"}
                colors["white"] = {"\027[0;37m","\027[1;37m"}
                colors["white"] = {"\027[0;37m","\027[1;37m"}
              colors["rainbow"] = {"\027[1;35m","\027[1;31m","\027[1;33m",
                                   "\027[1;32m","\027[0;36m","\027[1;34m"}
                 colors["none"] = {"\027[0m"}
local                colorNames = {"blue","yellow","red","green","violet",
                                   "cyan","black","white","none","rainbow"}
local             lineFunctions = {}
              logos["windows7"] = {}
              logos["windows8"] = {}
          logos["windows7"][01] = "${c1}        ,.=:!!t3Z3z.,               "
          logos["windows7"][02] = "${c1}       :tt:::tt333EE3               "
          logos["windows7"][03] = "${c1}       Et:::ztt33EEEL${c2} @Ee.,      ..,"
          logos["windows7"][04] = "${c1}      ;tt:::tt333EE7${c2} ;EEEEEEttttt33#"
          logos["windows7"][05] = "${c1}     :Et:::zt333EEQ.${c2} $EEEEEttttt33QL"
          logos["windows7"][06] = "${c1}     it::::tt333EEF${c2} @EEEEEEttttt33F "
          logos["windows7"][07] = "${c1}    ;3=*^```\"*4EEV${c2} :EEEEEEttttt33@. "
          logos["windows7"][08] = "${c4}    ,.=::::!t=., ${c1}`${c2} @EEEEEEtttz33QF  "
          logos["windows7"][09] = "${c4}   ;::::::::zt33)${c2}   \"4EEEtttji3P*   "
          logos["windows7"][10] = "${c4}  :t::::::::tt33.${c3}:Z3z..${c2}  ``${c3} ,..g.   "
          logos["windows7"][11] = "${c4}  i::::::::zt33F${c3} AEEEtttt::::ztF    "
          logos["windows7"][12] = "${c4} ;:::::::::t33V${c3} ;EEEttttt::::t3     "
          logos["windows7"][13] = "${c4} E::::::::zt33L${c3} @EEEtttt::::z3F     "
          logos["windows7"][14] = "${c4}{3=*^```\"*4E3)${c3} ;EEEtttt:::::tZ`     "
          logos["windows7"][15] = "${c4}             `${c3} :EEEEtttt::::z7      "
          logos["windows7"][16] = "${c3}                 \"VEzjt:;;z>*`      "
    logos["windows7"]["colors"] = {"\027[1;31m","\027[1;32m","\027[1;33m","\027[1;36m"}
          logos["windows8"][01] = "${c1}                         ....::::"
          logos["windows8"][02] = "${c1}                 ....::::::::::::"
          logos["windows8"][03] = "${c1}        ....:::: ::::::::::::::::"
          logos["windows8"][04] = "${c1}....:::::::::::: ::::::::::::::::"
          logos["windows8"][05] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][06] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][07] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][08] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][09] = "${c1}................ ................"
          logos["windows8"][10] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][11] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][12] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][13] = "${c1}:::::::::::::::: ::::::::::::::::"
          logos["windows8"][14] = "${c1}'''':::::::::::: ::::::::::::::::"
          logos["windows8"][15] = "${c1}        '''':::: ::::::::::::::::"
          logos["windows8"][16] = "${c1}                 ''''::::::::::::"
          logos["windows8"][17] = "${c1}                         ''''::::"
    logos["windows8"]["colors"] = {"\027[1;34m"}
                  logos["none"] = {""}
        logos["none"]["colors"] = {resetColor}
local                     color
local                 logoNames = {"windows7","windows8","none"}

--//    Functions    //--

local function CamelCase(phrase)
    for word in phrase:gmatch("[^%s]+") do
        phrase = phrase:gsub(word,string.upper(word:sub(1,1))..word:sub(2))
    end
    return phrase
end

local function errorString(str)
    if canColor then
        print(lightRed.."Error: "..str.."\nSee --help"..resetColor)
    else
        print("Error: "..str.."\nSee --help")
    end
end

local function lineFromFile(file,num)
    it=1
    for line in file:lines() do
        if num == it then
            return line
        end
        it = it+1
    end
end

local function receive(connection,player)
    if player == dominantPlayer then
        local lines = ""
        while true do
            local line = connection:receive()
            if line:sub(1,3) ~= "999" then
                return line
            end
            if not line then
                break
            end
        end
    else
        local lines = ""
        while true do
            local line,err = connection:receive()
            if not line then return false,err end
            lines = lines..line
            if line == "OK" or line:match("ACK") then break end
            lines = lines.."\n"
        end
        return lines
    end
end

local function warning()
    print("This version of CMDFetch uses Ansi escape codes.")
    print("Various Cygwin PTY's provide these, you can use Ansicon to get them")
    print("in Windows CMD.")
    print("  [ Ansicon can be found here:       ]")
    print("  [ http://adoxa.3eeweb.com/ansicon/ ]")
    print("Windows 8 Users should use Ansicon x86 even if they use x64 Windows")
    print("You can try it out with \"-c none\"\n")
    return
end

local function getGood(words)
    local word = io.popen(words)
    for line in word:lines() do
        if not line:lower():find(string.lower(words:match("get (%w+)"))) then
            local out = line:match("[\032%w%p_]+"):gsub("%s*$","")
            return out
        end
    end
end

local function colorCap(a,b) 
    if b == 0 then
        return "\027[0m"
    end
    if data256Color then
        slider = {46,82,118,154,190,226,220,214,208,202,198}
        for i = 1,#slider do
            slider[i] = "\027[38;5;"..slider[i].."m"
        end
    else
        slider = {"\027[1;32m","\027[0;32m","\027[0;33m","\027[0;31m","\027[1;31m"}
    end
    slider[0] = slider[1]
    return slider[math.floor((a/b*(#slider))+0.5)]
end

local currentColor = 1
local function toggleColor()
    currentColor = currentColor + 1
    if currentColor > #logos[logo]["colors"] then
        currentColor = 1
    end
    return currentColor
end

--//    Test for Lua Socket    //--

local tests = {"socket/socket","socket"}
local works = false
for i = 1,#tests do
	xpcall(
		function()
			require(tests[i])
		end,
		function(err)
			if not err then
				works = tests[i]
			end
		end
	)
end

if not socket then
	for a = 1,#usedLines do
		if usedLines[a] == "Now Playing" then
			for b = a+1,#usedLines do
				usedLines[b-1] = usedLines[b]
				usedLines[b] = nil
			end
		end
	end
end

--//    Default logo to Windows 8 logo if the user is using Windows 8    //--

local OS = getGood("wmic os get caption")
if OS:find("2012") or OS:find("8") then
    logo = "windows8"
end

--//    Test for Ansi escape codes by terminal emulator    //--

local failedCygwinTest
local failedAnsiconTest
local terminal = os.getenv("TERM")
failedCygwinTest = (terminal == nil)
failedAnsiconTest = (io.popen("cmd /c echo %ANSICON%"):read():match("%d") == nil)
local canColor = not (failedCygwinTest and failedAnsiconTest)
if auto256Color and not failedCygwinTest then
    data256Color = true
end

--//    Functions for lines    //--

lineFunctions["Now Playing"] = function()
    local foobar = socket.connect(fhost,fport)
    local mpd = socket.connect(mhost,mport)
    local artist,track
    if foobar then
        local out = receive(foobar,"foobar")
        artist,track = out:match(".+|.+|.+|.+|.+|.+|(.+)|.+|.+|.+|.+|(.+)|")
        foobar:close()
    elseif mpd then
        mpd:send("currentsong\r\n")
        np = receive(mpd,"mpd")
        for match in np:gmatch("([^\n]+)") do
            local tag,value = match:match("(.-): (.+)")
            if tag and value then
                if tag == "Artist" then
                    artist = value
                elseif tag == "Title" then
                    track = value
                end
            end
        end
        mpd:close()
    end
    if not artist and not track then
        if data256Color then
            return "\027[38;5;240mNot found"
        else
            return "\027[1;30mNot found"
        end
    end
    if fancyData then
        return artist.." "..brightColor.."-\027[0m "..track
    else
        return artist.." - "..track
    end
end

lineFunctions["Name"] = function()
    local nameColor,atColor,hostColor,name,host
    if fancyData and not data256Color then
        nameColor = "\027[0;33m"
        atColor = "\027[0;37m"
        hostColor = "\027[1;30m"
    elseif fancyData and data256Color then
        nameColor = "\027[38;5;178m"
        atColor = brightColor
        hostColor = "\027[38;5;240m"
    else
        nameColor = ""
        atColor =  brightColor
        hostColor = resetColor
    end
    if failedCygwinTest then
        name = os.getenv("USERNAME")
        host = os.getenv("USERDOMAIN")
    else
        name = os.getenv("USER")
        host = os.getenv("HOSTNAME")
    end
    return nameColor..name..atColor.."@"..hostColor..host
end

lineFunctions["OS"] = function()
    architecture = getGood("wmic OS get OSArchitecture")
    local out = OS.." "..architecture
    if fancyData then
        for i = 1,3 do
            out = out:gsub("%"..("_.-"):sub(i,i),brightColor..("_.-"):sub(i,i)..resetColor)
        end
    end
    return out
end

lineFunctions["Kernel"] = function()
    kernelOS = os.getenv("OS")
    kernel = getGood("wmic os get version")
    local out = kernelOS.." "..kernel
    if fancyData then
        for i = 1,3 do
            out = out:gsub("%"..("_.-"):sub(i,i),brightColor..("_.-"):sub(i,i)..resetColor)
        end
    end
    return out
end

lineFunctions["Uptime"] = function()
    local lastBootUp = lineFromFile(io.popen("wmic os get lastbootuptime"),2)
    local pattern="(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)(%d%d)"
    local year,month,day,hour,min,sec=(lastBootUp):match(pattern)
    time1 = os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    })
    local seconds = os.difftime(os.time(),time1)
    local hours = (seconds-(seconds%3600))/3600
    local remainingSeconds = (seconds-(hours*3600))
    local minutes = (remainingSeconds-(remainingSeconds%60))/60
    local seconds = seconds-(hours*3600+minutes*60)
    local nhours = hours%24
    local days = (hours-nhours)/24
    local hours = nhours
    days = brightColor .. days .. "\027[0m"
    hours = colorCap(hours,23)..hours.."\027[0m"
    minutes = colorCap(minutes,60)..minutes.."\027[0m"
    seconds = colorCap(seconds,60)..seconds.."\027[0m"
    out = ("%s days %s hours %s mins %s secs"):format(days,hours,minutes,seconds)
    local pattern = "[^%d]1\027%[0m %a+[s]"
    repeat
        if out:match(pattern) then
            out = out:gsub(pattern,out:match(pattern):gsub("s",""),1):gsub(1,1)
            out = out:gsub("[%s]ec"," sec")  --  If one second, fix issue with matching "1 s"
        end
    until not out:match(pattern)
    return out
end

lineFunctions["Memory"] = function()
    local ramSize = getGood("wmic os get totalvisiblememorysize")
    local ramFree = getGood("wmic os get freephysicalmemory")
    ramUsed = ramSize - ramFree
    ramUsed = math.floor((tonumber(ramUsed)/1024)+.5)
    ramSize = math.floor((tonumber(ramSize)/1024)+.5)
    local color = colorCap(ramUsed,ramSize)
    usedPercentage = math.floor((ramUsed/ramSize*100)*10+0.5)/10
    if fancyData then
        out = "["..color..ramUsed.."\027[0m/"..brightColor..ramSize
        out = out.."\027[0m] MB ("..color..usedPercentage.."%\027[0m)"
        return out
    else
        return color..ramUsed.."\027[0m/"..ramSize.." \027[0mMB"
    end
end

local slider


lineFunctions["Visual Style"] = function()
    local theme
    local dir = {"HKCU","Software","Microsoft","Windows","CurrentVersion","ThemeManager"}
    local stringToMatch1 = "[%w%_]+%s+[%w%_]+%s+([%w%_%-%s%%%p]+)"
    local stringToMatch2 = "([%:%p%w%s%\\]+%\\)([%w%_%-%s%%%p]+)"
    local regKey = "reg query "..table.concat(dir,"\\").." /v DllName"
    local themeFileName = lineFromFile(io.popen("cmd /c \"2>nul "..regKey.."\""),3)
    if not themeFileName then
        --  There isn't a visual style found, just use the theme file
        --  Often in the case of Windows Classic
        dir[6] = "Themes"
        local regKey = "reg query "..table.concat(dir,"\\").." /v CurrentTheme"
        local themeName = lineFromFile(io.popen("cmd /c \"2>nul "..regKey.."\""),3)
        themeName = themeName:match(stringToMatch1)
        pathToTheme,themeName = themeName:match(stringToMatch2)
        --  This is more difficult, currently reads the .theme file, if it is
        --  determined that it is Windows Classic, use "Windows Classic",
        --  otherwise trim the file extension from the theme file and use that.
        local command = "cmd /c type \""..pathToTheme..themeName.."\""
        for line in io.popen(command):lines() do
            found,result = line:find("ColorStyle")
            if found then
                if line:find("Classic") then
                    theme = "Windows Classic"
                else
                    theme = themeName:match("([%s%w]+)")
                    if theme:lower() == "classic" then
                        theme = "Windows Classic"
                    end
                end
            end
        end
    else
        local themeFileName = themeFileName:match(stringToMatch1)
        pathToTheme,themeName = themeFileName:match(stringToMatch2)
        theme = themeName:match("([%p%w%s%_%$-]+).msstyle")
        --  Trimming the file extension should be fine for this.
    end
    return theme
end

lineFunctions["bbLean Theme"] = function()
    local bbLeanTheme
    local tasks = io.popen("tasklist") -- Get task list
    for line in tasks:lines() do
        task = line:match("(%w+)%.exe")
        if task == "blackbox" then
            --  Check for bbLean
            local drive = os.getenv("HOMEDRIVE")
            local dir = "2>&1 cmd /c dir /b "..drive.."\\bbLean "
            if os.getenv("TERM") == "cygwin" then
                dir = dir:gsub("\\","\\\\")
            end
            local dir = io.popen(dir):read()
            if not dir:find("File Not Found") then
                for line in io.open(drive.."/bbLean/blackbox.rc","r"):lines() do
                    key, val = line:match("([%w%.]+): (.+)")
                    if key == "session.styleFile" then
                        bbLeanTheme = val:match("[\\/](.+)")
                    end
                end
            end
        end
    end
    if not bbLeanTheme then
        if data256Color then
            return "\027[38;5;240mNot found"
        else
            return "\027[1;30mNot found"
        end
    end
    bbLeanTheme = bbLeanTheme:gsub("[^\032%w%p_]","")
    return CamelCase(bbLeanTheme)
end

lineFunctions["Resolution"] = function()
    local height,heightLines = io.popen("wmic desktopmonitor get screenheight"),{}
    local width,widthLines = io.popen("wmic desktopmonitor get screenwidth"),{}
    local monitorHeights,monitorWidths = {},{}
    for line in height:lines() do
        table.insert(heightLines,line)
    end
    for line in width:lines() do
        table.insert(widthLines,line)
    end
    for i = 1,math.max(#heightLines,#widthLines) do
        if heightLines[i]:match("%d+") then
            table.insert(monitorHeights,heightLines[i]:match("%d+"))
        end
        if widthLines[i]:match("%d+") then
            table.insert(monitorWidths,widthLines[i]:match("%d+"))
        end
    end
    local out = ""
    for i = 1,#monitorHeights do
        if fancyData then
            out = out..monitorWidths[i]..brightColor.."x\027[0m"..monitorHeights[i].."\n"
        else
            out = out..monitorWidths[i].."x"..monitorHeights[i].."\n"
        end
    end
    return out
end

lineFunctions["CPU"] = function()
    local cpu,cpuLine = io.popen("wmic cpu get name"),""
    for line in cpu:lines() do
        if line and not line:lower():find("name") and line:find("%w") then
            cpuLine = cpuLine..line:gsub("%s+"," "):gsub("%([RTM]+%)","").."\n"
        end
    end
    if useCPUUsage then
        local usage = io.popen("wmic cpu get loadpercentage")
        for line in usage:lines() do
            if line:match("%d+") then
                local usage = colorCap(tonumber(line:match("%d+")),100)..line:match("%d+").."%"
                if not fancyData then
                    return cpuLine.."\027[0mLoad = "..usage
                else
                    return cpuLine.."\027[0mLoad "..brightColor.."= "..usage
                end
            end
        end
    else
        return cpuLine
    end
end

lineFunctions["GPU"] = function()
    local gpu,gpuLine = io.popen("wmic path Win32_VideoController get caption"),""
    for line in gpu:lines() do
        if line and not line:lower():find("caption") and line:find("%w") then
            gpuLine = gpuLine .. line:gsub("%s+"," "):gsub("%([RTM]+%)","") .. "\n"
        end
    end
    return gpuLine:sub(1,-1)
end

lineFunctions["Disk Space"] = function()
    local space = io.popen("wmic logicaldisk get freespace")
    local size = io.popen("wmic logicaldisk get size")
    local spaceLines,sizeLines = {},{}
    local line = ""
    for line in space:lines() do
        if line:find("%d") then
            table.insert(spaceLines,line:match("%d+"))
        end
    end
    for line in size:lines() do
        if line:find("%d") then
            table.insert(sizeLines,line:match("%d+"))
        end
    end
    for i = 1,#sizeLines do
        local used = tonumber(sizeLines[i]) - tonumber(spaceLines[i])
        if not fancyData then
            local usedGB = math.floor(used/1024^3+0.5)
            local spaceGB = math.floor(tonumber(sizeLines[i])/1024^3+0.5)
            local color = colorCap(usedGB,spaceGB)
            line = line..color..usedGB.."\027[0m/"..spaceGB.."GB\n"
        else
            local usedGB = math.floor(used*10/1024^3+0.5)/10
            local spaceGB = math.floor(tonumber(sizeLines[i])*10/1024^3+0.5)/10
            local color = colorCap(usedGB,spaceGB)
            local percent = usedGB/spaceGB*100
            local percent = math.floor(percent*10+0.5)/10
            local out = color..usedGB..brightColor.."/\027[0m"..spaceGB
            local out = out.." ("..color..percent.."%\027[0m) GB"
            line = line..out.."\n"
        end
    end
    return line:sub(1,-1)
end

lineFunctions["Terminal"] = function()
    local term = ""
    if not failedCygwinTest then
        term = terminal
    else
        --  There isn't really a way to check for Console2,
        --  the only other possible terminal emulator...
        term = "Command Prompt"
        local ssh = os.getenv("WINSSHDGROUP")
        --  Account for bitvise ssh here
        if ssh then
            term = "Bitvise ssh"
        end
    end
    return term
end

lineFunctions["Users"] = function()
    local userString = ""
    local users
    if not failedCygwinTest then
        users = io.popen("ls -1 /home")
        --  users = io.popen("cmd /c dir /b %HOMEDRIVE%\\\\Users")
    else
        users = io.popen("dir /b %HOMEDRIVE%\\Users")
    end
    local count = 0
    for line in users:lines() do
        local line = line:gsub("[^\032%w%p_]","")
        local bool = false
        for i = 1,#excludedUsers do
            if excludedUsers[i] == line then
                bool = true
            end
        end
        if not bool then
            local check
            if not failedCygwinTest then
                check = os.getenv("USER")
            else
                check = os.getenv("USERNAME")
            end
            if line == check then
                userString = userString..brightColor..line..resetColor..", "
            else
                userString = userString.. line..", "
            end
            count = count + 1
        end
    end
    return ("(%s) (%s%s\027[0m)"):format(userString:sub(0,-3),brightColor,count)
end

lineFunctions["MoBo"] = function()
    return getGood("wmic csproduct get name")
end

lineFunctions["Font"] = function()
    if failedCygwinTest or terminal == "cygwin" then
        if data256Color then
            return "\027[38;5;240mNot found"
        else
            return "\027[1;30mNot found"
        end
    else
        local default,font
        if terminal:find("xterm") then --attempt to pull from .minttyrc
			local dir = os.getenv("HOMEDRIVE").."\\\\cygwin\\\\home\\\\"..os.getenv("USERNAME")
			local dir = io.popen("cmd /c type "..dir.."\\\\.minttyrc")
			
            for line in dir:lines() do
                if line:sub(1,5) == "Font=" then
                    font = line:match("Font=(.+)")
                end
            end
        end
        for line in io.popen("ls -a ~ -1"):lines() do
            if line == ".Xdefaults" then
                default = ".Xdefaults"
            elseif line == ".Xresources" then
                default = ".Xresources"
            end
        end
        if default and not font then
            for line in io.popen("cat ~/"..default):lines() do
                if terminal:find("xterm") then  --  ambiguous, could be mintty or xterm
                    match = line:match("faceName: (.+)")
                    if match then font = match end
                else
                    match = line:match("font: (.+)")
                    if match then font = match end
                end
            end
        end
        if not font then
            if data256Color then
                return "\027[38;5;240mNot found"
            else
                return "\027[1;30mNot found"
            end
        else
            local font = font:gsub("xft:",""):gsub(":%w+=%w+",""):gsub(",\\",", ")
            return font
        end
    end
end

lineFunctions["WM"] = function()
    local tasks = io.popen("tasklist") -- Get task list
    local WM = ""
    local dwm = false
    for line in tasks:lines() do
        if line:find("dwm.exe") then
            if not dwm then
                if not failedCygwinTest then
                    local ps = io.popen("ps")
                    for line in ps:lines() do
                        if line:find("dwm") then
                            WM = WM.."dwm, "
                        end
                    end
                end
                dwm = true
            end
        elseif line:find("explorer.exe") and not WM:find("Explorer") then
            WM = WM.."Explorer, "
        elseif line:find("blackbox.exe") and not WM:find("bbLean") then
            WM = WM.."bbLean, "
        elseif line:find("wmfs.exe") and not WM:find("wmfs") then
            WM = WM.."wmfs, "
        elseif line:find("xfwm4") and not WM:find("xfwm4") then
            WM = WM.."xfwm4, "
        elseif line:find("bugn") and not WM:find("bug") then
            WM = WM.."bug.n, "
        end
    end
    if not WM then
        if data256Color then
            return "\027[38;5;240mNot found"
        else
            return "\027[1;30mNot found"
        end
    else
        return WM:sub(1,-3)
    end
end

lineFunctions["IRC Client"] = function()
    local tasks = io.popen("tasklist") -- Get task list
    local client = ""
    for line in tasks:lines() do
        if line:find("hexchat%.exe") then
            client = "Hexchat"
        elseif line:find("weechat%-curses%.exe") or line:find("weechat.exe") then
            client = "WeeChat"
        elseif line:find("irssi%.exe") then
            client = "irssi"
        end
    end
    if client == "" then
        if data256Color then
            return "\027[38;5;240mNot found"
        else
            return "\027[1;30mNot found"
        end
    else
        return client
    end
end

lineFunctions["Music Player"] = function()
    local tasks = io.popen("tasklist") -- Get task list
    local player = ""
    for line in tasks:lines() do
        if line:find("winamp.exe") then
            player = "Winamp"
        elseif line:find("foobar2000.exe") then
            player = "Foobar"
        elseif line:find("ncmpcpp.exe") then
            player = "ncmpcpp"
        end
    end
    if player =="" then
        if data256Color then
            return "\027[38;5;240mNot found"
        else
            return "\027[1;30mNot found"
        end
    else
        return player
    end
end

lineFunctions["Shell"] = function()
    if not failedCygwinTest then
        return os.getenv("SHELL") or "Not found"
    else
        return "CMD"
    end
end

lineFunctions["Processes"] = function()
    local tasks = io.popen("tasklist /fo csv /nh") -- Get task list
    local count = 0
    for line in tasks:lines() do
        count = count + 1
    end
    return tostring(count)
end

--//    Help information    //--

helpLines = {
    "Write an OS logo to the output with relevant information.\n",
    "  -h, --help            Write what you're looking at to the output",
    "  -c, --color COLOR     Change the color of the logo",
    "                             red, yellow, green, blue, violet",
    "                             black, white, none, cyan, rainbow",
    "  -l, --logo LOGO       Change the logo",
    "                             windows8, windows7, none",
    "  -b, --bright          Use only bright colors",
    "  -d, --dull            Use only dull colors",
    "      --showWarning     Show the Ansicon/Cygwin PTY warning.",
    "  -a, --align           Align the lines",
    "  -s, --stripe [4>#>-1] stripe the colors for the logo in the manner of screenfo",
    "                            Argument: 0: do not stripe (auto)",
    "                                      1: stripe vertically",
    "                                      2: stripe horizontally",
    "                                      3: stripe diagonally",
    "  -B, --block [#>0]     use a stripe step as high and/or as wide as the argument",
    "                            Default: 1",
    "  -L, --lefty           Flip the logo and information",
    "  -C, --center          Center information vertically relative to logo",
    "  -2, --256color        Use 256 colors",
    "  -1, --18color         Force use of 18 colors, do not allow automatic switching",
    "  -D, --down            Position the logo at the bottom of the information",
    "\nv.3.0.2",
    "By Hal, Zanthas, tested (and approved) by KittyKatt, other people"
}

--//    Argument parsing    //--

function parseArg(arg,arg2)
    if arg == "-h" or arg == "--help" then
        for i = 1,#helpLines do  --  Dump help information
            print(helpLines[i])
        end
        return  -- Stop script here
    elseif arg == "--showWarning" then
        warning()
        return false
    elseif arg == "-D" or arg == "--down" then
        down = not down
        if down then center = false end
    elseif arg == "-2" or arg == "--256color" then
        data256Color = true
    elseif arg == "-1" or arg == "--18color" then
        data256Color = false
    elseif arg == "-c" or arg == "--color" then
        if not arg2 or not colors[string.lower(arg2)] then  --  Argument isn't correct
            print("\nError: Improper syntax for option \"--color\"")
            print("Correct syntax: ")
            print("cmdfetch \"[-c,--color] ["..table.concat(colorNames,",").."]\"")
            return false
        else
            color = string.lower(arg2)
        end
    elseif arg == "-l" or arg == "--logo" then
        if not arg2 or not logos[string.lower(arg2)] then  --  Argument isn't correct
            print("\nError: Improper syntax for option \"--logo\"")
            print("Correct syntax: ")
            print("cmdfetch \"[-l,--logo] ["..table.concat(logoNames,",").."]\"")
            return false
        else
            logo = string.lower(arg2)
        end
    elseif arg == "-b" or arg == "--bright" then
        bright = not bright
        if bright then dull = false end
    elseif arg == "-d" or arg == "--dull" then
        dull = not dull
        if dull then bright = false end
    elseif arg == "-a" or arg == "--align" then
        align = not align
    elseif arg == "-s" or arg == "--stripe" then
        local canfit = (not tonumber(arg2)) or (tonumber(arg2) < 0 or tonumber(arg2) > 3) 
        if not arg2 or canfit then
            print("\nError: Improper syntax for option \"--stripe\"")
            print("Correct syntax:")
            print("cmdfetch \"[-s,--stripe] [4 > number > -1]\"")
            return false
        else
            stripe = tonumber(arg2)
        end 
    elseif arg == "-B" or arg == "--block" then
        if not arg2 or not tonumber(arg2) or tonumber(arg2) <= 0 then  --  Argument isn't correct
            print("\nError: Improper syntax for option \"--block\"")
            print("Correct syntax:")
            print("cmdfetch \"[-b,--block] [number > 0]\"")
            return false
        else
            block = tonumber(arg2)
        end
    elseif arg == "-L" or arg == "--lefty" then
        lefty = not lefty
    elseif arg == "-C" or arg == "--center" then
        center = not center
        if center then down = false end
    elseif arg:sub(1,1) == "-" and arg:sub(2,2) ~= "-" and not arg:find("[^%-hclbdoasBLC12D]") then
        local argblock = arg:sub(2)
        for match in argblock:gmatch("%w") do
            if ("sBcl"):find(match) then
                print("\nError: use of a flag that takes an argument in a argument block")
                print("This is not allowed to ambiguity, use only switches in argument blocks")
                return
            end
            parseArg("-"..match)
        end
    elseif arg:sub(1,1) == "-" and arg:sub(2,2) ~= "-" then
        local wrongArg = arg:match("[^%-hclbdoasBLC12D]")
        print("\nError: unknown flag used in an argument block \""..wrongArg.."\" ")
        print("See --help for a list of valid arguments")
        print("You may have meant to use \"-"..arg.."\"")
        return
    else
    end
    return true
end

for i = 1,#arg do
    local passed = parseArg(arg[i],arg[i+1])
    if not passed then
        return
    end
end

if not canColor and not (color == "none") then
    warning()
    return
end

--//    Populate logo with new colors    //--

if color then
    local bar = 1
    for i = 1,math.max(#colors[color],#logos[logo]["colors"]) do
        logos[logo]["colors"][i] = colors[color][bar]
        bar = bar + 1
        if bar > #colors[color] then
            bar = 1
        end
    end
end

--//    Populate table of information    //--

local cap = 0
for i = 1,#usedLines do
    cap = math.max(cap,usedLines[i]:len())
end
local dataLines,logoLines = {},{}
for i = 1,#usedLines do
    local info = (lineFunctions[usedLines[i]]()):gsub("[^\032\027%w%p_\n]","") or "hi"
    local firstLine = true
    for line in info:gmatch("[^\n]+") do
        if not (line:lower():find("not found") and noNotFound) then
            if firstLine then
                if align then
                    table.insert(
                        dataLines,(" "):rep(cap-usedLines[i]:len())..usedLines[i]..": "..line
                    )
                else
                    table.insert(dataLines,usedLines[i]..": "..line)
                end
                firstLine = false
            else
                local cleanTag = usedLines[i]:gsub("\027%[%d-%;-%d-m","")
                if align then
                    tag = (" "):rep(cap+2)
                else
                    tag = (" "):rep(cleanTag:len()+2)
                end
                table.insert(dataLines,tag..line)
            end
        end
    end
end

for i = 1,#dataLines do
    currentColor = 0  --  reset global color for the color toggle
    local head = dataLines[i]:match(".*:")
    local tail = dataLines[i]:match(".*:(.+)")
    if head then
        if stripe == 0 then
            dataLines[i] = dataLines[i]:gsub(head,logos[logo]["colors"][1]..head.."\027[0m")
        elseif stripe == 1 then
            local newLine = ""
            for i = 1,head:len(),block do
                local color = toggleColor()
                newLine = newLine..logos[logo]["colors"][color]..head:sub(i,i+block-1)
            end
            dataLines[i] = newLine.."\027[0m"..tail
        elseif stripe == 2 then
            local step = ((i)-((i-1)%block)%block)
            local color = ((step-step%block)/block+1)%#logos[logo]["colors"]
            if color == 0 then
                color = #logos[logo]["colors"]
            end
            if block == 1 then
                color = color - 1
                if color == 0 then
                    color = #logos[logo]["colors"]
                end
            end
            dataLines[i] = logos[logo]["colors"][color]..head.."\027[0m"..tail
        elseif stripe == 3 then
            local newLine = ""
            local step = ((i)-((i-1)%block)%block)
            local mcolor = ((step-step%block)/block+1)%#logos[logo]["colors"]
            if mcolor == 0 then
                mcolor = #logos[logo]["colors"]
            end
            if block == 1 then
                mcolor = mcolor - 1
                if mcolor == 0 then
                    mcolor = #logos[logo]["colors"]
                end
            end
            for i = 1,head:len(),block do
                local color = toggleColor()
                local modColor = (color+mcolor)%#logos[logo]["colors"]
                if modColor == 0 then
                    modColor = #logos[logo]["colors"]
                end
                newLine = newLine..logos[logo]["colors"][modColor]..head:sub(i,i+block-1)
            end
            dataLines[i] = newLine.."\027[0m"..tail
        end
    end
end

if stripe ~= 0 then --stripe
    for a = 1,#logos[logo] do
        for b = 1,#logos[logo]["colors"] do
            logos[logo][a] = logos[logo][a]:gsub("${c"..b.."}","")
        end
    end
end

for i = 1,#logos[logo] do
    if stripe == 0 then
        for b = 1,#logos[logo]["colors"] do
            logos[logo][i] = logos[logo][i]:gsub("${c"..b.."}",logos[logo]["colors"][b])
        end
    elseif stripe == 1 then
        currentColor = 0  --  reset color
        local newLine = ""
        for b = 1,logos[logo][i]:len(),block do
            local color = toggleColor()
            newLine = newLine..logos[logo]["colors"][color]..logos[logo][i]:sub(b,b+block-1)
        end
        logos[logo][i] = newLine
    elseif stripe == 2 then
        local step = ((i)-((i-1)%block)%block)
        local color = ((step-step%block)/block+1)%#logos[logo]["colors"]
        if color == 0 then
            color = #logos[logo]["colors"]
        end
        if block == 1 then
            color = color - 1
            if color == 0 then
                color = #logos[logo]["colors"]
            end
        end
        logos[logo][i] = logos[logo]["colors"][color]..logos[logo][i]
    elseif stripe == 3 then
        currentColor = 0  --  reset color
        local newLine = ""
        local step = ((i)-((i-1)%block)%block)
        local mcolor = ((step-step%block)/block+1)%#logos[logo]["colors"]
        if mcolor == 0 then
            mcolor = #logos[logo]["colors"]
        end
        if block == 1 then
            mcolor = mcolor - 1
            if mcolor == 0 then
                mcolor = #logos[logo]["colors"]
            end
        end
        for b = 1,logos[logo][i]:len(),block do
            local color = toggleColor()
            local modColor = (color+mcolor)%#logos[logo]["colors"]
            if modColor == 0 then
                modColor = #logos[logo]["colors"]
            end
            newLine = newLine..logos[logo]["colors"][modColor]..logos[logo][i]:sub(b,b+block-1)
        end
        logos[logo][i] = newLine
    end
end

local newLogo = {}
local lLines,dLines = #logos[logo],#dataLines
local dataWidth = 0
for i = 1,#dataLines do
    dataWidth = math.max(dataWidth,dataLines[i]:gsub("\027%[[%d;]+m",""):len())
end


for i = 1,#dataLines do
    if lefty then
        dataLines[i] = dataLines[i].." "
    else
        dataLines[i] = " "..dataLines[i]
    end
end

if center then
    if lLines < dLines then
        up = math.floor((dLines-lLines)/2)
        down = math.ceil((dLines-lLines)/2)
        local logoWidth = logos[logo][1]:gsub("\027%[[%d;]+m",""):len()
        for i = 1,up do
            if not lefty then
                table.insert(newLogo,(" "):rep(logoWidth)..dataLines[i])
            else
                table.insert(newLogo,dataLines[i])
            end
        end
        for i = 1,lLines do
            if not lefty then
                table.insert(newLogo,logos[logo][i]..dataLines[up+i])
            else
                local pad = dataLines[up+i]:len()-dataLines[up+i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[up+i]:len()
                local out = (dataLines[up+i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        end
        for i = 1,down do
            if not lefty then
                table.insert(newLogo,(" "):rep(logoWidth)..dataLines[lLines+up+i])
            else
                table.insert(newLogo,dataLines[lLines+up+i])
            end
        end
    elseif lLines > dLines then
        up = math.floor((lLines-dLines)/2)
        down = math.ceil((lLines-dLines)/2)
        for i = 1,up do
            if not lefty then
                table.insert(newLogo,logos[logo][i])
            else
                table.insert(newLogo,(" "):rep(dataWidth)..logos[logo][i])
            end
        end
        for i = up+1,lLines-down do
            if not lefty then
                table.insert(newLogo,logos[logo][i]..dataLines[i-up])
            else
                local pad = dataLines[i-up]:len()-dataLines[i-up]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i-up]:len()
                local out = (dataLines[i-up]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        end
        for i = lLines-down+1,lLines do
            if not lefty then
                table.insert(newLogo,logos[logo][i])
            else
                table.insert(newLogo,(" "):rep(dataWidth)..logos[logo][i])
            end
        end
    else
        for i = 1,lLines do
            if not lefty then
                table.insert(newLogo,logos[logo][i]..dataLines[i])
            else
                local pad = dataLines[i]:len()-dataLines[i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i]:len()
                local out = (dataLines[i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        end
    end
elseif down then
    local logoWidth = logos[logo][1]:gsub("\027%[[%d;]+m",""):len()
    local up = dLines-lLines
    if lLines < dLines then
        if lefty then
            for i = 1,up do
                table.insert(newLogo,dataLines[i])
            end
            for i = 1,lLines do
                local pad = dataLines[up+i]:len()-dataLines[up+i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[up+i]:len()
                local out = (dataLines[up+i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        else
            for i = 1,up do
                table.insert(newLogo,(" "):rep(logoWidth)..dataLines[i])
            end
            for i = 1,lLines do
                table.insert(newLogo,logos[logo][i]..dataLines[up+i])
            end
        end
    elseif lLines == dLines then
        if lefty then
            for i = 1,lLines do
                local pad = dataLines[i]:len()-dataLines[i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i]:len()
                local out = (dataLines[i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        else
            for i = 1,lLines do
                table.insert(newLogo,logos[logo][i]..dataLines[i])
            end
        end
    elseif lLines > dLines then
        for i = 1,lLines-dLines do
            if not lefty then
                table.insert(newLogo,logos[logo][i])
            else
                table.insert(newLogo,(" "):rep(dataWidth)..logos[logo][i])
            end
        end
        for i = 1,dLines do
            if not lefty then
                table.insert(newLogo,logos[logo][lLines-dLines+i]..dataLines[i])
            else
                local pad = dataLines[i]:len()-dataLines[i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i]:len()
                local out = (dataLines[i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][lLines-dLines+i])
            end
        end
    end
else
    local logoWidth = logos[logo][1]:gsub("\027%[[%d;]+m",""):len()
    local up = dLines-lLines
    if lLines < dLines then
        if lefty then
            for i = 1,lLines do
                local pad = dataLines[i]:len()-dataLines[i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i]:len()
                local out = (dataLines[i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
            for i = 1,up do
                table.insert(newLogo,dataLines[i+lLines])
            end
        else
            for i = 1,lLines do
                table.insert(newLogo,logos[logo][i]..dataLines[i])
            end
            for i = 1,up do
                table.insert(newLogo,(" "):rep(logoWidth)..dataLines[i+lLines])
            end
        end
    elseif lLines == dLines then
        if lefty then
            for i = 1,lLines do
                local pad = dataLines[i]:len()-dataLines[i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i]:len()
                local out = (dataLines[i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        else
            for i = 1,lLines do
                table.insert(newLogo,logos[logo][i]..dataLines[i])
            end
        end
    elseif lLines > dLines then
        for i = 1,dLines do
            if not lefty then
                table.insert(newLogo,logos[logo][i]..dataLines[i])
            else
                local pad = dataLines[i]:len()-dataLines[i]:gsub("\027%[[%d;]+m",""):len()
                local width = dataLines[i]:len()
                local out = (dataLines[i]..(" "):rep(dataWidth)):sub(1,pad+dataWidth)
                table.insert(newLogo,out..logos[logo][i])
            end
        end
        for i = 1,lLines-dLines do
            if not lefty then
                table.insert(newLogo,logos[logo][i+dLines])
            else
                table.insert(newLogo,(" "):rep(dataWidth)..logos[logo][i+dLines])
            end
        end
    end
end

for i = 1,#newLogo do
    out = "\027[0m"..newLogo[i].."\027[0m"
    if bright then
        out = out:gsub("\027%[0;","\027[1;")
    end
    if dull then
        out = out:gsub("\027%[1;","\027[0;")
    end
    if color and color:lower() == "none" then
        out = out:gsub("\027%[[%d;]+m","")
    end
    print(out)
end
