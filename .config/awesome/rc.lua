local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
require('naughty')

-- Error handling
if awesome.startup_errors then
    naughty.notify(
		{ preset = naughty.config.presets.critical,
                     title = "なにかがおかしいよ",
                     text = awesome.startup_errors 
		}
	)
end

menubar.cache_entries = true
menubar.show_categories = true
menubar.g = {
   height = 12,
   y = 10
}

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

-- Setup directories
config_dir = (os.getenv("HOME").."/.config/awesome/")
themes_dir = (config_dir .. "themes/")
icons_dir = (themes_dir .. "icons/")

beautiful.init(themes_dir .. "theme.lua")

-- This is used later as the default terminal, browser and editor to run.
terminal = "st"
editor = os.getenv("EDITOR") or "vim"
browser = "google-chrome-unstable"
filer = "caja"
mailer = "thunderbird"
modkey = "Mod4"

-- Layouts
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
	awful.layout.suit.floating,
}

-- Wallpapers in all workspaces
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- Maximum tag-id is 5.
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, layouts[1])
end

-- Menubar configuration
menubar.utils.terminal = terminal

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Widgets
-- Time and Date
tdwidget = wibox.widget.textbox()
vicious.register(tdwidget, vicious.widgets.date, '<span color="#F0F0F0"> %R </span>', 30)

-- Battery
baticon = wibox.widget.imagebox()
vicious.register(baticon, vicious.widgets.bat, function(widget, args)
    if args[1] == "+" then
        baticon:set_image(icons_dir .. "power_charge.png")
    elseif args[1] == "−" then
        baticon:set_image(icons_dir .. "power_discharge.png")
    else
        baticon:set_image(icons_dir .. "power_nobatt.png")
    end
end,
    5,"BAT0")

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, '<span color="#EEEEEE">$2% </span>', 10, "BAT0")

-- Net Speed

netwidget = wibox.widget.textbox()
neticon = wibox.widget.imagebox()

vicious.register(netwidget, vicious.widgets.net, function(widgets,args)
        local interface = ""
        if args["{bnep0 carrier}"] == 1 then
            interface = "bnep0"
        elseif args["{enp0s25 carrier}"] == 1 then
            interface = "enp0s25"
        elseif args["{wlp3s0 carrier}"] == 1 then
                interface = "wlp3s0"
        elseif args["{br carrier}"] == 1 then
                interface = "br"
        else
                return ""
        end
        return '' ..args["{"..interface.." down_kb}"]..'k'..'' end, 2
)

vicious.register(neticon, vicious.widgets.net, function(widget, args)
        if args["{bnep0 carrier}"] == 1 then
            neticon:set_image(icons_dir .. "net_bt.png")
        elseif args["{enp0s25 carrier}"] == 1 then
            neticon:set_image(icons_dir .. "net_ethernet.png")
        elseif args["{wlp3s0 carrier}"] == 1 then
            neticon:set_image(icons_dir .. "net_wlan.png")
        elseif args["{br carrier}"] == 1 then
            neticon:set_image(icons_dir .. "net_vpn.png")
        end
end)


-- Volume Widget

volume = wibox.widget.textbox()
vicious.register(volume, vicious.widgets.volume, '<span color="#EEEEEE">$1% </span>', 1, "Master")

volicon = wibox.widget.imagebox()
vicious.register(volicon, vicious.widgets.volume, function(widget, args)
        local paraone = tonumber(args[1])
            volicon:set_image(icons_dir .. "sound.png")
        if args[2] == "♩" or paraone == 0 then
            volicon:set_image(icons_dir .. "sound_mute.png")
        end
end, 5, "Master")

-- Memory
memwidget = wibox.widget.textbox()

vicious.register(memwidget, vicious.widgets.mem, '<span color="#EEEEEE">$1% </span>', 10)
memicon = wibox.widget.imagebox()
memicon:set_image(icons_dir .. "ram.png")

-- CPU
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu,
'<span color="#EEEEEE">$1% </span>', 2)

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(icons_dir .. "cpu.png")

-- Separater
separate = wibox.widget.imagebox()
separate:set_image(icons_dir .. "separate.png")


mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  -- c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = "14" })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    -- left_layout:add(mylauncher)
    left_layout:add(mylayoutbox[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
     if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(separate)
    right_layout:add(cpuicon)
    right_layout:add(separate)
    right_layout:add(cpuwidget)
    right_layout:add(separate)
    right_layout:add(memicon)
    right_layout:add(separate)
    right_layout:add(memwidget)
    right_layout:add(separate)
    right_layout:add(volicon)
    right_layout:add(separate)
    right_layout:add(volume)
    right_layout:add(separate)
    right_layout:add(baticon)
    right_layout:add(separate)
    right_layout:add(batwidget)
    right_layout:add(separate)
    right_layout:add(neticon)
    right_layout:add(separate)
    right_layout:add(netwidget)
    right_layout:add(separate)
    right_layout:add(tdwidget)
    right_layout:add(mytaglist[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
	awful.key({ } , "Print", function ()
            awful.util.spawn("/home/acq/.bin/screenshot")
    end),
-- {{ Opens Chromium }} --

awful.key({ "Control", "Shift"}, "c", function() awful.util.spawn(browser) end),
awful.key({ "Control", "Shift"}, "n", function() awful.util.spawn(browser .. " -incognito") end),

-- {{ Shuts down Computer }} --

awful.key({ "Control",        }, "Escape", function() awful.util.spawn("systemctl suspend -i") end),

-- {{ Spawns Sublime }} -- 
awful.key({ "Control", "Shift"}, "b", function() awful.util.spawn("/opt/sublime-text/sublime_text") end),

-- {{ Volume Control }} --

--awful.key({     }, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer set Master 5%+", false) end),
--awful.key({     }, "XF86AudioLowerVolume", function() awful.util.spawn("amixer set Master 5%-", false) end),
--awful.key({     }, "XF86AudioMute", function() awful.util.spawn("amixer set Master toggle", false) end),
awful.key({     }, "XF86AudioMicMute", function() awful.util.spawn("amixer set Capture toggle", false) end),
awful.key({     }, "XF86Launch1", function() awful.util.spawn("google-chrome-unstable", false) end),
awful.key({     }, "XF86Battery", function() awful.util.spawn("gksu tlp bat", false) end),
awful.key({     }, "XF86WebCam", function() awful.util.spawn("skype", false) end),
awful.key({     }, "XF86TouchpadToggle", function() awful.util.spawn("/home/acq/.bin/tpadtoggle", false) end),

-- {{ Vim-like controls:
    -- Layout manipulation
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( -1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1 )
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    awful.key({ modkey,           }, "F1", function () awful.util.spawn("xscreensaver-command --lock") end ),
    awful.key({ modkey,           }, "F3", function () awful.util.spawn("systemctl suspend -i") end ),
    awful.key({ modkey,           }, "F4", function () awful.util.spawn("systemctl suspend -i") end ),

    awful.key({ modkey,           }, "F5", function () awful.util.spawn("xbacklight -time 1 -steps 1 =1") end ),
    awful.key({ modkey,           }, "F6", function () awful.util.spawn("xbacklight -time 1 -steps 1 -10") end ),
    awful.key({ modkey,           }, "F7", function () awful.util.spawn("xbacklight -time 1 -steps 1 +10") end ),
    awful.key({ modkey,           }, "F8", function () awful.util.spawn("xbacklight -time 1 -steps 1 +10") end ),

    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
           awful.client.focus.history.previous()
               if client.focus then
                   client.focus:raise()
           end
        end),
    
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)


-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Tilda" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- {{ Function to ensure that certain programs only have one
-- instance of themselves when i restart awesome

function run_once(cmd)
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
                findme = cmd:sub(0, firstspace-1)
        end
        awful.util.spawn_with_shell("pgrep -u acq -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- {{ I need redshift to save my eyes }} -
run_once("redshift -l 0:0 -b 1.0 -l 35.6:139.3 -t 6500:5500")
-- awful.util.spawn("xmodmap ~/.speedswapper")

-- {{ Turns off the terminal bell }} --
awful.util.spawn("/usr/bin/xset b off")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--
--

-- os.execute"dex -a -e Awesome"
	-- "mate-power-manager",
do
  local cmds =
  {
--        "mate-panel",
    "mate-power-manager",
--    "compton --backend glx -f -b --mark-wmwin-focused --refresh-rate 60 --vsync-aggressive --sw-opti --blur-background --glx-no-stencil --glx-use-copysubbuffermesa --glx-no-rebind-pixmap --glx-swap-method -1 --dbus -I 0.5 -O 0.2",
	"fcitx",
	"nm-applet",
	"syndaemon -i 0.1",
	"blueman-applet",
--	"xmodmap -e 'keysym Muhenkan = Super_L'",
--    "xscreensaver",
--    "cbatticon -i standard -l 10 -r 3 -c 'systemctl suspend -i' -x '/home/acq/.bin/batnotify'",
--    "tilda",
	--and so on...
  }
  for _,i in pairs(cmds) do
    run_once(i)
  end
end
awful.util.spawn("export GTK_IM_MODULE=fcitx")
awful.util.spawn("export QT_IM_MODULE=fcitx")
awful.util.spawn('export XMODIFIERS="@im=fcitx"')

awful.util.spawn('~/.bin/ramwarn')
