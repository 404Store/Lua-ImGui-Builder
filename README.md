
# 🧩 Lua ImGui Builder  
A lightweight GUI framework built on **ImGui**, designed to simplify UI creation in Lua applications and game environments.

---

## 🚀 Key Features
✅ Object-Oriented design via `Gui.New()`  
✅ Automatic theming and customizable color sets  
✅ Supports Tabs, Child windows, Tables, Input widgets, and more  
✅ Simple usage pattern & minimal boilerplate  
✅ Auto-managed render lifecycle with `Gui:Render()`

---

## 📦 Installation
```lua
local Gui = load(MakeRequest(
    "https://raw.githubusercontent.com/404Store/Lua-ImGui-Builder/refs/heads/main/imgui",
    "GET"
).content)()
```

---

## 🧪 Basic Usage
```lua
local Win = Gui.New({
    title = "Demo Window",
    size = { 400, 300 },
    theme = "brown",
    OnRender = function(win)
        win:Text("Hello ImGui!")
    end
})

AddHook("OnDraw", "RenderUI", function()
    Win:Render()
end)
```

---

## 🎨 Themes
Two dark themes included by default:

| Theme | Description |
|-------|-------------|
| `brown` | Dark tone with brown style |
| `dark` | Modern dark minimalist |

Usage:
```lua
theme = "dark"
```

Themes can be extended via:
```lua
self.themes = {
    ...
}
```

---

## 📚 API Reference

### 🔸 Constructor
```lua
Gui.New({
    title = "My UI",
    size = { 300, 400 },
    flags = ImGui.WindowFlags.None,
    visible = true,
    theme = "dark",
    OnRender = function(value) end
})
```

---

### 🔹 Layout & Containers
| Function | Description |
|----------|-------------|
| `Gui:Tabs(func)` | Create a TabBar container |
| `Gui:Tab(label, func)` | Create a tab item |
| `Gui:Child(name, sizeX, sizeY, flags, func)` | Scrollable child frame |
| `Gui:Table(headers, func, flags, id)` | Create a table |
| `Gui:TableRow(values)` | Add a row to the table |

Example:
```lua
win:Tabs(function()
    win:Tab("Settings", function()
        win:Text("Settings Tab Active")
    end)
end)

win:Child("label", -1, -1, true, function() -- sizeX, sizeY is optional. flags (true : showed grid nil : not showed)
    win:Text("Hello World") 
end)

local tableV = {"Banana", "Apple", "Watermelon"}
crt:Table({"No", "Name"}, function() -- default flags 3094 (Showing Grid). id is optional
    for i = 1, #tableV do
        local name = tableV[i]
        crt:TableRow({i, name})
    end
end)
```

---

### 🎛️ Input Widgets
| Function | Return | Description |
|----------|--------|-------------|
| `Gui:Button(label, callback, sizeX, sizeY)` | boolean | Clickable button |
| `Gui:Checkbox(label, value)` | value new | Boolean input |
| `Gui:SliderDelay(label, value, min, max)` | value new | Delay slider (ms) |
| `Gui:InputInt(label, value)` | value new | Integer input |
| `Gui:InputText(label, hint, value)` | value new | Text input |

Example:
```lua
win:Button("CLICK ME", function()
    Gui.Text("Clicked!")
end,-1, 0) -- sizeX, sizeY is optional default will be 0, 0

enabled = win:Checkbox("Enable Feature", enabled)

delay = win:SliderDelay("DELAY", delay, 100, 300) -- the delay minimal slide is 100 until 300

id = win:InputInt("Item", id)

name = win:InputText("Name", "Input Name Slowly", name) -- you also can make label not showed by adding ##. Ex: ##Name

```

---

### 📝 Text Utility
```lua
win:Text(text, color)
```
If a color is provided, it automatically handles style push/pop.

---

Example:
```lua
win:Text("Hello world", 0xFF66CC66") -- text in color green. color is opsional
```

## 🧠 Usage Tips
- Call `Gui:Render()` every frame inside a Draw hook
- No need to manually call `Begin()` or `End()` — handled internally

---

