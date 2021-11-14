-----------
-- LUA.RC --
------------


-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local lain = require("lain")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- xrandr para múltiples monitores
local xrandr = require("xrandr")
-- Load Debian menu entries
-- local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

awful.spawn.with_shell("xrandr --output eDP1 --auto --output HDMI1 --auto --brightness 0.5 --left-of eDP1")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Paila",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Error",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

local pwd = "/home/samuel/.config/awesome/"

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "xresources/theme.lua")
-- beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")
beautiful.init(pwd .. "themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty -e \"fish\""
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. "vim"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
-- myawesomemenu = {
--    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
--    { "manual", terminal .. " -e man awesome" },
--    { "edit config", editor_cmd .. " " .. awesome.conffile },
--    { "restart", awesome.restart },
--    { "quit", function() awesome.quit() end },
-- }
-- 
-- local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
-- local menu_terminal = { "open terminal", terminal }
-- 
-- if has_fdo then
--     mymainmenu = freedesktop.menu.build({
--         before = { menu_awesome },
--         after =  { menu_terminal }
--     })
-- else
--     mymainmenu = awful.menu({
--         items = {
--                   menu_awesome,
--                   { "Debian", debian.menu.Debian_menu.Debian },
--                   menu_terminal,
--                 }
--     })
-- end


-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--mylauncher = awful.widget.launcher({ image = "/home/samuel/Imágenes/debian_logo.png",
--                                      menu = mymainmenu })

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen

        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table-----------------.
   -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    awful.tag.add("S", {
    icon               = "/Archivos/A/Imágenes/Nombre/S.png",
    layout             = awful.layout.suit.tile,
    master_fill_policy = "master_width_factor",
    gap_single_client  = true,
    gap                = 5,
    screen             = s,
    selected           = true,
    master_width_factor= 0.5
})


    awful.tag.add("A", {
    icon               = "/Archivos/A/Imágenes/Nombre/A.png",
    layout             = awful.layout.suit.tile,
    master_fill_policy = "master_width_factor",
    gap_single_client  = true,
    gap                = 5,
    screen             = s,
    --selected           = true,
})


    awful.tag.add("M", {
    icon               = "/Archivos/A/Imágenes/Nombre/M.png",
    layout             = awful.layout.suit.tile,
    master_fill_policy = "master_width_factor",
    gap_single_client  = true,
    gap                = 5,
    screen             = s,
    --selected           = true,
})


    awful.tag.add("U", {
    icon               = "/Archivos/A/Imágenes/Nombre/U.png",
    layout             = awful.layout.suit.tile,
    master_fill_policy = "master_width_factor",
    gap_single_client  = true,
    gap                = 5,
    screen             = s,
    --selected           = true,
})


    awful.tag.add("E", {
    icon               = "/Archivos/A/Imágenes/Nombre/E.png",
    layout             = awful.layout.suit.tile,
    master_fill_policy = "master_width_factor",
    gap_single_client  = true,
    gap                = 5,
    screen             = s,
    --selected           = true,
})

    awful.tag.add("L", {
    icon               = "/Archivos/A/Imágenes/Nombre/L.png",
    layout             = awful.layout.suit.tile,
    master_fill_policy = "master_width_factor",
    gap_single_client  = true,
    gap                = 5,
    screen             = s,
    --selected           = true,
})




    -- Create a promptbox for each screen
     s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
	-- style   = {
	--     shape_border_width = 1,
	--     shape_border_color = '#00f3cb',
	--     shape = gears.shape.rectangle
	-- },
	-- layout  = {
	--     spacing = 2,
	--     layout = wibox.layout.flex.horizontal
	-- },
	buttons = taglist_buttons
    }

    --tasklist
    -- s.mytasklist = awful.widget.tasklist {
    --     screen   = s,
    --     filter   = awful.widget.tasklist.filter.currenttags,
    --     buttons  = tasklist_buttons,
    --     style    = {
    --         shape_border_width = 1,
    --         shape_border_color = '#ffff00',
    --         shape  = gears.shape.powerline -- (width=20), -- completar
    --     },
    --     layout   = {
    --         spacing = -2,
    --        --  spacing_widget = {
    --        --      {
    --        --          forced_width = 5,
    --        --          shape        = gears.shape.circle,
    --        --          widget       = wibox.widget.separator
    --        --      },
    --        --      valign = 'center',
    --        --      halign = 'center',
    --        --      widget = wibox.container.place,
    --        --  },
    --         layout  = wibox.layout.flex.horizontal
    --     },
    --     -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    --     -- not a widget instance.
    --     widget_template = {
    --         {
    --             {
    --                 {
    --                     {
    --                         id     = 'icon_role',
    --                         widget = wibox.widget.imagebox,
    --                     },
    --                     margins = 1, -- era 2
    --                     widget  = wibox.container.margin,
    --                 },
    --                --  {
    --                --      id     = 'text_role',
    --                --      widget = wibox.widget.textbox,
    --                --  },
    --                 layout = wibox.layout.fixed.horizontal,
    --             },
    --             left  = 12, -- eran 10
    --             right = 12,
    --             widget = wibox.container.margin
    --         },
    --         id     = 'background_role',
    --         widget = wibox.container.background,
    --     },
    -- }
    --tasklist en popup
  s.popup_tag = awful.popup {
   widget = awful.widget.tasklist {
       screen   = s,
       filter   = awful.widget.tasklist.filter.currenttags,
       -- filter   = awful.widget.tasklist.filter.allscreen,
       buttons  = tasklist_buttons,
       style    = {
           shape = gears.shape.rounded_rect,
       },
       layout   = {
           spacing = 5,
           forced_num_rows = 1,
           layout = wibox.layout.grid.horizontal
       },
       widget_template = {
           {
               {
                   id     = 'clienticon',
                   widget = awful.widget.clienticon,
               },
               margins = 4,
               widget  = wibox.container.margin,
           },
           id              = 'background_role',
           forced_width    = 48,
           forced_height   = 48,
           widget          = wibox.container.background,
           create_callback = function(self, c, index, objects) --luacheck: no unused
               self:get_children_by_id('clienticon')[1].client = c
           end,
       },
   },
	 screen = s,
   border_color = '#777777',
   border_width = 2,
   ontop        = true,
   placement    = awful.placement.centered,
   shape        = gears.shape.rounded_rect,
   -- hide_on_right_click = true
   visible = false
}
----agregar widgets
--spotify
-- local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
--discos
--local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")
--batería
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
-- local battery_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
--procesador
local mitema = {}
mitema.font = "Terminus 8"
mitema.widget_cpu = pwd.."themes/multicolor/icons/cpu.png"
local markup = lain.util.markup
local cpuicon = wibox.widget.imagebox(mitema.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(mitema.font, "#e33a6e", cpu_now.usage .. "% "))
    end
})
--calendario
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local cw = calendar_widget({
    theme = 'outrun',
    placement = 'topright'
    })

