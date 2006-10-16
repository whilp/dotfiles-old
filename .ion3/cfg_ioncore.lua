--
-- Ion core configuration file
--


-- 
-- Bindings. This includes global bindings and bindings common to
-- screens and all types of frames only. See modules' configuration 
-- files for other bindings.
--


-- WScreen context bindings
--
-- The bindings in this context are available all the time.
--
-- The variable META should contain a string of the form 'Mod1+'
-- where Mod1 maybe replaced with the modifier you want to use for most
-- of the bindings. Similarly ALTMETA may be redefined to add a 
-- modifier to some of the F-key bindings.

defbindings("WScreen", {
    bdoc("Switch to n:th object (workspace, full screen client window) "..
         "within current screen."),
    kpress(META.."1", "WScreen.switch_nth(_, 0)"),
    kpress(META.."2", "WScreen.switch_nth(_, 1)"),
    kpress(META.."3", "WScreen.switch_nth(_, 2)"),
    kpress(META.."4", "WScreen.switch_nth(_, 3)"),
    kpress(META.."5", "WScreen.switch_nth(_, 4)"),
    kpress(META.."6", "WScreen.switch_nth(_, 5)"),
    kpress(META.."7", "WScreen.switch_nth(_, 6)"),
    kpress(META.."8", "WScreen.switch_nth(_, 7)"),
    kpress(META.."9", "WScreen.switch_nth(_, 8)"),
    kpress(META.."0", "WScreen.switch_nth(_, 9)"),
    
    submap(META.."K", {
        bdoc("Go to first region demanding attention or previously active one."),
        kpress("K", "ioncore.goto_activity() or ioncore.goto_previous()"),

        bdoc("Switch to next/previous object within current screen."),
        kpress(META.."N", "WScreen.switch_prev(_)"),
        kpress(META.."P", "WScreen.switch_next(_)"),

        --bdoc("Go to previous active object."),
        --kpress("K", "ioncore.goto_previous()"),
        
        --bdoc("Go to first object on activity/urgency list."),
        --kpress("I", "ioncore.goto_activity()"),
        
        bdoc("Clear all tags."),
        kpress("T", "ioncore.clear_tags()"),
    }),

    bdoc("Go to n:th screen on multihead setup."),
    kpress(META.."Shift+1", "ioncore.goto_nth_screen(0)"),
    kpress(META.."Shift+2", "ioncore.goto_nth_screen(1)"),
    
    bdoc("Go to next/previous screen on multihead setup."),
    kpress(META.."Shift+comma", "ioncore.goto_prev_screen()"),
    kpress(META.."Shift+period", "ioncore.goto_next_screen()"),
    
    bdoc("Create a new workspace of chosen default type."),
    kpress(META.."F9", "ioncore.create_ws(_)"),
    
    bdoc("Display the main menu."),
    kpress(META.."F12", "mod_query.query_menu(_, 'mainmenu', 'Main menu: ')"),
    --kpress(ALTMETA.."F12", "mod_menu.menu(_, _sub, 'mainmenu', {big=true})"),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'mainmenu')"),
    
    bdoc("Display the window list menu."),
    mpress("Button2", "mod_menu.pmenu(_, _sub, 'windowlist')"),

    bdoc("Forward-circulate focus."),
    -- '_chld' used here stands to for an actual child window that may not
    -- be managed by the screen itself, unlike '_sub', that is likely to be
    -- the managing group of that window. The right/left directions are
    -- used instead of next/prev, because they work better in conjunction
    -- with tilings.
    kpress(META.."Tab", "ioncore.goto_next(_chld, 'right')", 
           "_chld:non-nil"),
    submap(META.."K", { 
        bdoc("Backward-circulate focus."),
        kpress("AnyModifier+Tab", "ioncore.goto_next(_chld, 'left')", 
               "_chld:non-nil"),
        
        bdoc("Raise focused object, if possible."),
        kpress("AnyModifier+R", "WRegion.rqorder(_chld, 'front')",
               "_chld:non-nil"),
    }),

})


-- Client window bindings
--
-- These bindings affect client windows directly.

