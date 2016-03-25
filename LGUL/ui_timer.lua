--[[
The MIT License (MIT)

Copyright (c) 2015 mkdxdx

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]--

-- An invisible timer element
-- you can define its trigger function and then start it, and after an interval it will fire that function
-- if single is false it will autoreload itself

Timer = {}
Timer.__index = Timer
Timer.ident = "ui_timer"
Timer.name = "Timer"
Timer.updateable = true
function Timer:new(name)
	local self = {}
	setmetatable(self,Timer)
	if name ~= nil then self.name = name end
	self.interval = 1
	self.t = 1
	self.isRunning = false
	self.single = true
	return self
end
setmetatable(Timer,{__index = Element})

function Timer:start() self.isRunning = true self.t = self.interval end
function Timer:update(dt) 
	if self.isRunning == true then 
		self.t = self.t-dt 
		if self.t<=0 then 
			self.t = self.interval
			self:trigger() 
			if 	self.single == true then 
				self:pause() 
			end 
		end 
	end
end
function Timer:pause() self.isRunning = false end
function Timer:resume() self.isRunning = true end
function Timer:stop() self.isRunning = false self.t = self.interval end
function Timer:trigger() end