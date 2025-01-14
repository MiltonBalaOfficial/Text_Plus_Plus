local symbolDictionary = require("symbol_dictionary")
local rotationEnabledTextHelper = require("rotationEnabledTextHelper") -- tried but failed
local utf8 = require("utf8")
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gdk = lgi.require("Gdk", "3.0")
local Pango = lgi.Pango -- Font selection and font color view
local PangoCairo = lgi.PangoCairo

-- Actual values are stored to get back the stroke if the plugin is closed without inserting anything
local ActualText, ActualFontName, ActualFontSize, ActualFontColor, ActualTextPositionX, ActualTextPositionY
local activeTool, selectedTextString, window, text_view, text_buffer, fontName, fontColor, fontSize, textPositionX,
    textPositionY, zoom_factor, inputText
local isDeletedAndNeedToBeAdded, isDynamicOff, DynamicOffX, DynamicOffY

-- Kerning pair adjustment data for rotation enabled text
local specialPairs = require("kerning_pairs")

-- Global variables for rotation enabled text
local sep, sourcePath, scaleFactor, amountBaselineShiftY, startingX

-- Register the plugin
function initUi()
    -- Determine the path separator for the current OS
    sep = package.config:sub(1, 1)
    -- Get the plugin's source folder path
    sourcePath = debug.getinfo(1).source:match("@?(.*" .. sep .. ")")

    app.registerUi({
        menu = "Text⁺⁺",
        callback = "getInfoAndCreateWindow",
        accelerator = "<Control>t"
    })
end

-- Xournal++ font names are with bold/italic, so it need to be removed
function parse_font_name(font_name)
    if not font_name or type(font_name) ~= "string" then
        return nil, false, false, false -- Invalid input, return default values
    end

    -- Define patterns to identify bold, italic, and condensed
    local patterns = {
        bold_italic = "%s?[bB][oO][lL][dD]%s?[iI][tT][aA][lL][iI][cC]$",
        bold = "%s?[bB][oO][lL][dD]$",
        italic = "%s?[iI][tT][aA][lL][iI][cC]$",
        condensed = "%s?[cC][oO][nN][dD][eE][nN][sS][eE][dD]$"
    }

    local is_bold = false
    local is_italic = false
    local is_condensed = false

    -- Check for "condensed" and remove it
    if font_name:match(patterns.condensed) then
        is_condensed = true
        font_name = font_name:gsub(patterns.condensed, ""):match("^%s*(.-)%s*$")
    end

    -- Check for "bold italic" first
    if font_name:match(patterns.bold_italic) then
        is_bold = true
        is_italic = true
        font_name = font_name:gsub(patterns.bold_italic, ""):match("^%s*(.-)%s*$")
    elseif font_name:match(patterns.bold) then
        -- Check for "bold"
        is_bold = true
        font_name = font_name:gsub(patterns.bold, ""):match("^%s*(.-)%s*$")
    elseif font_name:match(patterns.italic) then
        -- Check for "italic"
        is_italic = true
        font_name = font_name:gsub(patterns.italic, ""):match("^%s*(.-)%s*$")
    end

    -- Trim whitespace and return the cleaned font name and style flags
    return font_name:match("^%s*(.-)%s*$"), is_bold, is_italic, is_condensed
end

-- Function to update the position coordinate according to window position
function update_position()
    local x, y = window:get_position()
    -- the starting position of the page when fullscreen and page is scrolled to top (manually set)
    local adjustment_x = 88
    local adjustment_y = 3
    local zoom_factor = app.getZoom()
    -- calculate the coordinate wrt the page to insert the text at the same position where it is seen right now
    textPositionX = (x - adjustment_x) / zoom_factor
    textPositionY = (y - adjustment_y) / zoom_factor
end

function decimal_to_rgb(color)
    local r = (color >> 16) & 0xFF -- Extract the red component
    local g = (color >> 8) & 0xFF -- Extract the green component
    local b = color & 0xFF -- Extract the blue component
    return r, g, b
end

-- Function to get a sorted list of fonts
local function get_sorted_font_list()
    local context = PangoCairo.FontMap.get_default():create_context()
    local families = context:list_families()
    local font_names = {}
    for _, family in ipairs(families) do
        table.insert(font_names, family.name)
    end
    table.sort(font_names) -- Sort font names alphabetically
    return font_names
end

-- Gets the text from the selection
function getText()
    -- Get the currently selected text table
    local selectedTexts = app.getTexts("selection")

    -- Use the first selected text
    local firstText = selectedTexts[1]
    selectedTextString = firstText.text

    -- Extract other info from the selected text to update the field with the value from the selected text
    fontName = firstText.font.name
    fontSize = firstText.font.size
    fontColor = firstText.color
    textPositionX = firstText.x
    textPositionY = firstText.y

    -- Delete the old text object and refresh the UI, before deleting keep safe the Actual text
    isDeletedAndNeedToBeAdded = true
    -- Extract other info from the selected text
    ActualText = firstText.text
    ActualFontName = firstText.font.name
    ActualFontSize = firstText.font.size
    ActualFontColor = firstText.color
    ActualTextPositionX = firstText.x
    ActualTextPositionY = firstText.y
    app.uiAction({
        action = "ACTION_DELETE"
    })
    app.refreshPage()

end

