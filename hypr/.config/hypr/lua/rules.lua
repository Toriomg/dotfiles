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

-- APARCADO junto al menú de la tecla Menú: cada ventana en su workspace especial.
-- for class, ws in pairs({ ["scratch-term"] = "term", ["scratch-monitor"] = "monitor", ["scratch-audio"] = "audio" }) do
--     hl.window_rule({
--         match = { class = class },
--         workspace = "special:" .. ws,
--     })
-- end
