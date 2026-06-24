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
        win:Text("Hello ImGui!")                    -- plain text
        win:Text("Colored Text", 0xFF66CC66)         -- green text
        win:Text("Centered Title", nil, true)        -- centered, default color
        win:Text("Warning", 0xFFFF8800, true)        -- orange + centered
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

All available color properties (override any subset):

```lua
Gui.RegisterTheme("ocean", {
    WindowBg          = 0xFF0A1628,
    ChildBg           = 0xFF0D1B30,
    PopupBg           = 0xFF0F1F36,
    TitleBg           = 0xFF0A1628,
    TitleBgActive     = 0xFF14305C,
    TitleBgCollapsed  = 0xFF0A1628,
    Border            = 0xFF1A3A5C,
    Tab               = 0xFF1A3A5C,
    TabHovered        = 0xFF205080,
    TabActive         = 0xFF2860A0,
    Button            = 0xFF1A3A5C,
    ButtonHovered     = 0xFF205080,
    ButtonActive      = 0xFF2860A0,
    CheckMark         = 0xFF4A9EE0,
    FrameBg           = 0xFF0D1B30,
    FrameBgHovered    = 0xFF14305C,
    FrameBgActive     = 0xFF1A3A5C,
    SliderGrab        = 0xFF4A9EE0,
    SliderGrabActive  = 0xFF60B0F0,
    ScrollbarBg       = 0xFF0A1628,
    ScrollbarGrab     = 0xFF1A3A5C,
    ScrollbarGrabHovered  = 0xFF205080,
    ScrollbarGrabActive   = 0xFF2860A0,
    Separator         = 0xFF1A3A5C,
    SeparatorHovered  = 0xFF205080,
    SeparatorActive   = 0xFF2860A0,
    Header            = 0xFF1A3A5C,
    HeaderHovered     = 0xFF205080,
    HeaderActive      = 0xFF2860A0,
    ResizeGrip        = 0xFF1A3A5C,
    ResizeGripHovered = 0xFF205080,
    ResizeGripActive  = 0xFF2860A0,
    Text              = 0xFFB0D4F1,
    TextDisabled      = 0xFF607080,
    MenuBarBg         = 0xFF0A1628,
    PlotLines         = 0xFF4A9EE0,
    PlotLinesHovered  = 0xFF60B0F0,
    PlotHistogram     = 0xFF4A9EE0,
    PlotHistogramHovered = 0xFF60B0F0,
    TableHeaderBg     = 0xFF14305C,
    TableBorderStrong = 0xFF1A3A5C,
    TableBorderLight  = 0xFF152A45,
    TableRowBg        = 0xFF0A1628,
    TableRowBgAlt     = 0xFF0D1B30,
    DragDropTarget    = 0xFF4A9EE0,
    NavHighlight      = 0xFF4A9EE0,
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

**Example:**

```lua
-- Toggle window visibility with a button
if win:Button(":eye: Toggle Panel") then
    win:ToggleVisible()
end

-- Show/hide from outside the render function
if someCondition then
    Win:Show()
else
    Win:Hide()
end

-- Change title or size at runtime
Win:SetTitle("New Title")
Win:SetSize(500, 400)

-- Manual Begin/End (advanced)
if win:Begin() then
    win:Text("Manual rendering")
    -- ... widgets ...
end
win:End()
```

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

**Examples:**

```lua
-- Text with SameLine
win:Text("Label:", 0xFFAAAAAA)
win:SameLine()
win:Text("Value", 0xFF66CC66)

-- SeparatorText with text label
win:SeparatorText("General Settings")

-- Indented text
win:Text("Main heading", nil, true)
win:Indent(20)
win:BulletText("Sub-item 1")
win:BulletText("Sub-item 2")
win:Unindent(20)

-- Grouping text with other widgets
win:Group(function()
    win:Text("Profile", 0xFF88CCFF)
    win:BulletText("Name: " .. playerName)
    win:BulletText("Level: " .. playerLevel)
end)

-- Text in multi-column layout
win:Columns(3, "info", true)
win:Text("Column A", 0xFFFF6644)
win:NextColumn()
win:Text("Column B", 0xFF44FF66)
win:NextColumn()
win:Text("Column C", 0xFF4488FF)
win:Columns(1)
```

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

**Examples:**

```lua
-- Text inside tabs
win:Tabs(function()
    win:Tab(":info: Info", function()
        win:Text("Welcome to the info tab", 0xFF88CCFF)
    end)
    win:Tab(":cog: Settings", function()
        win:Text("Configure your preferences here")
    end)
end)

