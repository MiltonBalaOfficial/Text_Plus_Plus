local symbolDictionary = require("symbol_dictionary")
local utf8 = require("utf8")
local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")
local Gdk = lgi.Gdk
local activeTool, entry, text_view, text_buffer, fontName, fontColor, inputFontSize, fontSize, textPositionX,
    textPositionY
textPositionX, textPositionY = 50, 50
local isDeletedAndNeedToBeAdded
local r, g, b

-- Kerning pair adjustment data for rotation enabled text
local specialPairs = require("kerning_pairs")
-- Global variables for rotation enabled text
local sep, sourcePath, scaleFactor, amountBaselineShiftY, startingX
local inputText, fontColor

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

-- Main function to Starting Thanks for using the plugin
function getInfoAndCreateWindow()
    -- save the active tool to reactivate at the end
    local toolInfo = app.getToolInfo("active")
    activeTool = toolInfo.type

    -- Start the input window
    createTextInputWindow()
end

function decimal_to_rgb(color)
    local r = (color >> 16) & 0xFF -- Extract the red component
    local g = (color >> 8) & 0xFF -- Extract the green component
    local b = color & 0xFF -- Extract the blue component
    return r, g, b 
end


-- Gets the text from the selection and Focus back to the input field
local ActualText, ActualFontName, ActualFontSize, ActualFontColor, ActualTextPositionX, ActualTextPositionY

function getText()
    -- Get the currently selected text table
    local selectedTexts = app.getTexts("selection")

    -- Use the first selected text as a reference
    local firstText = selectedTexts[1]

    -- Set the text of the entry field
    text_buffer:set_text(firstText.text, -1)

    -- Extract other info from the selected text
    fontName = firstText.font.name
    fontSize = firstText.font.size
    fontColor = firstText.color
    textPositionX = firstText.x
    textPositionY = firstText.y
    r, g, b = decimal_to_rgb(fontColor)

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