defbindings("WClientWin", {
    bdoc("Nudge the client window. This might help with some "..
         "programs' resizing problems."),
    kpress_wait(META.."L", "WClientWin.nudge(_)"),
    
    submap(META.."K", {
       bdoc("Kill client owning the client window."),
       kpress("C", "WClientWin.kill(_)"),
       
       bdoc("Send next key press to the client window. "..
            "Some programs may not allow this by default."),
       kpress("Q", "WClientWin.quote_next(_)"),
    }),
})


-- Client window group bindings

defbindings("WGroupCW", {
    bdoc("Toggle client window group full-screen mode"),
    kpress_wait(META.."Return",
                "WClientWin.set_fullscreen(_:bottom(), 'toggle')"),
})


-- WMPlex context bindings
--
-- These bindings work in frames and on screens. The innermost of such
-- contexts/objects always gets to handle the key press. Most of these 
-- bindings define actions on client windows. (Remember that client windows 
-- can be put in fullscreen mode and therefore may not have a frame.)

defbindings("WMPlex", {
    bdoc("Close current object."),
    kpress_wait(META.."C", "WRegion.rqclose_propagate(_, _sub)"),
})

-- Frames for transient windows ignore this bindmap

defbindings("WMPlex.toplevel", {
    bdoc("Run a terminal emulator."),
    kpress(ALTMETA.."F2", "ioncore.exec_on(_, XTERM or '~/bin/term')"),

    bdoc("Connect to the meta screen session."),
    kpress(META.."F2", 
        "ioncore.exec_on(_, '~/bin/term -T META -e ssh -t will@meta.lfod.us screen -RD meta')"),
    
    bdoc("Query for command line to execute."),
    kpress(ALTMETA.."F3", "mod_query.query_exec(_)"),

    bdoc("Query for Lua code to execute."),
    kpress(META.."F3", "mod_query.query_lua(_)"),

    bdoc("Run a web browser."),
    kpress(ALTMETA.."F4", "ioncore.exec_on(_, '~/bin/browser')"),

    bdoc("Run a web browser."),
    kpress(META.."F4", "ioncore.exec_on(_, 'firefox')"),

    bdoc("Pause/unpause MPD."),
    kpress(ALTMETA.."F5", "ioncore.exec_on(_, '~/bin/tunes stop')"),

    bdoc("Start ncmpc."),
    kpress(META.."F5", "ioncore.exec_on(_, '~/bin/tunes')"),

    bdoc("Decrease volume for a music program."),
    kpress(ALTMETA.."F6", "ioncore.exec_on(_, '~/bin/vol -d')"),

    bdoc("Skip to the previous track in a music program."),
    kpress(META.."F6", "ioncore.exec_on(_, '~/bin/tunes prev')"),

    bdoc("Increase volume for a music program."),
    kpress(ALTMETA.."F7", "ioncore.exec_on(_, '~/bin/vol -u')"),

    bdoc("Skip to the next track in a music program."),
    kpress(META.."F7", "ioncore.exec_on(_, '~/bin/tunes next')"),

    bdoc("Increase volume for a music program to a set high point."),
    kpress(ALTMETA.."F8", "ioncore.exec_on(_, '~/bin/vol -t')"),

    bdoc("Query for workspace to go to or create a new one."),
    kpress(ALTMETA.."F9", "mod_query.query_workspace(_)"),

    bdoc("Lock the screen."),
    kpress(ALTMETA.."F10", "ioncore.exec_on(_, '~/bin/lock')"),

    bdoc("Lock the screen."),
    kpress(META.."F10", "ioncore.exec_on(_, '~/bin/lock pause')"),

    bdoc("Restart."),
    kpress(ALTMETA.."F11", "ioncore.restart()"),

    bdoc("Quit."),
    kpress(ALTMETA.."F12", "ioncore.shutdown()"),
    
    bdoc("Query for a client window to go to."),
    kpress(META.."G", "mod_query.query_gotoclient(_)"),
    
    bdoc("Query for a client window to attach."),
    kpress(META.."A", "mod_query.query_attachclient(_)"),
    
    bdoc("Display context menu."),
    --kpress(META.."M", "mod_menu.menu(_, _sub, 'ctxmenu')"),
    kpress(META.."M", "mod_query.query_menu(_, 'ctxmenu', 'Context menu: ')"),

})


