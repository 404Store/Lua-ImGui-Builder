# Lua ImGui Builder

---

## Key Features

- Object-oriented design via `Gui.New()`
- Automatic theming and customizable color sets
- FontAwesome icon support with `:icon-name:` syntax
- Tab bars, child windows, tables, input widgets, and more
- Minimal boilerplate -- render lifecycle managed internally
- Notification system with auto-expire and stacked rendering
- Style presets (rounded, flat) plus per-instance overrides

---

## Installation

```lua
local Gui = load(MakeRequest(
    "https://raw.githubusercontent.com/404Store/Lua-ImGui-Builder/refs/heads/main/imgui",
    "GET"
).content)()
```

---

## Basic Usage

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

## Constructor

```lua
Gui.New({
    title   = "My UI",               -- window title
    size    = { 300, 400 },           -- initial width, height
    flags   = ImGui.WindowFlags.None, -- optional window flags
    visible = true,                   -- start visible
    theme   = "dark",                 -- theme name or color table
    style   = "rounded",             -- style preset name or table
    OnRender = function(win) end     -- called each frame
})
```

---

## Themes

Two built-in dark themes:

| Theme   | Description                    |
|---------|--------------------------------|
| `brown` | Warm brown-toned dark theme    |
| `dark`  | Cool modern dark minimalist    |

**Usage:**
```lua
theme = "dark"
```

**Custom themes at construction:**
```lua
Gui.New({
    theme = {
        WindowBg = 0xFF1A1A2E,
        Text     = 0xFFFFEEDD,
        Button   = 0xFF303050,
    }
})
```

**Register a reusable theme:**
```lua
Gui.RegisterTheme("ocean", {
    WindowBg = 0xFF0A1628,
    Text     = 0xFFB0D4F1,
    Button   = 0xFF1A3A5C,
})
```

**Change theme at runtime:**
```lua
win:SetTheme("ocean")
win:SetTheme({ WindowBg = 0xFF222222, ... })
```

---

## Styles

Two built-in style presets:

| Style     | Description                       |
|-----------|-----------------------------------|
| `rounded` | Soft corners, spacious padding    |
| `flat`    | Sharp corners, compact layout     |

Custom styles accept any `ImGui.StyleVar` key:
```lua
Gui.New({
    style = {
        WindowRounding = 4,
        FramePadding  = {12, 6},
        ItemSpacing   = {6, 4},
    }
})
```

Also settable at runtime:
```lua
win:SetStyle("flat")
win:SetStyle({ WindowRounding = 0 })
```

---

## API Reference

### Window Lifecycle

| Function              | Description                                |
|-----------------------|--------------------------------------------|
| `Gui:Render()`        | Render the window (call every frame)       |
| `Gui:Begin()`         | Manual begin (applies theme + style)       |
| `Gui:End()`           | Manual end (pops styles + vars)            |
| `Gui:Show()`          | Make window visible                        |
| `Gui:Hide()`          | Hide window                                |
| `Gui:ToggleVisible()` | Toggle visibility                          |
| `Gui:IsVisible()`     | Returns visibility state                   |
| `Gui:SetTitle(t)`     | Change window title                        |
| `Gui:SetSize(w, h)`   | Change window size                         |

---

### Layout & Spacing

| Function                                | Description                  |
|-----------------------------------------|------------------------------|
| `Gui:SameLine(offset, spacing)`         | Place next item on same line |
| `Gui:Spacing(count)`                    | Add vertical space           |
| `Gui:NewLine()`                         | Force new line               |
| `Gui:Indent(w)`                         | Indent content               |
| `Gui:Unindent(w)`                       | Unindent content             |
| `Gui:Separator()`                       | Horizontal line              |
| `Gui:SeparatorText(text)`               | Labeled separator            |
| `Gui:Group(fn)`                         | Group widgets together       |
| `Gui:Dummy(x, y)`                       | Invisible spacer             |
| `Gui:Columns(count, id, border)`        | Start multi-column layout    |
| `Gui:NextColumn()`                      | Move to next column          |
| `Gui:ColumnsBlock(count, id, border, fn)` | Columns with callback     |

