xivopeners_gnb = {}

xivopeners_gnb.supportedLevel = 80
xivopeners_gnb.openerAbilities = {
    KeenEdge = ActionList:Get(1, 16137),
    BrutalShell = ActionList:Get(1, 16139),
    BurstStrike = ActionList:Get(1, 16162),
    SolidBarrel = ActionList:Get(1, 16145),
    GnashingFang = ActionList:Get(1, 16146),
    JugularRip = ActionList:Get(1, 16156),
    BowShock = ActionList:Get(1, 16159),
    SonicBreak = ActionList:Get(1, 16153),
    RoughDivide = ActionList:Get(1, 16154),
    BlastingZone = ActionList:Get(1, 16165),
    SavageClaw = ActionList:Get(1, 16147),
    AbdomenTear = ActionList:Get(1, 16157),
    WickedTalon = ActionList:Get(1, 16150),
    Bloodfest = ActionList:Get(1, 16164),
    NoMercy = ActionList:Get(1, 16138)
}



xivopeners_gnb.openerInfo = {
    listOpeners = {"Early WF", "Late WF"},
    currentOpenerIndex = 1,
}

xivopeners_gnb.openers = {
    earlyWF = {
        xivopeners_gnb.openerAbilities.KeenEdge,
        --ivopeners_gnb.openerAbilities.Potion,
        xivopeners_gnb.openerAbilities.BrutalShell,
        xivopeners_gnb.openerAbilities.Bloodfest,
        xivopeners_gnb.openerAbilities.NoMercy,
        xivopeners_gnb.openerAbilities.BurstStrike,
        xivopeners_gnb.openerAbilities.SolidBarrel,
        xivopeners_gnb.openerAbilities.KeenEdge,
        xivopeners_gnb.openerAbilities.GnashingFang,
        xivopeners_gnb.openerAbilities.JugularRip,
        xivopeners_gnb.openerAbilities.BowShock,
        xivopeners_gnb.openerAbilities.SonicBreak,
        xivopeners_gnb.openerAbilities.RoughDivide,
        xivopeners_gnb.openerAbilities.BlastingZone,
        xivopeners_gnb.openerAbilities.SavageClaw,
        xivopeners_gnb.openerAbilities.AbdomenTear,
        xivopeners_gnb.openerAbilities.RoughDivide,
        xivopeners_gnb.openerAbilities.WickedTalon,
        xivopeners_gnb.openerAbilities.EyeGouge,
        xivopeners_gnb.openerAbilities.BurstStrike,
        xivopeners_gnb.openerAbilities.BrutalShell,
        xivopeners_gnb.openerAbilities.SolidBarrel,
        xivopeners_gnb.openerAbilities.BurstStrike,
        xivopeners_gnb.openerAbilities.KeenEdge,
        xivopeners_gnb.openerAbilities.BrutalShell,
        xivopeners_gnb.openerAbilities.SolidBarrel
    },

    lateWF = {
        xivopeners_gnb.openerAbilities.KeenEdge,
        --ivopeners_gnb.openerAbilities.Potion,
        xivopeners_gnb.openerAbilities.BrutalShell,
        xivopeners_gnb.openerAbilities.Bloodfest,
        xivopeners_gnb.openerAbilities.NoMercy,
        xivopeners_gnb.openerAbilities.BurstStrike,
        xivopeners_gnb.openerAbilities.SolidBarrel,
        xivopeners_gnb.openerAbilities.KeenEdge,
        xivopeners_gnb.openerAbilities.GnashingFang,
        xivopeners_gnb.openerAbilities.JugularRip,
        xivopeners_gnb.openerAbilities.BowShock,
        xivopeners_gnb.openerAbilities.SonicBreak,
        xivopeners_gnb.openerAbilities.RoughDivide,
        xivopeners_gnb.openerAbilities.BlastingZone,
        xivopeners_gnb.openerAbilities.SavageClaw,
        xivopeners_gnb.openerAbilities.AbdomenTear,
        xivopeners_gnb.openerAbilities.RoughDivide,
        xivopeners_gnb.openerAbilities.WickedTalon,
        xivopeners_gnb.openerAbilities.EyeGouge,
        xivopeners_gnb.openerAbilities.BurstStrike,
        xivopeners_gnb.openerAbilities.BrutalShell,
        xivopeners_gnb.openerAbilities.SolidBarrel,
        xivopeners_gnb.openerAbilities.BurstStrike,
        xivopeners_gnb.openerAbilities.KeenEdge,
        xivopeners_gnb.openerAbilities.BrutalShell,
        xivopeners_gnb.openerAbilities.SolidBarrel
    },
}

