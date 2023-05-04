-- allow us to toggle various views
-- "show_minimap"
-- "show_quickbar"
-- "show_shortcut_bar"
function ToggleView(player, view, show)
	if show == true then
		DebugPrint(player,"Showing view " .. view)
	else
		DebugPrint(player,"Hiding view " .. view)
	end
	
	local settings = player.game_view_settings
	settings[view] = show
end

--[[
-- allow us to toggle various map settings
-- See https://lua-api.factorio.com/latest/Concepts.html#MapViewSettings
function toggle_map_setting(player, setting, show)
	local settings = player.map_view_settings
	settings[setting] = show
end
]]

function ProcessArmour(player)

	if player.character == nil then
		return
	end
    
	local armourInv = player.get_inventory(defines.inventory.character_armor)
	local armour = armourInv.get_contents()
	
	local noArmour = armourInv.is_empty()
	
	local lightArmour = armour["light-armor"] ~= nil
		or armour["light-armor"] ~= nil
		or armour["tiny-armor-mk1"] ~= nil
		or armour["pamk3-lvest"] ~= nil
		or armour["early-construction-light-armor"] ~= nil
	
	
	local heavyArmour = armour["heavy-armor"] ~= nil
		or armour["tiny-armor-mk2"] ~= nil
		or armour["heavy-armor-2"] ~= nil
		or armour["heavy-armor-3"] ~= nil
		or armour["pamk3-hvest"] ~= nil
		or armour["early-construction-heavy-armor"] ~= nil
		or armour["Schall-engineering-suit-basic"] ~= nil
		
	
	local modularArmour = armour["modular-armor"] ~= nil
		or armour["Schall-engineering-suit"] ~= nil
	
	local powerArmour = armour["power-armor"] ~= nil
		or armour["se-thruster-suit"] ~= nil
		or armour["Schall-engineering-suit-mk1"] ~= nil
	
	local powerArmourMk2 = armour["power-armor-mk2"] ~= nil
		or armour["se-thruster-suit-2"] ~= nil
		or armour["Schall-engineering-suit-mk2"] ~= nil
	
	-- Set HUD Options
	ToggleView(player,"show_minimap",noArmour == false);
	ToggleView(player,"show_quickbar",noArmour == false);
	ToggleView(player,"show_shortcut_bar",noArmour == false);
		
	-- Set Movespeed and Inventory Sizes
	if noArmour then
		DebugPrint(player,"No Armour")
		SetMovespeed(player,settings.global["meaningful-speed-mod-none"].value)
	elseif lightArmour then
		DebugPrint(player,"Light Armour")
		SetMovespeed(player,settings.global["meaningful-speed-mod-light"].value)
		AdjustInventorySize(player,settings.global["meaningful-inventory-mod-light"].value)
	elseif heavyArmour then
		DebugPrint(player,"Heavy Armour")
		SetMovespeed(player,settings.global["meaningful-speed-mod-heavy"].value)
		AdjustInventorySize(player,settings.global["meaningful-inventory-mod-heavy"].value)
	elseif modularArmour then
		DebugPrint(player,"Modular Armour")
		SetMovespeed(player,settings.global["meaningful-speed-mod-modular"].value)
		AdjustInventorySize(player,settings.global["meaningful-inventory-mod-modular"].value)
	elseif powerArmour then
		DebugPrint(player,"Power Armour")
		SetMovespeed(player,settings.global["meaningful-speed-mod-power"].value)
		AdjustInventorySize(player,settings.global["meaningful-inventory-mod-power"].value)
	elseif powerArmourMk2 then
		DebugPrint(player,"Power Armour Mk 2")
		SetMovespeed(player,settings.global["meaningful-speed-mod-power-mk2"].value)
		AdjustInventorySize(player,settings.global["meaningful-inventory-mod-power-mk2"].value)
	end
	
	-- Set work speed
	local steelAxe = player.force.technologies["steel-axe"]
	
    if steelAxe.researched then
		DebugPrint(player,"Steel Axe Researched")
        SetMiningSpeed(player,settings.global["meaningful-mining-speed-mod-steelaxe"].value)
        SetCraftingSpeed(player,settings.global["meaningful-crafting-speed-mod-steelaxe"].value)
    else
		DebugPrint(player,"Steel Axe Not Researched")
        SetMiningSpeed(player,settings.global["meaningful-mining-speed-mod-normal"].value)
        SetCraftingSpeed(player,settings.global["meaningful-crafting-speed-mod-normal"].value)
    end

	-- DebugPrint(player,"PROCESSING ARMOUR")