-- WFrame context bindings
--
-- These bindings are common to all types of frames. The rest of frame
-- bindings that differ between frame types are defined in the modules' 
-- configuration files.

defbindings("WFrame", {
    submap(META.."K", {
        bdoc("Maximize the frame horizontally/vertically."),
        kpress("H", "WFrame.maximize_horiz(_)"),
        kpress("V", "WFrame.maximize_vert(_)"),
    }),
    
    bdoc("Display context menu."),
    mpress("Button3", "mod_menu.pmenu(_, _sub, 'ctxmenu')"),
    
    bdoc("Begin move/resize mode."),
    kpress(META.."R", "WFrame.begin_kbresize(_)"),
    
    bdoc("Switch the frame to display the object indicated by the tab."),
    mclick("Button1@tab", "WFrame.p_switch_tab(_)"),
    mclick("Button2@tab", "WFrame.p_switch_tab(_)"),
    
    bdoc("Resize the frame."),
    mdrag("Button1@border", "WFrame.p_resize(_)"),
    mdrag(META.."Button3", "WFrame.p_resize(_)"),
    
    bdoc("Move the frame."),
    mdrag(META.."Button1", "WFrame.p_move(_)"),
    
    bdoc("Move objects between frames by dragging and dropping the tab."),
    mdrag("Button1@tab", "WFrame.p_tabdrag(_)"),
    mdrag("Button2@tab", "WFrame.p_tabdrag(_)"),
           
})

-- Frames for transient windows ignore this bindmap

defbindings("WFrame.toplevel", {
    bdoc("Tag current object within the frame."),
    kpress(META.."T", "WRegion.set_tagged(_sub, 'toggle')", "_sub:non-nil"),

    bdoc("Switch to next/previous object within the frame."),
    kpress(META.."period", "WFrame.switch_next(_)"),
    kpress(META.."comma", "WFrame.switch_prev(_)"),
    
    submap(META.."K", {
        bdoc("Switch to n:th object within the frame."),
        kpress("1", "WFrame.switch_nth(_, 0)"),
        kpress("2", "WFrame.switch_nth(_, 1)"),
        kpress("3", "WFrame.switch_nth(_, 2)"),
        kpress("4", "WFrame.switch_nth(_, 3)"),
        kpress("5", "WFrame.switch_nth(_, 4)"),
        kpress("6", "WFrame.switch_nth(_, 5)"),
        kpress("7", "WFrame.switch_nth(_, 6)"),
        kpress("8", "WFrame.switch_nth(_, 7)"),
        kpress("9", "WFrame.switch_nth(_, 8)"),
        kpress("0", "WFrame.switch_nth(_, 9)"),
        
        bdoc("Move current object within the frame left/right."),
        kpress("comma", "WFrame.dec_index(_, _sub)", "_sub:non-nil"),
        kpress("period", "WFrame.inc_index(_, _sub)", "_sub:non-nil"),
               
        bdoc("Maximize the frame horizontally/vertically."),
        kpress("H", "WFrame.maximize_horiz(_)"),
        kpress("V", "WFrame.maximize_vert(_)"),

        bdoc("Attach tagged objects to this frame."),
        kpress("A", "WFrame.attach_tagged(_)"),
    }),
})

-- Bindings for floating frames.

defbindings("WFrame.floating", {
    bdoc("Toggle shade mode"),
    mdblclick("Button1@tab", "WFrame.set_shaded(_, 'toggle')"),
    
    bdoc("Raise the frame."),
    mpress("Button1@tab", "WRegion.rqorder(_, 'front')"),
    mpress("Button1@border", "WRegion.rqorder(_, 'front')"),
    mclick(META.."Button1", "WRegion.rqorder(_, 'front')"),
    
    bdoc("Lower the frame."),
    mclick(META.."Button3", "WRegion.rqorder(_, 'back')"),
    
    bdoc("Move the frame."),
    mdrag("Button1@tab", "WFrame.p_move(_)"),
})


