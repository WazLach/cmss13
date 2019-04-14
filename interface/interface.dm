//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		to_chat(src, "<span class='danger'>The wiki URL is not set in the server configuration.</span>")
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		to_chat(src, "<span class='danger'>The forum URL is not set in the server configuration.</span>")
	return

/client/verb/rules()
	set name = "rules"
	set desc = "Read our rules."
	set hidden = 1
	if( config.rulesurl )
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")
	return

/client/verb/donate()
	set name = "Donate"
	set desc = "Like our server? Buy us a beer and get some custom-made items."
	set hidden = 1

	to_chat(src, "<br>View our donation page for more info: https://cm-ss13.com/viewtopic.php?f=119&t=5978.<br>")
	return

/client/verb/submitbug()
	set name = "Submit Bug"
	set desc = "Submit a bug."
	set hidden = 1

	if(alert("Please search for the bug first to make sure you aren't posting a duplicate.",,"Ok","Cancel")=="Cancel")
		return
	src << link("https://gitlab.com/cmdevs/ColonialMarines/issues")
	return

/client/verb/set_fps()
	set name = "Set FPS"
	set desc = "Set client FPS. 20 is the default"
	set category = "Preferences"
	var/fps = input(usr,"New FPS Value. 0 is server-sync. Higher values cause more desync. Values over 30 not recommended.","Set FPS") as num
	if(world.byond_version >= 511 && byond_version >= 511 && fps >= MIN_FPS && fps <= MAX_FPS)
		vars["fps"] = fps
		prefs.fps = fps
		prefs.save_preferences()
	return

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tshift+e = sidearm equip
\tr = throw
\tt = say
\tx = swap-hand
\tz = activate held object (or y)
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tNum1 = swap target between right leg and right foot
\tNum2 = target groin
\tNum3 swap target between left leg and left foot
\tNum4 swap target between right arm and right hand
\tNum5 target chest
\tNum6 swap target between left arm and left hand
\tNum8 swap target between head, eyes, and mouth
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	src << hotkey_mode
	src << other
	if(admin_holder)
		src << admin
