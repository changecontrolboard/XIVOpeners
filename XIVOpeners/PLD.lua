xivopeners_pld = {}

xivopeners_pld.debug = false

xivopeners_pld.supportedLevel = 80
xivopeners_pld.openerAbilities = {
    ShieldLob = ActionList:Get(1, 24),
    FastBlade = ActionList:Get(1, 9),
    RiotBlade = ActionList:Get(1, 15),
    GoringBlade = ActionList:Get(1, 3538),
    RoyalAuthority = ActionList:Get(1, 3539),
    CircleofScorn = ActionList:Get(1, 23),
    Intervene = ActionList:Get(1, 16461),
    Atonement = ActionList:Get(1, 16460),
    SpiritsWithin = ActionList:Get(1, 29),
    Requiescat = ActionList:Get(1, 7383),
    HolySpirit = ActionList:Get(1, 7384),
    Confiteor = ActionList:Get(1, 16459),
    FightorFlight = ActionList:Get(1, 20),
    -- Potion = 
}

xivopeners_pld.openerInfo = {
    listOpeners = {"Recommended", "Compatibility"},
    currentOpenerIndex = 1,
}

xivopeners_pld.openers = {
    recommended = {
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.FastBlade,
        xivopeners_pld.openerAbilities.FightorFlight,
        xivopeners_pld.openerAbilities.RiotBlade,
        xivopeners_pld.openerAbilities.GoringBlade, 
        xivopeners_pld.openerAbilities.FastBlade, 
        xivopeners_pld.openerAbilities.RiotBlade,
        -- xivopeners_pld.openerAbilities.Potion, 
        xivopeners_pld.openerAbilities.RoyalAuthority, 
        xivopeners_pld.openerAbilities.CircleofScorn,
        xivopeners_pld.openerAbilities.Intervene,
        xivopeners_pld.openerAbilities.Atonement,
        xivopeners_pld.openerAbilities.SpiritsWithin,
        xivopeners_pld.openerAbilities.Intervene, 
        xivopeners_pld.openerAbilities.Atonement,
        xivopeners_pld.openerAbilities.Atonement,
        xivopeners_pld.openerAbilities.FastBlade,
        xivopeners_pld.openerAbilities.RiotBlade,
        xivopeners_pld.openerAbilities.GoringBlade, 
        xivopeners_pld.openerAbilities.Requiescat,
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.CircleofScorn, 
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.Confiteor,
        xivopeners_pld.openerAbilities.FastBlade,
        xivopeners_pld.openerAbilities.RiotBlade,
        xivopeners_pld.openerAbilities.SpiritsWithin, 
        xivopeners_pld.openerAbilities.GoringBlade
    },

    compatibility = {
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.FastBlade,
        xivopeners_pld.openerAbilities.FightorFlight,
        xivopeners_pld.openerAbilities.RiotBlade,
        xivopeners_pld.openerAbilities.GoringBlade, 
        xivopeners_pld.openerAbilities.FastBlade, 
        xivopeners_pld.openerAbilities.RiotBlade,
        -- xivopeners_pld.openerAbilities.Potion, 
        xivopeners_pld.openerAbilities.RoyalAuthority, 
        xivopeners_pld.openerAbilities.CircleofScorn,
        xivopeners_pld.openerAbilities.Intervene,
        xivopeners_pld.openerAbilities.Atonement,
        xivopeners_pld.openerAbilities.SpiritsWithin,
        xivopeners_pld.openerAbilities.Intervene, 
        xivopeners_pld.openerAbilities.Atonement,
        xivopeners_pld.openerAbilities.Atonement,
        xivopeners_pld.openerAbilities.FastBlade,
        xivopeners_pld.openerAbilities.RiotBlade,
        xivopeners_pld.openerAbilities.GoringBlade, 
        xivopeners_pld.openerAbilities.Requiescat,
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.CircleofScorn, 
        xivopeners_pld.openerAbilities.HolySpirit,
        xivopeners_pld.openerAbilities.Confiteor,
        xivopeners_pld.openerAbilities.FastBlade,
        xivopeners_pld.openerAbilities.RiotBlade,
        xivopeners_pld.openerAbilities.SpiritsWithin, 
        xivopeners_pld.openerAbilities.GoringBlade
    },
}

