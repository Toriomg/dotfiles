hl.config({
    input = {
        kb_layout = "us,es",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        touchpad = { natural_scroll = true }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "float"
})

hl.gesture({
    fingers = 4,
    direction = "swipe",
    mods = "SUPER",
    action = "move"
})


hl.gesture({
    fingers = 4,
    direction = "swipe",
    action = "resize"
})


hl.config({
    cursor = { no_hardware_cursors = true }
})