---

### Containers

| Function                                            | Description                    |
|-----------------------------------------------------|--------------------------------|
| `Gui:Tabs(renderFunc)`                              | Tab bar container              |
| `Gui:Tab(label, renderFunc)`                        | Single tab item                |
| `Gui:Child(name, w, h, border, flags, renderFunc)`  | Scrollable child region        |
| `Gui:BeginChild(name, w, h, border, flags)`         | Manual child begin             |
| `Gui:EndChild()`                                    | End manual child               |
| `Gui:TreeNode(label, renderFunc)`                   | Collapsible tree node          |
| `Gui:CollapsingHeader(label, renderFunc)`           | Collapsing header              |
| `Gui:Card(title, w, h, renderFunc)`                 | Styled card container          |
| `Gui:MenuBar(renderFunc)`                           | Menu bar container             |
| `Gui:Menu(label, renderFunc)`                       | Dropdown menu                  |
| `Gui:MenuItem(label, shortcut, selected, enabled)`  | Menu item                     |

---

### Text

| Function                              | Description                  |
|---------------------------------------|------------------------------|
| `Gui:Text(text, color, center)`       | Text with optional color + centered |
| `Gui:TextWrapped(text)`               | Wrapped text                 |
| `Gui:BulletText(text)`                | Bullet-pointed text          |
| `Gui:LabelText(label, text)`          | Label + value pair           |

---

### Input Widgets

| Function                                                          | Return     | Description            |
|------------------------------------------------------------------|------------|------------------------|
| `Gui:Button(label, callback, w, h)`                              | boolean    | Clickable button       |
| `Gui:SmallButton(label, callback)`                               | boolean    | Compact button         |
| `Gui:ArrowButton(id, dir, callback)`                             | boolean    | Directional arrow      |
| `Gui:Checkbox(label, value)`                                     | new value  | Boolean toggle         |
| `Gui:InputInt(label, value)`                                     | new value  | Integer input          |
| `Gui:InputFloat(label, value, step, stepFast, fmt)`              | new value  | Float input            |
| `Gui:InputText(label, hint, value)`                              | new value  | Single-line text input |
| `Gui:InputTextMultiline(label, value, w, h, bufSize)`            | new value  | Multi-line text area   |
| `Gui:RawInputTextMultiline(label, value, bufSize, w, h, flags)` | changed, value | Full flags control |
| `Gui:Combo(label, currentItem, items)`                           | new index  | Dropdown selector      |
| `Gui:RadioButton(label, active)`                                 | boolean    | Single radio           |
| `Gui:RadioGroup(labels, selectedIndex)`                          | new index  | Horizontal radio group |
| `Gui:Selectable(label, selected, flags, w, h)`                   | new state  | Selectable row         |
| `Gui:ListBox(label, currentItem, items, heightItems)`            | new index  | Scrollable list        |
| `Gui:SliderFloat(label, value, min, max, fmt)`                   | new value  | Float slider           |
| `Gui:SliderInt(label, value, min, max)`                         | new value  | Integer slider         |
| `Gui:SliderDelay(label, value, min, max)`                        | new value  | Delay slider (ms)      |
| `Gui:DragFloat(label, value, speed, min, max, fmt)`              | new value  | Draggable float        |
| `Gui:DragInt(label, value, speed, min, max)`                     | new value  | Draggable integer      |
| `Gui:ProgressBar(fraction, w, h, overlay)`                       | --         | Progress indicator     |

---

### Tables

| Function                                   | Description               |
|--------------------------------------------|---------------------------|
| `Gui:Table(headers, renderFunc, flags, id, headerColor, zebraColor)` | Create a data table |
| `Gui:TableRow(values)`                     | Add a row to the table    |

