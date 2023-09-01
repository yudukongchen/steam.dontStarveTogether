
-- 乱动皮肤的后果自负！！！ 抓到一次没任何机会！
local userdata = require("util/tz_userdatahook")
local skinowner = {} -- 服务器所有人拥有的皮肤
local selfowner = {} -- 自己拥有的皮肤
local skinowner_tmp = {} -- 自己拥有的皮肤_限时皮肤
local selfowner_tmp = {} -- 自己拥有的皮肤_限时皮肤

local islogin = {} -- 已经登录过的玩家
local autologin = {} -- 服务器自动获取一次皮肤
local selfid = TheNet:GetUserID()
local selfnetid = ''
function IsDefaultCharacterSkin( item_key )
    return string.sub( item_key, -5 ) == "_none"
end

function TaizhenSkinCheckFn(inventory, name)
    return IsDefaultCharacterSkin(name) or (selfowner[name] or selfowner_tmp[name]) and true or false
end

function TaiZhenSkinCheckClientFn(inventory, userid, name)
    if userid and name and ( not islogin[userid] or skinowner[userid] and skinowner_tmp[userid]) then
        if not islogin[userid] then -- 没取到玩家记录 就当是有吧 
            return true
        end
        return
            (skinowner[userid][name] or skinowner_tmp[userid][name]) and true or
                false
    end
    return IsDefaultCharacterSkin(name) or false
end
function TaiZhenGetAllSkinCheckFn(userid,filterfn)  --userid 不传默认自己  filterfn可以过滤皮肤名称
    userid = userid or selfid
    local all = {}
    for k,v in pairs(skinowner[userid]) do
        if not (filterfn and not filterfn(k,false)) then
            table.insert(all ,k) 
        end
    end
    for k,v in pairs(skinowner_tmp[userid]) do
        if not (filterfn and filterfn(k,false)) then
            table.insert(all ,k) 
        end
    end
    return all
end
local ThanksImg = {}
function RegThanksImg(prefab,name,xml,tex)     --给非皮肤注册贴图用的 
    STRINGS.SKIN_NAMES[prefab] = name
    ThanksImg[prefab] = {name = name,xml=xml,tex=tex}
end
GLOBAL.TaiZhenGetAllSkinCheckFn = TaiZhenGetAllSkinCheckFn  --获取玩家所有皮肤 
GLOBAL.TaiZhenSkinCheckClientFn = TaiZhenSkinCheckClientFn  --检查指定玩家皮肤权限
GLOBAL.TaizhenSkinCheckFn = TaizhenSkinCheckFn  --检查自己皮肤权限
GLOBAL.TaizhenRegThanksImg = RegThanksImg --给非皮肤注册贴图用的 
-- 破解很简单,逮到就完蛋

-- 先读取缓存  尽力而为 读不到就算了
local cache = "TzSkinCache"
local servercache = cache .. "_server"
if TheNet:GetIsServer() then
    TheSim:GetPersistentString(servercache, function(load_success, str)
        if load_success then
            -- print(servercache, str)
            local r, j = pcall(json.decode, str)
            if r and j.tmp and j.owner then
                for k, v in pairs(j.owner) do
                    if type(v) == "table" then
                        skinowner[k] = v
                    end
                end
                for k, v in pairs(j.tmp) do
                    if type(v) == "table" then
                        skinowner_tmp[k] = v
                    end
                end
            end
        end
    end)

end
-- 客户端缓存 
if not TheNet:IsDedicated() then
    TheSim:GetPersistentString(cache, function(load_success, str)
        if load_success then
            --print(cache, str)
            local r, j = pcall(json.decode, str)
            if r and j.tmp and j.owner then
                for k, v in pairs(j.owner) do
                    if type(k) == "string" and v == 1 then
                        selfowner[k] = v
                    end
                end
                for k, v in pairs(j.tmp) do
                    if type(k) == "string" and v == 1 then
                        selfowner_tmp[k] = v
                    end
                end
            end
        end
    end)

end

function SaveSkinCache()
    if TheNet:GetIsServer() then
        local r, j =
            pcall(json.encode, {owner = skinowner, tmp = skinowner_tmp})
        if r then TheSim:SetPersistentString(servercache, j, true) end
    end
    local r, j = pcall(json.encode, {owner = selfowner, tmp = selfowner_tmp})
    if r then TheSim:SetPersistentString(cache, j, true) end
