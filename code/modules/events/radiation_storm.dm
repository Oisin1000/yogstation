/datum/round_event_control/radiation_storm
	name = "Radiation Storm"
	typepath = /datum/round_event/radiation_storm
	max_occurrences = 1

/datum/round_event/radiation_storm
	var/list/protected_areas = list(/area/maintenance, /area/turret_protected/ai_upload, /area/turret_protected/ai_upload_foyer, /area/turret_protected/ai)


/datum/round_event/radiation_storm/setup()
	startWhen = rand(10, 20)
	endWhen = startWhen + 5

/datum/round_event/radiation_storm/announce()
	command_alert("High levels of radiation detected near the station. Maintenance is best shielded from radiation.", "Anomaly Alert")
	world << sound('sound/AI/radiation.ogg')	//sound not longer matches the text, but an audible warning is probably good


/datum/round_event/radiation_storm/start()
	message_admins("Random Event: Radiation Storm")
	for(var/mob/living/carbon/C in living_mob_list)
		var/turf/T = get_turf(C)
		if(!T)			continue
		if(T.z != 1)	continue

		var/skip = 0
		for(var/a in protected_areas)
			if(istype(T.loc, a))
				skip = 1
				continue

		if(skip)	continue

		if(locate(/obj/machinery/power/apc) in T)	//damn you maint APCs!!
			continue

		if(istype(C, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			H.apply_effect((rand(15, 75)), IRRADIATE, 0)
			if(prob(5))
				H.apply_effect((rand(90, 150)), IRRADIATE, 0)
			if(prob(25))
				if(prob(75))
					randmutb(H)
					domutcheck(H, null, 1)
				else
					randmutg(H)
					domutcheck(H, null, 1)

		else if(istype(C, /mob/living/carbon/monkey))
			var/mob/living/carbon/monkey/M = C
			M.apply_effect((rand(15, 75)), IRRADIATE, 0)


/datum/round_event/radiation_storm/end()
	command_alert("The radiation threat has passed. Please return to your workplaces.", "Anomaly Alert")