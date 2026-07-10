hl.layer_rule({
    name = "no_anim_for_selection",
    match = {
        namespace = "selection"
    },
    no_anim = true
})

hl.window_rule({
    match = { class = "pavucontrol" },
    float = true,
    center = true,
})
