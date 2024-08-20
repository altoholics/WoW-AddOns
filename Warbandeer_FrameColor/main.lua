local addOnName, ns = ...
local ADDON_NAME = "Warbandeer"

local CreateSkinModule = FrameColor_CreateSkinModule

function ns.Print(...) print("|cFF33FF99".. addOnName.. "|r:", ...) end

function ns:SkinNineSliced(frame, color, desaturation)   
    for _, texture in pairs({
        frame.NineSlice.TopEdge,
        frame.NineSlice.BottomEdge,
        frame.NineSlice.TopRightCorner,
        frame.NineSlice.TopLeftCorner,
        frame.NineSlice.RightEdge,
        frame.NineSlice.LeftEdge,
        frame.NineSlice.BottomRightCorner,
        frame.NineSlice.BottomLeftCorner,  
    }) do
        texture:SetDesaturation(desaturation)
        texture:SetVertexColor(color.r, color.g, color.b, color.a) 
    end
end

function ns.api.SkinFrame(frame)
    local module = CreateSkinModule({
        moduleName = ADDON_NAME,
        moduleDesc = "",
    })

    function module:OnEnable()
        self:Recolor(self.GetColor1(), self.GetColor2(), 1)
    end

    function module:OnDisable()
        local color = {r=1,g=1,b=1,a=1}
        self:Recolor(color, color, 0)
    end

    function module:Recolor(color1, color2, desaturation)
        if frame then
            ns:SkinNineSliced(frame,color1,desaturation)
            frame.Bg:SetDesaturation(desaturation)
            frame.Bg:SetVertexColor(color2.r, color2.g, color2.b, color2.a)
        end
    end

    module:Recolor(module.GetColor1(), module.GetColor2(), 1)
end
