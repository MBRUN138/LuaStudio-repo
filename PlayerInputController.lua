local ContextActionService = game:GetService("ContextActionService")
 
-- Setting up the action handling function
local function handleAction(actionName, inputState, inputObj)
    if inputState == Enum.UserInputState.Begin then
        print("Handling action: " .. actionName)
    end
 
	-- Since this function does not return anything, this handler will
	-- "sink" the input and no other action handlers will be called after
	-- this one.
end
 
-- Bind the action to the handler
ContextActionService:BindAction("BoundAction", handleAction, false, Enum.KeyCode.W, Enum.KeyCode.D)
