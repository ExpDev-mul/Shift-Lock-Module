--[[
	~Updated as of 29/09/2021~
	
	[Api]:
	ShiftLock:Lock(boolean) --> {nil}
	ShiftLock:IsLocked() --> {boolean}
	
	[Credits]:
	All credits go to ComplexMetatable, feel free to use this in your game without limits!
	
--]]

local shiftLock = {
	-- Settings (i.e Customizations):
	Settings = {
		CameraOffsetX = (1.75);
		CameraOffsetY = (0.25);
		MouseIconOnToggle = ("");
		CameraOffsetLerpSpeed = (3);
		CharacterFacingLerpSpeed = (6);
		RotateCharacter = (true);
	}
}

local shiftLockController = (require(script:WaitForChild("ShiftLockController")));
local shiftLockClass = (shiftLockController.new(shiftLock.Settings));

function shiftLock:Lock(boolean)
	assert(not (boolean == nil), "Argument missing or is equal to nil.")
	assert(typeof(boolean) == "boolean", "Argument is not a valid boolean.")
	shiftLockClass:Lock(boolean)
end;

function shiftLock:IsLocked()
	return (shiftLockClass.isShiftLockToggled)
end;

return shiftLock
