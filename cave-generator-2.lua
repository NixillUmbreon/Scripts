-- This is a cave generator.
-- It generates caves.

-------------
-- OPTIONS --
-------------
-- If a chatbox is detected, this sets the name and range of the box.
chatName = "Cave Gen"
chatRange = 100

-- The two corners of the cuboid in which bedrock generates ({x, y, z})
bNEB = {-748,  3, -432}
bSWT = {-768, 24, -452}
-- The two corners of the cuboid in which the cave generates ({x, y, z})
cNEB = {-749,  4, -433}
cSWT = {-767, 23, -451}
-- The two corners of the cuboid to make completely air, or nil to avoid this
aNEB = nil
aSWT = nil
-- The two corners of the cuboid to make completely air as well (entrance), or nil to avoid this
eNEB = {-748, 24, -432}
eSWT = {-768, 24, -452}

-- Cave generation options
cave = {
  shape = {"tubes"}, -- Only "tubes" or "blocks" are supported by default
  count = 25, -- Number of caves to generate
  solid = "stone", -- Solid block to generate in cave
  --solData = 0 -- if there's a data value
  hollow = "air" -- Hollow block to generate in cave
  --holData = 0 -- if there's a data value
}

-- Ore generation options
ores = {
  --n = name in message, b = block id, d = data, at = attempts,
  --c = chance, bt = bottom, t = top, m = max
  --vc = vein chance, vm = vein max
  --n and b are required
  --default for d, bt are 0; default for c, vc, vm, at, and t are 1
  --bt and t are [0..1] top to bottom of the cave cuboid
  --c is chance to succeed (out of 1)
  --vc is the vein chance of an ore (the chance another block will be placed adjacent to the first one)
  --vm is the vein maximum 
  --default for m is at
  
  --vanilla ores
  {n="coal ore(s)", b="coal_ore", at=10, vc=.9, vm=16},
  {n="iron ore(s)", b="iron_ore", at=15, vc=.9, vm=8},
  {n="gold ore(s)", b="gold_ore", at=10, c=.8, t=.5, vc=.9, vm=8},
  {n="redstone ore(s)", b="redstone_ore", at=10, c=.5, t=.2, vc=.9, vm=8},
  {n="diamond ore(s)", b="diamond_ore", at=10, c=.25, t=.2, m=2, vc=.9, vm=8},
  {n="emerald ore", b="emerald_ore", at=1, c=.1},
  
  --project red ores
  {n="ruby ore(s)", b="ProjRed|Exploration:projectred.exploration.ore", d=0, at=20, c=.3, m=10, vc=.9, vm=8},
  {n="sapphire ore(s)", b="ProjRed|Exploration:projectred.exploration.ore", d=1, at=20, c=.3, m=10, vc=.9, vm=8},
  {n="peridot ore(s)", b="ProjRed|Exploration:projectred.exploration.ore", d=2, at=20, c=.3, m=10, vc=.9, vm=8},
  {n="copper ore(s)", b="ProjRed|Exploration:projectred.exploration.ore", d=3, at=20, c=.3, m=10, vc=.9, vm=8},
  {n="tin ore(s)", b="ProjRed|Exploration:projectred.exploration.ore", d=4, at=20, c=.3, m=10, vc=.9, vm=8},
  {n="silver ore(s)", b="ProjRed|Exploration:projectred.exploration.ore", d=5, at=20, c=.3, m=10, vc=.9, vm=8},
  
  --clay because clay
  {n="clay block(s)", b="clay", at=20, c=.25, vc=.5, vm=8},

  --glowstone because glowstone
  {n="glowstone", b="glowstone", at=10, c=.1, vc=.5, vm=10}
  
  --sand because flatland
  {n="sand block(s)", b="sand", at=5, c=.75, vm=10}
}

-----------------------
-- OPTION CORRECTION --
-----------------------
function fixCoords(low, high)
  if (low == nil) then return end
  if (low[1] > high[1]) then low[1], high[1] = high[1], low[1] end
  if (low[2] > high[2]) then low[2], high[2] = high[2], low[2] end
  if (low[3] > high[3]) then low[3], high[3] = high[3], low[3] end
end
fixCoords(bNEB, bSWT)
fixCoords(cNEB, cSWT)
fixCoords(aNEB, aSWT)
fixCoords(eNEB, eSWT)
cave.solData = cave.solData or 0
cave.holData = cave.holData or 0
chatName = chatName or "Cave Gen"
chatRange = chatRange or 40

---------------------
-- CAVE GENERATORS --
---------------------
caveGen = {
  blocks = function()
    local x1 = math.random(cNEB[1], cSWT[1])
    local x2 = math.random(x1, cSWT[1])
    local y1 = math.random(cNEB[2], cSWT[2])
    local y2 = math.random(y1, cSWT[2])
    local z1 = math.random(cNEB[3], cSWT[3])
    local z2 = math.random(z1, cSWT[3])
    if (x2 > x1 and y2 > y1 and z2 > z1) then
      w.setBlocks(x1, y1, z1, x2, y2, z2, cave.hollow, cave.holData)
      return true
    else
      return false
    end
  end,
  tubes = function()
    local dir = math.random(1, 3)
    local x1 = math.random(cNEB[1], cSWT[1]-2)
    local x2 = x1 + 2
    local y1 = math.random(cNEB[2], cSWT[2]-2)
    local y2 = y1 + 2
    local z1 = math.random(cNEB[3], cSWT[3]-2)
    local z2 = z1 + 2
    if (dir == 1) then
      x1 = math.random(cNEB[1], cSWT[1])
      x2 = math.random(x1, cSWT[1])
    elseif (dir == 2) then
      y1 = math.random(cNEB[2], cSWT[2])
      y2 = math.random(y1, cSWT[2])
    elseif (dir == 3) then
      z1 = math.random(cNEB[3], cSWT[3])
      z2 = math.random(z1, cSWT[3])
    end
    if (x2 > x1 and y2 > y1 and z2 > z1) then
      w.setBlocks(x1, y1, z1, x2, y2, z2, cave.hollow, cave.holData)
      return true
    else
      return false
    end
  end
}