-- Text inside collapsible tree nodes
win:TreeNode("Details", function()
    win:Text("Hidden content revealed on click", nil, true)
    win:BulletText("Point 1")
    win:BulletText("Point 2")
end)

-- Text inside a card container
win:Card(":bell: Notification", -1, -1, function()
    win:TextWrapped("This card has a styled header and wraps long text automatically.")
    win:Text("3 new alerts", 0xFFFF8800)
end)

-- MenuBar with dropdown menus
win:MenuBar(function()
    win:Menu(":file: File", function()
        if win:MenuItem(":floppy-disk: Save", "Ctrl+S") then saveFile() end
        if win:MenuItem(":folder-open: Open", "Ctrl+O") then openFile() end
        win:Separator()
        if win:MenuItem("Exit", "Alt+F4") then closeApp() end
    end)
    win:Menu("Edit", function()
        if win:MenuItem("Undo", "Ctrl+Z") then undo() end
        if win:MenuItem("Redo", "Ctrl+Y", false, canRedo) then redo() end
    end)
end)
```

---

### Text

| Function                              | Description                  |
|---------------------------------------|------------------------------|
| `Gui:Text(text, color, center)`       | Text with optional color + centered |
| `Gui:TextWrapped(text)`               | Wrapped text                 |
| `Gui:BulletText(text)`                | Bullet-pointed text          |
| `Gui:LabelText(label, text)`          | Label + value pair           |

**Examples:**

```lua
-- Gui:Text -- basic, colored, centered
win:Text("Hello ImGui!")                        -- plain text
win:Text("Important", 0xFF66CC66)                -- green colored text
win:Text("Title", nil, true)                     -- centered, default color
win:Text("Warning", 0xFFFF8800, true)            -- orange + centered

-- Gui:TextWrapped -- wraps text to fit available width
win:TextWrapped("This is a long string that will automatically wrap to fit within the current content region width without overflowing.")

-- Gui:BulletText -- bullet-pointed items
win:BulletText("First item")
win:BulletText("Second item with :star: icon")
win:BulletText("Last bullet point")

-- Gui:LabelText -- label + value pair
win:LabelText("Status", "Connected")
win:LabelText("Version", "v2.1.0")
win:LabelText("Player", playerName)
```

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

**Examples:**

```lua
-- Button -- click callback or return value
win:Button("Click Me", function() print("clicked!") end)       -- callback style
if win:Button("Save", nil, 120, 30) then                       -- return value + custom size
    saveData()
end
if win:Button(":rocket: Launch") then                          -- icon + return value
    launchRocket()
end

-- SmallButton -- compact, no size params
win:SmallButton("x", function() closePanel() end)
win:SmallButton(":plus: Add")

-- ArrowButton -- direction arrows
win:ArrowButton("left", ImGui.Dir.Left, function() prev() end)
win:SameLine()
win:ArrowButton("right", ImGui.Dir.Right, function() next() end)

-- Checkbox -- returns new boolean state
local enabled = true
enabled = win:Checkbox("Enable :cog: feature", enabled)

local showGrid = false
showGrid = win:Checkbox("Show Grid", showGrid)

-- InputText -- returns new string
local name = "Alice"
name = win:InputText(":user: Name", "Enter your name...", name)

local searchQuery = ""
searchQuery = win:InputText("Search", "Search...", searchQuery)

-- InputInt / InputFloat -- returns new number
local count = 5
count = win:InputInt("Quantity", count)

local speed = 1.5
speed = win:InputFloat("Speed", speed, 0.1, 1.0, "%.2f")

-- InputTextMultiline -- larger text input
local bio = ""
bio = win:InputTextMultiline("Bio", bio, -1, 100)

-- Combo -- dropdown (0-based index)
local options = {":rocket: Fast", ":walking: Medium", ":sleeping: Slow"}
local selection = 0
selection = win:Combo("Speed", selection, options)

-- ListBox -- scrollable list (0-based index)
local items = {"Item A", "Item B", "Item C"}
local idx = 0
idx = win:ListBox("Choose", idx, items, 5)