-- Main function to Starting
function getInfoAndCreateWindow()
    -- save the active tool to reactivate at the end
    local toolInfo = app.getToolInfo("active")
    activeTool = toolInfo.type

    -- Get the Text tool font and font size, if any selected text found then fontName and size will be updated later from it.
    local textTool = app.getToolInfo("text")
    fontName = textTool.font.name
    fontSize = textTool.font.size
    fontColor = textTool.color

    -- Set a starting coordinate
    textPositionX, textPositionY = 15, 15

    -- Trigger the rectangle selection tool (at the starting of the plugin) for selecting the working textbox
    app.uiAction({
        action = "ACTION_TOOL_SELECT_RECT"
    })

    -- Try to get entry text and other data if any text is selected (at the starting of the plugin)
    local status, isSelection = pcall(app.getTexts, "selection") -- Run without throwing error message if there is no selection of the text (then new text can be inserted)
    if status and isSelection and #isSelection > 0 then
        getText()
    end
    fontName = fontName
    -- get the current zoom level of the app
    zoom_factor = app.getZoom()

    -- Start the input window
    createTextInputWindow()
end

-- Insert text from the inputfield
function insertText(inputText, restoreTheDeletedText)
    if isDynamicOff then -- If dynamic positioning is off then use the last coordinate picked
        textPositionX = DynamicOffX
        textPositionY = DynamicOffY
        isDynamicOff = nil -- once inserted then again make it nil 
    else
        update_position() -- update the position if dynamic positioning is on
    end

    if restoreTheDeletedText then
        local refs = app.addTexts {
            texts = {{
                text = ActualText,
                font = {
                    name = ActualFontName,
                    size = ActualFontSize
                },
                color = ActualFontColor,
                x = ActualTextPositionX,
                y = ActualTextPositionY
            }}
        }
        app.addToSelection(refs)
        app.refreshPage()
    else
        local refs = app.addTexts {
            texts = {{
                text = inputText,
                font = {
                    name = fontName,
                    size = fontSize
                },
                color = fontColor,
                x = textPositionX,
                y = textPositionY
            }}
        }
        app.addToSelection(refs)
        app.refreshPage()

        -- Switch to the previously active tool so that work could be continued
        if activeTool == "text" then
            app.uiAction({
                action = "ACTION_TOOL_TEXT"
            })
        else
            app.uiAction({
                action = "ACTION_TOOL_SELECT_RECT"
            })
        end
    end

end

-- Function to get a substring of a UTF-8 string
function utf8_sub(str, start_char, end_char)
    local start_byte = utf8.offset(str, start_char)
    local end_byte = end_char and (utf8.offset(str, end_char + 1) - 1) or nil

    if start_byte and end_byte then
        return string.sub(str, start_byte, end_byte)
    elseif start_byte then
        return string.sub(str, start_byte)
    else
        return ""
    end
end

-- Function to insert the symbol at the current cursor position in GtkTextView
function insertSymbol(symbol)
    -- Get the current cursor (insert mark) position
    local cursor_mark = text_buffer:get_insert()
    local cursor_iter = text_buffer:get_iter_at_mark(cursor_mark)

    -- Get the current text from the buffer
    local start_iter = text_buffer:get_start_iter()
    local end_iter = text_buffer:get_end_iter()
    local text = text_buffer:get_text(start_iter, end_iter, true) -- Include hidden text

    -- Get the cursor position as an offset
    local cursor_pos = cursor_iter:get_offset()

    -- Extract text before and after the cursor
    local before_cursor = utf8_sub(text, 1, cursor_pos)
    local after_cursor = utf8_sub(text, cursor_pos + 1, utf8.len(text) or 0)

    -- Insert the symbol
    local updated_text = before_cursor .. symbol .. after_cursor

    -- Replace the entire text in the buffer
    text_buffer:set_text(updated_text, -1)

    -- Calculate the new cursor position
    local symbol_length = utf8.len(symbol) or 0
    local new_cursor_pos = cursor_pos + symbol_length

    -- Move the cursor to the new position
    local new_cursor_iter = text_buffer:get_iter_at_offset(new_cursor_pos)
    text_buffer:place_cursor(new_cursor_iter)

    -- Restore focus to the GtkTextView
    text_view:grab_focus()
end