-- mytextclock:connect_signal("button::press",
--     function(_, _, _, button)
--         if button == 1 then cw.toggle() end
--     end)

-- mytextclock:connect_signal("button::press",function() awful.spawn.with_shell("alacritty -e \"cal -y\"") end)

--logout
-- local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
-- ALSA volume
-- local volumearc_widget = require("awesome-wm-widgets.volumearc-widget.volumearc")
mitema.widget_vol = pwd.."themes/multicolor/icons/spkr.png"
local volicon = wibox.widget.imagebox(mitema.widget_vol)
mitema.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = "00"
        end

        widget:set_markup(markup.fontfg(mitema.font, "#7493d2", volume_now.level .. "% "))
    end
})
volicon:connect_signal("button::press", function() awful.spawn.with_shell("pavucontrol") end)
mitema.volume.widget:connect_signal("button::press", function() awful.spawn.with_shell("pavucontrol") end)

-- Net
mitema.widget_netdown = pwd.."themes/multicolor/icons/net_down.png"
mitema.widget_netup = pwd.."themes/multicolor/icons/net_up.png"
local netdownicon = wibox.widget.imagebox(mitema.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(mitema.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(mitema.font, "#e54c62", net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(mitema.font, "#87af5f", net_now.received .. " "))
    end
})

