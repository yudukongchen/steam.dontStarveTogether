
local  needtosave = { 
    tzsama = {
        current = true,
        max = true,
		add = true,
    },
    tz_xx = {
		dengji = true,
		jieduan = true,
		ba = true,
		sh = true,
		hd = true,
		kz = true,
		jd_1 = true,
		jd_2 = true,
		jd_3 = true,
		jd_4 = true,	
		adddamageforlevel1 = true,
		xiuxian = true,
		trigger = true,
		nightbuff = true,
		addshanbi = true,
		canreadbook = true,
    }
}

return Class(function(self, inst)
    assert(TheWorld.ismastersim, "好好学习天天向上")

    self.inst = inst

    local _world = TheWorld
    local _ismastershard = _world.ismastershard

    self._savedata = {}
    if _ismastershard then
        inst:ListenForEvent("ms_newplayerspawned", function(world, player)
            if self._savedata[player.userid] ~= nil then
                for k, v in pairs(self._savedata[player.userid]) do
                    if player.components[k] ~= nil then
                        for k1,v1 in pairs(v) do
                            player.components[k][k1] = v1
                        end 
                        self._savedata[player.userid][k] = nil
                        if player.components[k].DoneInfoLoad then
                            player.components[k]:DoneInfoLoad()
                        end
                    else
                    end
                end
                --if player.qmsktbl ~= nil and self._savedata[player.userid]["qingmujineng"] then
                --    player.qmsktbl = self._savedata[player.userid]["qingmujineng"]
                --    self._savedata[player.userid]["qingmujineng"] = nil
                --end
            end
        end)
    end

    inst:ListenForEvent("ms_playerdespawnanddelete", function(inst,player)
        local save = {}
        save[player.userid] = {}
        for k,v in pairs(needtosave) do 
            if player and player.components[k]  ~= nil then
                save[player.userid][k] = {}
                if player.components[k].PreInfoSave then
                    player.components[k]:PreInfoSave()
                end
                for k1,v1 in pairs(v) do
                    save[player.userid][k][k1] = player.components[k][k1]
                end
            end
        end
        --if player.qmsktbl ~= nil then
        --    save[player.userid]["qingmujineng"] = player.qmsktbl
        --end
        if next(save) ~= nil then
			local success,a  = pcall(json.encode,save)
            if success then
                SendModRPCToShard(SHARD_MOD_RPC["tz_saveinfo"]["tz_saveinfo"],{"1","0"},a)    
			end
        end
    end)

    if _ismastershard then function self:AddPlayerInfo(playerid,infostr)
        if not self._savedata[playerid] then
            self._savedata[playerid] = {}
        end
        for k, v in pairs(infostr) do
            self._savedata[playerid][k] = v
        end
    end end

    if _ismastershard then function self:OnSave()
        return {_savedata = self._savedata}
    end end

    if _ismastershard then function self:OnLoad(data)
        if data and data._savedata then
            self._savedata = data._savedata
        end
    end end

end)
