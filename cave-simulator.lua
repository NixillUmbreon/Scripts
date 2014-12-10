-- Back left bottom corner: -1669, 1, -165
-- Front right top corner: -1651, 19, -151
-- Airspace front right top corner: -1651, 19, -147
-- Bedrock bottom left back corner: -1670, 0, -166
-- Bedrock front right top corner: -1650, 20, -146

c = require("component")
e = require("event")
d = c.debug
w = d.getWorld()
t = require("term")
sd = require("sides")
rs = c.redstone
cb = c.command_block
currentTime = (w.getTime() - 18000) % 24000

function placeOres(oreMsgName, oreName, oreData, oreAttempts, oreChance, topLayer)
  orePlaced = 0
  for a = 1, oreAttempts do
    if math.random(0, oreChance) == 0 then
      x = math.random(-1669, -1651)
      y = math.random(1, topLayer)
      z = math.random(-165, -151)
      
      if w.getBlockId(x, y, z)~=0 then
        w.setBlock(x, y, z, oreName, oreData)
        orePlaced = orePlaced + 1
      end
    end
  end
  t.write("Placed " .. orePlaced .. " " .. oreMsgName .. "\n", true)
end

while true do
  t.clear()
  t.write("Generating new cave... ", true)
  
  -- set entire volume to bedrock
  w.setBlocks(-1670, 0, -166, -1650, 20, -146, "bedrock", 0)
  t.write("Sealed chamber... ", true)
    
  -- set entire inner volume to Lava, to destroy mobs and drops
  w.setBlocks(-1669, 1, -165, -1651, 19, -147, "lava", 0)
  t.write("Lava'd chamber... ", true)

  os.sleep(5)
  
  -- set entire inner volume to Air
  w.setBlocks(-1669, 1, -165, -1651, 19, -147, "air", 0)
  t.write("Hollowed chamber... ", true)
  
  -- set stairs in bedrock
  w.setBlocks(-1663, 1, -149, -1657, 1, -147, "bedrock", 0)
  w.setBlocks(-1662, 2, -148, -1658, 2, -147, "bedrock", 0)
  w.setBlocks(-1661, 3, -147, -1659, 3, -147, "bedrock", 0)
  t.write("Stairs generated...", true)

  -- set Stone
  w.setBlocks(-1669, 1, -165, -1651, 19, -151, "stone", 0)
  t.write("Stone added...\n", true)
  
  -- place caves
  caves = 0
  for a = 1, 5 do
    x1 = math.random(-1669, -1651)
    x2 = math.random(x1, -1651)
    y1 = math.random(1, 19)
    y2 = math.random(y1, 19)
    z1 = math.random(-165, -151)
    z2 = math.random(z1, -151)
    if (x2 > x1 and y2 > y1 and z2 > z1) then
      w.setBlocks(x1, y1, z1, x2, y2, z2, "air", 0)
      caves = caves + 1
    end
  end
  t.write(caves .. " cave(s) added\n", true)
  
  -- placeOres(oreMsgName, oreName, oreData, oreAttempts, oreChance, topLayer)
  -- Ore chance means 1 in (chance+1) chance
  
  -- attempt to place diamond ores, always in the lowest two layers
  placeOres("diamond ore(s)", "diamond_ore", 0, 4, 10, 2)

  -- attempt to place redstone ores in the lowest five layers
  placeOres("redstone ore(s)", "redstone_ore", 0, 10, 5, 5)
  
  -- attempt to place gold ores in the lowest nine layers
  placeOres("gold ore(s)", "gold_ore", 0, 10, 5, 9)
  
  -- attempt to place iron ores in the caves
  placeOres("iron ore(s)", "iron_ore", 0, 20, 0, 19)
  
  -- attempt to place coal ores in the caves
  placeOres("coal ore(s)", "coal_ore", 0, 20, 0, 19)
  
  -- attempt to place copper ores in the caves
  placeOres("copper ore(s)", "ic2:blockOreCopper", 0, 20, 2, 19)
  
  -- attempt to place tin ores in the caves
  placeOres("tin ore(s)", "ic2:blockOreTin", 0, 20, 2, 19)
  
  -- attempt to place uranium ores in the lowest 5 layers
  placeOres("uranium ore(s)", "ic2:blockOreUran", 0, 1, 0, 5)
  
  -- attempt to place Project Red ores in the lowest 6 layers
  placeOres("ruby ore(s)", "ProjRed|Exploration:projectred.exploration.ore", 0, 20, 2, 19)
  placeOres("sapphire ore(s)", "ProjRed|Exploration:projectred.exploration.ore", 1, 20, 2, 19)
  placeOres("peridot ore(s)", "ProjRed|Exploration:projectred.exploration.ore", 2, 20, 2, 19)
  
  -- attempt to place clay blocks in the caves
  placeOres("clay block(s)", "clay", 0, 20, 3, 19)
  
  -- unseal the entrance
  w.setBlocks(-1660, 4, -146, -1660, 5, -146, "air", 0)
  
  -- wait for midnight
  lastTime = currentTime
  while currentTime >= lastTime do
    lastTime = currentTime
    currentTime = (w.getTime() - 18000) % 24000
    if rs.getInput(sd.top) ~= 0 then os.exit() end
  end
end