-- MEM RAM
mitema.widget_mem = pwd.."themes/multicolor/icons/mem.png"
local memicon = wibox.widget.imagebox(mitema.widget_mem)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(mitema.font, "#e0da37", mem_now.used .. "M "))
    end
})

memicon:connect_signal("button::press",function() awful.spawn.with_shell("alacritty -e htop")end)
memory.widget:connect_signal("button::press",function() awful.spawn.with_shell("alacritty -e htop")end)


-- Conexión a internet
s.red_status=awful.popup{
    widget={
	awful.widget.watch('bash -c "nmcli d | grep wifi|cut -c19-200"',5),
	margins=7,
	widget =wibox.container.margin
    },
    -- border_color='#00f3cb',
    border_color=beautiful.bg_focus,
    border_width=1,
    placement=awful.placement.top,
    shape = gears.shape.rounded_rect,
    visible = false,
    opacity = 0.85,
		screen = s,
    bg = beautiful.bg_normal,
    -- bg='#1E0E33',
    ontop = true,
    width =300,
    height = 15
}
-- Temperatura del procesador
s.proc_temp=awful.popup{
    widget={
	awful.widget.watch('bash -c "sensors|grep temp1|sed /"0.0°C"/d|cut -c14-24"',15),
	margins=7,
	widget=wibox.container.margin
    },
    border_color=beautiful.bg_focus,
    border_width=1,
    placement=awful.placement.top,
    shape = gears.shape.rounded_rect,
    visible = false,
    opacity = 0.85,
		screen = s,
    bg = beautiful.bg_normal,
    ontop = true,
    height = 23,
    width = 200
}
--Logout menu funcional
local salida = wibox.widget{
    {
	image= pwd.."awesome-wm-widgets/logout-menu-widget/icons/power_w.svg",
	resize=true,
	widget= wibox.widget.imagebox
    },
    margins=4,
    layout=wibox.container.margin
}
salida:connect_signal("button::press",function() 
    awful.spawn.with_shell("rofi -show p -modi p:/home/samuel/rofi-power-menu/rofi-power-menu -theme DarkBlue.rasi -width 15 -lines 6 -location 2") 
end)
-- Separadores
local betaw =  wibox.widget{
		markup = "<span foreground=\"#F68F03\" size=\"large\"> <b>  β </b> </span>",
		valign = "center",
		widget = wibox.widget.textbox,
	    }
betaw:connect_signal("button::press",function () myscreen = awful.screen.focused()
    myscreen.red_status.visible = not myscreen.red_status.visible end)

local lambdaw =  wibox.widget{
		markup = "<span foreground=\"#F68F03\" size=\"large\"> <b> λ  </b> </span>",
		valign = "center",
		widget = wibox.widget.textbox
	    }
lambdaw:connect_signal("button::press",function () myscreen = awful.screen.focused()
    myscreen.proc_temp.visible = not myscreen.proc_temp.visible end)
local debianw =wibox.widget{
		image = pwd.."debian-amarillo.png",
		resize = true,
		widget = wibox.widget.imagebox
	    }

