-- WirePlumber script for automatic audio profile switching
-- Author: ParticleG
-- Priority: Headphones (when plugged) > Speaker > HDMI
--
-- This script automatically switches between Headphones and Speaker profiles
-- based on jack availability.

cutils = require ("common-utils")
log = Log.open_topic ("custom-audio-switch")

-- Constants
local CARD_NAME = "alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"
local PROFILE_HEADPHONES = "HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)"
local PROFILE_SPEAKER = "HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"

-- Hook: Monitor route changes (jack plug/unplug events)
SimpleEventHook {
  name = "custom-audio/monitor-route-changes",
  interests = {
    EventInterest {
      Constraint { "event.type", "=", "device-params-changed" },
      Constraint { "event.subject.param-id", "=", "EnumRoute" },
      Constraint { "device.name", "=", CARD_NAME },
    },
  },
  execute = function(event)
    local device = event:get_subject()
    
    -- Check if headphones are available
    local headphones_available = false
    for p in device:iterate_params("EnumRoute") do
      local route = cutils.parseParam(p, "EnumRoute")
      if route and route.name and route.name:match("Headphones") then
        if route.available == "yes" then
          headphones_available = true
          break
        end
      end
    end
    
    -- Determine target profile
    local target_profile = headphones_available and PROFILE_HEADPHONES or PROFILE_SPEAKER
    
    -- Get current profile
    local current_profile = nil
    for p in device:iterate_params("EnumProfile") do
      local profile = cutils.parseParam(p, "EnumProfile")
      if profile and profile.save and profile.name then
        current_profile = profile.name
        break
      end
    end
    
    -- Switch if needed
    if current_profile ~= target_profile then
      log:info(string.format("Headphones %s, switching to %s",
        headphones_available and "plugged in" or "unplugged",
        headphones_available and "Headphones profile" or "Speaker profile"))
      
      local param = Pod.Object {
        "Spa:Pod:Object:Param:Profile", "Profile",
        index = nil,
        name = target_profile,
        save = true,
      }
      
      device:set_param("Profile", param)
    end
  end
}:register()

log:info("Custom audio profile switching script loaded")
log:info("Priority order: Headphones > Speaker > HDMI")
