local fn = require("fillnoise")

local l_gfx = love.graphics
local draw = l_gfx.draw
local newCanvas = l_gfx.newCanvas
local setCanvas = l_gfx.setCanvas
local getCanvas = l_gfx.getCanvas
local newImage = l_gfx.newImage
local getBlendMode = l_gfx.getBlendMode
local setBlendMode = l_gfx.setBlendMode
local getColor = l_gfx.getColor
local setColor = l_gfx.setColor
local newImageData = love.image.newImageData

local preset,blending,color,alpb,postlvl = 1,2,3,4,5


Blender = {}
Blender.__index = Blender
Blender.ParameterIndices = {Preset = 1, Blending = 2, Color = 3, AlphaBlend = 4, PosterLevel = 5}
Blender.BlendModes = {"alpha","subtract","add","multiply","screen"}
function Blender:new(seed,w,h)
	local self = setmetatable({},Blender)
	self.tw = 128
	self.th = 128
	self.seed = seed or math.random()
	self.tex = newCanvas(self.tw,self.th)
	self.images = {}
	self.genparams = {}
	return self
end

function Blender:getTextureSize() return self.tw,self.th end
function Blender:getParameterIndices()	return self.ParameterIndices end
function Blender:setSeed(s)	self.seed = s end
function Blender:getSeed() return self.seed end
function Blender:getTexture() return self.tex end
function Blender:getBlendModes() return self.BlendModes end
function Blender:getPretextures(index) if index then return self.images[index] else return self.images end end


function Blender:setTextureSize(w,h)
	self.tex = newCanvas(w,h)
	self.tw = w
	self.th = h
	self:createBlankBatch()
end



function Blender:createBlankBatch(index)
	local genparams = self.genparams
	local images = self.images
	local w,h = self:getTextureSize()
	if index then
		local id = newImageData(w,h)
		images[index] = newImage(id)
	else
		for i,v in ipairs(genparams) do
			local id = newImageData(w,h)
			images[i] = newImage(id)
		end
	end

end

function Blender:renderPreTex(index)
	local genparams = self.genparams
	local images = self.images
	if index then
		local paramt = genparams[index]
		local pta = paramt[preset]
		local col = paramt[color]
		local bm = paramt[blending]
		local alpb = paramt[alpb]
		local postlevel = paramt[postlvl]
		fn.generate(images[index],pta,col,alpb)
		if postlevel then
			fn.posterize(images[index],postlevel)
		end
	else
		for i,v in ipairs(genparams) do
			local pta = v[preset]
			local col = v[color]
			local bm = v[blending]
			local alpb = v[alpb]
			local postlevel = v[postlvl]
			fn.generate(images[i],pta,col,alpb)
			if postlevel then
				fn.posterize(images[i],postlevel)
			end
		end
	end	
end

function Blender:render()
	local genparams = self.genparams
	local images = self.images
	local canv = l_gfx.getCanvas()
	local bm,am = l_gfx.getBlendMode()
	l_gfx.setCanvas(self.tex)
	l_gfx.clear(0,0,0,255)
	for i,v in ipairs(genparams) do
		local blendmode = v[blending]
		
		l_gfx.setBlendMode(blendmode)
		l_gfx.draw(images[i])
	end
	l_gfx.setBlendMode(bm,am)
	l_gfx.setCanvas(canv)
end

function Blender:addParameter(p)
	self.genparams[#self.genparams+1] = p
end


function Blender:setParameters(index,pt,pvar)
	if type(index) == "table" then
		self.genparams = index
	else
		if type(pt) == "table" then
			self.genparams[index] = pt
		else 
			self.genparams[index][pt] = pvar
		end
	end
end

function Blender:removeParameter(index)	
	if #self.genparams>1 then
		table.remove(self.genparams,index)
	end
end

function Blender:getParameters(index)
	if index then
		return self.genparams[index]
	else
		return self.genparams
	end
end


