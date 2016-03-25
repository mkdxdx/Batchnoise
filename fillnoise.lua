local pf,px1,py1,px2,py2,ps = 1,2,3,4,5,6
local cos,sin,random,pi,floor = math.cos,math.sin,math.random,math.pi,math.floor
local noise = love.math.noise

local fillnoise = {}

function fillnoise.generate(img,pt,color,ab)
	local iw,ih = img:getWidth(),img:getHeight()
	local id = img:getData()
	
	local f = pt[pf]
	local x1 = pt[px1]
	local y1 = pt[py1]
	local x2 = pt[px2]
	local y2 = pt[py2]
	local sd = pt[ps]
	
	for y=1,ih do
		for x=1,iw do
		
		local s=x / iw
		local t=y / ih
		local dx=x2-x1
		local dy=y2-y1
		
		local nx=x1+cos(s*2*pi)*dx/(2*pi)
		local ny=y1+cos(t*2*pi)*dy/(2*pi)
		local nz=x1+sin(s*2*pi)*dx/(2*pi)
		local nw=y1+sin(t*2*pi)*dy/(2*pi)
		
		local v = noise(nx*f+sd,ny*f+sd,nz*f+sd,nw*f+sd)
		local r,g,b,a
		if color ~= nil then
			r,g,b = color[1]*v,color[2]*v,color[3]*v
		else
			r,g,b = 255*v,255*v,255*v
		end
		if ab == true then
			a = color[4]*v
		else
			a = 255
		end
		id:setPixel(x-1,y-1,r,g,b,a)
		end
	end
	img:refresh()
end

function fillnoise.ptgen(freq,dist,predefseed,ran_f,mul_f,ran_d,mul_d)
	local param_t = {}
	param_t[pf] = (freq or random(10,(ran_f or 100))*(mul_f or 0.1))
	local d = (dist or random(2,(ran_d or 50))*(mul_d or 1))
	param_t[px1] = -(d/2)
	param_t[py1] = -(d/2)
	param_t[px2] = d/2
	param_t[py2] = d/2
	param_t[ps] = (predefseed or random())
	return param_t
end

function fillnoise.posterize(img,lc)
	local id = img:getData()
	local iw,ih = img:getWidth(),img:getHeight()
	for y=1,ih do
		for x=1,iw do
			local r,g,b,a = id:getPixel(x-1,y-1)
			r = floor((r/255)*lc)/lc*255
			g = floor((g/255)*lc)/lc*255
			b = floor((b/255)*lc)/lc*255
			id:setPixel(x-1,y-1,r,g,b,a)
		end
	end
	img:refresh()
end

return fillnoise