-- RadioButton -- manual state management
local selected = 1
if win:RadioButton("Option A", selected == 1) then selected = 1 end
win:SameLine()
if win:RadioButton("Option B", selected == 2) then selected = 2 end
win:SameLine()
if win:RadioButton("Option C", selected == 3) then selected = 3 end

-- RadioGroup -- returns new 1-based index
local mode = 1
mode = win:RadioGroup({":sun: Light", ":moon: Dark"}, mode)

-- Selectable -- toggle state
local isSelected = false
isSelected = win:Selectable(":user: Player 1", isSelected)
isSelected = win:Selectable(":user: Player 2", isSelected)

-- SliderFloat / SliderInt
local volume = 75
volume = win:SliderInt("Volume", volume, 0, 100)

local brightness = 0.5
brightness = win:SliderFloat("Brightness", brightness, 0, 1, "%.2f")

-- SliderDelay -- ms slider (default range 120-300)
local delay = 150
delay = win:SliderDelay("Delay", delay)

-- DragFloat / DragInt
local xPos = 0.0
xPos = win:DragFloat("X Position", xPos, 0.5, -100, 100, "%.1f")

local quantity = 10
quantity = win:DragInt("Quantity", quantity, 1, 0, 100)

-- ProgressBar -- fraction 0.0 to 1.0
local progress = 0.6
win:ProgressBar(progress, -1, 0, math.floor(progress * 100) .. "%")
win:ProgressBar(current / max, 200, 20, ":rocket: Loading...")
```

### Tables

| Function                                   | Description               |
|--------------------------------------------|---------------------------|
| `Gui:Table(headers, renderFunc, flags, id, headerColor, zebraColor)` | Create a data table |
| `Gui:TableRow(values)`                     | Add a row to the table    |

Default flags: `3094` (borders + row stripes).

```lua
-- Basic table with text rows
win:Table({"No", "Name"}, function()
    for i = 1, #items do
        win:TableRow({i, items[i]})
    end
end)

-- Table with icon headers and colored text cells
win:Table({":id: ID", ":user: Player", ":heart: HP"}, function()
    for i = 1, #players do
        win:TableRow({players[i].id,
                      players[i].name,
                      tostring(players[i].hp) .. "/100"})
    end
end)

