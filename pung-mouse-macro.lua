--[[PUBG LEANSPAM SCRIPT 1.0]]--
 
--[[MASTER SCRIPT ENABLE/DISABLE SETTING]]--

--[[MOUSE SETTINGS 600 DPI]]--

--[[PUBG SETTINGS]]--
-- SCOPE SENSITIVITIES 0x = 60, 2x = 60, 3x = 53, 4x = 63, 6x = 70 --

--------------------------------------------------------------------------------------------------------------
 
local st_k="capslock" --TURN ON/OFF SCRIPT.
local softLock=true -- SOFT TURN ON/OFF SCRIPT.
local current_weapon = "m416";
local recoil_table = {}
local hold_breath = "SHIFT"

recoil_table["m416"] = {
  n_r = 5,
  step_1 = 10,
  step_1_incr = 3,
  step_2 = 40,
  step_2_incr = 2,
  step_3 = 100,
  hold_breath_r = 3
}

recoil_table["beryl"] = {
  n_r = 8,
  step_1 = 15,
  step_1_incr = 4,
  step_2 = 40,
  step_2_incr = 2,
  step_3 = 100,
  hold_breath_r = 3
}

recoil_table["m16a4"] = {
  n_r = 12,
  step_1 = 2,
  step_1_incr = 1,
  step_2 = 4,
  step_2_incr = 1,
  step_3 = 9,
  hold_breath_r = 3
}

--[[NO RECOIL SETTINGS]]--
--------------------------------------------------------------------------------------------------------------
 
local n_r=5 --HOW MANY PIXELS THE MOUSE IS MOVED DOWN DEFAULT: 5
local nr_s=20 --INTERVAL BETWEEN MOUSE MOVEMENTS DEFAULT: 40
local nr_p=0 --DELAY BEFORE STARTING MOUSE MOVEMENTS EACH TIME DEFAULT: 0
 
--[[LEAN-SPAM SETTINGS]]--
--------------------------------------------------------------------------------------------------------------
 
local lt_k="scrolllock" --KEY TO TURN ON/OFF LEANSPAM WHILE LEFT CLICKING
local ll_k="Q" --LEFT PEEK KEY SETTING DEFAULT: "Q"
local rl_k="E" --RIGHT PEEK KEY SETTING DEFAULT "E"
local m_l=3 --FINE TUNE SETTING FOR LEAN TIME - LOWER NUMBER = FASTER LEANING (MUST BE ODD NUMBER TO WORK PROPERLY) DEFAULT: 3
 
 
--[[DON'T MODIFY THESE SETTINGS]]--
--------------------------------------------------------------------------------------------------------------
 
local l_s=nr_s*(m_l//2)
local l_st=1
local o_r
local ls_s
local l_k
 
--[[FUNCTIONS]]--
--------------------------------------------------------------------------------------------------------------
 
function lean_spam()
    if l_k == ll_k then
        l_k=rl_k
    else
        l_k=ll_k
    end
    PressKey(l_k)
    Sleep(l_s)
    ReleaseKey(l_k)
    no_recoil=l_s//m_l
end
 
function leandir()
    if ls_s then
        if (l_k == ll_k) then
            return (l_st)
        else
            return -(l_st)
        end
    else
        return 0
    end
end
 
function norecoil()
    Sleep(nr_p)
    local it = 0
    local local_N_R = recoil_table[current_weapon]["n_r"]
    repeat
        o_r=n_r
        if ls_s then
            if (l_st > m_l) then
                 lean_spam()
                 l_st=0
            else
                l_st=l_st+1
            end
        end
        n_r=o_r
    if (IsModifierPressed(hold_breath)) then
      MoveMouseRelative(leandir(),local_N_R)
    else
      MoveMouseRelative(leandir(),local_N_R)
    end
    
    OutputLogMessage("%d\n", local_N_R)
    OutputLogMessage("%s\n", current_weapon)
    if (it == recoil_table[current_weapon]["step_1"]) then local_N_R = local_N_R + recoil_table[current_weapon]["step_1_incr"] end
    if (it == recoil_table[current_weapon]["step_2"]) then local_N_R = local_N_R + recoil_table[current_weapon]["step_2_incr"] end
    if (it == recoil_table[current_weapon]["step_3"]) then local_N_R = 0 end
    Sleep(nr_s)
    it = it + 1
    until not IsMouseButtonPressed(1)
end
 
--[[MAIN ONEVENT FOR SCRIPT FUNCTIONALITY]]--
--------------------------------------------------------------------------------------------------------------
 
function OnEvent(event, arg)
    OutputLogMessage("%d\n", arg)
    if (arg == 6) then
        softLock=false
        current_weapon="none"
    end
    if (arg == 4) then
      softLock=true
      current_weapon = "m416"
    end
    if (arg == 5) then
      softLock=true
      current_weapon = "beryl"
    end
    if (arg == 3) then
      softLock=true
      current_weapon = "m16a4"
    end
    
    

    if not IsKeyLockOn(st_k) then
        EnablePrimaryMouseButtonEvents(false)
    else
        EnablePrimaryMouseButtonEvents(true)
    end
    if IsKeyLockOn(lt_k) then
        ls_s=true
    else
        ls_s=false
    end
    if (softLock and IsMouseButtonPressed(1) and IsKeyLockOn(st_k)) then
        norecoil()
    end
end