-- WMoveresMode context bindings
-- 
-- These bindings are available keyboard move/resize mode. The mode
-- is activated on frames with the command begin_kbresize (bound to
-- META.."R" above by default).

defbindings("WMoveresMode", {
    bdoc("Cancel the resize mode."),
    kpress("AnyModifier+Escape","WMoveresMode.cancel(_)"),

    bdoc("End the resize mode."),
    kpress("AnyModifier+Return","WMoveresMode.finish(_)"),

    bdoc("Grow in specified direction."),
    kpress("H",  "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("L", "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("K",    "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("J",  "WMoveresMode.resize(_, 0, 0, 0, 1)"),
    kpress("F",     "WMoveresMode.resize(_, 1, 0, 0, 0)"),
    kpress("B",     "WMoveresMode.resize(_, 0, 1, 0, 0)"),
    kpress("P",     "WMoveresMode.resize(_, 0, 0, 1, 0)"),
    kpress("N",     "WMoveresMode.resize(_, 0, 0, 0, 1)"),
    
    bdoc("Shrink in specified direction."),
    kpress("Shift+H",  "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+L", "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+K",    "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+J",  "WMoveresMode.resize(_, 0, 0, 0,-1)"),
    kpress("Shift+F",     "WMoveresMode.resize(_,-1, 0, 0, 0)"),
    kpress("Shift+B",     "WMoveresMode.resize(_, 0,-1, 0, 0)"),
    kpress("Shift+P",     "WMoveresMode.resize(_, 0, 0,-1, 0)"),
    kpress("Shift+N",     "WMoveresMode.resize(_, 0, 0, 0,-1)"),
    
    bdoc("Move in specified direction."),
    kpress(META.."H",  "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."L", "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."K",    "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."J",  "WMoveresMode.move(_, 0, 1)"),
    kpress(META.."F",     "WMoveresMode.move(_,-1, 0)"),
    kpress(META.."B",     "WMoveresMode.move(_, 1, 0)"),
    kpress(META.."P",     "WMoveresMode.move(_, 0,-1)"),
    kpress(META.."N",     "WMoveresMode.move(_, 0, 1)"),
})


--
-- Menu definitions
--


-- Main menu
defmenu("mainmenu", {
    submenu("Programs",         "appmenu"),
    menuentry("Lock screen",    "ioncore.exec_on(_, 'xlock')"),
    menuentry("Help",           "mod_query.query_man(_)"),
    menuentry("About Ion",      "mod_query.show_about_ion(_)"),
    submenu("Styles",           "stylemenu"),
    submenu("Session",          "sessionmenu"),
})


-- Application menu
defmenu("appmenu", {
    menuentry("XTerm",          "ioncore.exec_on(_, 'xterm')"),
    menuentry("Firefox",        "ioncore.exec_on(_, 'firefox')"),
    menuentry("Run...",         "mod_query.query_exec(_)"),
})


-- Session control menu
defmenu("sessionmenu", {
    menuentry("Save",           "ioncore.snapshot()"),
    menuentry("Restart",        "ioncore.restart()"),
    menuentry("Restart TWM",    "ioncore.restart_other('twm')"),
    menuentry("Exit",           "ioncore.shutdown()"),
})


-- Context menu (frame/client window actions)
defctxmenu("WFrame", "Frame", {
    menuentry("Close",          "WRegion.rqclose_propagate(_, _sub)"),
    menuentry("Kill",           "WClientWin.kill(_sub)",
                                "_sub:WClientWin"),
    menuentry("Toggle tag",     "WRegion.set_tagged(_sub, 'toggle')",
                                "_sub:non-nil"),
    menuentry("Attach tagged",  "WFrame.attach_tagged(_)"),
    menuentry("Clear tags",     "ioncore.clear_tags()"),
    menuentry("Window info",    "mod_query.show_tree(_, _sub)"),
})


-- Context menu for screens
defctxmenu("WScreen", "Screen", {
    menuentry("New workspace",  "ioncore.create_ws(_)"),
    menuentry("New empty workspace",
                                "ioncore.create_ws(_, nil, true)"),
    menuentry("Close workspace","WRegion.rqclose(_sub)"),
})

    