end

--擅动着 杀无赦
local black = {
}

AddSimPostInit(function()
    local old = ShouldDisplayItemInCollection
    GLOBAL.ShouldDisplayItemInCollection = function(str,...) 
        if (black[str] or str:match("^tz_.+_tmp$") or str:match("^taizhen_.+_tmp$")) and not TaizhenSkinCheckFn(TheInventory,str)  then return false end
        return old(str,...) 
    end
end)

-- 网络部分
local ThankYouPopup = require "screens/thankyoupopup"
local apiurl = "http://tz.flapi.cn/api/Dst" 
local token = ""
local tokentime = 0
-- local apiurl = "http://127.0.0.1/api/Dst"
local function nofn() end

GLOBAL.TaizhenCD = function(ti) -- 内置CD
    local t = ti
    local last = -ti
    return function()
        local ct = GetTime()
        if (ct - ti) > last then
            last = ct
            return true
        end
        return false
    end
end

local function SkinApi(api, data, fn)
    if not api then return false end
    data = data or {}
    fn = fn or nofn
    local r, js = pcall(json.encode, data)
    if r then
    --print("SkinApi",api, data, fn)
        TheSim:QueryServer(apiurl .. api .. '?token=' .. token,
                           function(str, succ, code)
            --print(api, js, str)
            if succ and code == 200 then
                local re, jso = pcall(json.decode, str)
                if re and type(jso) == "table" then
                    fn(jso.code, jso.msg, jso.data)
                else
                    fn(-3, 'err json', str)
                    --print("APIFailed3",'err json',str)
                end
            else
                fn(-2,code, str)
                --print("APIFailed2",code,str)
            end
        end, 'POST', js)
    else
        fn(-1, 'err json')
    end
end

local function GetSkins(userid)
    if not userid then return end
    if not skinowner[userid] then skinowner[userid] = {} end
    if not skinowner_tmp[userid] then skinowner_tmp[userid] = {} end
    SkinApi("s/GetSkins", {kid = userid}, function(code, msg, data)
        
        if code == 2001 and data.items then
            skinowner[userid] = {}
            for k, v in pairs(data.items) do skinowner[userid][v] = 1 end
            if userid == selfid then
                selfowner = {}
                for k, v in pairs(data.items) do selfowner[v] = 1 end
            end
            if data.temps then
                skinowner_tmp[userid] = {}
                for k, v in pairs(data.temps) do
                    skinowner_tmp[userid][v] = 1
                end
                if userid == selfid then
                    selfowner_tmp = {}
                    for k, v in pairs(data.temps) do
                        selfowner_tmp[v] = 1
                    end
                end
            end

            islogin[userid] = true
            SaveSkinCache()

            local player  = LookupPlayerInstByUserID(userid)
            if player then
                player:PushEvent("TzSkinUpdate_Event",{items = data.items,temps = data.temps})
            end
        end
    end)
end
local gametimes = 0
local function Login(userid, netid, nick)
    SkinApi('c/Login', {kid = userid, netid = netid, nick = nick},
            function(code, msg, data)
        if code > 1000 and data and data.token then
            token = data.token
            tokentime = 3600
            if data.time then gametimes = data.time end
        else
            print("LoginFailed",msg, data)
            return false
        end
    end)
end
-- 游戏时长上报

local function OnLine()
    SkinApi('c/online/', {}, function(code, msg, data)
        if code > 3000 and data and data.time then
            gametimes = data.time
        else
            return false
        end
    end)
end

local function UseSkinCDK(cdk,cb)  --客户端调用
    SkinApi('c/UseCDK', {cdk = cdk},cb)
end

