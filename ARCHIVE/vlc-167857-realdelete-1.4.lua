function descriptor()
   return {
      title = "RealDelete",
      version = "1.3",
      shortdesc = [[RealDelete]],
	  longdesc= [[
Deletes currently playing file from disk and from playlist.

Usage (Windows):
1. Name extension file realdelete.lua and copy it into VLC extensions folder
e.g. C:\Program Files (x86)\VideoLAN\VLC\lua\extensions\realdelete.lua
2. restart VLC; extension should be visible under View menu

Tested on Windows 8 & VLC 2.1.1
Supports only ASCII file names.

License: GPL http://www.gnu.org/licenses/gpl.html

You use this extension at your own risk - author cannot be held responsible
for any direct or indirect damage caused.

Based on:
* Diskdelete 0.2 by Mark Morschhäuser
* https://forum.videolan.org/viewtopic.php?f=29&t=108811
(users 147852369, mederi)
	  ]],
      url=""
   }
end

shouldDelete = 0
shouldClose = 0
broken = 0
metaCounter = 0
btnDelete = nil
btnOk = nil
btnCancel = nil
deleteFromPlaylist = 0

function activate()
   vlc.msg.info("[RealDelete] Activated")
   d = vlc.dialog("RealDelete")
   labelInfo=d:add_label("Delete <b>from disk and from playlist</b>?",1,1,2,1)
   labelFile=d:add_label("",1,2,2,2)
   labelSpacing=d:add_label("<br/>",1,3,2,1)   
   btnDelete = d:add_button("Delete", click_delete,1,4,1,1)
   btnCancel = d:add_button("Cancel", click_cancel,2,4,1,1)
   selectFile()
   d:show()   
end

function deactivate()
   vlc.msg.info("[RealDelete] Deactivated")
end

function close()
   vlc.msg.info("[RealDelete] Will close now")
   --d:delete() -- close and delte dialog
   vlc.deactivate()
end

function selectFile()
   local isPlaying = vlc.input.is_playing()
   if isPlaying~= true then
      broken = 1
      messageMode("File to delete should be playing")
   else
      item = vlc.input.item()   
      uri = item:uri()  
      filenameBefore = vlc.strings.decode_uri(uri) -- decode %foo stuff from the URI
	  --isLocalFile = string.find(filenameBefore,"file:///")
	  --vlc.msg.info("[RealDelete] isLocalFile?: " .. isLocalFile)
	  -- filename = filenamebefore
	  -- if true then
		-- filename = string.sub(filename,9)
	  -- end
	  --isNetworkFile = (string.find(filenameBefore,"file://") ~= nil) and ~ isLocalFile
      filename = string.gsub(filenameBefore, "file:///", "") -- for local files
	  filename = string.gsub(filename, "file:", "") -- for network files
	  filename = string.gsub(filename, "//", "\\\\") -- for network files on Windows
	  --if isLocalFile then
		--filename = string.sub(filenameBefore,9) -- remove 'file:///'
	  --elseif isNetworkFile then
	   -- filename = string.sub(filenameBefore,6) -- remove 'file:'
	  --end
      --filepath = string.gsub(filename,"/","\\") -- Windows style path, e.g. c:\mp3\the best.mp3
      vlc.msg.info("[RealDelete] selected for deletion: " .. filename .. "; before: " .. filenameBefore)
      labelFile:set_text(filename)
      itemId = vlc.playlist.current()
   end
end

function click_cancel()
   close()
end

function click_delete()
   vlc.playlist.next()   
   shouldDelete = 1
end

function meta_changed()   
   --vlc.msg.info("[RealDelete] Meta changed ")
   if broken == 1 then
      --vlc.msg.info("[RealDelete] Broken")
      do return end
   elseif shouldDelete == 1 then      
      metaCounter = metaCounter + 1      
      if metaCounter > 2 then      
         vlc.msg.info("metaCounter > 1")
         local nextItemId = vlc.playlist.current()
         if nextItemId == itemId then-- maybe only one item in playlist
            vlc.msg.info("Maybe only one item in playlist - or shuffle caused to open the same file twice.")
            vlc.playlist.next()
            nextItemId = vlc.playlist.current()
            if nextItemId == itemId then-- only one item in playlist
               broken = 1
               messageMode("<br>Playlist should have at least two files</br>")
            end               
         else
            shouldDelete = 0      
            deleteFile()
         end
      end
   elseif shouldClose == 1 then
      metaCounter = metaCounter + 1
      vlc.msg.info("[RealDelete] Meta counter " .. metaCounter)
      if metaCounter > 7 then               
         vlc.msg.info("[RealDelete] Meta counter " .. metaCounter)
         if deleteFromPlaylist == 1 then            
            vlc.playlist.delete(itemId)
         end
         shouldClose = 0         
         close()   
      end
   end
end

function messageMode(message)
   vlc.msg.info("messageMode()")
   broken = 1
   vlc.msg.info(message)
   shouldClose  = 1
   vlc.playlist.next()
   --close()
   -- labelInfo:set_text("")
   -- labelInfo=d:add_label(message,1,1,3,1)   
   -- btnDelete = d:add_button("OK", close,1,4,1,1)
end

function deleteFile()
   if broken == 1 then
      do return end
   end
   vlc.msg.info("deleteFile()")
   if filename~=nil then   
      retval, err = os.remove(filename)
      if(retval == nil) then -- error handling; if deletion failed, print why
         broken = 1
         local errMessage = tostring(err)
         vlc.msg.info("[RealDelete] error: " .. errMessage)
         if string.find(errMessage, "No such file or directory") then
            messageMode("Cannot delete files with non-ascii names :(")
         else
            messageMode(errMessage)
         end
      else
         vlc.msg.info("[RealDelete] File deleted")   
         --vlc.playlist.delete(itemId)
         deleteFromPlaylist = 1
         filename=nil
         --d:hide() -- hide dialog
         shouldClose = 1       
      end
   end
end