xivopeners_pld.abilityQueue = {}
xivopeners_pld.lastCastFromQueue = nil -- might need this for some more complex openers with conditions
xivopeners_pld.openerStarted = false
xivopeners_pld.lastcastid = 0
xivopeners_pld.lastcastid2 = 0

function xivopeners_pld.getOpener()
    if (xivopeners_pld.openerInfo.currentOpenerIndex == 1) then
        return xivopeners_pld.openers.recommended
    else
        return xivopeners_pld.openers.compatibility
    end
end

function xivopeners_pld.checkOpenerIds()
    for key, action in pairs(xivopeners_pld.getOpener()) do
        if (action == nil) then
            xivopeners.log("WARNING: Action at index " .. tostring(key) .. " was nil! The id is likely incorrect.")
        end
    end
end

function xivopeners_pld.openerAvailable()
    -- check cooldowns
    for _, action in pairs(xivopeners_pld.getOpener()) do
        if (action.cd >= 1.5) then return false end
    end
    return true
end

function xivopeners_pld.queueOpener()
    -- the only time this gets called is when the main script is toggled, so we can do more than just queue the opener
    -- empty queue first
    xivopeners_pld.abilityQueue = {}
    for _, action in pairs(xivopeners_pld.getOpener()) do
        xivopeners_pld.enqueue(action)
    end
    --    xivopeners.log("queue:")
    --    for _, v in pairs(xivopeners_pld.abilityQueue) do
    --        xivopeners.log(v.name)
    --    end
    xivopeners_pld.lastCastFromQueue = nil
    xivopeners_pld.openerStarted = false
end

function xivopeners_pld.updateLastCast()
--    xivopeners.log(tostring(xivopeners_pld.lastcastid) .. ", " .. tostring(xivopeners_pld.lastcastid2) .. ", " .. tostring(Player.castinginfo.lastcastid))
    if (xivopeners_pld.lastcastid == -1) then
        -- compare the real castid and see if it changed, if it did, update from -1
        if (xivopeners_pld.lastcastid2 ~= Player.castinginfo.castingid and Player.castinginfo.castingid ~= xivopeners_pld.openerAbilities.PitchPerfect.id) then
            xivopeners.log("cast changed")
            xivopeners_pld.lastcastid = Player.castinginfo.castingid
            xivopeners_pld.lastcastid2 = Player.castinginfo.castingid
        end
    elseif (xivopeners_pld.lastcastid ~= Player.castinginfo.castingid) then
        xivopeners_pld.lastcastid = Player.castinginfo.castingid
        xivopeners_pld.lastcastid2 = Player.castinginfo.castingid
    end
end

function xivopeners_pld.drawCall(event, tickcount)
    if (xivopeners_pld.debug) then
        GUI:Text("lastcastid")
        GUI:NextColumn()
        GUI:InputText("##xivopeners_pld_lastcastid_display", tostring(xivopeners_pld.lastcastid))

        GUI:NextColumn()
        GUI:Text("lastcastid2")
        GUI:NextColumn()
        GUI:InputText("##xivopeners_pld_lastcastid2_display", tostring(xivopeners_pld.lastcastid2))

        GUI:NextColumn()
        GUI:Text("lastcastid_o")
        GUI:NextColumn()
        GUI:InputText("##xivopeners_pld_lastcastid_original_display", tostring(Player.castinginfo.lastcastid))

        GUI:NextColumn()
        GUI:Text("castingid")
        GUI:NextColumn()
        GUI:InputText("##xivopeners_pld_castingid", tostring(Player.castinginfo.castingid))

        if (xivopeners_pld.abilityQueue[1]) then
            GUI:NextColumn()
            GUI:Text("queue[1]")
            GUI:NextColumn()
            GUI:InputText("##xivopeners_pld_queue[1]", xivopeners_pld.abilityQueue[1].name)
        end

        if (xivopeners_pld.lastCastFromQueue) then
            GUI:NextColumn()
            GUI:Text("lastCastFromQueue")
            GUI:NextColumn()
            GUI:InputText("##xivopeners_pld_lastcastfromqueue", xivopeners_pld.lastCastFromQueue.name)
        end
    end