if not TheNet:IsDedicated() then
    GetSkins(selfid)
    local function trylogin()
            if token ~= "" then return end
            for k, v in pairs(TheNet:GetClientTable() or {}) do
                if v and v.userid == selfid then
                    selfnetid = v.netid
                end
            end

            if selfnetid:find("R:") then
                selfnetid = 'RU_' .. selfnetid:sub(3, -1)
            else
                selfnetid = 'OU_' .. selfnetid
            end
            Login(selfid, selfnetid, TheNet:GetLocalUserName())
        end
    trylogin()
    AddSimPostInit(function(inst)
        TheWorld:DoTaskInTime(0,trylogin)
        TheWorld.TryReLoginTimes = 0
        TheWorld.TryReLogin = TheWorld:DoPeriodicTask(10, function()
            TheWorld.TryReLoginTimes = TheWorld.TryReLoginTimes +1
            if TheWorld.TryReLoginTimes < 21 and token == ""  then
                trylogin()
            else
                TheWorld.TryReLogin:Cancel()
            end
            
        end)
        TheWorld:DoPeriodicTask(300, function()
            GetSkins(selfid)
            tokentime = tokentime - 300
            if tokentime < 0 then
                Login(selfid, selfnetid, TheNet:GetLocalUserName())
            end
            if ThePlayer and ThePlayer:HasTag("taizhen") then OnLine() end
        end)
    end)
end

if TheNet:GetIsServer() then
    AddPlayerPostInit(function(inst)
        inst:DoTaskInTime(0, function() GetSkins(inst.userid) end)
    end)
    AddSimPostInit(function(inst)
        TheWorld:DoPeriodicTask(600, function()
            local t = TheNet:GetClientTable()
            for k, v in pairs(t) do GetSkins(v.userid) end
        end)
    end)
end

-- skinRPC处理
local skinhandle = {
    GetSkins = function(inst,Force)
        if not inst.taizhengetskincd then
            inst.taizhengetskincd = TaizhenCD(60)
            GetSkins(inst.userid)
        elseif inst.taizhengetskincd() or Force then
            GetSkins(inst.userid)
        end
    end
}

AddModRPCHandler("taizhen", 'skin', function(player, cmd, ...)
    if type(cmd) == "string" and skinhandle[cmd] then
        skinhandle[cmd](player, ...)
    end
end)
function SkinRPC(cmd, ...)
    if type(cmd) == "string" and skinhandle[cmd] then
        if TheNet:GetIsServer() then
            if ThePlayer then skinhandle[cmd](ThePlayer, ...) end
        else
            SendModRPCToServer(MOD_RPC.taizhen.skin, cmd, ...)
        end
    end
end
-- ban掉乱换皮肤的
-- 除此之外检测到换皮肤的封号
local skinhook = {}

local function CheckBuild(inst, build)
    if not build then return false end
    if not table.contains(PREFAB_SKINS.taizhen, build) then return false end
    if not inst:HasTag("taizhen") then return true end
    
    if TheWorld.ismastersim then
        if not inst.userid or not islogin[inst.userid] then return false end
        if not (skinowner[inst.userid][build] or skinowner[inst.userid][build.."_tmp"] ) then return true end
    else
        if not (selfowner[build] or selfowner_tmp[build]) then
            return true
        end
    end
    return false
end
local function CheckSymbolBuild(inst, symbol, build)
    return CheckBuild(inst, build)
end

skinhook.SetBuild = userdata.MakeHook("AnimState", 'SetBuild', CheckBuild)
skinhook.SetSkin = userdata.MakeHook("AnimState", 'SetSkin', CheckBuild)
skinhook.AddOverrideBuild = userdata.MakeHook("AnimState", 'AddOverrideBuild',
                                              CheckBuild)
skinhook.OverrideSkinSymbol = userdata.MakeHook("AnimState",
                                                'OverrideSkinSymbol',
                                                CheckSymbolBuild)
skinhook.OverrideSymbol = userdata.MakeHook("AnimState", 'OverrideSymbol',
                                            CheckSymbolBuild)

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0.5, function()
        for k, v in pairs(skinhook) do userdata.Hook(inst, v) end
    end)
end)

STRINGS.THANKS_POPUP.TZSKIN = '感谢游玩阿平酱'

if TheNet:GetIsServer() then
    AddPrefabPostInit("taizhen", function(inst)
        local skin = inst.components.skinner.skin_name
        if skin:find("none") and skin ~= "taizhen_none" then
            inst.components.skinner:SetSkin("taizhen_none")
        end
    end)
end

-- 客户端UI
if not TheNet:IsDedicated() then

