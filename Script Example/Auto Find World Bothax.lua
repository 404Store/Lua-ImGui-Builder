local Gui = load(MakeRequest("https://raw.githubusercontent.com/404Store/Lua-ImGui-Builder/refs/heads/main/imgui", "GET").content)()
local worldList = {}
local shorcut = false
local lengthWorld = 5
local includeNumber = false

function generateWord()
    local text = not includeNumber and 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' or 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result = {}
    for i = 1, lengthWorld do
        local idx = math.random(1, #text)
        table.insert(result, text:sub(idx, idx))
    end
    return table.concat(result)
end

function Info(x)
    WM = "`0[`#https://user404-store.vercel.app/`0] "
    LogToConsole(WM..x)
    SendVariantList({
        [0] = "OnTextOverlay",
        [1] = WM..x
    })
end

local Win = Gui.New({
    theme = "brown",
    title = "Helper Find World",
    size = {380, 470},
    OnRender = function(crt)
        crt:Button((shorcut and "DISABLE" or "ENABLE").." SHORTCUT", function() 
            shorcut = not shorcut
        end, -1, 0)
        crt:Button("FIND WORLD", function() 
            Info("Generating random world...")
            SendPacket(3, "action|join_request\nname|" .. generateWord() .. "\ninvitedWorld|0")
        end, -1, 0)
        crt:Child("MAIN", -1, -1, nil, function()
            lengthWorld = crt:InputInt("Length", lengthWorld)
            includeNumber = crt:Checkbox("With Number", includeNumber)
            ImGui.SeparatorText("World List")
            crt:Child("LIST", -1, -1, true, function()
                crt:Table({"No", "Name"}, function()
                    for i = #worldList, 1, -1 do
                        local name = worldList[i]
                        crt:TableRow({i, name})
                    end
                end)
            end)
        end)
    end
})

local WinShorcut = Gui.New({
    theme = "dark",
    title = "NONE",
    size = {100, 25},
    flags = ImGui.WindowFlags.NoTitleBar,
    OnRender = function(crt)
        crt:Child("MAIN", -1, -1, nil, function()
            crt:Text("SHORTCUT BUTTON",0xFF40C040)
            ImGui.Separator()
            crt:Button("FIND", function() 
                Info("Generating random world...")
                SendPacket(3, "action|join_request\nname|" .. generateWord() .. "\ninvitedWorld|0")
            end, -1, 0)
        end)
    end
})

AddHook("OnDraw", "DemoGui", function()
    Win:Render()
    if shorcut then WinShorcut:Render() end
end)

AddHook("OnVariant", "Debug", function(var)
    if var[0] == "OnConsoleMessage" and var[1]:find("entered.") then
        local world = GetWorld().name or 'NONE'
        Info(world.." Added into list.")
        table.insert(worldList, world)
    end
end)