-------------------
-- ORE GENERATOR --
-------------------
function placeOres(ore)
  --n = name in message, b = block id, d = data, at = attempts, c = chance, bt = bottom, t = top, m = max
  --n and b are required
  --default for d, bt, and c are 0; default for at and t are 1
  --bt and t are [0..1] top to bottom of the cave cuboid
  --c is number of chances to fail (plus one chance to succeed)
  --default for m is at
  local oreD = ore.d or 0
  local oreAt = ore.at or 1
  local oreC = ore.c or 1
  local gap = cSWT[2] - cNEB[2]
  local oreBt = math.floor((ore.bt or 0) * gap + cNEB[2])
  local oreT = math.floor((ore.t or 1) * gap + cNEB[2])
  local oreM = ore.m or ore.at
  local oreVc = ore.vc or 1
  local oreVm = ore.vm or 1
  local orePlaced = 0

  for a = 1, ore.at do
    if math.random(0, 1000) / 1000 < oreC then
      local x = math.random(cNEB[1], cSWT[1])
      local y = math.random(oreBt, oreT)
      local z = math.random(cNEB[3], cSWT[3])
      
      if (w.getBlockId(x, y, z) == cave.solid) then
        w.setBlock(x, y, z, ore.b, oreD)
        orePlaced = orePlaced + 1
        
        ore.b = w.getBlockId(x, y, z)

        local vein = oreVm > 1
        local oreVPlaced = 1
        while vein do
          x = x + math.random(-1, 1)
          y = y + math.random(-1, 1)
          z = z + math.random(-1, 1)
          if (w.getBlockId(x, y, z) == cave.solid) then
            if math.random(0, 1000) / 1000 < oreC then
              w.setBlock(x, y, z, ore.b, oreD)
              oreVPlaced = oreVPlaced + 1
              orePlaced = orePlaced + 1
            else
              vein = false
            end
          elseif (w.getBlockId(x, y, z) == ore.b) then
          else
            vein = false
          end

          if (oreVPlaced >= oreVm) then vein = false end
        end

        if (orePlaced == oreM) then break end
      end
    end
  end
  prnt("Placed " .. orePlaced .. " " .. ore.n .. "", true)
end


--------------------
-- MISC FUNCTIONS --
--------------------
function prnt(message)
  if (cb ~= nil) then
    cb.say(message)
  end
  t.write(message .. "\n", true)
end

function setBlocks(nbe, stw, block, data)
  if nbe ~= nil then
    return w.setBlocks(nbe[1], nbe[2], nbe[3], stw[1], stw[2], stw[3], block, data)
  else
    return
  end
end

------------------
-- MAIN PROGRAM --
------------------
c = require("component")
e = require("event")
d = c.debug
w = d.getWorld()
t = require("term")
rs = c.redstone
sd = require("sides")
cb = nil
currentTime = (w.getTime() - 18000) % 24000

if c.isAvailable("chat_box") then
  cb = c.chat_box
  cb.setDistance(chatRange)
  cb.setName(chatName)
  t.write("Chat box found.", true)
else
  t.write("No chat box found.", true)
end

while true do
  t.clear()
  prnt("Generating new cave...")
  
  -- set entire volume to bedrock
  setBlocks(bNEB, bSWT, "bedrock", 0)
  prnt("Sealed chamber... ")
    
  -- set entire inner volume to Lava, to destroy mobs and drops
  setBlocks(cNEB, cSWT, "lava", 0)
  prnt("Lava'd chamber... ")

  os.sleep(5)
  
  -- set entire inner volume to Air
  setBlocks(cNEB, cSWT, "air", 0)
  setBlocks(aNEB, aSWT, "air", 0)
  prnt("Hollowed chamber... ")
  
  -- set Stone
  setBlocks(cNEB, cSWT, cave.solid, cave.solData)
  cave.solid = w.getBlockId(cNEB[1], cNEB[2], cNEB[3])
  prnt("Solid added...")
  
  -- place caves
  caves = 0
  for a = 1, cave.count do
    local selGen = caveGen[cave.shape[math.random(1, #cave.shape)]]
    if selGen() then
      caves = caves + 1
    end
  end
  prnt(caves .. " cave(s) added", true)
  
  -- place ores
  for a = 1, #ores do placeOres(ores[a]) end
  
  -- unseal the entrance if applicable
  setBlocks(eNEB, eSWT, "air", 0)
  prnt("Cave opened.")
  
  -- wait for midnight
  lastTime = currentTime
  while currentTime >= lastTime do
    os.sleep(0.05)
    lastTime = currentTime
    currentTime = (w.getTime() - 18000) % 24000
    if rs.getInput(sd.front) ~= 0 then os.exit() end
    if rs.getInput(sd.right) ~= 0 then currentTime = 0 end
  end
end
