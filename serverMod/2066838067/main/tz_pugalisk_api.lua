--注册动作
AddAction("TZ_PYTHON_SUMMON","TZ_PYTHON_SUMMON",function(act) 
    if act.target.components.tz_python_summon_rocket then
        act.target.components.tz_python_summon_rocket:Launch()
        return true 
    end
end) 
ACTIONS.TZ_PYTHON_SUMMON.priority = 99
ACTIONS.TZ_PYTHON_SUMMON.rmb = true


AddComponentAction("SCENE", "tz_python_summon_rocket", function(inst, doer, actions, right) 
    if right and doer:HasTag("player") and inst:HasTag("tz_python_summon_rocket") then 
        table.insert(actions, ACTIONS.TZ_PYTHON_SUMMON)
    end 
end)

STRINGS.ACTIONS.TZ_PYTHON_SUMMON = "发送和平心愿"

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.TZ_PYTHON_SUMMON,"give"))

AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.TZ_PYTHON_SUMMON,"give"))

AddStategraphState("wilson",
    State{
        name = "tz_pugalisk_curse_sealed",
        tags = { "busy", "nomorph", "nopredict", "nointerrupt"},

        onenter = function(inst)
            inst:ClearBufferedAction()
            inst.Physics:Stop()

            inst.AnimState:SetPercent("hit",0.2)
            
            -- inst.sg.statemem.sealfx = inst:SpawnChild("tz_pugalisk_cursed_mark_seal_fx")
        end,

        onexit = function(inst)
            -- if inst.sg.statemem.sealfx and inst.sg.statemem.sealfx:IsValid() then
            --     inst.sg.statemem.sealfx:Remove()
            -- end
            SpawnAt("collapse_small",inst)
            if inst.components.debuffable:HasDebuff("tz_pugalisk_cursed_mark_debuff") then
                inst.components.debuffable:RemoveDebuff("tz_pugalisk_cursed_mark_debuff")
            end
        end,
    }
)


TUNING.TZ_PUGALISK_CONFIG = {
    HEALTH = 5000000,
    ATTACK_DAMAGE = 700,
    BODY_ABSORB_DAMAGE_MAX = 2000000,
    HEAD_DAMAGE_TAKEN_MULT = 0.6,
    MOVING_DAMAGE_TAKEN_MULT = 0.05,

    -- Skill:Sound attack
    SOUND_DAMAGE = 700,
    SOUND_WEAK_DURATION = 20,
    SOUND_WEAK_DAMAGE_TAKEN_MULT = 2.0,
    SOUND_CAST_RANGE_MIN = 0.1,
    SOUND_CAST_RANGE_MAX = 16,
    SOUND_CD = 25,
    SOUND_LOW_HEALTH_PERCENT = 0.3,
    SOUND_CD_LOW_HEALTH = 15,

    -- Skill:Roar
    ROAR_TARGET_RANGE = 8,
    ROAR_RANGE = 12,
    ROAR_DAMAGE = 105,
    ROAR_COUNT = 5,
    ROAR_PERIOD = 0.2,
    ROAR_CD = 20,

    -- Skill:Summon meteor
    METEOR_CAST_DURATION = 12,
    METEOR_TARGET_RANGE = 24,
    METEOR_SMALL_PERIOD = 0.5,
    METEOR_SMALL_DAMAGE = 350,
    METEOR_SMALL_ABORT_DAMAGE = 20000,
    METEOR_LOW_HEALTH_PERCENT = 0.3,
    METEOR_BIG_PERIOD = 1,
    -- METEOR_BIG_DAMAGE = 50,
    METEOR_BIG_ABORT_DAMAGE = 100000,
    METEOR_REMAIN_HEALTH = 5000,
    METEOR_FIRE_DEBUFF_DURATION = 15,
    METEOR_CD = 115,


    -- Random lightning
    RANDOM_LIGHTNING_PERIOD = 7.5,
    RANDOM_LIGHTNING_RANGE = 30,
    RANDOM_LIGHTNING_DAMAGE = 350,

    -- Lightning target player
    PLAYER_LIGHTNING_PERIOD = 4.5,
    PLAYER_LIGHTNING_RANGE = 20,
    PLAYER_LIGHTNING_DAMAGE = 350,

    -- Spawn pit
    PIT_HIT_RANGE = 4.8,
    PIT_DAMAGE = 350,
    PIT_FADEOUT_TIME = 120,

    -- Curse mark on players nearby
    CURSE_MARK_PERIOD = 180,
    -- CURSE_MARK_PERIOD = 10, --Test 
    CURSE_MARK_RANGE = 36,
    CURSE_MARK_SG_DURATION = 480,
    CURSE_MARK_SG_HIT_BREAK_CNT = 10,
    CURSE_MARK_AGAIN_TIME = 3,

    RECOVER_AFTER_HUGE_DAMAGE_CD = 10,
    RECOVER_AFTER_HUGE_DAMAGE_THRESHOLD = 50000,


    SUMMON_FALLEN_TIME = TUNING.TOTAL_DAY_TIME,
    SUMMON_FALLEN_HIT_COUNT = 4,
}



AddRecipe2(
    "tz_python_summon_rocket",
    {
        Ingredient("atrium_key", 1),
    },
    TECH.MAGIC_THREE,				
    {
        builder_tag = "tz_builder",
		image = "tz_python_summon_rocket.tex",
		atlas = "images/inventoryimages/tz_python_summon_rocket.xml",
    },
    {"CHARACTER","MAGIC","TOOLS"}
)