Default flags: `3094` (borders + row stripes).

```lua
win:Table({"No", "Name"}, function()
    for i = 1, #items do
        win:TableRow({i, items[i]})
    end
end)
```

---

### Colors

| Function                           | Return     | Description              |
|------------------------------------|------------|--------------------------|
| `Gui:ColorEdit3(label, color)`     | new color  | RGB color picker         |
| `Gui:ColorEdit4(label, color)`     | new color  | RGBA color picker        |
| `Gui:PushColors(colorTable)`       | --         | Push multiple colors     |
| `Gui:PopColors(n)`                 | --         | Pop N or all colors      |

---

### Popups & Modals

| Function                      | Description                |
|-------------------------------|----------------------------|
| `Gui:Popup(id, renderFunc)`   | Context popup              |
| `Gui:OpenPopup(id)`           | Trigger popup open         |
| `Gui:Modal(title, renderFunc)` | Modal dialog (auto-resize) |
| `Gui:ClosePopup()`            | Close current popup        |

---

### Tooltips

| Function                        | Description                      |
|---------------------------------|----------------------------------|
| `Gui:Tooltip(text)`             | Tooltip on hovered item          |
| `Gui:HelpMarker(desc)`          | "(?)" marker with tooltip        |

---

### Disabled State

```lua
win:Disabled(isDisabled, function()
    win:Button("Can't Click", nil, -1)
end)
```

Falls back to dimmed text color on older ImGui versions without `BeginDisabled`.

---

### Notifications

```lua
-- Trigger a notification (static method)
Gui.Notify("Operation complete", 3.0, 0xFF66CC66)

-- Render the notification overlay (call each frame)
Gui.RenderNotifications()
```

Notifications auto-expire and stack in the top-left corner.

---

### Icons

FontAwesome icons are loaded automatically. Use `:icon-name:` syntax in any text label:

```lua
win:Button(":rocket: Launch", callback)
win:Text(":cog: Settings")
```

**Preview available icons:**
Browse all available FontAwesome icon names at [lunix.space/icon/](https://lunix.space/icon/). Search for an icon to find its name, then use it with the `:icon-name:` syntax (e.g., `:rocket:`, `:cog:`, `:user:`).

Programmatic access:
```lua
local icon = Gui.Icon("rocket")  -- returns the icon character
Gui.ListIcons("rocket")          -- log matching icon names to console
```

---

### Clipboard

```lua
Gui:SetClipboard("text to copy")
local text = Gui:GetClipboard()
```

---

### Cursor & Position

| Function                                      | Returns    | Description              |
|-----------------------------------------------|------------|--------------------------|
| `Gui:GetCursorPos()`                          | x, y       | Current cursor position  |
| `Gui:SetCursorPos(x, y)`                      | --         | Set cursor position      |
| `Gui:SetCursorPosX(x)`                        | --         | Set horizontal cursor    |
| `Gui:SetCursorPosY(y)`                        | --         | Set vertical cursor      |
| `Gui:GetCursorScreenPos()`                    | x, y       | Screen-space cursor      |
| `Gui:SetCursorScreenPos(x, y)`                | --         | Set screen-space cursor  |
| `Gui:GetContentRegionAvail()`                 | w, h       | Available content region |
| `Gui:GetTextLineHeight()`                     | height     | Current line height      |
| `Gui:GetTextLineHeightWithSpacing()`          | height     | Line height with spacing |
| `Gui:GetWindowSize()`                         | w, h       | Current window size      |

---

## Usage Tips

- Call `Gui:Render()` every frame inside a Draw hook
- No need to manually call `Begin()` / `End()` -- handled internally
- Use `##` in labels to hide the label display (ImGui convention): `"##MyID"`
- The table default flags (3094) enable scroll Y, borders, and row backgrounds

---

## Example Scripts

[Example Scripts Repository](https://github.com/404Store/Lua-ImGui-Builder/tree/main/Script%20Example)
