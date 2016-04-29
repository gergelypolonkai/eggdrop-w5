################################################################################
#                                                                              #
# W5CL - W00d5t0ck's ChanLimit script                                          #
#                                                                              #
# Written by W00d5t0ck@IRCnet (also W00d5t0ck@SulIRC)                          #
#                                                                              #
# History:                                                                     #
#   2003/09/11 First version                                                   #
#   2003/09/12 First public release                                            #
#                                                                              #
# Tested on eggdrop1.6.15 with tcl8.3 on UnrealIRCd3.1.6-Noon, on a debian 3.0 #
# with the 2.4.18 (distribution) kernel .)                                     #
#                                                                              #
# Good work to you, bot-owner!                                                 #
#                                                                              #
# Feel free to look for me on IRCnet's #eggdrop or on SulIRC's #help for help! #
# If I don't answer, don't forget to CTCP BEEP me! If I still don't answer,    #
# I'm Not Behind Keyboard.                                                     #
#                                                                              #
# Licensed under GPL v2                                                        #
#                                                                              #
################################################################################

####################
# General settings #
####################

# Setting name for channels which are limited [w5cl]
set w5cl-limit "w5cl"

# Number added to number of users on channel limit [3]
set w5cl-plus 3

# Flags for users who can set or unset channel limit (turn on/off) [m|m]
set w5cl-flags "m|m"

############################################################################
# Please do not edit ANYTHING beyond here, unless you really know what you #
# are doing!                                                               #
############################################################################
set w5cl-version "1.0"

# Default values. I'm a bit paranoid .)
if {[catch {set w5cl-limit}]} {set w5cl-limit "w5cl"}
if {[catch {set w5cl-plus}]} {set w5cl-plus 3}
if {[catch {set w5cl-flags}]} {set w5cl-flags "m|m"}

catch {setudef flag ${w5cl-limit} }

bind join * * w5cljoin
bind part * * w5clpart
bind sign * * w5clsign

proc w5cljoin {nick uhost hand chan} {
  global w5cl-limit w5cl-plus

  if {[botonchan $chan]} {
    if {[botisop $chan] && [channel get $chan ${w5cl-limit}]} {
      set num [expr [llength [chanlist $chan]] + ${w5cl-plus}]
      putserv "MODE $chan +l $num"
    }
  } else {putlog "Got information from $chan, and I'm not on it!"}
  return 0
}

proc w5clpart {nick uhost hand chan msg} {
  global w5cl-limit w5cl-plus

  if {[botonchan $chan]} {
    if {[botisop $chan] && [channel get $chan ${w5cl-limit}]} {
      set num [expr [llength [chanlist $chan]] + ${w5cl-plus} - 1]
      putserv "MODE $chan +l $num"
    }
  } else {putlog "Got information from $chan, and I'm not on it!"}
  return 0
}

proc w5clsign {nick uhost hand chan reason} {
  global w5cl-limit w5cl-plus

  if {[botonchan $chan]} {
    if {[botisop $chan] && [channel get $chan ${w5cl-limit}]} {
      set num [expr [llength [chanlist $chan]] + ${w5cl-plus} - 1]
      putserv "MODE $chan +l $num"
    }
  } else {putlog "Got information from $chan, and I'm not on it!"}
  return 0
}

putlog "W00d5t0ck's chanlimit script, v${w5cl-version}"
