////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST
	var/skilllock = 1

/obj/item/reagent_container/hypospray/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/item/reagent_container/hypospray/attack(mob/M, mob/living/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='danger'>[src] is empty.</span>")
		return
	if (!istype(M))
		return
	if (reagents.total_volume)
		if(skilllock && user.mind && user.mind.cm_skills && user.mind.cm_skills.medical < SKILL_MEDICAL_CHEM)
			user.visible_message("<span class='warning'>[user] fumbles with [src]...</span>", "<span class='warning'>You fumble with [src]...</span>")
			if(!do_mob(user, M, 30, BUSY_ICON_FRIENDLY, BUSY_ICON_MEDICAL))
				return
		var/sleeptoxin = 0
		for(var/datum/reagent/R in reagents.reagent_list)
			if(istype(R, /datum/reagent/toxin/chloralhydrate) || istype(R, /datum/reagent/toxin/stoxin))
				sleeptoxin = 1
				break
		if(sleeptoxin)
			if(!do_after(user, 20, TRUE, 5, BUSY_ICON_GENERIC, TRUE))
				return 0
			if(!M.Adjacent(user))
				return 0
		if(M != user && M.stat != DEAD && M.a_intent != "help" && !M.is_mob_incapacitated() && ((M.mind && M.mind.cm_skills && M.mind.cm_skills.cqc >= SKILL_CQC_MP) || isYautja(M))) // preds have null skills
			user.KnockDown(3)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Used cqc skill to stop [user.name] ([user.ckey]) injecting them.</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Was stopped from injecting [M] ([M.ckey]) by their cqc skill.</font>")
			msg_admin_attack("[user.name] ([user.ckey]) got robusted by the cqc of [M.name] ([M.key]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
			M.visible_message("<span class='danger'>[M]'s reflexes kick in and knock [user] to the ground before they could use \the [src]'!</span>", \
				"<span class='warning'>You knock [user] to the ground before they inject you!</span>", null, 5)
			playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
			return 0

		to_chat(user, "<span class='notice'> You inject [M] with [src].</span>")
		to_chat(M, "<span class='warning'>You feel a tiny prick!</span>")
		playsound(loc, 'sound/items/hypospray.ogg', 50, 1)

		src.reagents.reaction(M, INGEST)
		if(M.reagents)

			var/list/injected = list()
			for(var/datum/reagent/R in src.reagents.reagent_list)
				injected += R.name
			var/contained = english_list(injected)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [M.name] ([M.key]). Reagents: [contained]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) injected [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			to_chat(user, "<span class='notice'> [trans] units injected. [reagents.total_volume] units remaining in [src].</span>")

	return 1

/obj/item/reagent_container/hypospray/tricordrazine
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients. Contains tricordrazine."
	volume = 30

/obj/item/reagent_container/hypospray/tricordrazine/New()
	..()
	reagents.add_reagent("tricordrazine", 30)

