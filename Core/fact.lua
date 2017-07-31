require 'cairo'
require 'Core/common'

-- reads the weather from Downloads/weather.txt
function readFact()
    -- read the weather file
    print('Reading the fact:')
    fact_file = lines_from('Downloads/fact.cml')
    -- print the line
    for index, line in pairs(fact_file) do
        _,_,key, value = line:find('([%a%d_]+):(.+)')
        print(key..value)
        fact[key] = value
    end
end

--  the funtion which will be called at the beginning of the run, used to setup a few global values
function conky_setup_fact()
    -- global variables to hold the data
    fact = {}
    fact['status'] = 'EMPTY'

    -- a global to tell if the script is running for the first time
    start_fact = true
end

-- function main that is called everty time the script is run
function conky_main_fact(  )

    local text = ""

    -- date and time variables
    local hour = tonumber(conky_parse('${time %I}'))
    local minute = tonumber(conky_parse('${time %M}'))
    local second = tonumber(conky_parse('${time %S}'))

    -- if the weather is to be update this time
    local update_fact = false

    -- update the weather every nine minutes
    if (hour * 3600 + minute * 60 + second) % 555  <= 3 then
        update_fact = true
    end

    -- if this the first time
    if start_fact then
        update_fact = true
        start_fact = false
    end

    print('Time since last update (update at 555): ' .. (hour * 3600 + minute * 60 + second) % 555)

    -- read the weather
    if update_fact then
        readFact()
    end

    -- options for printing text
    local options = {}
    options.valign = 0
    options.halign = 0
    options.width = 0
    options.height = 0
    options.bold = 0
    options.italic = 0

    -- scaling varible
    local scale = 1

    -- variables for layout
    local total_width = conky_window.width*(scale) - conky_window.width/15
    local total_height = conky_window.height*(scale) - conky_window.height/8
    local box_width = total_width
    local box_height = total_height

    -- variables positioning
    local start_x = conky_window.width/30
    local  start_y = 0
    local x = start_x
    local y  = start_y

    -- lets print the facts
    start_y = conky_window.height/2.8;
    box_width = total_width/2
    box_height = total_height/6
    --cairo_set_source_rgba(cr, 1,1,1,1)
    y = start_y
    start_x = box_width

    -- cairo_rectangle(cr, start_x, start_y, box_width, box_height)
    -- cairo_stroke(cr)

    print('Fact data status: ' .. fact['status'])

    -- if the status is FILLED that means we have the data
    if fact['status'] == 'FILLED' then
        local which_fact = (minute*60 + second)/720
        which_fact = which_fact - which_fact%1 + 1
        -- print the fact
        options.halign = 0
        _, y, _ = multiText(fact[which_fact..'_summary'], start_x + box_width*(0.1) , y + box_height*(0.1), box_width*(0.90), box_height, box_height*(0.14), 'Text Me One', extents, font_ext, options);
    end
end
