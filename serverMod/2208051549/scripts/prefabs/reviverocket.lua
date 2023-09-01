local assets =
{
    Asset("ANIM", "anim/reviverocket.zip"),
    Asset("ANIM", "anim/flare_water.zip"),
    Asset("ATLAS", "images/inventoryimages/reviverocket.xml"),
}

local function RemoveHudIndicator(inst)  -- client code
	if ThePlayer ~= nil and ThePlayer.HUD ~= nil then 
		ThePlayer.HUD:RemoveTargetIndicator(inst)
	end
end

local function SetupHudIndicator(inst) -- client code
	ThePlayer.HUD:AddTargetIndicator(inst, {image = "reviverocket.tex"})
	inst:DoTaskInTime(TUNING.MINIFLARE.HUD_INDICATOR_TIME, RemoveHudIndicator)
	inst:ListenForEvent("onremove", RemoveHudIndicator)
end

local function show_flare_hud(inst)
    -- While we don't access the HUD directly, we're trying to send a HUD event,
    -- so if the HUD isn't there we don't need to do any work.
    if ThePlayer ~= nil then
        local fx, fy, fz = inst.Transform:GetWorldPosition()
        local px, py, pz = ThePlayer.Transform:GetWorldPosition()
        local sq_dist_to_flare = distsq(fx, fz, px, pz)

        if ThePlayer.HUD ~= nil then
            if sq_dist_to_flare < TUNING.MINIFLARE.HUD_MAX_DISTANCE_SQ then
                ThePlayer:PushEvent("startflareoverlay")
		    else
			    SetupHudIndicator(inst)
            end
        end

        local near_audio_gate_distsq = TUNING.MINIFLARE.HUD_MAX_DISTANCE_SQ
        local far_audio_gate_distsq = TUNING.MINIFLARE.FAR_AUDIO_GATE_DISTANCE_SQ
        local volume = (sq_dist_to_flare > far_audio_gate_distsq and TUNING.MINIFLARE.BASE_VOLUME)
                or (sq_dist_to_flare > near_audio_gate_distsq and 
                        TUNING.MINIFLARE.BASE_VOLUME + (1 - Remap(sq_dist_to_flare, near_audio_gate_distsq, far_audio_gate_distsq, 0, 1)) * (1-TUNING.MINIFLARE.BASE_VOLUME)
                    )
                or 1.0
        inst.SoundEmitter:PlaySound("turnoftides/common/together/miniflare/explode", nil, volume)
    end
end


local function on_ignite_over(inst)
    local fx, fy, fz = inst.Transform:GetWorldPosition()

    local random_angle = math.pi * 2 * math.random()
    local random_radius = -(TUNING.MINIFLARE.OFFSHOOT_RADIUS) + (math.random() * 2 * TUNING.MINIFLARE.OFFSHOOT_RADIUS)

    fx = fx + (random_radius * math.cos(random_angle))
    fz = fz + (random_radius * math.sin(random_angle))

    -------------------------------------------------------------
    -- Find talkers to say speech.      找玩家说话。。。上面计算看到信号弹的距离相关
    --[[for _, player in ipairs(AllPlayers) do
        if player._miniflareannouncedelay == nil and math.random() > TUNING.MINIFLARE.CHANCE_TO_NOTICE then --注意到的机会。。。
            local px, py, pz = player.Transform:GetWorldPosition()
            local sq_dist_to_flare = distsq(fx, fz, px, pz) 
            if sq_dist_to_flare > TUNING.MINIFLARE.SPEECH_MIN_DISTANCE_SQ then
				player._miniflareannouncedelay = player:DoTaskInTime(TUNING.MINIFLARE.NEXT_NOTICE_DELAY, function(i) i._miniflareannouncedelay = nil end) -- so gross, if this logic gets any more complicated then make a component
                player.components.talker:Say(GetString(player, "ANNOUNCE_FLARE_SEEN"))
            end
        end
    end]]

    -------------------------------------------------------------
    --come to live again friend 。。。good luck
    local ghosts={}
    for _,v in ipairs(AllPlayers) do
        if v:HasTag("playerghost") then
            table.insert(ghosts,v)
        end
    end
    if #ghosts ~= 0 then
        local luckydog=ghosts[math.random(#ghosts)]
        luckydog:PushEvent("respawnfromghost", { source = nil, user = luckydog })
    end

    inst:Remove()
end

local function on_ignite(inst)  --点火
    -- We've been set off; we shouldn't save anymore.
    inst.persists = false
    inst.entity:SetCanSleep(false)

    inst.AnimState:PlayAnimation("fire")
    inst:ListenForEvent("animover", on_ignite_over) --点火结束。。。

    inst.SoundEmitter:PlaySound("turnoftides/common/together/miniflare/launch")
end

local function on_dropped(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
end

local function reviverocket_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("flare")
    inst.AnimState:SetBuild("reviverocket")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "large", nil, {0.65, 0.4, 0.65})   --让 库存，存货 可浮动。。。？

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("burnable")
    inst.components.burnable:SetOnIgniteFn(on_ignite)   --

    MakeSmallPropagator(inst)   --小型传播子，内部有一些传播子初值设定，作用不详
    inst.components.propagator.heatoutput = 0
    inst.components.propagator.damages = false

    inst.components.inventoryitem.atlasname = "images/inventoryimages/reviverocket.xml"

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("ondropped", on_dropped)
    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("float") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)

    return inst
end

return Prefab("reviverocket", reviverocket_fn, assets),   --原参数prefabs还有小地图啊。。。给去掉了
        MakePlacer("reviverocket_placer", "reviverocket", "reviverocket", "idle")--,啊。。。放置。。。吧
       -- Prefab("miniflare_minimap", flare_minimap, minimap_assets, minimap_prefabs)
