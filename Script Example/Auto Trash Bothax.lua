local delayTrash = 3 -- you can set it until 0 sec.

local Gui = load(MakeRequest("https://raw.githubusercontent.com/404Store/Lua-ImGui-Builder/refs/heads/main/imgui", "GET").content)()
local itemList = {}
local nextTrashTime = 0
local dataPicker = {}
function itemPick(name)
    dataPicker[name] = dataPicker[name] or nil
    local result = dataPicker[name]
    ImGui.SetNextWindowSize(ImVec2(350, 450), ImGui.Cond.Once)
    if ImGui.BeginPopupModal(name, true) then
        local x, y = ImGui.InputTextWithHint("Filter Items.","Input Slowly.",Nameitems,255)
        if x then
            listName = {}
            for _, itm in pairs(GetItemsByPartialName(y)) do 
                table.insert(listName, {id = itm.id, name = itm.name})
            end 
        end
        ImGui.Separator()
        ImGui.BeginChild("scroll", ImVec2(0, 0), true)
            if listName and #listName > 0 then
                for _, item in pairs(listName) do
                    if ImGui.Selectable(item.name, selectedItem == item.id) then
                        dataPicker[name] = item
                        ImGui.CloseCurrentPopup()
                    end
                end
            end
        ImGui.EndChild()
        ImGui.EndPopup()
    end
    return result
end

local Win =
    Gui.New(
    {
        theme = "brown",
        title = "Auto Trash | https://user404-store.vercel.app/",
        size = {500, 400},
        OnRender = function(crt)
            ImGui.Separator()
            crt:ColumnsBlock(2, "x", true, function()
                crt:Text("Next Auto Trash in :")
                ImGui.SameLine()
                crt:Text((nextTrashTime - os.time()) .. "s")
                crt:NextColumn()
                crt:Text("Credit : User404.5457")
            end)
            ImGui.Separator()
            crt:Button("Set ItemID", function()
                ImGui.OpenPopup("User404.5457 Helper | Item Picker")
            end,ImGui.GetContentRegionAvail().x / 2)
            ImGui.SameLine()
            itemSelect = itemPick("User404.5457 Helper | Item Picker")
            crt:Text("Item :")
            ImGui.SameLine()
            crt:Text((itemSelect and itemSelect.name or "NONE"), 0xFF66CC66)
            if not itemSelect then
                ImGui.BeginDisabled()
            end
            if ImGui.Button("ADD", ImVec2(-1, 0)) then
                table.insert(itemList, itemSelect.id)
                dataPicker["User404.5457 Helper | Item Picker"] = nil
            end
            if not itemSelect then
                ImGui.EndDisabled()
            end
            crt:Child("LIST", -1, -1, true, function()
                crt:Table({"Item", "On Inventory", "Func"}, function()
                    for i = #itemList, 1, -1 do
                        local name = GetItemInfo(itemList[i]).name
                        local count = (GetInventory()[itemList[i]] and GetInventory()[itemList[i]].amount) or 0
                        ImGui.TableNextRow()
                        ImGui.TableSetColumnIndex(0)
                        crt:Text(name)
                        ImGui.TableSetColumnIndex(1)
                        crt:Text(count)
                        ImGui.TableSetColumnIndex(2)
                        crt:Button("\xef\x86\xb8##"..i, function()
                            table.remove(itemList, i)
                        end, -1)
                    end
                end)
            end)
        end
    }
)

AddHook("OnVariant", 1, function(var)
    if var[0] == "OnDialogRequest" and var[1]:find("trash") then
        local itemID = tonumber(var[1]:match("itemID|(%d+)"))
        if itemID == itemTrash then
            return true
        end
    end
end)

AddHook("OnDraw", "DemoGui", function()
    Win:Render()
    if os.time() >= nextTrashTime then
        for _, item in pairs(itemList) do
            local inv = (GetInventory()[item] and GetInventory()[item].amount) or 0
            itemTrash = item
            if inv > 0 then
                RunDelayed(200, SendPacket, 2, ("action|trash\n|itemID|%d\n"):format(itemTrash))
                RunDelayed(200, SendPacket, 2, ("action|dialog_return\ndialog_name|trash_item\nitemID|%d|\ncount|%d\n"):format(itemTrash, inv))
            end
        end
        nextTrashTime = os.time() + delayTrash
    end
end)
