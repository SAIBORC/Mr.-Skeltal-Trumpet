# Mr.-Skeltal-Trumpet
here fix of the trumpet mod on gmod

here the guy where i get mod from https://steamcommunity.com/id/iblamecarson

here the mod i download it with out fix https://steamcommunity.com/sharedfiles/filedetails/?id=813746555

here link the fix one on link of mega because i can't even put on steam workshop i have limited account i didn't pay the 5$ thing that why :3

-(BUG)- addon / when you add the file on addons file just remove the (Mr.{space} ) on start of (Mr. Skeltal Trumpet) and well remove the error creater sholld be [Skeltal Trumpet]

https://mega.nz/file/nIQHCLCY#frXM6Zov2EfV2gvhN5V9wHm1X-MYyeLERQuI9rLtEyQ

here what i fix on it

the model for first-person now showed and the right place

the model for third-person now showed in right place but i can't fix the hand im too lazy :3

fix the left click now left click to half doot and hold left click play the fullone you can spam like old meme :3

thanks to bilm for share this :3

here the code .lua for it to make a trust :3

----------------------------------------------------------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------------------------------------------------
