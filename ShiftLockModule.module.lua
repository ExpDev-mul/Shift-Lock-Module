local players = (game:GetService("Players"));
local playerMouseInstance = (players.LocalPlayer:GetMouse());
local character = (players.LocalPlayer.Character or players.LocalPlayer.CharacterAdded:Wait());
character:WaitForChild("Humanoid")
character:WaitForChild("HumanoidRootPart")
local camera = (workspace.CurrentCamera);
local runService = (game:GetService("RunService"));
local userInputService = (game:GetService("UserInputService"));
local shiftLockController = {}
shiftLockController.__index = shiftLockController

function shiftLockController.new(settings)
	local self = {isShiftLockToggled = (false)};
	local renderSteppedConnection, inputChangedConnection, humanoidDiedConnection, characterAddedConnection;
	local loadedCharacter = (false);
	local functions = {
		-- | RenderStepped | --
		renderStep = function(dt)
			local camera = (workspace.CurrentCamera);
			userInputService.MouseBehavior = self.isShiftLockToggled and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default;
			playerMouseInstance.Icon = self.isShiftLockToggled and settings.MouseIconOnToggle or ""
			local humanoid = (character:FindFirstChildOfClass("Humanoid"));
			local humanoidRootPart = (character:FindFirstChild("HumanoidRootPart"));
			if (humanoid) and (humanoidRootPart) then 
				if (settings.RotateCharacter) then
					humanoid.AutoRotate = not self.isShiftLockToggled
				end;
				
				humanoid.CameraOffset = self.isShiftLockToggled and humanoid.CameraOffset:Lerp(Vector3.new(settings.CameraOffsetX, settings.CameraOffsetY), dt * 3 * settings.CameraOffsetLerpSpeed) or humanoid.CameraOffset:Lerp(Vector3.new(), dt * 3 * settings.CameraOffsetLerpSpeed)
			end;
			
			if (self.isShiftLockToggled) then
				if not (character.Humanoid.SeatPart) then
					if (settings.RotateCharacter) then
						local x, y, z = camera.CFrame:ToOrientation();
						humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, y, 0), dt * 5 * settings.CharacterFacingLerpSpeed)
					end;
				end;
			end;
		end;
		
		-- | InputChanged | --
		inputChanged = function(input, gpe)
			if (gpe) or (not self.isShiftLockToggled) then return end;
			if (character.Humanoid.SeatPart) then return end;
			if (input.UserInputType == Enum.UserInputType.MouseMovement) then
				camera.CFrame = camera.CFrame * CFrame.Angles((input.Delta.X / camera.ViewportSize.X) * userInputService.MouseDeltaSensitivity, 0, 0) * CFrame.Angles(0, (input.Delta.Y / camera.ViewportSize.Y) * userInputService.MouseDeltaSensitivity, 0)
			end;
		end;
		
		-- | Died | --
		died = function()
			players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").CameraOffset = Vector3.new()
			renderSteppedConnection:Disconnect()
			humanoidDiedConnection:Disconnect()
			playerMouseInstance.Icon = ""
		end;
		
		-- | CharacterAdded | --
		characterAdded = function()
			self.isShiftLockToggled = false
		end,
	};
	
	renderSteppedConnection = runService.RenderStepped:Connect(functions.renderStep)
	inputChangedConnection = userInputService.InputChanged:Connect(functions.inputChanged)
	humanoidDiedConnection = players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Died:Connect(functions.died)
	characterAddedConnection = players.LocalPlayer.CharacterAdded:Connect(functions.characterAdded)
	return setmetatable(self, shiftLockController)
end;

function shiftLockController:Lock(boolean)
	assert(not (boolean == nil), "Argument missing or is equal to nil.")
	assert(typeof(boolean) == typeof(false), "Argument is not a valid boolean.")
	assert(character:FindFirstChildOfClass("Humanoid").Health > 0, "Can not lock shift lock when humanoid is dead.")
	print(string.format("Shift lock state: %s", boolean and "Yes" or "No"))
	self.isShiftLockToggled = boolean
end;

return shiftLockController