-- Function to update symbol buttons based on the selected category
function updateSymbolButtons(symbols, symbol_grid)
    -- Remove all existing children in the grid
    for _, child in ipairs(symbol_grid:get_children()) do
        symbol_grid:remove(child)
    end

    -- Define CSS for custom label styling
    local css_provider = Gtk.CssProvider()
    css_provider:load_from_data([[
        .custom-symbol-label {
            font-size: 20px;
            color: yellow;
        }
    ]])

    -- Apply the CSS to the current Gtk screen
    local screen = Gdk.Screen:get_default()
    Gtk.StyleContext.add_provider_for_screen(screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    local num_columns_symbols = 10
    -- Create new buttons for the symbols
    for i, symbol_data in ipairs(symbols) do
        local label = Gtk.Label {
            label = symbol_data.dialogText,
            halign = Gtk.Align.CENTER,
            valign = Gtk.Align.CENTER
        }
        label:get_style_context():add_class("custom-symbol-label")

        local button = Gtk.Button {}
        button:add(label) -- Add the label to the button
        button.on_clicked = function()
            insertSymbol(symbol_data.textSymbol) -- Add the symbol to the text input
        end

        symbol_grid:attach(button, (i - 1) % num_columns_symbols, math.floor((i - 1) / num_columns_symbols), 1, 1)
    end

    symbol_grid:show_all()
end

-- Function to create the custom text input window with special symbols
function createTextInputWindow()
    -- Custom CSS 
    local customCssProvider = Gtk.CssProvider()
    customCssProvider:load_from_data([[
        button {
            transition: background-color 0.3s ease;
        }
        button:active {
            background:rgb(41, 42, 43); /* Darker background when clicked */
        }
        /* Style for the button when it remains in the 'active' state */
        button.active {
            background:rgb(34, 33, 33);  /* Coral background to indicate active state */
            color: #fff;          /* Change text color for contrast */
                    outline: none;
        box-shadow: none;
        }

        window {
            background-color: transparent;
            /*border: 10px solid rgba(50, 50, 50, 1);*/
        }

        textview {
            background-color: transparent;
        }

        textview text {
            background-color: transparent;
        }

        box {
            background-color: rgba(50, 50, 50, 1);
            color: red;
        }
    ]])

    -- Function to set font size, font name, and color dynamically
    local css_provider = Gtk.CssProvider()
    local function set_font_style(widget, font_size, font_name)

        -- Parse the font name to extract styles and cleaned name
        local clean_name, is_bold, is_italic, is_condensed = parse_font_name(font_name)
        fontName = clean_name

        -- Format the RGB color into CSS-compatible `rgb(red, green, blue)`
        local r, g, b = decimal_to_rgb(fontColor)
        local font_color = string.format("rgb(%d, %d, %d)", r, g, b)
        local css_data = string.format([[
        textview {
            font-family: '%s';
            font-size: %fpx;
        }
        textview text {
            color: %s;
        }
    ]], font_name, font_size, font_color)

        css_provider:load_from_data(css_data)
        local context = widget:get_style_context()
        context:add_provider(css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER)
    end

    -- Full color list with decimal values
    local colors = {{16711680, "red"}, -- 16711680 corresponds to 0xff0000
    {255, "blue"}, -- 255 corresponds to 0x0000FF
    {32768, "green"}, -- 32768 corresponds to 0x008000
    {16744448, "orange"}, -- 16744448 corresponds to 0xff8000
    {16711935, "magenta"}, -- 16711935 corresponds to 0xff00ff
    {49407, "lightblue"}, -- 49407 corresponds to 0x00c0ff
    {65280, "lightgreen"}, -- 65280 corresponds to 0x00ff00
    {16776960, "yellow"}, -- 16776960 corresponds to 0xffff00
    {8421504, "gray"}, -- 8421504 corresponds to 0x808080
    {0, "black"}, -- 0 corresponds to 0x000000
    {16777215, "white"}, -- 16777215 corresponds to 0xffffff
    {12345678, "placeholder"} -- Add a placeholder color (e.g., 12345678 as an arbitrary default)
    }

    -- Placeholder index
    local placeholder_index = #colors -- Set to the last index where the placeholder is

    -- Find the index of the initial color in the colors list
    local color_index = placeholder_index -- Default to the placeholder index
    for i, color in ipairs(colors) do
        if color[1] == fontColor then
            color_index = i
            break
        end
    end

    -- Update the placeholder color when initializing the plugin
    colors[placeholder_index][1] = fontColor

    -- Function to update the color
    function update_color(drawing_area)
        local cr = drawing_area:get_window():cairo_create()
        local color = Gdk.RGBA()
        color:parse(string.format("#%06x", colors[color_index][1])) -- Convert decimal to hex
        cr:set_source_rgba(color.red, color.green, color.blue, color.alpha)
        cr:arc(15, 15, 10, 0, 2 * math.pi) -- Circle matches button size
        cr:fill()

        -- Add a black border around the circle
        cr:set_source_rgb(0, 0, 0) -- Black color for the border
        cr:set_line_width(1) -- Border thickness
        cr:arc(15, 15, 10, 0, 2 * math.pi) -- Draw border circle
        cr:stroke() -- Apply the border
    end

    -- Function to change color
    function change_color(direction)
        color_index = color_index + direction
        if color_index > #colors then
            color_index = 1
        elseif color_index < 1 then
            color_index = #colors
        end

        -- Update fontColor as a decimal value
        fontColor = colors[color_index][1]
        set_font_style(text_view, fontSize * zoom_factor, fontName) -- set entry font size
    end

    -- The main Window
    window = Gtk.Window {
        title = "Text⁺⁺",
        default_width = 850,
        default_height = 250,
        -- border_width = 20,
        on_destroy = function()
            if isDeletedAndNeedToBeAdded then -- Check if the window is closed without inserting the text, if so then add the deleted text to ensure no action.
                insertText(nil, true)
                isDeletedAndNeedToBeAdded = nil
            end
            selectedTextString = nil
            window:destroy()
        end
    }

    -- Apply the CSS to the window
    local context = window:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    -- Create a vertical box for layout
    local main_vertical_layout_box = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL
    }
    window:add(main_vertical_layout_box)

    -- Create a horizontal box for buttons at the bottom
    local hbox_for_top_buttons = Gtk.Box {
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 10 -- Add some space between buttons
    }
    main_vertical_layout_box:pack_start(hbox_for_top_buttons, false, true, 0) -- vertically expand false

    -- Apply the CSS to the middle container
    local context = hbox_for_top_buttons:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    -- Create a toggle button (on/off button)
    local dynamic_position_toggle_button = Gtk.ToggleButton {
        label = "Set Position" -- Initial label
    }

    -- Create OK button and other buttons at the bottom 
    local cancel_button = Gtk.Button {
        label = "Close Window"
    }
    local ok_button = Gtk.Button {
        label = "Insert"
    }
    local ok_background_button = Gtk.Button {
        label = "Insert with Background"
    }
    local ok_button_rotation = Gtk.Button {
        label = "Insert as rotation enabled"
    }

    hbox_for_top_buttons:pack_start(dynamic_position_toggle_button, false, false, 0)
    hbox_for_top_buttons:pack_start(cancel_button, false, false, 0)
    hbox_for_top_buttons:pack_start(ok_background_button, false, false, 0)
    hbox_for_top_buttons:pack_start(ok_button_rotation, false, false, 0)
    hbox_for_top_buttons:pack_start(ok_button, false, false, 0)

    -- Create a scrollable text view
    local scrolled_window_for_entry = Gtk.ScrolledWindow {
        hscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
        vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
        height_request = 250
    }

    -- Create the Entry field (it is set as global as it needs to be modified time to time)
    text_view = Gtk.TextView()
    text_buffer = text_view:get_buffer()
    scrolled_window_for_entry:add(text_view)
    main_vertical_layout_box:pack_start(scrolled_window_for_entry, true, true, 0)

    -- Apply the CSS to text_view as it needs to be transparent
    local context = text_view:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    local main_vertical_box_below_text_view = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL,
        hexpand = true,
        vexpand = false -- Prevent the lower box from expanding vertically
    }
    main_vertical_layout_box:pack_start(main_vertical_box_below_text_view, false, true, 0)

    -- Apply the CSS to the middle container
    local context = main_vertical_box_below_text_view:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    -- Create horizontal separator 
    local horizontal_separator = Gtk.Separator {
        orientation = Gtk.Orientation.HORIZONTAL
    }
    main_vertical_box_below_text_view:pack_start(horizontal_separator, false, false, 0)

    -- Create a horizontal box for categories one side and others one side
    local hbox_middle_of_main_vbox = Gtk.Box {
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 10 -- Add some space between buttons
    }
    main_vertical_box_below_text_view:pack_start(hbox_middle_of_main_vbox, false, true, 0)

    -- Create a vertical box at the left part of hbox_middle_of_main_vbox 
    local vbox_under_input_left = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10 -- Add some space between buttons
    }
    hbox_middle_of_main_vbox:pack_start(vbox_under_input_left, false, false, 0)

    -- Create a foot note at the bottom 
    local labelCategorySelection = Gtk.Label {
        label = "Choose a Category"
    }
    labelCategorySelection:set_markup("<span foreground='orange'>Choose a Category</span>") -- colored text
    vbox_under_input_left:pack_start(labelCategorySelection, false, false, 0)

    -- Create a grid to hold the category buttons 
    local category_grid = Gtk.Grid {
        column_spacing = 10,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER
    }
    vbox_under_input_left:pack_start(category_grid, false, false, 0)

    -- Create vertical separator
    local vertical_separator_hBox_middle = Gtk.Separator {
        orientation = Gtk.Orientation.VERTICAL
    }
    hbox_middle_of_main_vbox:pack_start(vertical_separator_hBox_middle, false, false, 0)

    -- create vertical box for the right part of the central horizontal box 
    local vbox_under_input_right = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL
    }
    hbox_middle_of_main_vbox:pack_start(vbox_under_input_right, true, true, 0)

    -- Create a horizontal box for buttons at the bottom 
    local hbox_for_buttons_under_entry = Gtk.Box {
        orientation = Gtk.Orientation.HORIZONTAL
    }
    vbox_under_input_right:pack_start(hbox_for_buttons_under_entry, false, true, 0) -- vertically expand false

    -- Create buttons with more descriptive names
    local font_color_backward_button = Gtk.Button {
        label = "≪"
    }

    -- Create a button
    local color_picker_button = Gtk.Button {
        margin_left = -10
    }

    -- Create a container (box) to hold the drawing area
    local color_display_box = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL
    }

    -- Create a drawing area for the color display
    local color_display = Gtk.DrawingArea {
        width = 30,
        height = 30,
        on_draw = update_color
    }

    -- Add the drawing area to the container
    color_display_box:pack_start(color_display, true, true, 0)

    -- Add the container to the button
    color_picker_button:add(color_display_box)

    local font_color_forward_button = Gtk.Button {
        label = "≫"
    }

    hbox_for_buttons_under_entry:pack_start(font_color_backward_button, false, false, 0)
    hbox_for_buttons_under_entry:pack_start(color_picker_button, false, false, 0)
    hbox_for_buttons_under_entry:pack_start(font_color_forward_button, false, false, 0)

    local font_size_spin_button = Gtk.SpinButton { -- font increase decrease field
        adjustment = Gtk.Adjustment {
            lower = 1,
            upper = 500,
            step_increment = 1,
            page_increment = 10
        },
        value = fontSize, -- Starting value
        numeric = true,
        margin_left = 10,
        margin_right = 10
    }
    hbox_for_buttons_under_entry:pack_start(font_size_spin_button, false, false, 0)

    -- Create a label for the button
    local open_button_label = Gtk.Label {
        label = "<span font_family='" .. fontName .. "' font_size='13000'>" .. fontName .. "</span>",
        use_markup = true, -- Enable Pango markup
        xalign = 0, -- Align text to the left
        width_request = 270,
        height_request = 20

    }

    -- Create the button and add the label as its child
    local font_list_open_button = Gtk.Button {
        margin_right = 10
    }
    font_list_open_button:add(open_button_label)
    hbox_for_buttons_under_entry:pack_start(font_list_open_button, false, false, 0)

    local clear_button = Gtk.Button {
        label = "Clear All",
        margin_right = 10
    }
    hbox_for_buttons_under_entry:pack_start(clear_button, false, false, 0)

    -- Create horizontal separator 
    local horizontal_separator_above_symbol_grid = Gtk.Separator {
        orientation = Gtk.Orientation.HORIZONTAL,
        margin_top = 5,
        margin_bottom = 5
    }
    vbox_under_input_right:pack_start(horizontal_separator_above_symbol_grid, false, false, 0)

    -- Scrolled window to hold the symbol grid
    local scrolled_window = Gtk.ScrolledWindow {
        hscrollbar_policy = Gtk.PolicyType.NEVER,
        vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
        expand = true
    }
    scrolled_window:set_direction(Gtk.TextDirection.RTL) -- Place the scrollbar at the left

    -- Create a grid to hold the symbol buttons 
    local symbol_grid = Gtk.Grid {
        column_homogeneous = true, -- Make columns have the same width
        column_spacing = 10, -- Space between columns
        row_spacing = 10, -- Space between rows
        margin_top = 10,
        margin_bottom = 10,
        margin_left = 20,
        margin_right = 10
    }
    scrolled_window:add(symbol_grid)
    vbox_under_input_right:pack_start(scrolled_window, true, true, 0)

    -- Update the symbol_grid with the initial category symbols at the starting
    updateSymbolButtons(symbolDictionary[1].texts, symbol_grid)

    -- Add Category buttons to the category_grid
    local previousCategoryButton = nil -- Track the previously pressed button

    for i, category_data in ipairs(symbolDictionary) do
        local CategoryButton = Gtk.Button {
            label = category_data.category,
            margin_bottom = 5
        }

        -- Apply initial style to the button label
        local buttonContext = CategoryButton:get_style_context()
        buttonContext:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

        -- Add the button to the grid, placing it in column 1 and the appropriate row
        category_grid:attach(CategoryButton, 1, i - 1, 1, 1)

        -- Mark the first button initially
        if i == 1 then
            -- Add the "active" class to the first button
            buttonContext:add_class("active")
            previousCategoryButton = CategoryButton
        end

        CategoryButton.on_clicked = function()
            updateSymbolButtons(category_data.texts, symbol_grid)
            -- Remove mark from the previously pressed button, if any
            if previousCategoryButton then
                previousCategoryButton:get_style_context():remove_class("active")
            end

            -- Add the "active" class to the clicked button
            buttonContext:add_class("active")

            -- Restore focus to the GtkTextView
            text_view:grab_focus()

            -- Set the current button as the previously pressed button
            previousCategoryButton = CategoryButton
        end
    end

    -- Create the subwindow for font selection
    local subwindow = Gtk.Window {
        title = "Select a Font",
        default_width = 400,
        default_height = 300,
        transient_for = window,
        modal = true
    }

    -- Subwindow layout
    local font_list = Gtk.ListBox {}
    local font_list_container = Gtk.ScrolledWindow {
        vexpand = true,
        hexpand = true,
        child = font_list
    }
    subwindow:add(font_list_container)

    -- Populate the font list
    local fonts = get_sorted_font_list()
    for _, font_name in ipairs(fonts) do
        local row = Gtk.ListBoxRow {}
        local label = Gtk.Label {
            label = font_name,
            xalign = 0
        }

        -- Apply the font style to each label in the font list using markup
        label:set_text(font_name) -- Store the plain font name
        label:set_markup("<span font_family='" .. font_name .. "' font_size='12000'>" .. font_name .. "</span>") -- Display styled font name

        row:add(label)
        font_list:insert(row, -1)
    end
    font_list:show_all()

    -- Connect the button to open the subwindow
    font_list_open_button.on_clicked = function()
        subwindow:show_all() -- Show the subwindow
    end

    -- Handle font selection
    font_list.on_row_activated = function(list, row)
        local label_widget = row:get_child() -- Get the label widget
        local font_name = label_widget:get_text() -- Retrieve the plain font name

        fontName = font_name -- Update the global active font name

        open_button_label:set_markup("<span font_family='" .. fontName .. "' font_size='13000'>" .. fontName .. "</span>")

        subwindow:hide() -- Close the subwindow after selection
        fontName = fontName
        set_font_style(text_view, fontSize * zoom_factor, fontName) -- set entry font size

        -- Restore focus to the GtkTextView
        text_view:grab_focus()
    end

    window:add(subwindow)

    -- prevent destroy the subwindow
    subwindow.on_delete_event = function()
        subwindow:hide()
        return true -- Prevent default close behavior
    end

    window:show_all()

    -- Set the text of the entry field if selection
    if selectedTextString then
        text_buffer:set_text(selectedTextString, -1)
    end

    -- Set Initial font size and Font family (font size is multiplied by zoomFactor to show as it will appear on the document page)
    set_font_style(text_view, fontSize * zoom_factor, fontName) -- set entry font 

    font_size_spin_button:set_value(fontSize)

    -- Set the window At the existing text when it is full screen and page is scrolled to top
    window:move(88 + textPositionX * zoom_factor, 3 + textPositionY * zoom_factor)

    -- Set the callback for the toggle button to change the label
    dynamic_position_toggle_button.on_toggled = function(self)
        -- Update the label when toggled
        if self:get_active() then
            self:set_label("Position fixed")
            isDynamicOff = true
            update_position()
            DynamicOffX = textPositionX
            DynamicOffY = textPositionY
        else
            self:set_label("Set Position")
            isDynamicOff = nil -- once inserted then again make it nil 
        end

        -- Restore focus to the input field
        text_view:grab_focus()
    end

    -- color picker button click event
    color_picker_button.on_clicked = function()
        -- Create a ColorChooserDialog
        local dialog = Gtk.ColorChooserDialog {
            title = "Choose a color",
            transient_for = color_picker_window,
            modal = true
        }

        -- Use a pcall (protected call) to ensure cleanup
        local success, err = pcall(function()
            -- Show the dialog and wait for user response
            local response = dialog:run()

            if response == Gtk.ResponseType.OK then
                -- Get the selected color
                local color = dialog:get_rgba()

                -- Convert the RGBA values to a single decimal RGB value
                local r = math.floor(color.red * 255)
                local g = math.floor(color.green * 255)
                local b = math.floor(color.blue * 255)
                fontColor = (r << 16) | (g << 8) | b

                set_font_style(text_view, fontSize * zoom_factor, fontName) -- set entry font size
                -- Update the placeholder color
                colors[placeholder_index][1] = fontColor
                color_index = #colors
                -- Restore focus to the GtkTextView
                text_view:grab_focus()
            end

        end)

        -- Ensure the dialog is destroyed regardless of the result
        dialog:destroy()

        -- Log any error if occurred during the pcall
        if not success then
            print("Error:", err)
        end
    end

    -- Add function to the bottom buttons
    ok_button.on_clicked = function()
        -- Get the current text from the buffer
        local start_iter = text_buffer:get_start_iter()
        local end_iter = text_buffer:get_end_iter()
        local inputText = text_buffer:get_text(start_iter, end_iter, true) -- Include hidden text

        if inputText == "" then
            print("The text field is empty. Please enter some text.")
        else
            insertText(inputText)
            isDeletedAndNeedToBeAdded = nil -- operation successful, no need to add the deleted text
            window:destroy() -- closes the main window
        end
    end

    -- Add function to the bottom buttons
    ok_button_rotation.on_clicked = function()
        -- Get the current text from the buffer
        local start_iter = text_buffer:get_start_iter()
        local end_iter = text_buffer:get_end_iter()
        local inputText = text_buffer:get_text(start_iter, end_iter, true) -- Include hidden text

        if inputText == "" then
            print("The text field is empty. Please enter some text.")
        else
            -- rotationEnabledTextHelper.processAndInsertCharacters(inputText) -- tried to separate the rotation logic, but failed
            processAndInsertCharacters(inputText)
            isDeletedAndNeedToBeAdded = nil -- operation successful, no need to add the deleted text
            window:destroy() -- closes the main window
        end
    end

    ok_background_button.on_clicked = function()
        -- Get the current text from the buffer
        local start_iter = text_buffer:get_start_iter()
        local end_iter = text_buffer:get_end_iter()
        local inputText = text_buffer:get_text(start_iter, end_iter, true) -- Include hidden text

        if inputText == "" then
            print("The text field is empty. Please enter some text.")
        else
            insertText(inputText)
            AddBoxToSelection(255, false)
            isDeletedAndNeedToBeAdded = nil -- operation successful, no need to add the deleted text
            window:destroy() -- closes the main window
        end
    end
    -- Update the global variable whenever the spin button value changes
    font_size_spin_button.on_value_changed = function()
        fontSize = font_size_spin_button.value

        set_font_style(text_view, fontSize * zoom_factor, fontName) -- set entry font size

        -- Restore focus to the GtkTextView
        text_view:grab_focus()
    end

    clear_button.on_clicked = function()
        text_buffer:set_text("", -1)

        -- Restore focus to the input field
        text_view:grab_focus()
    end

    cancel_button.on_clicked = function()
        textPositionX, textPositionY = 50, 50 -- reset the position coordinates
        window:destroy() -- closes the main window
    end

    font_color_backward_button.on_clicked = function()
        change_color(-1)

        -- Restore focus to the GtkTextView
        text_view:grab_focus()
    end

    font_color_forward_button.on_clicked = function()
        change_color(1)

        -- Restore focus to the GtkTextView
        text_view:grab_focus()
    end

    -- focus to the GtkTextView
    text_view:grab_focus()
