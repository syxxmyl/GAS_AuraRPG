local M = {}

local PrintString = UE.UKismetSystemLibrary.PrintString

function M.Print(context, text, color, duration)
    color = color or UE.FLinearColor(1,1,1,1)
    duration = duration or 5
    PrintString(context, text, true, false, color, duration)
end

return M
