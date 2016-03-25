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
local preset,blending,color,alpb,postlvl = 1,2,3,4,5,6
local bm_array = {"alpha","subtract","add","multiply","screen"}
local bm_alp,bm_sub,bm_add,bm_mul,bm_scr = 1,2,3,4,5
bm_index = 1

ui_scrdir = "lgul/"
require(ui_scrdir.."ui")
require("blender")
initialtable = nil

function loadrequire(m)
	local function requiref(m)
		require(m)
	end
	local r = pcall(requiref,m)
	if not(r) then
		print("No "..m.." module")
	else
		initialtable = require(m)
	end
end
loadrequire("reverse")




function love.load()
	ui = UIManager:new()
	local tim = os.time()
	math.randomseed(tim)
	local seed = math.random()
	
	
	blender = Blender:new(seed,128,128)
	b_parIndices = blender:getParameterIndices()
	b_blendModes = blender:getBlendModes()
	if not(initialtable) then
		initialtable = { 
			{{0.5, -2,-2, 2,2, seed},b_blendModes[1],{255,255,255,255},false,255} 
		}
	end
	blender:setParameters(initialtable)
	blender:createBlankBatch()
	blender:renderPreTex()
	blender:render()
	
	
	local fcanv = ui:addItem(UICanvas:new("C_FinalTex"))
	fcanv:setPosition(320,20)
	fcanv:create(128,128)
	
	
	local previewc = ui:addItem(UICanvas:new("C_Preview"))
	previewc:setPosition(320,272)
	previewc:create(512,512)
	
	local ctrlgb = ui:addItem(GroupBox:new("GB_Control"))
	ctrlgb:setSize(272,548)
	ctrlgb.caption = "Render control"
		
		local seedb = ctrlgb:addItem(Button:new("B_Seed"))
		seedb.caption = "Seed: "..blender:getSeed()
		seedb:setSize(ctrlgb.w-8,32)
		seedb:setPosition(4,4)
		function seedb:click(b)
			if b == 1 then
				local s = math.random()
				blender:setSeed(s)
				self.caption = "Seed: "..s
			end
		end
		
		local sp_texszw = ctrlgb:addItem(Spin:new("SP_TexSzW"))
		sp_texszw.caption = "Width:"
		sp_texszw:setSize(64,16)
		sp_texszw:setPosition(56,seedb.y+seedb.h+4)
		sp_texszw.leftCaption = true
		sp_texszw.min = 1
		sp_texszw.value = 128
		
		
		local sp_texszh = ctrlgb:addItem(Spin:new("SP_TexSzH"))
		sp_texszh.caption = "Height:"
		sp_texszh:setSize(64,16)
		sp_texszh:setPosition(sp_texszw.x,sp_texszw.y+sp_texszw.h+4)
		sp_texszh.leftCaption = true
		sp_texszh.min = 1
		sp_texszh.value = 128
		
		
		local b_apply = ctrlgb:addItem(Button:new("B_Apply"))
		b_apply:setSize(128,36)
		b_apply.caption = "Apply and render"
		b_apply:setPosition(sp_texszw.x+sp_texszw.w+4,sp_texszw.y)
		function b_apply:click(b)
			if b == 1 then
				blender:setTextureSize(sp_texszw.value,sp_texszh.value)
				fcanv.canvas = blender:getTexture()
				fcanv:setPosition(320,blender.th+24)
				blender:createBlankBatch()
				blender:renderPreTex()
				blender:render()				
				previewc:setPosition(320,fcanv.h+fcanv.y+32)
			end
		end
		
		local paramlist = ctrlgb:addItem(ListBox:new("LB_Paramlist"))
		paramlist:setSize(ctrlgb.w-8,128)
		paramlist:setPosition(4,b_apply.h+b_apply.y+4)
		paramlist.showBorder = true
		
		local b_parins = ctrlgb:addItem(Button:new("B_InsP"))
		b_parins.caption = "Insert"
		b_parins:setSize(paramlist.w/2-2,32)
		b_parins:setPosition(paramlist.x,paramlist.y+paramlist.h+4)
		function b_parins:click(b)
			if b == 1 then
				local param = {{1/2,-1,-1,1,1,blender.seed},bm_array[bm_alp],{255,255,255,255},false,255}
				blender:addParameter(param)
				refreshListData()
				paramlist:click(1)
				paramlist.index = #blender:getParameters()
				blender:createBlankBatch()
				blender:renderPreTex()
				blender:render()
			end
		end
		
		
		local b_pardel = ctrlgb:addItem(Button:new("B_DelP"))
		b_pardel.caption = "Delete"
		b_pardel:setSize(paramlist.w/2-2,32)
		b_pardel:setPosition(b_parins.x+b_parins.w+4,b_parins.y)
		function b_pardel:click(b)
			if b == 1 then
				if #blender.genparams>1 then
					blender:removeParameter(paramlist.index)
					refreshListData()
					paramlist:click(1)
					paramlist.index = #blender.genparams
					blender:render()
				end
			end
		end
		
		local gb_preset = ctrlgb:addItem(GroupBox:new("GB_Preset"))
		gb_preset.caption = "Preset control"
		gb_preset:setSize(ctrlgb.w-8,192)
		
			local sp_freq = gb_preset:addItem(Spin:new("SP_Freq"))
			sp_freq.caption = "Frequency: "
			sp_freq:setSize(64,16)
			sp_freq:setPosition(96,4)
			sp_freq.leftCaption = true
			sp_freq.min = 0.0001
			sp_freq.value = 0.5
			sp_freq.allowMult = true
			sp_freq.displayMult = true
			sp_freq.step = 1
			sp_freq.mult_precise = 0.01
			sp_freq.mult_coarse = 0.1
			sp_freq.mult_turbo = 10
			sp_freq.maxdec = 4
			function sp_freq:changeValue()
				local part = blender:getParameters(paramlist.index)
				part[b_parIndices.Preset][1] = self.value
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_x1 = gb_preset:addItem(Spin:new("SP_X1"))
			sp_x1.caption = "X1"
			sp_x1:setSize(48,16)
			sp_x1:setPosition(32,sp_freq.y+sp_freq.h+4)
			sp_x1.leftCaption = true
			function sp_x1:changeValue()
				local part = blender:getParameters(paramlist.index)
				part[b_parIndices.Preset][2] = self.value
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_x2 = gb_preset:addItem(Spin:new("SP_X2"))
			sp_x2.caption = "X2"
			sp_x2:setSize(48,16)
			sp_x2:setPosition(sp_x1.x+sp_x1.w+32,sp_freq.y+sp_freq.h+4)
			sp_x2.leftCaption = true
			function sp_x2:changeValue()
				local part = blender:getParameters(paramlist.index)
				part[b_parIndices.Preset][4] = self.value
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_y1 = gb_preset:addItem(Spin:new("SP_Y1"))
			sp_y1.caption = "Y1"
			sp_y1:setSize(48,16)
			sp_y1:setPosition(sp_x1.x,sp_x1.y+sp_x1.h+4)
			sp_y1.leftCaption = true
			function sp_y1:changeValue()
				local part = blender:getParameters(paramlist.index)
				part[b_parIndices.Preset][3] = self.value
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_y2 = gb_preset:addItem(Spin:new("SP_Y2"))
			sp_y2.caption = "Y2"
			sp_y2:setSize(48,16)
			sp_y2:setPosition(sp_x2.x,sp_x2.y+sp_x2.h+4)
			sp_y2.leftCaption = true
			function sp_y2:changeValue()
				local part = blender:getParameters(paramlist.index)
				part[b_parIndices.Preset][5] = self.value
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local b_prstseed = gb_preset:addItem(Button:new("B_PresetSeed"))
			b_prstseed.caption = "Seed: "
			b_prstseed:setSize(gb_preset.w-8,32)
			b_prstseed:setPosition(4,sp_y1.y+sp_y1.h+4)
			function b_prstseed:click(b)
				if b == 1 then
					local s = math.random()
					self.caption = "Seed: "..s
					local part = blender:getParameters(paramlist.index)
					part[b_parIndices.Preset][6] = s
					blender:renderPreTex(paramlist.index)
					blender:render()
				end
			end
			
			local cb_globalseed = gb_preset:addItem(Button:new("CB_GlobalSeed"))
			cb_globalseed.caption = " Use global"
			cb_globalseed:setPosition(8,b_prstseed.h+b_prstseed.y+4)
			cb_globalseed:setSize(96,16)
			cb_globalseed.checked = true
			function cb_globalseed:click(b)
				if b == 1 then
					local part = blender:getParameters(paramlist.index)
					part[b_parIndices.Preset][6] = blender:getSeed()
					b_prstseed.caption = "Seed: "..blender:getSeed()
					blender:renderPreTex(paramlist.index)
					blender:render()
				end
			end
			
			
			local b_blendmode = gb_preset:addItem(Button:new("B_Blendmode"))
			b_blendmode.caption = "Mode:alpha"
			b_blendmode:setPosition(4,cb_globalseed.y+cb_globalseed.h+4)
			b_blendmode:setSize(112,24)
			function b_blendmode:click(b)
				if b == 1 then
					local part = blender:getParameters(paramlist.index)
					bm_index = bm_index + 1
					if bm_index>#b_blendModes then
						bm_index = 1
					end
					self.caption = "Mode:"..b_blendModes[bm_index]
					part[b_parIndices.Blending] = b_blendModes[bm_index]
					local pind = paramlist.index
					refreshListData()
					paramlist.index = pind
					blender:renderPreTex(paramlist.index)
					blender:render()
				end
			end
			
			local sp_pcolr = gb_preset:addItem(Spin:new("SP_PColR"))
			sp_pcolr.caption = ""
			sp_pcolr:setPosition(4,b_blendmode.y+b_blendmode.h+4)
			sp_pcolr:setSize(32,16)
			sp_pcolr.max = 255
			sp_pcolr.min = 0
			sp_pcolr.value = 255
			function sp_pcolr:changeValue()
				local part = blender:getParameters(paramlist.index)[color]
				part[1] = self.value
				local pind = paramlist.index
				refreshListData()
				paramlist.index = pind
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_pcolg = gb_preset:addItem(Spin:new("SP_PColG"))
			sp_pcolg.caption = ""
			sp_pcolg:setPosition(sp_pcolr.x+sp_pcolr.w+4,sp_pcolr.y)
			sp_pcolg:setSize(32,16)
			sp_pcolg.max = 255
			sp_pcolg.min = 0
			sp_pcolg.value = 255
			function sp_pcolg:changeValue()
				local part = blender:getParameters(paramlist.index)[color]
				part[2] = self.value
				local pind = paramlist.index
				refreshListData()
				paramlist.index = pind
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_pcolb = gb_preset:addItem(Spin:new("SP_PColB"))
			sp_pcolb.caption = ""
			sp_pcolb:setPosition(sp_pcolg.x+sp_pcolg.w+4,sp_pcolg.y)
			sp_pcolb:setSize(32,16)
			sp_pcolb.max = 255
			sp_pcolb.min = 0
			sp_pcolb.value = 255
			function sp_pcolb:changeValue()
				local part = blender:getParameters(paramlist.index)[color]
				part[3] = self.value
				local pind = paramlist.index
				refreshListData()
				paramlist.index = pind
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
			local sp_pcola = gb_preset:addItem(Spin:new("SP_PColA"))
			sp_pcola.caption = ""
			sp_pcola:setPosition(sp_pcolb.x+sp_pcolb.w+4,sp_pcolb.y)
			sp_pcola:setSize(32,16)
			sp_pcola.max = 255
			sp_pcola.min = 0
			sp_pcola.value = 255
			function sp_pcola:changeValue()
				local part = blender:getParameters(paramlist.index)[color]
				part[4] = self.value
				local pind = paramlist.index
				refreshListData()
				paramlist.index = pind
				blender:renderPreTex(paramlist.index)
				blender:render()
				
			end
			
			local cb_blendalpha = gb_preset:addItem(CheckBox:new("CB_BlendAlpha"))
			cb_blendalpha.caption = "Blend alpha"
			cb_blendalpha:setPosition(sp_pcola.x+sp_pcola.w+4,sp_pcola.y)
			cb_blendalpha.buttonStyle = true
			cb_blendalpha:setSize(96,16)
			function cb_blendalpha:click(b)
				if b == 1 then
					blender:setParameters(paramlist.index,b_parIndices.AlphaBlend,self.checked)
					blender:renderPreTex(paramlist.index)
					blender:render()
				end
			end
			
			local sp_posterlevel = gb_preset:addItem(Spin:new("SP_PosterLevel"))
			sp_posterlevel.caption = "Posterize level:"
			sp_posterlevel:setPosition(104,sp_pcolr.y+sp_pcolr.h+4)
			sp_posterlevel.leftCaption = true
			sp_posterlevel:setSize(64,16)
			sp_posterlevel.min = 1
			sp_posterlevel.max = 255
			sp_posterlevel.value = 255
			function sp_posterlevel:changeValue()
				blender:setParameters(paramlist.index,b_parIndices.PosterLevel,self.value)
				blender:renderPreTex(paramlist.index)
				blender:render()
			end
			
		gb_preset:setPosition(4,b_parins.y+b_parins.h+20)
		
		function paramlist:click(b)
			if b == 1 then
				local p = blender:getParameters(self.index)
				sp_freq.value = p[preset][1]
				
				sp_x1.value = p[preset][2]
				sp_y1.value = p[preset][3]
				sp_x2.value = p[preset][4]
				sp_y2.value = p[preset][5]
				
				b_prstseed.caption = "Seed: "..p[preset][6]
				
				b_blendmode.caption = "Mode: "..p[blending]
				
				sp_pcolr.value = p[color][1]
				sp_pcolg.value = p[color][2]
				sp_pcolb.value = p[color][3]
				sp_pcola.value = p[color][4]
				
				cb_blendalpha.checked = p[alpb]
				
				sp_posterlevel.value = p[postlvl]
				
			end
		end
		
		local b_save = ctrlgb:addItem(Button:new("B_Save"))
		b_save:setPosition(4,gb_preset.y+gb_preset.h+4)
		b_save:setSize(ctrlgb.w/2-6,48)
		b_save.caption = "Save texture"
		function b_save:click(b)
			if b == 1 then
				blender:getTexture():newImageData():encode("png","texture.png")
			end
		end
		
		local b_code = ctrlgb:addItem(Button:new("B_Code"))
		b_code:setPosition(b_save.x+b_save.w+4,b_save.y)
		b_code:setSize(ctrlgb.w/2-6,48)
		b_code.caption = "Get presets"
		function b_code:click(b)
			if b == 1 then
				local s = ""
				for i,v in ipairs(blender:getParameters()) do
					s = s.."{"
					for k,l in ipairs(v) do
					
						if type(l) == "table" then
							s = s.."{"
							for j=1,#l do
								s = s..tostring(l[j])
								if j < #l then
									s = s..","
								end
							end
							s = s.."},"
						else
							if type(l) == "string" then
								l = "\""..l.."\""
							end
							s = s..tostring(l)
							if k<#v then
								s = s..","
							end
						end
						
					end
					s = s.."}"
					if i<#blender:getParameters() then
						s = s..",\n"
					end
				end
				love.system.setClipboardText(s)
			end
		end
		
	local b_preview = ctrlgb:addItem(Button:new("B_Preview"))
	b_preview.caption = "Tiled preview"
	b_preview:setSize(ctrlgb.w-8,32)
	b_preview:setPosition(4,b_code.y+b_code.h+4)
	function b_preview:click(b)
		if b == 1 then
			preview()
		end
	end
	
	ctrlgb:setPosition(4,16)
	
	refreshListData()
	b_apply:click(1)
	paramlist.index = 1
	paramlist:click(1)