end


-------------------------------------------Add Background---------------------------------------------
-- Function to get the complementary color
function getComplementaryColor(colorDecimal)
    -- Extract RGB components from the decimal value
    local red = (colorDecimal >> 16) & 0xFF
    local green = (colorDecimal >> 8) & 0xFF
    local blue = colorDecimal & 0xFF

    -- Calculate complementary color components
    local compRed = 255 - red
    local compGreen = 255 - green
    local compBlue = 255 - blue

    -- Combine the complementary color components into a single decimal value
    local compColorDecimal = (compRed << 16) | (compGreen << 8) | compBlue

    return compColorDecimal
end

-- to make darker if bright 
function darkenColorIfBrightCombined(colorDecimal, sumThreshold, maxThreshold, darkenPercentage)
    -- Extract RGB components
    local red = (colorDecimal >> 16) & 0xFF
    local green = (colorDecimal >> 8) & 0xFF
    local blue = colorDecimal & 0xFF

    -- Calculate the sum of RGB values
    local brightnessSum = red + green + blue

    -- Find the maximum RGB value
    local maxComponent = math.max(red, green, blue)

    -- Check if the color is too bright (either sum or max exceeds threshold)
    if brightnessSum > sumThreshold or maxComponent > maxThreshold then
        -- Darken the color by reducing each component
        local darkenFactor = 1 - darkenPercentage / 100
        red = math.max(0, math.floor(red * darkenFactor))
        green = math.max(0, math.floor(green * darkenFactor))
        blue = math.max(0, math.floor(blue * darkenFactor))
    end

    -- Combine the darkened RGB components back into a single decimal value
    local darkenedColorDecimal = (red << 16) | (green << 8) | blue

    return darkenedColorDecimal
