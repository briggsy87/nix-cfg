-- Custom linemode showing both modification time and file size

function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.modified or 0)
  local size = self._file:size()

  if time == 0 then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    -- Same year: show month, day, and time
    time = os.date("%b %d %H:%M", time)
  else
    -- Different year: show full date
    time = os.date("%b %d  %Y", time)
  end

  return ui.Line(string.format("%s  %s", ya.readable_size(size), time))
end