end

function refreshListData()
	local paramlist = ui:getItem("GB_Control"):getItem("LB_Paramlist")
	paramlist:clear()
	for i,v in ipairs(blender:getParameters()) do
		local pta = v[b_parIndices.Preset]
		local col = v[b_parIndices.Color]
		local bm = v[b_parIndices.Blending]
		local alpb = v[b_parIndices.AlphaBlend]
		local postlevel = v[b_parIndices.PosterLevel]
		local str = "{"
		for j,k in ipairs(pta) do
			if string.len(k)>5 then k = " ... " end
			str = str..tostring(k)..","
		end
		str = str.."},"
		local colstr = ""
		for j,k in ipairs(col) do
			colstr = colstr..math.floor(k)..","
		end
		paramlist:addItem("Texture "..i..": "..bm.."  ["..colstr.."]")
	end
end



function preview()
	local pc = getCanvas()
	local pvc = ui:getItem("C_Preview")
	local tp = ui:getItem("C_FinalTex")
	setCanvas(pvc:get())
	l_gfx.clear(0,0,0,255)
	local bw,bh = blender:getTextureSize()
	for y=1,3 do
		for x=1,3 do
			draw(blender:getTexture(),(x-1)*bw,(y-1)*bh)
		end
	end
	setCanvas(pc)
	pvc:setPosition(nil,tp.h+tp.y+32)
end




function love.draw()
	for i,v in ipairs(blender:getPretextures()) do
		if i>#blender:getParameters() then break end
		local tw,th = blender:getTextureSize()
		l_gfx.draw(v,320+(i-1)*tw,20)
	end
	ui:draw()
end


function love.mousemoved(x,y,dx,dy)	ui:mousemoved(x,y) end
function love.mousepressed(x,y,b) ui:mousepressed(x,y,b) end
function love.mousereleased(x,y,b) ui:mousereleased(x,y,b) end
function love.update(dt) ui:update(dt) end
function love.keypressed(key,ir) ui:keypressed(key,ir) end
function love.keyreleased(key,ir) ui:keyreleased(key,ir) end
function love.wheelmoved(x,y) ui:wheelmoved(x,y) end