-- Insert text from the inputfield
function insertText(inputText, restoreTheDeletedText)
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
                    size = inputFontSize
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
    -- save the active tool to reactivate at the end
    local toolInfo = app.getToolInfo("active")
    activeTool = toolInfo.type

    -- Get the Text tool selected font and font size, if any selected text found then fontName and size will be updated later
    local textTool = app.getToolInfo("text")
    fontName = textTool.font.name
    fontSize = textTool.font.size
    fontColor = textTool.color
    r, g, b = decimal_to_rgb(fontColor)

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
            color: red;
            border: 10px solid rgba(50, 50, 50, 1);
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
local function set_font_style(widget, font_size, font_name, r, g, b)
    -- Format the RGB color into CSS-compatible `rgb(red, green, blue)`
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



    local window = Gtk.Window {
        title = "Insert Custom Text with Symbols",
        default_width = 800,
        default_height = 250,
        border_width = 10,
        on_destroy = function()
            if isDeletedAndNeedToBeAdded then -- Check if the window is closed without inserting the text, if so then add the deleted text to ensure no action.
                insertText(nil, true)
                isDeletedAndNeedToBeAdded = nil
            end
            window:destroy()
        end
    }

    -- Apply the CSS to the window
    local context = window:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    -- Set the window position to the center of the screen
    window:set_position(Gtk.WindowPosition.CENTER)

    -- Create a vertical box for layout
    local main_vertical_layout_box = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL
    }
    window:add(main_vertical_layout_box)

    -- Create a scrollable text view
    local scrolled_window_for_entry = Gtk.ScrolledWindow {
        hscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
        vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
        height_request = 200
    }

    -- Create the Entry field (it is set as global as it needs to be modified time to time)
    text_view = Gtk.TextView()
    text_buffer = text_view:get_buffer()
    scrolled_window_for_entry:add(text_view)
    main_vertical_layout_box:pack_start(scrolled_window_for_entry, true, true, 0)

    -- Apply the CSS to the window
    local context = text_view:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)


    local main_vertical_box_below_text_view = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL
    }
    main_vertical_layout_box:pack_end(main_vertical_box_below_text_view, true, true, 0)

    -- Apply the CSS to the middle container
    local context = main_vertical_box_below_text_view:get_style_context()
    context:add_provider(customCssProvider, Gtk.STYLE_PROVIDER_PRIORITY_USER)

    -- Create horizontal separator (second child of main_vertical_box_below_text_view)
    local horizontal_separator = Gtk.Separator {
        orientation = Gtk.Orientation.HORIZONTAL
    }
    main_vertical_box_below_text_view:pack_start(horizontal_separator, false, false, 0)

    -- Create a horizontal box for categories one side and others one side (third child of main_vertical_box_below_text_view)
    local hbox_middle_of_main_vbox = Gtk.Box {
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 10 -- Add some space between buttons
    }
    main_vertical_box_below_text_view:pack_end(hbox_middle_of_main_vbox, true, true, 0)

    -- Create a vertical box at the left part of hbox_middle_of_main_vbox (First child of hbox_middle_of_main_vbox)
    local vbox_under_input_left = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL,
        spacing = 10 -- Add some space between buttons
    }
    hbox_middle_of_main_vbox:pack_start(vbox_under_input_left, false, false, 0)

    -- Create a foot note at the bottom (First child of vbox_under_input_left)
    local labelCategorySelection = Gtk.Label {
        label = "Choose a Category"
    }
    labelCategorySelection:set_markup("<span foreground='orange'>Choose a Category</span>") -- colored text
    vbox_under_input_left:pack_start(labelCategorySelection, false, false, 0)

    -- Create a grid to hold the category buttons (Second child of vbox_under_input_left)
    local category_grid = Gtk.Grid {
        column_spacing = 10,
        halign = Gtk.Align.CENTER,
        valign = Gtk.Align.CENTER
    }
    vbox_under_input_left:pack_start(category_grid, false, false, 0)

    -- Create vertical separator (second child of hbox_middle_of_main_vbox)
    local vertical_separator_hBox_middle = Gtk.Separator {
        orientation = Gtk.Orientation.VERTICAL
    }
    hbox_middle_of_main_vbox:pack_start(vertical_separator_hBox_middle, false, false, 0)

    -- create vertical box for the right part of the central horizontal box (third child of hbox_middle_of_main_vbox)
    local vbox_under_input_right = Gtk.Box {
        orientation = Gtk.Orientation.VERTICAL
    }
    hbox_middle_of_main_vbox:pack_start(vbox_under_input_right, true, true, 0)

    -- Create a horizontal box for buttons at the bottom (First child of vbox_under_input_right)
    local hbox_for_buttons_under_entry = Gtk.Box {
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 10 -- Add some space between buttons
    }
    -- Set alignment to center
    hbox_for_buttons_under_entry:set_halign(Gtk.Align.CENTER)
    vbox_under_input_right:pack_start(hbox_for_buttons_under_entry, false, false, 0)

    -- Create OK button and other buttons at the bottom (First child of hbox_buttons_bottom)
    local font_size_label = Gtk.Label {
        label = "Font Size:"
    }
    hbox_for_buttons_under_entry:pack_start(font_size_label, false, false, 0)

    local font_size_spin_button = Gtk.SpinButton { -- font increase decrease field
        adjustment = Gtk.Adjustment {
            lower = 1,
            upper = 500,
            step_increment = 1,
            page_increment = 10
        },
        value = fontSize, -- Starting value
        numeric = true
    }
    hbox_for_buttons_under_entry:pack_start(font_size_spin_button, false, false, 0)

    inputFontSize = font_size_spin_button.value

    -- Update the global variable whenever the spin button value changes
    font_size_spin_button.on_value_changed = function()
        inputFontSize = font_size_spin_button.value

        -- get the current zoom level of the app
        local zoom_factor = app.getZoom()

        set_font_style(text_view, inputFontSize * zoom_factor, fontName, r, g, b) -- set entry font size
    end

    local clear_button = Gtk.Button {
        label = "Clear All"
    }
    hbox_for_buttons_under_entry:pack_start(clear_button, false, false, 0)

    -- Create horizontal separator (second child of vbox_under_input_right)
    local horizontal_separator_above_symbol_grid = Gtk.Separator {
        orientation = Gtk.Orientation.HORIZONTAL
    }
    vbox_under_input_right:pack_start(horizontal_separator_above_symbol_grid, false, false, 0)

    -- Scrolled window to hold the symbol grid
    local scrolled_window = Gtk.ScrolledWindow {
        hscrollbar_policy = Gtk.PolicyType.NEVER,
        vscrollbar_policy = Gtk.PolicyType.AUTOMATIC,
        expand = true
    }
    scrolled_window:set_direction(Gtk.TextDirection.RTL) -- Place the scrollbar at the left

    -- Create a grid to hold the symbol buttons (Third child of vbox_under_input_right)
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

    -- Create horizontal separator (Fourth child of vbox_under_input_right)
    local horizontal_separator_above_Ok_button = Gtk.Separator {
        orientation = Gtk.Orientation.HORIZONTAL
    }
    vbox_under_input_right:pack_start(horizontal_separator_above_Ok_button, false, false, 0)

    -- Create a horizontal box for buttons at the bottom (Fifth child of vbox_under_input_right)
    local hbox_buttons_bottom = Gtk.Box {
        orientation = Gtk.Orientation.HORIZONTAL,
        spacing = 10 -- Add some space between buttons
    }
    -- Set alignment to center
    hbox_buttons_bottom:set_halign(Gtk.Align.CENTER)
    vbox_under_input_right:pack_end(hbox_buttons_bottom, false, false, 0)

    -- Create OK button and other buttons at the bottom (First child of hbox_buttons_bottom)
    local cancel_button = Gtk.Button {
        label = "Close"
    }
    local ok_button = Gtk.Button {
        label = "Insert Text"
    }
    local ok_pen_button = Gtk.Button {
        label = "Insert Text & activate pen"
    }
    local ok_button_rotation = Gtk.Button {
        label = "Insert as rotation enabled Text"
    }

    hbox_buttons_bottom:pack_start(cancel_button, false, false, 0)
    hbox_buttons_bottom:pack_start(ok_pen_button, false, false, 0)
    hbox_buttons_bottom:pack_start(ok_button_rotation, false, false, 0)
    hbox_buttons_bottom:pack_start(ok_button, false, false, 0)

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


    window:show_all()


        -- get the current zoom level of the app
        local zoom_factor = app.getZoom()

        -- Set Initial font size and Font family (font size is multiplied by zoomFactor to show as it will appear on the document page)
        set_font_style(text_view, inputFontSize * zoom_factor, fontName, r, g, b) -- set entry font 

    -- Trigger the rectangle selection tool (at the starting of the plugin) for selecting the working textbox
    app.uiAction({
        action = "ACTION_TOOL_SELECT_RECT"
    })

    -- Try to get entry text and other data if any text is selected (at the starting of the plugin)
    local status, isSelection = pcall(app.getTexts, "selection") -- Run without throwing error message if there is no selection of the text (then new text can be inserted)
    if status and isSelection and #isSelection > 0 then
        getText()
        font_size_spin_button:set_value(fontSize)
        
    else
        font_size_spin_button:set_value(fontSize)
    end

            -- Set the window At the existing text
            window:move(78 + textPositionX * zoom_factor, 26 + textPositionY * zoom_factor)

    -- Function to update the position label
    local function update_position()
        local x, y = window:get_position()

        -- the starting position of the page when fullscreen and page is scrolled to top (manually set)
        local adjustment_x = 78
        local adjustment_y = 26
        local zoom_factor = app.getZoom()

        -- calculate the coordinate wrt the page to insert the text at the same position where it is seen right now
        textPositionX = (x - adjustment_x) / zoom_factor
        textPositionY = (y - adjustment_y) / zoom_factor
    end

    -- Connect to the configure-event to track position changes
    window.on_configure_event = function(_, event)
        -- Update the position whenever the window is moved
        update_position()
        return false -- Continue propagation of the event
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
            textPositionX, textPositionY = 50, 50 -- reset the position coordinates
            isDeletedAndNeedToBeAdded = nil
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
            processAndInsertCharacters(inputText)
            textPositionX, textPositionY = 50, 50 -- reset the position coordinates
            isDeletedAndNeedToBeAdded = nil
            window:destroy() -- closes the main window
        end
    end

    ok_pen_button.on_clicked = function()
        -- Get the current text from the buffer
        local start_iter = text_buffer:get_start_iter()
        local end_iter = text_buffer:get_end_iter()
        local inputText = text_buffer:get_text(start_iter, end_iter, true) -- Include hidden text

        if inputText == "" then
            print("The text field is empty. Please enter some text.")
        else
            insertText(inputText)
            app.uiAction({
                action = "ACTION_TOOL_PEN"
            })
            textPositionX, textPositionY = 50, 50 -- reset the position coordinates
            isDeletedAndNeedToBeAdded = nil
            window:destroy() -- closes the main window
        end
    end

    clear_button.on_clicked = function()
        text_buffer:set_text("", -1)

        -- Restore focus to the input field
        text_buffer:grab_focus()
    end

    cancel_button.on_clicked = function()
        textPositionX, textPositionY = 50, 50 -- reset the position coordinates
        window:destroy() -- closes the main window
    end
    window:move(0, 0)
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

