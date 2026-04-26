SWEP.PrintName = "Mr. Skeltal Trumpet"
SWEP.Author = "You"
SWEP.Instructions = "Left-click once to doot, hold left-click to doot continuously."
SWEP.Spawnable = true
SWEP.Category = "Doot"

SWEP.ViewModel = "models/weapons/c_models/c_bugle/c_bugle.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_bugle/c_bugle.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary = SWEP.Primary

local singleDoot = "singledoot.wav"
local fullDoot = "fulldoot.wav"

function SWEP:Initialize()
    self:SetHoldType("slam") -- hands up to mouth style
end

function SWEP:Deploy()
    self:SetHoldType("slam")
    return true
end

function SWEP:PrimaryAttack()
    if self:IsPlayingLoop() then return end

    self:SetNextPrimaryFire(CurTime() + 0.1)

    if self.Owner:KeyDown(IN_ATTACK) then
        self:StartLoopSound()
    else
        self:EmitSound(singleDoot)
    end
end

function SWEP:Think()
    if not self.Owner:KeyDown(IN_ATTACK) then
        if self:IsPlayingLoop() then
            self:StopLoopSound()
        end
    elseif not self:IsPlayingLoop() and self.Owner:KeyDown(IN_ATTACK) then
        self:StartLoopSound()
    end
end

function SWEP:StartLoopSound()
    if SERVER then return end
    if not self.looping then
        self.looping = true
        self.Owner:EmitSound(fullDoot, 75, 100, 1, CHAN_STATIC)
    end
end

function SWEP:StopLoopSound()
    if SERVER then return end
    if self.looping then
        self.looping = false
        self.Owner:StopSound(fullDoot)
    end
end

function SWEP:IsPlayingLoop()
    return self.looping == true
end

function SWEP:Holster()
    if CLIENT then self:StopLoopSound() end
    return true
end

function SWEP:OnRemove()
    if CLIENT then self:StopLoopSound() end
end

-- Align model for third-person
function SWEP:DrawWorldModel()
    local ply = self:GetOwner()

    if IsValid(ply) then
        local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
        if not bone then self:DrawModel() return end

        local pos, ang = ply:GetBonePosition(bone)
        if not pos or not ang then self:DrawModel() return end

        ang:RotateAroundAxis(ang:Right(), 0)
        ang:RotateAroundAxis(ang:Up(), -180)
        ang:RotateAroundAxis(ang:Forward(), 90)

        pos = pos + ang:Forward() * 1 + ang:Right() * -4.6 + ang:Up() * -15

        self:SetRenderOrigin(pos)
        self:SetRenderAngles(ang)
        self:DrawModel()
    else
        self:DrawModel()
    end
end

-- Align model for first-person
function SWEP:GetViewModelPosition(pos, ang)
    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), 180)
    pos = pos + ang:Forward() * 8 + ang:Right() * -3 + ang:Up() * -19
    return pos, ang
end