-- Table with inline text
local names = {"Alice", "Bob", "Charlie"}
win:Text("Player Roster", 0xFF88CCFF, true)
win:Table({"#", "Name"}, function()
    for i, name in ipairs(names) do
        win:TableRow({i, name})
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

**Examples:**

```lua
-- ColorEdit3 -- RGB picker (values 0.0-1.0)
local bgColor = {0.2, 0.3, 0.5}
bgColor = win:ColorEdit3("Background", bgColor)

-- ColorEdit4 -- RGBA picker with alpha channel
local tint = {1.0, 0.5, 0.2, 1.0}
tint = win:ColorEdit4("Tint", tint)

-- PushColors / PopColors -- temporary color override
win:PushColors({
    {ImGui.Col.Button, 0xFF4444FF},
    {ImGui.Col.Text, 0xFFFFFFFF},
})
win:Button("Blue Styled Button")
win:PopColors()

-- Push color for a single widget
win:PushColors({{ImGui.Col.Text, 0xFFFF8800}})
win:Text("Warning text in orange")
win:PopColors()

-- Color picker with live preview
local accentColor = {0.4, 0.6, 1.0}
accentColor = win:ColorEdit3("Accent", accentColor)
local hexColor = string.format("%02X%02X%02X",
    math.floor(accentColor[1] * 255),
    math.floor(accentColor[2] * 255),
    math.floor(accentColor[3] * 255))
win:Text("Current accent: #" .. hexColor, nil, true)
```

---

### Popups & Modals

| Function                      | Description                |
|-------------------------------|----------------------------|
| `Gui:Popup(id, renderFunc)`   | Context popup              |
| `Gui:OpenPopup(id)`           | Trigger popup open         |
| `Gui:Modal(title, renderFunc)` | Modal dialog (auto-resize) |
| `Gui:ClosePopup()`            | Close current popup        |

**Examples:**

```lua
-- Text inside a modal dialog
win:Modal(":question: Confirm", function()
    win:Text("Are you sure you want to proceed?", 0xFFFF8800, true)
    win:TextWrapped("This action cannot be undone. Please confirm your choice before continuing.")
    win:Spacing()
    if win:Button("Yes, proceed") then
        win:ClosePopup()
    end
    win:SameLine()
    if win:Button("Cancel") then
        win:ClosePopup()
    end
end)

-- Popup with bullet list
win:Popup("help", function()
    win:Text("Keyboard Shortcuts", 0xFF88CCFF, true)
    win:Separator()
    win:BulletText("Ctrl+S -- Save")
    win:BulletText("Ctrl+Z -- Undo")
    win:BulletText("Ctrl+P -- Print")
end)
```

### Tooltips

| Function                        | Description                      |
|---------------------------------|----------------------------------|
| `Gui:Tooltip(text)`             | Tooltip on hovered item          |
| `Gui:HelpMarker(desc)`          | "(?)" marker with tooltip        |

**Examples:**

```lua
-- Tooltip on hovered widget
if win:Button("Save", saveFunc) then end
win:Tooltip("Save your current progress to disk")     -- tooltip for the button above

win:Text("Server Status", 0xFF66CC66)
win:Tooltip("All systems operational")                 -- tooltip for the text above

-- Inline help marker
win:HelpMarker("This setting controls the maximum file size in bytes.")
win:HelpMarker("Press Ctrl+S to save your work.")      -- independent help topics

-- Help marker next to a label using SameLine
win:Text("Advanced Options", nil, true)
win:HelpMarker("These settings affect network behavior.")
```

---

### Disabled State

```lua
win:Disabled(isDisabled, function()
    win:Button("Can't Click", nil, -1)
    win:Text("This text is also dimmed", 0xFFCCCCCC)
    win:BulletText("Bullet points disabled too")
end)
```

Falls back to dimmed text color on older ImGui versions without `BeginDisabled`.

**Example with text feedback:**

```lua
local saving = false
if win:Button("Save", function() saving = true end) then end
win:Disabled(saving, function()
    win:Text(":floppy-disk: Saving in progress...", 0xFF888888)
    win:BulletText("Writing data to disk")
    win:BulletText("Please do not close")
end)
```

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
-- Icons in buttons
win:Button(":rocket: Launch", callback)
win:Button(":floppy-disk: Save", saveFunc)

-- Icons in text display
win:Text(":cog: Settings")
win:Text(":user: John Doe", 0xFF88CCFF)
win:BulletText(":check: Task completed")
win:BulletText(":warning: Low disk space")
win:LabelText("Status", ":circle: Online")

-- Icons in table headers and containers
win:Table({":id: ID", ":envelope: Email"}, function() ... end)
win:Card(":bell: Alerts", -1, -1, function() ... end)
win:Tab(":home: Dashboard", function() ... end)
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

**Examples:**

```lua
-- Position text at a specific location
win:SetCursorPos(50, 20)
win:Text("Positioned Text", 0xFF88CCFF)

-- Center text manually using content region
local aw, ah = win:GetContentRegionAvail()
win:SetCursorPosX((aw - #"Right Aligned" * 8) * 0.5)  -- rough center
win:Text("Right Aligned", 0xFFFF8844)

-- Use text line height for vertical positioning
local lineH = win:GetTextLineHeightWithSpacing()
win:SetCursorPosY(100 + lineH * 3)
win:Text("Offset by 3 lines")
```

---

## Usage Tips

- Call `Gui:Render()` every frame inside a Draw hook
- No need to manually call `Begin()` / `End()` -- handled internally
- Use `##` in labels to hide the label display (ImGui convention): `"##MyID"`
- The table default flags (3094) enable scroll Y, borders, and row backgrounds
- `Gui:Text(text)` supports `:icon-name:` syntax -- any text function can render icons
- Use `Gui:Text("label", color, true)` to center headings without manual math
- Combine `Gui:SameLine()` with `Gui:Text()` to create label-value pairs
- `Gui:TextWrapped()` is great for tooltip-style descriptions and help text
- Color values are hex RGBA (`0xAABBGGRR`) -- e.g. `0xFF66CC66` is opaque green

---

## Example Scripts

[Example Scripts Repository](https://github.com/404Store/Lua-ImGui-Builder/tree/main/Script%20Example)
