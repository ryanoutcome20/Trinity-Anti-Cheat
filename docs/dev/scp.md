# Introduction

A simple list of the arguments for the SCP CUserCMD wrappers.

```
Buttons - Identical to CUserCMD
MouseX - Identical to CUserCMD
SideMove - Identical to CUserCMD
MouseY - Identical to CUserCMD
ForwardMove - Identical to CUserCMD
UpMove - Identical to CUserCMD
CommandNumber - Identical to CUserCMD
TickCount - Identical to CUserCMD
IsForced - Identical to CUserCMD
Pos - Identical to Player:GetPos
Weapon - Identical to Player:GetActiveWeapon
OnGround - Identical to Player:IsOnGround
EyeTrace - Returns an eye trace (util.TraceLine) from the shoot position of the player
ViewAngles - Returns either CUserCMD:GetViewAngles or the players actual world angles depending on TAC.Config.AccurateAngles
PhysgunTarget - Returns an entity that the player is holding, NULL if not holding anything with the physgun
Delta - Returns the delta between the last two viewangles, great for stuff like snap detection
```

All of these have Set and Get objects as well as a static variable in the table so you can access stuff like this:

```lua
MsgN(cNew.ViewAngles)
MsgN(cNew:GetViewAngles())

cNew:SetViewAngles(angle_zero)

MsgN(cNew.ViewAngles)
MsgN(cNew:GetViewAngles())
```