end





  -- Function to compute selection corners
  function getCorners()
    -- Retrieve selection information
    local selInfo = app.getToolInfo("selection")
    if not selInfo then
        error("First select some strokes or texts!") -- Notify user if no selection
        return nil
    end
  
    local boundingBox = selInfo.boundingBox
  
    -- Compute the four corners of the bounding box
    local x1, y1 = boundingBox.x, boundingBox.y
    local x2, y2 = boundingBox.x + boundingBox.width, boundingBox.y
    local x3, y3 = boundingBox.x + boundingBox.width, boundingBox.y + boundingBox.height
    local x4, y4 = boundingBox.x, boundingBox.y + boundingBox.height
  
    -- Return the corners in table format
    return {
        x = {x1 + 10, x2 - 10, x3 - 10, x4 + 10},
        y = {y1 + 10, y2 + 10, y3 - 10, y4 - 10}
    }
  end
  
  -- Function to add a box (background or highlight) to the selection
  function AddBoxToSelection(opacity, highlight)
    -- Get the corners of the selection
    local corners = getCorners()
    if not corners then return end -- Exit if no selection
  

local complementaryColor = getComplementaryColor(fontColor)

-- Make darker background if it is too bright
local sumThreshold = 600 -- Sum threshold (max is 255 * 3 = 765)
local maxThreshold = 240 -- Max brightness threshold
local darkenPercentage = 30 -- Darken by 30%
local finalBackgroundColor = darkenColorIfBrightCombined(complementaryColor, sumThreshold, maxThreshold, darkenPercentage)
  
    -- Define the box stroke
    local box = {
        x = {corners.x[1], corners.x[2], corners.x[3], corners.x[4], corners.x[1]}, -- Close the shape
        y = {corners.y[1], corners.y[2], corners.y[3], corners.y[4], corners.y[1]}, -- Close the shape
        width = 0.5, -- Stroke width
        fill = opacity, -- Fill opacity
        tool = "pen", -- Tool type
        color = finalBackgroundColor -- Use the active pen color
    }
  
    -- Get the currently selected strokes and texts
    local strokes = app.getStrokes("selection") -- Retrieve strokes in selection
    local selectedTexts = app.getTexts("selection") -- Retrieve texts in selection
  
    if highlight then
        -- Add the highlight stroke over the selected Items
        app.addStrokes({ strokes = { box }, allowUndoRedoAction = "grouped" })
    else -- Adding background first then the selected Items again

        -- Add the background first
        app.addStrokes({ strokes = { box }, allowUndoRedoAction = "grouped" })
  
        -- Delete the current selection
        app.uiAction({ action = "ACTION_DELETE" })
  
        -- Re-add all selected texts if available
        if selectedTexts and #selectedTexts > 0 then
            app.addTexts({ texts = selectedTexts }) -- Re-add all selected texts
        end
  
        -- Re-add strokes if available
        if strokes and #strokes > 0 then
            app.addStrokes({ strokes = strokes, allowUndoRedoAction = "grouped" })
        end 
    end
  
    -- Refresh the page to apply changes
    app.refreshPage()
  end
  