end

function DebugPrint(player,text)
	if settings.global["meaningful-debug"].value == true then
		player.print(text)
	end
end

function AdjustReach(player,size)
	if settings.startup["meaningful-reach-enable"].value == true then
		DebugPrint(player,"Setting Reach: " .. size)
		player.character_build_distance_bonus = size
		player.character_item_drop_distance_bonus = size
		player.character_item_pickup_distance_bonus = size
		player.character_loot_pickup_distance_bonus = size
		player.character_reach_distance_bonus = size
		player.character_resource_reach_distance_bonus = size
	end
end

function AdjustInventorySize(player,size)
	if settings.startup["meaningful-inventory-size-enable"].value == true then
		DebugPrint(player,"Setting inventory size: " .. size)
		player.character.character_inventory_slots_bonus = size
	end
	-- player.get_inventory(defines.inventory.character_main).resize(size)
end

function SetMovespeed(player,speed)
	DebugPrint(player,"Setting movespeed to " .. speed-1.0)
	player.character.character_running_speed_modifier = speed-1.0
end

function SetMiningSpeed(player,speed)
	DebugPrint(player,"Setting mining speed to " .. speed-1.0)
	player.character.character_mining_speed_modifier = speed-1.0
end

function SetCraftingSpeed(player,speed)
	DebugPrint(player,"Setting crafting speed to " .. speed-1.0)
	player.character.character_crafting_speed_modifier = speed-1.0
end

function FixTutorialReach(player)
	player.character_build_distance_bonus = 100
	player.character_item_drop_distance_bonus = 100
	player.character_item_pickup_distance_bonus = 100
	player.character_loot_pickup_distance_bonus = 100
	player.character_reach_distance_bonus = 100
	player.character_resource_reach_distance_bonus = 100
end

-- event handler hook
-- simply refresh every player.
-- Not the most efficient, but works
local function PlayerEvent(event)
	for i, player in pairs(game.players) do
		ProcessArmour(player)
    end
end

-- Process the armour changes at various points
script.on_event(defines.events.on_player_joined_game, PlayerEvent)
script.on_event(defines.events.on_cutscene_cancelled, PlayerEvent)
script.on_event(defines.events.on_runtime_mod_setting_changed, PlayerEvent)
script.on_event(defines.events.on_player_armor_inventory_changed, PlayerEvent)
script.on_event(defines.events.on_research_finished, PlayerEvent)

--[[
-- Because we are modifying the players reach, this will break the tutorial screens
-- Here, we can fix it

--Subscribe to gui events so we can fix the reach in the tutorials screen
script.on_event(defines.events.on_gui_opened, TutorialOpen)
script.on_event(defines.events.on_gui_closed, TutorialClose)

local function TutorialOpen(event)
	if event["gui_type"] == defines.gui_type.tutorials then
		for i, player in pairs(game.players) do
			DebugPrint(player,"Tutorial Screen Opened - fixing reach")
			FixTutorialReach(player)
		end
	end
end
local function TutorialClose(event)
	if event["gui_type"] == defines.gui_type.tutorials then
		for i, player in pairs(game.players) do
			DebugPrint(player,"Tutorial Screen Closed - resetting reach")
			ProcessArmour(player)
		end
	end
end
]]--