end

function xivopeners_pld.main(event, tickcount)
    if (Player.level >= xivopeners_pld.supportedLevel) then
        local target = Player:GetTarget()
        if (not target) then return end

        if (not xivopeners_pld.openerAvailable() and not xivopeners_pld.openerStarted) then return end -- don't start opener if it's not available, if it's already started then yolo

        if (xivopeners_pld.openerStarted and next(xivopeners_pld.abilityQueue) == nil) then
            -- opener is finished, pass control to ACR
            xivopeners.log("Finished openers, handing control to ACR")
            xivopeners_pld.openerStarted = false
            if (xivopeners.running) then xivopeners.ToggleRun() end
            if (not FFXIV_Common_BotRunning) then
                ml_global_information.ToggleRun()
            end
            return
        end

        if (ActionList:IsCasting()) then return end

        xivopeners_pld.updateLastCast()

        if (not xivopeners_pld.openerStarted) then
            -- technically, even if you use an ability from prepull, it should still work, since the next time this loop runs it'll jump to the elseif
            xivopeners.log("Starting opener")
            xivopeners_pld.openerStarted = true
            xivopeners_pld.useNextAction(target)
        elseif (xivopeners_pld.lastCastFromQueue and xivopeners_pld.lastcastid == xivopeners_pld.lastCastFromQueue.id) then
            xivopeners_pld.lastcastid = -1
            if (xivopeners_pld.lastCastFromQueue ~= xivopeners_pld.openerAbilities.PitchPerfect) then
                xivopeners_pld.dequeue()
            end
            xivopeners_pld.useNextAction(target)
        else
            xivopeners_pld.useNextAction(target)
        end

    end
end

function xivopeners_pld.enqueueNext(action)
    table.insert(xivopeners_pld.abilityQueue, 1, action)
end

function xivopeners_pld.enqueue(action)
    -- implementation of the queue can be changed later
    table.insert(xivopeners_pld.abilityQueue, action)
end

function xivopeners_pld.dequeue()
    xivopeners.log("Dequeing " .. xivopeners_pld.abilityQueue[1].name)
    table.remove(xivopeners_pld.abilityQueue, 1)
end

function xivopeners_pld.useNextAction(target)
    -- do the actual opener
    -- the current implementation uses a queue system
    if (target and target.attackable and xivopeners_pld.abilityQueue[1]) then
        -- idk how to make it not spam console
        if (xivopeners_pld.abilityQueue[1] == xivopeners_pld.openerAbilities.RagingStrikes and HasBuff(Player.id, xivopeners_pld.openerAbilities.RagingStrikesBuffID)) then
            xivopeners.log("Player already used raging strikes prepull, continue with opener")
--            xivopeners_pld.lastCastFromQueue = xivopeners_pld.openerAbilities.RagingStrikes
            xivopeners_pld.dequeue()
            return
        end
        if (Player.gauge[2] >= 3 and xivopeners_pld.abilityQueue[1] ~= xivopeners_pld.openerAbilities.PitchPerfect) then
            -- don't want to dequeue here
            xivopeners.log("Using PP3 proc")
            xivopeners_pld.openerAbilities.PitchPerfect:Cast(target.id)
--            xivopeners_pld.lastCastFromQueue = xivopeners_pld.openerAbilities.PitchPerfect
            return
        end
        if (xivopeners_pld.abilityQueue[1] == xivopeners_pld.openerAbilities.BurstShot and HasBuff(Player.id, xivopeners_pld.openerAbilities.StraightShotReadyBuffID)) then
            xivopeners.log("Using RA proc during BurstShot window")
            xivopeners_pld.openerAbilities.RefulgentArrow:Cast(target.id)
            xivopeners_pld.lastCastFromQueue = xivopeners_pld.openerAbilities.RefulgentArrow
            return
        end
--        xivopeners.log("Casting " .. xivopeners_pld.abilityQueue[1].name)
        xivopeners_pld.abilityQueue[1]:Cast(target.id)
--        if (Player.castinginfo.castingid == xivopeners_pld.abilityQueue[1].id) then
            xivopeners_pld.lastCastFromQueue = xivopeners_pld.abilityQueue[1]
--        end
    end
end