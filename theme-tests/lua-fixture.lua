local config = {
  name = "lua",
  retries = 2,
  enabled = true,
  tags = { "sun", "moon", "star" },
}

local function join_tags(items)
  local parts = {}
  for index, value in ipairs(items) do
    parts[index] = string.format("%d:%s", index, value)
  end
  return table.concat(parts, ",")
end

if config.enabled and config.retries >= 1 then
  print(config.name .. " -> " .. join_tags(config.tags))
else
  print("disabled")
end