--------------------------------------------Rotation enabled text------------------------------------------

-- Finds the maximum X-coordinate in a set of strokes.
local function findMaxXCoordinate(data)
    local maxX = -math.huge
    for _, stroke in pairs(data) do
        for _, x in ipairs(stroke.x) do
            maxX = math.max(maxX, x)
        end
    end
    return maxX
end

-- Finds the minimum X-coordinate in a set of strokes.
local function findMinXCoordinate(data)
    local minX = math.huge
    for _, stroke in pairs(data) do
        for _, x in ipairs(stroke.x) do
            minX = math.min(minX, x)
        end
    end
    return minX
end

-- Main function to insert characters from a string.
function processAndInsertCharacters(inputText)
    getInputDataAndSetStartingParameters()
    local prevMaxX = startingX -- prevMax is set to starting x because 'space' at the initial position gives no prevMax

    for i = 1, #inputText do
        local char = inputText:sub(i, i)
        local prevChar = i > 1 and inputText:sub(i - 1, i - 1) or nil

        if char == " " then -- If the character is 'space'
            local spaceWidth = 13 * scaleFactor
            prevMaxX = prevMaxX + spaceWidth -- Shift the prevMaxX rightwards to add gap (space)

        elseif char == "\t" then -- If the character is 'tab'
            local tabWidth = 4 * 13 * scaleFactor -- Assuming a tab equals 4 spaces
            prevMaxX = prevMaxX + tabWidth -- Shift the prevMaxX for a tab

        elseif char == "\n" then -- If the character is 'new line'
            local lineHeight = 47 * scaleFactor -- Vertical spacing between lines
            amountBaselineShiftY = amountBaselineShiftY + lineHeight -- Shift the Y-coordinate of the baseline for the new lines
            prevMaxX = startingX - 3 * scaleFactor -- Reset the X-coordinate also subtract the commonDifference so that the new line align with the startingX

        else
            local charFile = determineCharacterFile(char)
            local filepath = sourcePath .. "Characters" .. sep .. charFile
            local strokes = read_strokes_from_file(filepath)

            if not strokes or #strokes == 0 then
                -- If character is not found, show a message
                error("Character ( " .. char .. " ) is not available in 'Characters' folder, please add it.")
            end

            strokes = positionAdjustedCharacters(strokes, char, prevChar, prevMaxX) -- creates new strokes by shifting the x and y coordinates.

            local refs = app.addStrokes({
                strokes = strokes,
                allowUndoRedoAction = "grouped"
            }) -- insert the shifted characters
            app.refreshPage()
            app.addToSelection(refs)
            prevMaxX = findMaxXCoordinate(strokes) -- reset prevMax after insertion of a character 
        end
    end