-- Logos Apps

		local apps = {}
    -- Brave browser
    apps.brav = wibox.widget{
				image = pwd.."apps/brave-logo.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.brav:connect_signal("button::press", function() awful.spawn.with_shell("brave-browser") end)
		
		-- Audacity
		apps.auda = wibox.widget{
				image = pwd.."apps/audacity.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.auda:connect_signal("button::press",function() awful.spawn.with_shell("audacity") end)
		
		-- Rstudio
		apps.rstu = wibox.widget{
				image = pwd.."apps/rstudio.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.rstu:connect_signal("button::press",function() awful.spawn.with_shell("rstudio") end)
		
		-- Zoom
		apps.zoom = wibox.widget{
				image = pwd.."apps/zoom.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.zoom:connect_signal("button::press",function() awful.spawn.with_shell("zoom") end)
		

		-- Atom
		apps.atom = wibox.widget{
				image = pwd.."apps/atom.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.atom:connect_signal("button::press",function() awful.spawn.with_shell("atom") end)
		

		-- Julia
		apps.juli = wibox.widget{
				image = pwd.."apps/julia.svg",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.juli:connect_signal("button::press",function() awful.spawn("alacritty -o background_opacity=0.8 -e /home/samuel/julia-1.6.3/bin/julia",{floating=true}) end)
		

		-- Gimp
		apps.gimp = wibox.widget{
				image = pwd.."apps/gimp.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.gimp:connect_signal("button::press",function() awful.spawn.with_shell("gimp") end)
		

		-- Libre Office
		apps.libr = wibox.widget{
				image = pwd.."apps/libreoffice.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.libr:connect_signal("button::press",function() awful.spawn.with_shell("libreoffice") end)
		

		-- Telegram
		apps.tele = wibox.widget{
				image = pwd.."apps/telegram.png",
				resize = true,
				widget = wibox.widget.imagebox
		}
		apps.tele:connect_signal("button::press",function() awful.spawn.with_shell("/home/samuel/Telegram/Telegram") end)
		


    local appsGrid = wibox.widget{
			  forced_num_cols = 3,
			  forced_num_rows = 3,
			  -- min_cols_size = 10,
			  -- min_rows_size = 10,
			  spacing = 20,
				superpose = true,
				expand = true,
			  -- homogeneous = false,
				forced_height = 70,
				forced_width = 70,
				-- horizontal_homogeneous = false,
				-- vertical_homogeneous = false,
		    layout = wibox.layout.grid.vertical
		}
		appsGrid:add_widget_at(apps.brav,1,1,1,1)
		appsGrid:add_widget_at(apps.auda,1,2,1,1)
		appsGrid:add_widget_at(apps.rstu,1,3,1,1)
		appsGrid:add_widget_at(apps.zoom,2,1,1,1)
		appsGrid:add_widget_at(apps.atom,2,2,1,1)
		appsGrid:add_widget_at(apps.juli,2,3,1,1)
		appsGrid:add_widget_at(apps.gimp,3,1,1,1)
		appsGrid:add_widget_at(apps.libr,3,2,1,1)
		appsGrid:add_widget_at(apps.tele,3,3,1,1)

  -- Crear wibox 1
  s.mywibox1=wibox({
      -- position="bottom",
      screen=s,
      opacity=1.0,
      -- bg='#1E0E33',
      bg = beautiful.bg_normal,
      --bg = '#06095F',
      shape=function (cr,width,height)
          gears.shape.partially_rounded_rect (cr,width,height,false,false,true,false,20)
      end,
      width=207,
      height=20,
      --border_width=2,
      border_width=0,
      -- border_color='#38E7DF',
      border_color=beautiful.bg_focus,
      x=s.geometry.x,
      y=s.geometry.y,
      visible=true,
      ontop=true
  })

    -- Crear wibox 2
    s.mywibox2=wibox({
				-- position="top",
				screen=s,
				opacity=1.0,
				-- bg='#1E0E33',
				bg = beautiful.bg_normal,
				shape=function (cr,width,height)
				    gears.shape.partially_rounded_rect (cr,width,height,false,false,false,true,20)
				end,
				width=495,
				height=20,
				border_width=0,
				-- border_color='#38E7DF',
				border_color=beautiful.bg_focus,
 				x=s.geometry.x+s.geometry.width-495,
				y=s.geometry.y,
				visible=true,
				ontop=true
    })
    
		-- Crear wibox 3
    s.mywibox3=awful.wibar({
				screen=s,
				position="top",
				opacity=0,
				width=100,
				height=24,
				border_width=0,
				border_color='#ffffff00',
				visible=true,
				ontop=true
    })

		-- Crear wibox 4
		-- s.mywibox4 = awful.wibar({
		-- 				screen = s,
		-- 				position = "right",
		-- 				opacity = 0.9,
		-- 				width = 500,
		-- 				height = 350,
		-- 				border_width = 0,
		-- 				bg = beautiful.bg_normal,
		-- 				fg = beautiful.fg_normal,
		-- 				visible = false,
		-- 				ontop = true,
		-- 				shape = function(cr,width,height)
		-- 						gears.shape.partially_rounded_rect(cr,width,height,true,false,false,true,20)
		-- 				end,
		-- 		})

		-- Crear wibox 4 (Apps)
		s.mywibox4=awful.wibar({
				screen = s,
				position = "left",
				opacity = 0.9,
				width = 250,
				height = 200,
				border_width = 25,
				-- border_color = beautiful.bg_normal,
				border_color = "#790C6C",
				visible = false,
				-- bg = beautiful.bg_normal,
				bg = "#790C6C",
				ontop = true,
				shape=function (cr,width,height)
				    gears.shape.partially_rounded_rect (cr,width,height,false,true,true,false,60)
				end,

		})

s.mywibox4:connect_signal("button::press",function () myscreen = awful.screen.focused()
    myscreen.mywibox4.visible = not myscreen.mywibox4.visible end)


   s.mywibox1:setup {
       layout=wibox.layout.align.horizontal,
       { -- Left widgets
           layout = wibox.layout.fixed.horizontal,
           betaw,
           s.mylayoutbox,
           wibox.widget.textbox(" "),
           s.mytaglist,
           wibox.widget.textbox(" "),
           wibox.widget.textbox(" "),
       },
       nil,
       {
	   layout = wibox.layout.fixed.horizontal,
	   debianw,
	   wibox.widget.textbox("    "),
       }
   }
    s.mywibox2:setup {
	layout=wibox.layout.align.horizontal,
	{--derecha
	    layout=wibox.layout.fixed.horizontal,
	    wibox.widget.textbox("    "),
	    debianw,
	},
	nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
						netdownicon,
            netdowninfo,
            netupicon,
            netupinfo.widget,
						memicon,
            memory.widget,
						volicon,
            mitema.volume.widget,
	    battery_widget({
	    show_current_level = true,
	    display_notification = true,
	    timeout = 3,
			screen = s
	    }),
	    cpuicon,
	    cpu.widget,
            mytextclock,
	    salida,
	    lambdaw
        },
    }
   s.mywibox3:setup {
       layout=wibox.layout.align.horizontal,
       nil,
       nil,
       {
	   layout = wibox.layout.fixed.horizontal,
	   wibox.widget.textbox("  ")
       }
   }

	 s.mywibox4:setup {
			 -- Rejilla
       layout = wibox.layout.flex.vertical,
			 appsGrid,
	}
					
					
					
  --  s.mywibox4:add(
  -- 		 wibox.widget {
	-- 		 image = "apps/pavu.png",
	-- 		 resize = true,
	-- 		 widget = wibox.widget.imagebox
	-- 		 }
	-- 	)

		-- s.mywibox4:setup {
		-- 		layout = wibox.layout.align.horizontal,
		-- 		nil,
		-- 		s.mypromptbox,
		-- 		nil				
		-- }

end)
-- }}}

local pos = 4 --[[
 1: portatil
 2: lg
 3: portatil - lg
 4: lg - portatil
 nil: no hace cambios
 --]]

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () awful.spawn.with_shell("rofi -show-icons -no-plugins -modi \"drun\" -lines 7 -location 0 -show drun -width 500 -theme DarkBlue.rasi -drun-icon-theme kora -terminal alacritty") end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "Up",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Down",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --          {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),
    -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn.with_shell("alacritty") end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),


-----------Samuel
    awful.key({ modkey,		  }, "g", function () awful.spawn.with_shell("rofi -show-icons -no-plugins -modi \"drun\" -lines 7 -location 0 -show drun -width 500 -theme DarkBlue.rasi -drun-icon-theme kora -terminal alacritty") end,
	      {description = "abre rofi launcher", group = "launcher"}),
    awful.key({ modkey, "Shift"	  }, "g", function () awful.spawn.with_shell("rofi -show-icons -no-plugins -modi \"drun\" -show drun -theme sidebar.rasi -drun-icon-theme kora -terminal alacritty") end,
	      {description = "abre rofi launcher grande", group = "launcher"}),
    awful.key({		  }, "Print", function() awful.spawn.with_shell("gnome-screenshot") end,
	      {description = "Captura total de pantalla", group = "screen"}),
    awful.key({ "Shift"	  }, "Print", function() awful.spawn.with_shell("gnome-screenshot -a") end,
	      {description = "Captura de área de pantalla", group = "screen"}),
    awful.key({"Control", "Shift" }, "Print", function() awful.spawn.with_shell("gnome-screenshot -w") end,
	      {description = "Capturar ventana actual", group = "screen"}),
--     awful.key({ }, "Lock", function() awful.spawn.with_shell("i3lock -e -t -i /Archivos/A/Imágenes/Fondos\\ de\\ Pantalla/colorful_5-wallpaper-1366x768.png") end,
-- 	      {description = "Bloquear Pantalla", group = "screen"}),
    awful.key({ modkey,		  }, "w", function() awful.spawn.with_shell("nmcli r wifi on") end,
	      {description = "Encender wi-fi", group = "wi-fi"}),
    awful.key({ modkey, "Shift"	  }, "w", function() awful.spawn.with_shell("nmcli r wifi off") end,
	      {description = "Apagar wi-fi", group = "wi-fi"}),
    awful.key({ modkey,		  }, "b", function() awful.spawn.with_shell("firefox-esr") end,
	      {description = "Abre firefox", group = "client"}),
    awful.key({ modkey,		  }, "z", function() awful.spawn.with_shell("zathura") end,
	      {description = "Abre zathura", group = "client"}),
    awful.key({ modkey, "Shift"	  }, "b", function() awful.spawn.with_shell("luakit") end,
	      {description = "Abre luakit", group = "client"}),
    -- awful.key({			  }, "XF86MonBrightnessDown", function () 
		-- 				local handle = io.popen("xbacklight -get")
		-- 				local brillo = handle:read("*a")
		-- 				handle:close()
		-- 				local step = math.max(brillo*0.13+0.5,1)
		-- 				os.execute("xbacklight -dec "..step) end,
    --           {description = "Bajar el brillo", group = "screen"}),
    -- awful.key({			  }, "XF86MonBrightnessUp", function () 
		-- 				local handle = io.popen("xbacklight -get")
		-- 				local brillo = handle:read("*a")
		-- 				handle:close()
		-- 				local step = math.max(brillo*0.13+0.5,1)
		-- 				os.execute("xbacklight -inc "..step) end,
    --           {description = "Subir el brillo", group = "screen"}),
		awful.key({  }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 2") end,
						{description = "Bajar el brillo", group = "screen"}),
		awful.key({  }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 2") end,
						{description = "Subir el brillo", group = "screen"}),
    awful.key({ }, "XF86AudioRaiseVolume", function ()  awful.util.spawn("amixer set Master 5%+") end,
              {description = "Subir el volumen", group = "sonido" }),
    awful.key({ }, "XF86AudioLowerVolume", function ()  awful.util.spawn("amixer set Master 5%-") end,
              {description = "Bajar el volumen", group = "sonido" }),
    awful.key({ }, "XF86AudioMute", function ()         awful.util.spawn("amixer sset Master toggle") end,
              {description = "Silenciar", group = "sonido"}),
    awful.key({ }, "XF86AudioMicMute", function () awful.util.spawn("amixer set Capture nocap") end,
              {description = "Cerrar el micrófono", group = "sonido"}),
    awful.key({ "Shift" }, "XF86AudioMicMute", function () awful.util.spawn("amixer set Capture cap") end,
              {description = "Abrir el micrófono", group = "sonido"}),
    awful.key({ modkey,		  }, "e", function () awful.spawn.with_shell("alacritty -e ranger") end,
	      {description = "Abre el explorador de archivos", group = "launcher"}),
    awful.key({ modkey,	"Shift"	  }, "e", function () awful.spawn.with_shell("pcmanfm-qt") end,
	      {description = "Abre el explorador de archivos gráfico", group = "launcher"}),
    awful.key({ modkey  }, "p", function () myscreen = awful.screen.focused()
              myscreen.mywibox1.visible = not myscreen.mywibox1.visible  
              myscreen.mywibox2.visible = not myscreen.mywibox2.visible  
              myscreen.mywibox3.visible = not myscreen.mywibox3.visible  end,
              {description = "ver/ocultar wibox", group="awesome"}),
		-- awful.key({ modkey, }, "x", function () myscreen = awful.screen.focused()
		-- 						myscreen.mywibox4.visible = not myscreen.mywibox4.visible end,
		-- 				  {description = "Usar Lua promp", group="awesome"}),
		awful.key({ modkey }, "space", function() myscreen = awful.screen.focused() 
						  myscreen.mywibox4.visible = not myscreen.mywibox4.visible end,
						  {description = "Ver menú de apiclaciones", group = "launcher"}),
    awful.key({ modkey,     }, "Tab", function () myscreen = awful.screen.focused() myscreen.popup_tag.visible = not myscreen.popup_tag.visible end,
              {description = "Ver ventanas abiertas", group="awesome"}),
		awful.key({ modkey, "Control" }, "Right", function() awful.screen.focus_relative(1) end,
						  {description = "Enfocar la otra pantalla", group = "screen"}),
		awful.key({ modkey, "Control" }, "Left", function() awful.screen.focus_relative(1) end,
						  {description = "Enfocar la otra pantalla", group = "screen"}),
		awful.key({ modkey, }, "k", function() 
				xrandr.xrandr(pos)
				-- awesome.restart()
				end,
					 	  {description = "Escoger distribución de monitores.", group ="screen"}),
		awful.key({ modkey, }, "x", function()
								awful.spawn("alacritty -e lua", {
												floating  = true,
												tag       = mouse.screen.selected_tag,
								}) end,
						  {description = "Abrir Lua prompt", group="awesome"}),

---------------

   --  awful.key({ modkey,           }, "a", add_tag,
   --        {description = "add a tag", group = "tag"}),
   --  awful.key({ modkey, "Shift"   }, "a", delete_tag,
   --        {description = "delete the current tag", group = "tag"}),


    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "r", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "r", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    --awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
      --        {description = "run prompt", group = "launcher"}),

    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "i", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
--        -- Toggle tag display.
--        awful.key({ modkey, "Control" }, "#" .. i + 9,
--                  function ()
--                      local screen = awful.screen.focused()
--                      local tag = screen.tags[i]
--                      if tag then
--                         awful.tag.viewtoggle(tag)
--                      end
--                  end,
--                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to screen.
				awful.key({ modkey, "Control" }, "s", 
								  function ()
											if client.focus then
													client.focus:move_to_screen()
											end
									end,
									{description = "Mueve cliente enfocado a la otra pantalla", group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false}
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
		-- {rule = {class = "Alacritty" },
		-- 		properties = {screen = awful.screen.focused()} },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--Fondos de pantalla


--ejecutar al arrancar
awful.spawn.with_shell("compton --config /home/samuel/.config/compton/compton.conf")
---- REDSHIFT
local reds = io.popen("pidof redshift")
local ejecutando = reds:read("*a")
reds:close()
if ejecutando=="" then
		awful.spawn.with_shell("redshift -t 6700:4500 -l 4.67:-70.06")
end
----
awful.spawn.with_shell("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
awful.spawn.with_shell("nitrogen --restore")

--  awful.spawn.with_shell("/home/samuel/.local/bin/fondos &")
-- awful.spawn.with_shell("feh --bg-fill /Archivos/A/Imágenes/Fondos_de_Pantalla/wp11")
