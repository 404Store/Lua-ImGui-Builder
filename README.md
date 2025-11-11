
# 🧩 Lua ImGui GUI Builder  
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

> Ensure your environment supports ImGui

---

## 🧪 Basic Usage
```lua
local win = Gui.New({
    title = "Demo Window",
    size = { 400, 300 },
    theme = "brown",
    OnRender = function()
        ImGui.Text("Hello ImGui!")
    end
})

AddHook("OnDraw", "RenderUI", function()
    win:Render()
end)
```

---

## 🎨 Themes
Two dark themes included by default:

| Theme | Description |
|-------|-------------|
| `brown` | Dark tone with purple/brown style |
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
    OnRender = function() end
})
```

---

### 🔹 Layout & Containers
| Function | Description |
|----------|-------------|
| `Gui:Tabs(func)` | Create a TabBar container |
| `Gui:Tab(label, func)` | Create a tab item |
| `Gui:Child(name, w, h, flags, func)` | Scrollable child frame |
| `Gui:Table(headers, func, flags, id)` | Create a table |
| `Gui:TableRow(values)` | Add a row to the table |

Example:
```lua
win:Tabs(function()
    win:Tab("Settings", function()
        ImGui.Text("Settings Tab Active")
    end)
end)
```

---

### 🎛️ Input Widgets
| Function | Return | Description |
|----------|--------|-------------|
| `Gui:Button(label, callback, w, h)` | boolean | Clickable button |
| `Gui:Checkbox(label, value)` | value new | Boolean input |
| `Gui:SliderDelay(label, value, min, max)` | value new | Delay slider (ms) |
| `Gui:InputInt(label, value)` | value new | Integer input |
| `Gui:InputText(label, hint, value)` | value new | Text input |

Example:
```lua
enabled = win:Checkbox("Enable Feature", enabled)
```

---

### 📝 Text Utility
```lua
Gui:Text(text, color)
```
If a color is provided, it automatically handles style push/pop.

---

## 🧠 Usage Tips
- Call `Gui:Render()` every frame inside a Draw hook
- No need to manually call `Begin()` or `End()` — handled internally

---