end

-- Triggers text conversion: selects a rectangle, deletes old text, and processes characters.
function getInputDataAndSetStartingParameters()
    -- Set Starting parameters
    scaleFactor = fontSize / 53.53 -- 53.53 is the character strokes' size
    startingX = textPositionX -- set the starting x for first character

    -- Calculate the baseline for the textbox
    local textboxBaseline = textPositionY + fontSize * 0.7 -- Approximate baseline at 70% of font size

    -- Calculate the vertical shift needed to align the baselines of the first line of the textbox and the baseline of the character_stroke
    local characterBaseline = 100 * scaleFactor -- Baseline of the characters is 100 when created the character_stroke
    amountBaselineShiftY = textboxBaseline - characterBaseline

    -- Delete the input text object
    app.uiAction({
        action = "ACTION_DELETE"
    })
end

-- Determines the file name for a character based on its type, including Greek, symbols, and math symbols.
function determineCharacterFile(char)
    if char:match("%a") then
        -- Check if the letter is lowercase or uppercase
        if char:match("%l") then -- %l matches lowercase letters
            return "small_" .. char .. ".lua"
        elseif char:match("%u") then -- %u matches uppercase letters
            return "capital_" .. char .. ".lua"
        else
            return "otherAlphabet_" .. char .. ".lua"
        end

    elseif char:match("%d") then -- %d matches Digits
        return "digit_" .. char .. ".lua"

    elseif restrictedCharacterMapping[char] then -- first check it then check %p, otherwise error!
        -- Restricted characters that cannot be used in file name
        return "restricted_" .. restrictedCharacterMapping[char] .. ".lua"

    elseif char:match("%p") then -- Symbols
        return "symbol ( " .. char .. " ).lua"
    end
