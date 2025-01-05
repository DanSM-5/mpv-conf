-- Script to handle storing screenshots with a name based on the video.

-- Change screenshot extension
local extension = 'jpg'

-- mpv built-in modules
local mp = require('mp')
local msg = require('mp.msg')

---Check if the current playing asset is a video from the filesystem (local)
---@return boolean If the playing asset is local
local function is_local_file()
  -- Pathname for urls will be the url itself
  local pathname = mp.get_property('path', '')
  return string.find(pathname, "^https?://") == nil
end

---Remove special characters from string.
---Carriage return and new line characters are removed. Others are
---replaced by an underscore.
---@param s string string to be cleanup
---@return string cleaned string
local function clean_string(s)
  -- Remove problematic chars from strings
  local escaped = string.gsub(s, "[\\/:|!?*%[%]\"\'><, ]", [[_]]):gsub("[\n\r]", [[]])
  return escaped
end

---Check that path exists and it is a file with write permissions
---@param name string Path to file to check
---@return boolean If the name is a file and it is writable
local function file_exists(name)
  -- io.open supports both '/' and '\' path separators
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

---Get the directory to store the screenshot
---@return string Path to directory where screenshots should be saved
local get_save_location = function ()
  local directory = mp.command_native({ 'expand-path', mp.get_property_native('screenshot-directory') })

  return directory
end

---Get filename for the screenshot to save.
---@return string Name of the file to save.
local get_file_name = function ()
  local is_local = is_local_file()
  local filename = is_local and mp.get_property('filename/no-ext') or mp.get_property('media-title', mp.get_property('filename/no-ext'))
  local file_path = get_save_location() .. '/' ..  clean_string(filename)

  local file = nil

  -- increment filename
  for i = 0, 9999 do
    local potential_name = string.format('%s_%04d.%s', file_path, i, extension)
    if not file_exists(potential_name) then
      file = potential_name
      break
    end
  end

  return file ~= nil and file or ''
end

---Save a screenshot using the video's name
---it also cleans problematic characters.
local save_screenshot = function ()
  local filename = get_file_name()

  if filename == '' then
    local error = 'Error getting name for screenshot'
    msg.info(error)
    mp.osd_message(error)
    return
  end

  local message = string.format('Screenshot saved: %s', filename)
  mp.commandv('screenshot-to-file', filename, 'video')
  msg.info(message)
  mp.osd_message(message)
end

-- Register message for input.conf
mp.register_script_message('custom_screenshot', save_screenshot)

