print ("---------------------")
print("Setting up WiFi AP...")

 wifi.setmode(wifi.SOFTAP)
 cfg={}
     cfg.ssid="masterpassword"
     cfg.pwd="masterpassword"
     cfg.auth=wifi.WPA_WPA2_PSK
     wifi.ap.config(cfg)

print("Done.")
print ("---------------------")

majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("Flash size is "..flashsize.." kBytes.")

---remaining, used, total=file.fsinfo()
---    print("File system:\n Total : "..(total/1024).." kBytes\n Used  : "..(used/1024).." kBytes\n Remain: "..(remaining/1024).." kBytes")

function startup()
    uart.on("data")
    if abort == true then
        print('startup aborted')
        return
        end
	print ("---------------------")
    print('Starting HTTP Server')
    dofile('server.lua')
    print ('Starting DNS Server')
    dofile('dns-liar.lua')
	print ("---------------------")
    end

 -- prepare abort procedure
 -- abort = false
 -- print('Send some xxxx Keystrokes now to abort startup.')
 -- if <CR> is pressed, abort
 --     uart.on("data", "x", 
 --     function(data)
 --       print("receive from uart:", data)
 --       if data=="x" then
 --         abort = true 
 --         uart.on("data") 
 --       end        
 --   end, 0)

startup()