end

-- Reads stroke data from a character file. Returns a table of strokes formatted for insertion, with scaling applied.
function read_strokes_from_file(filepath)
    if not filepath then
        return
    end
    local hasFile, content = pcall(dofile, filepath)
    if not hasFile then
        app.openDialog("NO such file", {"OK"})
        print("Error: " .. content)
        return {}
    end

    local strokesToAdd = {}
    for _, stroke in ipairs(content) do
        if type(stroke) == "table" and stroke.x and stroke.y then
            local scaledX, scaledY = {}, {}
            for _, x in ipairs(stroke.x) do
                table.insert(scaledX, x * scaleFactor)
            end
            for _, y in ipairs(stroke.y) do
                table.insert(scaledY, y * scaleFactor)
            end
            table.insert(strokesToAdd, {
                x = scaledX,
                y = scaledY,
                pressure = stroke.pressure,
                tool = stroke.tool or "pen",
                color = fontColor --[[or stroke.color]] , -- if nill then uses the active color 
                width = stroke.width or 0,
                fill = stroke.fill or 255,
                lineStyle = stroke.lineStyle or "plain"
            })
        end
    end
    return strokesToAdd
end

-- Adjusts character strokes based on spacing and special cases.
function positionAdjustedCharacters(strokes, char, prevChar, prevMaxX)
    local minXCoordinate = findMinXCoordinate(strokes)
    local commonDifference = 3 * scaleFactor -- Default gap between characters
    local amountCharacterShiftX = (prevMaxX - minXCoordinate) + commonDifference -- this shift is from the actual x of the character_stroke

    if char == "j" then -- All 'j' character needs to be shifted towards left for better view
        amountCharacterShiftX = amountCharacterShiftX - 8 * scaleFactor
    end

    if prevChar then
        local charPair = prevChar .. char -- detect the special kerning pairs
        if specialPairs[charPair] then
            amountCharacterShiftX = amountCharacterShiftX + specialPairs[charPair] * scaleFactor
        end
    end

    local newStrokes = {}
    for _, stroke in ipairs(strokes) do
        local newStroke = {
            x = {},
            y = {},
            pressure = stroke.pressure,
            tool = stroke.tool,
            color = stroke.color,
            width = stroke.width,
            fill = stroke.fill,
            lineStyle = stroke.lineStyle
        }
        for _, x in ipairs(stroke.x) do
            table.insert(newStroke.x, x + amountCharacterShiftX)
        end
        for _, y in ipairs(stroke.y) do
            table.insert(newStroke.y, y + amountBaselineShiftY)
        end
        table.insert(newStrokes, newStroke)
    end
    return newStrokes
end

-- Mappings for restricted characters
restrictedCharacterMapping = {
    ["/"] = "forward_slash", -- Forward slash (/)
    ["\\"] = "backslash", -- Backslash (\)
    [":"] = "colon", -- Colon (:)
    ["*"] = "asterisk", -- Asterisk (*)
    ["?"] = "question_mark", -- Question mark (?)
    ['"'] = "double_quote", -- Double quote (")
    ["'"] = "single_quote", -- Single quote (')
    ["<"] = "less_than", -- Less than symbol (<)
    [">"] = "greater_than", -- Greater than symbol (>)
    ["|"] = "pipe", -- Pipe symbol (|)
    ["."] = "period" -- Period (.) (problematic at the start or end)
}

