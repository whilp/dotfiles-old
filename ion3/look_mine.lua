-- look_cleanios.lua drawing engine configuration file for Ion.
-- hacked by Will Maier

if not gr.select_engine("de") then return end

de.reset()

de.defstyle("*", {
    shadow_colour = "#ffffff",
    highlight_colour = "#ffffff",
    background_colour = "#d8d8d8",
    foreground_colour = "#000000",
    padding_pixels = 1,
    highlight_pixels = 1,
    shadow_pixels = 1,
    spacing = 0,
    border_style = "elevated",
    font = "-sgi-screen-medium-r-normal--13-130-72-72-m-70-iso8859-1",
    text_align = "center",
})

de.defstyle("frame", {
    based_on = "*",
    padding_colour = "#d8d8d8",
    background_colour = "#000000",
    -- transparent_background = true,
})


de.defstyle("frame-tiled", {
    based_on = "frame",
    shadow_pixels = 0,
    highlight_pixels = 0,
    padding_pixels = 0,
    spacing = 1,
    transparent_background = true,
})

de.defstyle("tab", {
    based_on = "*",
    font = "-sgi-screen-medium-r-normal--10-100-72-72-m-60-iso8859-1",
    de.substyle("active-selected", {
        shadow_colour = "#f0f066",
        highlight_colour = "#f0f066",
        background_colour = "#f0c000",
        foreground_colour = "#000000",
    }),
    de.substyle("active-unselected", {
        shadow_colour = "#ffffff",
        highlight_colour = "#ffffff",
        background_colour = "#d8d8d8",
        foreground_colour = "#000000",
    }),
    de.substyle("inactive-selected", {
        shadow_colour = "#ffffff",
        highlight_colour = "#ffffff",
        background_colour = "#a8a8a8",
        foreground_colour = "#000000",
    }),
    de.substyle("inactive-unselected", {
        shadow_colour = "#ffffff",
        highlight_colour = "#ffffff",
        background_colour = "#d8d8d8",
        foreground_colour = "#000000",
    }),
    text_align = "center",
})

de.defstyle("tab-menuentry", {
    based_on = "tab",
    text_align = "left",
    spacing = 1,
})

de.defstyle("tab-menuentry-big", {
    based_on = "tab-menuentry",
    font = "-*-helvetica-medium-r-normal-*-17-*-*-*-*-*-*-*",
    padding_pixels = 7,
})

de.defstyle("input-edln", {
    based_on = "*",
    de.substyle("*-cursor", {
        background_colour = "#000000",
        foreground_colour = "#d8d8d8",
    }),
    de.substyle("*-selection", {
        background_colour = "#f0c000",
        foreground_colour = "#000000",
    }),
})

dopath("lookcommon_clean")

-- Needs to come after ^^ in order to work
de.defstyle("stdisp", {
    shadow_pixels = 0,
    highlight_pixels = 0,
    font = "-sgi-screen-medium-r-normal--12-120-72-72-m-70-iso8859-1",
    background_colour = "#000000",
    -- transparent_background = true,
    de.substyle("important", {
        foreground_colour = "green",
    }),

    de.substyle("critical", {
        foreground_colour = "red",
        background_colour = "yellow",
    }),
})

gr.refresh()

