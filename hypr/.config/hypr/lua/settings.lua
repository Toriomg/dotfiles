hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 10,
        border_size = 0,
        col = {
            active_border = "#999", -- Lua acepta las variables cargadas por source
            inactive_border = "#000"
        },
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle"
    },
    decoration = {
        rounding = 16,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        blur = {
            enabled = true,
            size = 4,
            passes = 3,
            popups = true,
            vibrancy = 0.2,
        },
        shadow = {
            enabled = false
        },
    },
    animations = {
        enabled = true,
        workspace_wraparound = true
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        focus_on_activate = true
    }
})

-- Curvas personalizadas
hl.curve("fluid", {
    type = "bezier",
    points = {{0.15, 0.85}, {0.25, 1}}
})
hl.curve("snappy", {
    type = "bezier",
    points = {{0.3, 1}, {0.4, 1}}
})

-- Animaciones (Usando la nueva sintaxis hl.animation)
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 3,
    bezier = "fluid",
    style = "popin 5%"
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2.5,
    bezier = "snappy"
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.7,
    bezier = "snappy",
    style = "slide"
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true -- You probably want this
    }
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master"
    }
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true
    }
})
