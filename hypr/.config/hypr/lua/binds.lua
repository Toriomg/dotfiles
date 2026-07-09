local mainMod = "SUPER"

-- Apps y Sistema
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(_G.terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(_G.fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(_G.menu))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + M", hl.dsp.exit())

-- Foco
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces (Loop automático)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia (Locked + Repeating)
local multimediaFlags = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"),       {multimediaFlags})
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"),       {multimediaFlags})
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), {multimediaFlags})
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),  {multimediaFlags})
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"),          {multimediaFlags})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),          {multimediaFlags})

-- Ratón
--hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
--hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- CAPTURAS DE PANTALLA (Hyprshot) ---
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --freeze -o ~/Screenshots/"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot -m window -o ~/Screenshots/"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m active -m output -o ~/Screenshots/"))

-- --- SISTEMA Y BLOQUEO ---
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind("ALT + TAB", hl.dsp.exec_cmd("wlogout -b 2"))

-- --- SCRIPTS PERSONALIZADOS (ALT + Keys) ---
hl.bind("ALT + W", hl.dsp.exec_cmd("~/.config/hypr/wallpaper.sh"))
hl.bind("ALT + A", hl.dsp.exec_cmd("~/.config/waybar/scripts/refresh.sh"))
hl.bind("ALT + B", hl.dsp.exec_cmd("~/.config/waybar/scripts/select.sh"))
-- hl.bind("ALT + R", hl.dsp.exec_cmd("~/.config/swaync/refresh.sh"))
hl.bind("ALT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/random_wallpaper.sh")) -- Usé SHIFT + R para diferenciar de la 'r' minúscula si lo prefieres