xivopeners_gnb.abilityQueue = {}
xivopeners_gnb.lastCastFromQueue = nil -- might need this for some more complex openers with conditions
xivopeners_gnb.openerStarted = false


function xivopeners_gnb.getOpener()
    local opener
    if (xivopeners_gnb.openerInfo.currentOpenerIndex == 1) then
        opener = xivopeners_gnb.openers.earlyWF
    else
        opener = xivopeners_gnb.openers.lateWF
    end
    return opener
end

function xivopeners_gnb.checkOpenerIds()
    for key, action in pairs(xivopeners_gnb.getOpener()) do
        if (action == nil) then
            xivopeners.log("WARNING: Action at index " .. tostring(key) .. " was nil! The id is likely incorrect.")
        end
    end
end

function xivopeners_gnb.openerAvailable()
    -- check cooldowns
    for _, action in pairs(xivopeners_gnb.getOpener()) do
        if (action.cd >= 1.5) then return false end
    end
    return true
end

function xivopeners_gnb.drawCall(event, tickcount)
end

function xivopeners_gnb.main(event, tickcount)
    if (Player.level >= xivopeners_gnb.supportedLevel) then
        local target = Player:GetTarget()
        if (not target) then return end

        if (not xivopeners_gnb.openerAvailable() and not xivopeners_gnb.openerStarted) then return end -- don't start opener if it's not available, if it's already started then yolo

        if (xivopeners_gnb.openerStarted and next(xivopeners_gnb.abilityQueue) == nil) then
            -- opener is finished, pass control to ACR
            xivopeners.log("Finished openers, handing control to ACR")
            xivopeners_gnb.openerStarted = false
            if (xivopeners.running) then xivopeners.ToggleRun() end
            if (not FFXIV_Common_BotRunning) then
                ml_global_information.ToggleRun()
            end
            return
        end

        if (ActionList:IsCasting()) then return end

        if (not xivopeners_gnb.openerStarted) then
            -- technically, even if you use an ability from prepull, it should still work, since the next time this loop runs it'll jump to the elseif
            xivopeners.log("Starting opener")
            xivopeners_gnb.openerStarted = true
            xivopeners_gnb.useNextAction(target)
        elseif (xivopeners_gnb.lastCastFromQueue and Player.castinginfo.lastcastid == xivopeners_gnb.lastCastFromQueue.id) then
            xivopeners_gnb.dequeue()
            xivopeners_gnb.useNextAction(target)
        else
            xivopeners_gnb.useNextAction(target)
        end

    end
end

function xivopeners_gnb.queueOpener()
    -- the only time this gets called is when the main script is toggled, so we can do more than just queue the opener
    -- empty queue first
    xivopeners_gnb.abilityQueue = {}
    for _, action in pairs(xivopeners_gnb.getOpener()) do
        xivopeners_gnb.enqueue(action)
    end
--    xivopeners.log("queue:")
--    for _, v in pairs(xivopeners_gnb.abilityQueue) do
--        xivopeners.log(v.name)
--    end
    xivopeners_gnb.lastCastFromQueue = nil
    xivopeners_gnb.openerStarted = false
end

function xivopeners_gnb.enqueue(action)
    -- implementation of the queue can be changed later
    table.insert(xivopeners_gnb.abilityQueue, action)
end

function xivopeners_gnb.dequeue()
    table.remove(xivopeners_gnb.abilityQueue, 1)
end

function xivopeners_gnb.useNextAction(target)
    -- do the actual opener
    -- the current implementation uses a queue system
    if (target and target.attackable and xivopeners_gnb.abilityQueue[1]) then
        -- idk how to make it not spam console
        --xivopeners.log("Casting " .. xivopeners_gnb.abilityQueue[1].name)
        xivopeners_gnb.abilityQueue[1]:Cast(target.id)
        xivopeners_gnb.lastCastFromQueue = xivopeners_gnb.abilityQueue[1]
    end
end