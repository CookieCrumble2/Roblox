local type = true -- set to false to use clipboard instead
local p = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

if type then
    print(p)
else
    setclipboard(tostring(p))
end
