--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

local l_gfx = love.graphics


-- particle emitter element
-- made specifically for particle editor
-- so it may not meet your needs

ParticleEmitter = {}
ParticleEmitter.__index = ParticleEmitter
ParticleEmitter.ident = "ui_particleemitter"
ParticleEmitter.name = "ParticleEmitter"
ParticleEmitter.updateable = true
ParticleEmitter.x = 0
ParticleEmitter.y = 0
ParticleEmitter.followMouse = false -- if true it will follow the cursor
ParticleEmitter.mode = l_gfx.getBlendMode()
function ParticleEmitter:new(name,tex)
	local self = {}
	setmetatable(self,ParticleEmitter)
	self.ps = l_gfx.newParticleSystem(tex,10)
	self.ps:setEmissionRate(1)
	self.ps:setEmitterLifetime(-1)
	self.ps:setSizes(1)
	self.ps:setParticleLifetime(1)
	if name ~= nil then self.name = name end
	return self
end

setmetatable(ParticleEmitter,{__index = UIElement})

function ParticleEmitter:draw()
	local bm = l_gfx.getBlendMode()
	l_gfx.setBlendMode(self.mode)
	l_gfx.draw(self.ps)
	l_gfx.setBlendMode(bm)
end

function ParticleEmitter:update(dt)
	self.ps:update(dt)
end

function ParticleEmitter:mousemoved(x,y)
	if self.followMouse == true then
		self.ps:moveTo(x,y)
	end
end