local messages = {}
local PopupDialogScreen = require "screens/redux/popupdialog"
local function TaiZhenPushPopupDialog(title, message, button, fn)
    if not (ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls) then
        table.insert(messages,{title, message, button, fn})
    end
    local buttonstr = button or STRINGS.UI.POPUPDIALOG.OK
    local scr
    local function doclose() TheFrontEnd:PopScreen(scr) end
    scr = PopupDialogScreen(title, message, {
        {
            text = buttonstr,
            cb = function()
                doclose()
                if fn then fn() end
            end
        }
    })
    TheFrontEnd:PushScreen(scr)
    local screen = TheFrontEnd:GetActiveScreen()
    if screen then screen:Enable() end
    return scr
end
AddClassPostConstruct("widgets/controls",function(self)
    self.inst:DoTaskInTime(3,function()
    if next(messages) then
        for k,v in pairs(messages) do
            TaiZhenPushPopupDialog(unpack(v))
        end
        messages = {}
    end
    end)
end)
GLOBAL.TaiZhenPushPopupDialog = TaiZhenPushPopupDialog

    local GameTimeUnLockScreen -- 提前定义
    local CdkUnLockScreen -- 提前定义
    local SkinActive = {
        taizhen_none = function(s, item)
            local scr = CdkUnLockScreen(item)
            scr.unlocktext:SetString("仅用于解锁其他皮肤")
            return scr
        end,
    }
    local item_map = {taizhen_none = "taizhen"}
    AddClassPostConstruct("widgets/redux/itemexplorer", function(self)
        local old_ShowItemSetInfo = self._ShowItemSetInfo
        self._ShowItemSetInfo = function(s, ...)
            if SkinActive[s.set_item_type] then
                s.set_info_screen = SkinActive[s.set_item_type](s,
                                                                s.set_item_type)
                s.set_info_screen.owned_by_wardrobe = true
                TheFrontEnd:PushScreen(self.set_info_screen)
                return
            end
            return old_ShowItemSetInfo(s, ...)
        end

        local old_UpdateItemSelectedInfo = self._UpdateItemSelectedInfo
        self._UpdateItemSelectedInfo = function(s, item, ...)
            -- print(item,...)
            local r = old_UpdateItemSelectedInfo(s, item, ...)
            if SkinActive[item] and not selfowner[item] then
                s.set_info_btn:SetText("激活")
                s.set_info_btn:Show()
                s.set_item_type = item
            end
            return r
        end
    end)
    -- UI定义
    local Screen = require "widgets/screen"
    local Text = require "widgets/text"
    local UIAnim = require "widgets/uianim"
    local Image = require "widgets/image"
    local Widget = require "widgets/widget"
    local TEMPLATES = require "widgets/redux/templates"

    local MAX_ITEMS = 5
    local LINE_HEIGHT = 44
    local TEXT_WIDTH = 300
    local TEXT_OFFSET = 40
    local FONT = BUTTONFONT
    local FONT_SIZE = 32
    local ITEM_SCALE = 0.6
    local IMAGE_X = -55
    local OWNED_COLOUR = UICOLOURS.WHITE
    local NEED_COLOUR = UICOLOURS.GREY

    local UnLockScreen = Class(Screen, function(self, item, cb)
        Screen._ctor(self, "UnLockScreen")
        self.item = item
        self.cb = cb
        self.black = self:AddChild(TEMPLATES.BackgroundTint())
        self.proot = self:AddChild(TEMPLATES.ScreenRoot("ROOT"))
        self.cd = TaizhenCD(10)
        self.buttons = {
            {
                text = '激活',
                cb = function()
                    if self.cd() then
                        if self.cb then
                            self.cb(self, item)
                        end
                    else
                        TaiZhenPushPopupDialog("太真的温馨提示","请稍候再试")
                    end
                end
            }, {text = '关闭', cb = function() self:Close() end}
        }
        local width = 400
        self.dialog = self.proot:AddChild(
                          TEMPLATES.CurlyWindow(width, 450, STRINGS.NAMES[item],
                                                self.buttons))
        self.content_root = self.proot:AddChild(Widget("content_root"))
        self.content_root:SetPosition(200, -150)

        self.anim_root = self.content_root:AddChild(Widget("anim_root"))
        self.anim_root:SetVAnchor(ANCHOR_MIDDLE)
        self.anim_root:SetHAnchor(ANCHOR_MIDDLE)
        self.anim_root:SetScaleMode(SCALEMODE_PROPORTIONAL)
        self.anim_root:SetPosition(-150, -50)
        self.anim = self.anim_root:AddChild(UIAnim())
        self.animstate = self.anim:GetAnimState()
        self.animstate:SetBuild(item_map[item] or item)
        self.animstate:SetBank("wilson")
        self.animstate:PlayAnimation("emoteXL_loop_dance0", true)
        self.animstate:AddOverrideBuild("player_emote_extra")
        self.anim:SetFacing(FACING_DOWN)
        self.anim:SetScale(0.8, 0.8, 0.8)
        self.animstate:Hide("ARM_carry")
        self.animstate:Hide("head_hat")
        self.animstate:Hide("HAIR_HAT")

        self.icon = self.content_root:AddChild(UIAnim())
        self.icon:GetAnimState():SetBank("accountitem_frame")
        self.icon:GetAnimState():SetBuild("accountitem_frame")
        self.icon:GetAnimState():PlayAnimation("icon", true)
        self.icon:GetAnimState():OverrideSkinSymbol("SWAP_ICON", item_map[item] or item,
                                                    "SWAP_ICON")

        self.icon:GetAnimState():Hide("TINT")
        self.icon:GetAnimState():Hide("LOCK")
        self.icon:GetAnimState():Hide("NEW")
        self.icon:GetAnimState():Hide("SELECT")
        -- self.icon:GetAnimState():Hide("FOCUS")
        self.icon:GetAnimState():Hide("IC_WEAVE")
        for k, _ in pairs(EVENT_ICONS) do
            self.icon:GetAnimState():Hide(k)
        end
        self.icon:GetAnimState():Hide("DLC")

        self.icon:SetPosition(-100, 310)

        self.info_txt = self.content_root:AddChild(
                            Text(CHATFONT, 26, nil, UICOLOURS.WHITE))
        self.info_txt:SetPosition(-35, 130)
        self.info_txt:SetRegionSize(width * 0.8, 85)
        self.info_txt:SetHAlign(ANCHOR_LEFT)
        self.info_txt:SetVAlign(ANCHOR_MIDDLE)
        self.info_txt:EnableWordWrap(true)
        self.info_txt:SetString(STRINGS.SKIN_DESCRIPTIONS[item] or "UnKnow")

        self.name_txt = self.content_root:AddChild(
                            Text(CHATFONT, 30, nil, UICOLOURS.WHITE))
        self.name_txt:SetPosition(-35, 220)
        self.name_txt:SetRegionSize(width * 0.8, 85)
        self.name_txt:SetHAlign(ANCHOR_LEFT)
        self.name_txt:SetVAlign(ANCHOR_MIDDLE)
        self.name_txt:EnableWordWrap(true)
        self.name_txt:SetString(STRINGS.SKIN_NAMES[item] or "UnKnow")

        self.rarity_txt = self.content_root:AddChild(
                              Text(CHATFONT, 26, nil,
                                   {255 / 255, 215 / 255, 0 / 255, 1}))
        self.rarity_txt:SetPosition(-35, 190)
        self.rarity_txt:SetRegionSize(width * 0.8, 85)
        self.rarity_txt:SetHAlign(ANCHOR_LEFT)
        self.rarity_txt:SetVAlign(ANCHOR_MIDDLE)
        self.rarity_txt:EnableWordWrap(true)
        self.rarity_txt:SetString("总之就是非常可爱")
        -- self.anim:GetAnimState():SetMultColour(unpack(FRONTEND_PORTAL_COLOUR))

        -- self.horizontal_line = self.content_root:AddChild(
        -- Image("images/ui.xml",
        -- "line_horizontal_6.tex"))
        -- self.horizontal_line:SetScale(1, 0.55)
        -- self.horizontal_line:SetPosition(5, 96, 0)

        self.horizontal_line = self.content_root:AddChild(
                                   Image("images/global_redux.xml",
                                         "item_divider.tex"))
        self.horizontal_line:SetScale(0.5, 1)
        self.horizontal_line:SetPosition(-200, 75, 0)

        self.horizontal_line2 = self.content_root:AddChild(
                                    Image("images/global_redux.xml",
                                          "item_divider.tex"))
        self.horizontal_line2:SetScale(0.25, 1)
        self.horizontal_line2:SetPosition(-95, 170, 0)
        self.unlockdes = self.content_root:AddChild(
                             Text(CHATFONT, 26, nil,
                                  {255 / 255, 215 / 255, 0 / 255, 1}))
        self.unlockdes:SetPosition(-235, 50)
        self.unlockdes:SetRegionSize(width * 0.8, 85)
        self.unlockdes:SetHAlign(ANCHOR_LEFT)
        self.unlockdes:SetVAlign(ANCHOR_MIDDLE)
        self.unlockdes:EnableWordWrap(true)
        self.unlockdes:SetString("解锁方式:")

        self.unlocktext = self.content_root:AddChild(
                              Text(CHATFONT, 26, nil,
                                   {255 / 255, 215 / 255, 0 / 255, 1}))
        self.unlocktext:SetPosition(-165, 50)
        self.unlocktext:SetRegionSize(width * 0.8, 85)
        self.unlocktext:SetHAlign(ANCHOR_LEFT)
        self.unlocktext:SetVAlign(ANCHOR_MIDDLE)
        self.unlocktext:EnableWordWrap(true)
        self.unlocktext:SetString("")

        self.default_focus = self.dialog
    end)

    function UnLockScreen:OnControl(control, down)
        if UnLockScreen._base.OnControl(self, control, down) then
            return true
        end
        if control == CONTROL_CANCEL and not down then
            self.buttons[#self.buttons].cb()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
            return true
        end
    end

    function UnLockScreen:Close() TheFrontEnd:PopScreen(self) end
    -- GameTimeUnLockScreen = Class(UnLockScreen, function(self, item, cb)
        -- UnLockScreen._ctor(self, item, cb)
        -- local pro = gametimes / 300 

        -- self.characterprogress = self.content_root:AddChild(Text(HEADERFONT, 40, nil, {255 / 255, 215 / 255, 0 / 255, 1}))
        -- self.characterprogress:SetPosition(-200, 10)
        -- pro=math.min(math.max(0,pro),1)
        -- self.characterprogress:SetString(string.format("当前进度: %0.1f%%",pro*100))
        
        -- self.cb = function(s,i)
            -- if gametimes > 300 then
                -- local a = TaiZhenPushPopupDialog("太真的温馨提示","正在激活中,请稍后查看结果")
                -- SkinApi('c/ActiveSkin', {skin = 'sora_gete'},
                        -- function(code, msg, data)
                        -- TheFrontEnd:PopScreen(a)
                    -- if code == 5021 then
                        -- SkinRPC('GetSkins',true)
                        -- GetSkins(selfid)
                        -- TheFrontEnd:PushScreen(
                            -- ThankYouPopup(
                                -- {
                                    -- {
                                        -- item = "sora_gete",
                                        -- item_id = 0,
                                        -- gifttype = "SORASKIN"
                                    -- }
                                -- }))
                    -- elseif code == 5020 then
                        -- TaiZhenPushPopupDialog('太真的温馨提示',"你已经拥有了[穹妹-哥特萝莉],不需要重复激活")
                        -- SkinRPC('GetSkins')
                        -- GetSkins(selfid)
                    -- elseif code == -5022 then
                        -- TaiZhenPushPopupDialog('太真的温馨提示',"时间计算出错,请半小时后再试")
                    -- else
                        -- TaiZhenPushPopupDialog('太真的温馨提示',"皮肤激活失败,错误代码:"..code..info)
                    -- end
                -- end)
                
                -- return
            -- else
                -- TaiZhenPushPopupDialog("太真的温馨提示","在线时长不足50小时\n激活失败\n如果时长不对 请过半小时再试")
            -- end
        -- end
    -- end)
    local cdkcd = TaizhenCD(10)
    local function TaiZhenUseSkinCDK(cdk,cb)
        if not cdkcd() then
            TaiZhenPushPopupDialog('太真的温馨提示',"CDK使用过于频繁 请稍后再试")
            return
        end
        UseSkinCDK(cdk,function(code,msg,data)
                    --TheFrontEnd:PopScreen(a)
                    if (code == -6001 or code == -6002 or code == -6003) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"卡密不正确 请重新输入")
                    elseif (code == -6004 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"这张卡密已经被你使用过了")
                    elseif (code == -6005 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"这张卡密已经被别人使用过了")
                    elseif (code == -6103 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"绑定码不正确")
                    elseif (code == -6104 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"绑定码已经被绑定了")
                    elseif (code == -6105 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"你已经绑定成功")
                    elseif (code == -6106 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"你已经绑定过其他的绑定码了")
                    elseif (code == -2 ) then
                        info = "code="..msg.."\n{"..data.."}"
                        
                        TaiZhenPushPopupDialog('太真的温馨提示',"服务器链接失败,请稍后再试"..info)
                    elseif (code == -3 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"服务器内部出错,请稍后再试")
                    elseif (code < 0 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"卡密使用失败,请联系作者 code:"..code) 
                    elseif (code == 6021 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"你已经拥有了["..data.skinname.."],不需要重复激活")
                        SkinRPC('GetSkins')
                        GetSkins(selfid)
                    elseif (code == 6103 ) then
                        TaiZhenPushPopupDialog('太真的温馨提示',"绑定成功,QQ:"..data.qq)
                    elseif (code == 6001 ) then
                        SkinRPC('GetSkins',true)
                        GetSkins(selfid)
                        TheFrontEnd:PopScreen(self)
                        local thanks = ThankYouPopup(
                                {
                                    {
                                        item = data.skinprefab,
                                        item_id = 0,
                                        gifttype = "TZSKIN"
                                    }
                                })
                        TheFrontEnd:PushScreen(thanks)
                        if ThanksImg[data.skinprefab] then
                        thanks.oldOpenGift = thanks.OpenGift
                        thanks.OpenGift = function(s,...)  local r = s.oldOpenGift(s,...) s.spawn_portal:GetAnimState():OverrideSkinSymbol("SWAP_ICON", softresolvefilepath(ThanksImg[data.skinprefab].xml),ThanksImg[data.skinprefab].tex)  return r end
                        end
                        
                    else
                        TaiZhenPushPopupDialog('太真的温馨提示',"皮肤激活失败,错误代码:"..code)
                    end
                    if cb then cb(code,msg,data) end
                end)
    
    end
    GLOBAL.TaiZhenUseSkinCDK = TaiZhenUseSkinCDK
    CdkUnLockScreen = Class(UnLockScreen, function(self, item, cb)
        UnLockScreen._ctor(self, item, cb)
        self.cdkbox = self.content_root:AddChild(TEMPLATES.StandardSingleLineTextEntry(nil, 360, 40))
        
        self.cdkbox:SetPosition(-200,0)
        self.cdkbox.textbox:SetTextLengthLimit(23)
        self.cdkbox.textbox:SetForceEdit(true)
        self.cdkbox.textbox:EnableWordWrap(false)
        self.cdkbox.textbox:EnableScrollEditWindow(true)
        self.cdkbox.textbox:SetHelpTextEdit("")
        self.cdkbox.textbox:SetHelpTextApply('请输入CDK')
        self.cdkbox.textbox:SetTextPrompt('请输入CDK', UICOLOURS.GREY)
        self.cdkbox.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)
        self.cdkbox.textbox:SetCharacterFilter("-0123456789QWERTYUPASDFGHJKLZXCVBNMqwertyupasdfghjklzxcvbnm")
        self.cdkbox:SetOnGainFocus( function() self.cdkbox.textbox:OnGainFocus() end )
        self.cdkbox:SetOnLoseFocus( function() self.cdkbox.textbox:OnLoseFocus() end )
       
        self.cdkbox.focus_forward = self.cdkbox.textbox
        self.cb = function(s,i)
            local cdk = self.cdkbox.textbox:GetString()
            if cdk then
                cdk = cdk:upper()
                if not (cdk:match('^[SB][0-9A-Z\-]+$') and cdk:utf8len() == 23) then
                    TaiZhenPushPopupDialog("太真的温馨提示","请输入正确的卡密")
                    return
                end
                --local a = TaiZhenPushPopupDialog("太真的温馨提示","正在激活中,请稍后查看结果")
                TaiZhenUseSkinCDK(cdk)
                return
            else
                TaiZhenPushPopupDialog("太真的温馨提示","请输入卡密")
            end
        end
       --self.cdkinput = self.content_root:AddChild(
       --                     Text(CHATFONT, 26, nil,
       --                          {255 / 255, 215 / 255, 0 / 255, 1}))
    end)
end




-- 获取n秒后的时间
local function GetSecondAfter(n)
    local t = os.clock() + n
    while os.clock() < t do end
    return os.clock()
end
GetSecondAfter(3)

