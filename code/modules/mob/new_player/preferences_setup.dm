/datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	var/datum/species/current_species = all_species[species ? species : "Human"]
	set_biological_gender(pick(current_species.genders))

	h_style = random_hair_style(biological_gender, species)
	f_style = random_facial_hair_style(biological_gender, species)
	if(current_species)
		if(current_species.appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
		if(current_species.appearance_flags & HAS_EYE_COLOR)
			randomize_eyes_color()
		if(current_species.appearance_flags & HAS_HAIR_COLOR)
			randomize_hair_color("hair")
			randomize_hair_color("facial")
		if(current_species.appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
	if(current_species.appearance_flags & HAS_UNDERWEAR)
		all_underwear.Cut()
		for(var/datum/category_group/underwear/WRC in global_underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name


	backbag = rand(1,4)
	pdachoice = rand(1,3)
	age = rand(current_species.min_age, current_species.max_age)
	b_type = RANDOM_BLOOD_TYPE
	if(H)
		copy_to(H,1)


/datum/preferences/proc/randomize_hair_color(var/target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

/datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/mannequin)
	copy_to(mannequin)
	if(!dress_mob)
		return

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	if(job_civilian_low & ASSISTANT)
		previewJob = job_master.GetJob("Assistant")
	else
		for(var/datum/job/job in job_master.occupations)
			var/job_flag
			switch(job.department_flag)
				if(CIVILIAN)
					job_flag = job_civilian_high
				if(MEDSCI)
					job_flag = job_medsci_high
				if(ENGSEC)
					job_flag = job_engsec_high
			if(job.flag == job_flag)
				previewJob = job
				break

	if(previewJob)
		mannequin.job = previewJob.title
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title])
		var/list/equipped_slots = list() //If more than one item takes the same slot only spawn the first
		for(var/thing in gear)
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_roles)
					for(var/job_name in G.allowed_roles)
						if(previewJob.title == job_name)
							permitted = 1
				else
					permitted = 1

				if(G.whitelisted && (G.whitelisted != mannequin.species.name))
					permitted = 0

				if(!permitted)
					continue

				if(G.slot && !(G.slot in equipped_slots))
					equipped_slots += G.slot
					var/metadata = gear[G.display_name]
					mannequin.equip_to_slot_or_del(G.spawn_item(mannequin, metadata), G.slot)
		mannequin.update_icons()

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)

	preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale(48+32, 16+32)

	var/list/offsets = list("x1" = 0,
							"x2" = 0,
							"x3" = 0,
							"y1" = 0,
							"y2" = 0,
							"y3" = 0)

	if(mannequin.get_organ(BP_TAUR))
		preview_icon.Scale(64+32, 16+32)
		offsets["x1"] = -8
		offsets["y1"] = 2
		offsets["x2"] = -20
		offsets["y2"] = -8
		offsets["x3"] = 0
		offsets["y3"] = 0

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 25 + offsets["x1"], 17 + offsets["y1"])

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 1 + offsets["x2"], 9 + offsets["y2"])

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 49 + offsets["x3"], 1 + offsets["y3"])

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.