###############################################################################
#                                                                              #
# w5ts - W00d52kr1pt topic system, v1.0                                        #
#                                                                              #
# Author:                   W00d5t0ck@IRCnet (also W00d5t0ck@SulIRC)           #
#                                                                              #
# Purpose:                  Randomly changes the channels' topics, and locks   #
#                           them, if said to.                                  #
#                                                                              #
# History:                                                                     #
#                           2003/08/24 First public release (1.0)              #
#                                                                              #
# Future plans:             Nothing. Make suggestions, or rewrite it, if you   #
#                           don't like something...                            #
#                                                                              #
# E-mail (suggestion, etc): polesz@techinfo.hu                                 #
#                                                                              #
# Licensed under GPL v2                                                        #
#                                                                              #
################################################################################

#### General settings ####

# Enable public commands? May be insecure [0/1]
set w5tsenablepub 0

# Enable msg commands? May be insecure [0/1]
set w5tsenablemsg 0

# Enable dcc commands? It's safe to enable it, and it is highly recommended
# [1/0]
set w5tsenabledcc 1

# What character do the public commands start? [!]
set w5tscmdchar "!"

# Command to lock a channel's topic
set w5tslockcmd "locktopic"

# Command to set the channel randtopic
set w5tsrandcmd "randtopic"

# Command to set a locked channel's topic
set w5tstopccmd "topikvalt"

# Command to retrieve settings for a channel
set w5tsretrcmd "topik"

# How often change topic on +w5tsrand channels? ("r" for random, or a number
# to set the interval in minutes
set w5tstpcinterval "r"

# If the interval is random, set the minimum and maximum time here.
set w5tstimemin 5
set w5tstimemax 10

# File that holds the topics. Relative to the eggdrop executable, not the
# script! [topics.txt]
set w5tstopicfile "topics.dat"

# Learn new topics? Consumes a bit more CPU when saving. May fill your quotas
# if you change topic too often. Learns only, when the channel's topic is not
# locked, or via the topic-changing command. [1/0]
set w5tslearntopics 1

# With what global flags can the users change the topic and use the flag-
# dependant commands? [nmo]
set w5tsglobalflags "nmob"

# With what channel flags can the users change the topic and use the flag-
# dependant commands? [mno]
set w5tschanflags "mno"

# Kick users who change topic on a locked channel? [0/1]
set w5tskick 1

# Reason when kicking those users? It will be the reason of the ban, if w5tsban
# is 1 ["Don't change topic on a locked channel!"]
set w5tskickreason "Ezen a csatornán nem lehet topikot váltani!"

# Ban those users? [0/1]
set w5tsban 1

# Ban for how long (in minutes)? If you set this to 0, the ban will never expire
set w5tsbantime 10

# Warn how many times before kick users who changes topic on a locked channel?
# Set to 0 to immediate kick [1]
set w5tswarn 1

# Channel flag for topic lock?
set w5tstlflag "w5tslock"

# Channel flag for random topic?
set w5tsrtflag "w5tsrand"

# Channel setting name for warned users?
set w5tswarnsetting "w5tswarn"

# Channel setting name for the locked topic?
set w5tstopcsetting "w5tstopic"

# Usage information for public topiclock command
set w5tspublockusage "Használat: a $w5tscmdchar$w5tslockcmd 1 lezárja, a $w5tscmdchar$w5tslockcmd 0 to felnyitja a topikot"

# Usage information for public randtopic command
set w5tspubrandusage "Használat: a $w5tscmdchar$w5tsrandcmd 1 engedélyezi, a $w5tscmdchar$w5tsrandcmd 0 letiltja a véletlen-topikot"

# Usage information for public topic command
set w5tspubtopcusage "Használat: $w5tscmdchar$w5tstopccmd új topik"

# Usage information for message topiclock command
set w5tsmsglockusage "Használat: a $w5tslockcmd jelszó csatorna 1 lezárja, a $w5tslockcmd jelszó csatorna 0 felnyitja a topikot"

# Usage information for message randtopic command
set w5tsmsgrandusage "Használat: a $w5tsrandcmd jelszó csatorna 1 engedélyezi, a $w5tsrandcmd jelszó csatorna 0 letiltja a véletlenszerû topikot"

# Usage information for message topic command
set w5tsmsgtopcusage "Használat: $w5tstopccmd jelszó csatorna új topik"

# Usage information for dcc topiclock command
set w5tsdcclockusage "Használat: a $w5tslockcmd csatorna 1 lezárja, a $w5tslockcmd csatorna 0 felnyitja a topikot"

# Usage information for dcc randtopic command
set w5tsdccrandusage "Használat: a $w5tsrandcmd csatorna 1 engedélyezi, a $w5tsrandcmd csatorna 0 letiltja a véletlenszerû topikot"

# Usage information for dcc topic command
set w5tsdcctopcusage "Használat: $w5tstopccmd csatorna új topik"

# Setting information. Use \$lock, and \$rand for locked and random status,
# and \$chan for channel name!!!
set w5tssettinginfo "\$chan beállítások: topiktiltás(\$lock); véletlentopik(\$rand)"

# Message to send when a user sets a new topic on a locked channel:
set w5tstopcmsg "A topik le van zárva!"

# String for "on" state
set w5tsonstr "be"

# String for "off" state
set w5tsoffstr "ki"


#### Please don't change anything beyond here, unless you know what ####
#### you are doing!                                                 ####

set w5tsver "1.0"

if {$numversion < 1061500} {putlog "This script is tested on eggdrop-1.6.15, a newer bot than this one. Please mail me at polesz@techinfo.hu if the script works with this version without modifications!"}

if {$w5tsenablepub == 1} {
	bind pub - $w5tscmdchar$w5tslockcmd w5tspublocktopic
	bind pub - $w5tscmdchar$w5tsrandcmd w5tspubrandtopic
	bind pub - $w5tscmdchar$w5tstopccmd w5tspubtopic
} else {
  catch {unbind pub - $w5tscmdchar$w5tslockcmd w5tspublocktopic}
  catch {unbind pub - $w5tscmdchar$w5tsrandcmd w5tspubrandtopic}
  catch {unbind pub - $w5tscmdchar$w5tstopccmd w5tspubtopic}
}
if {$w5tsenablemsg == 1} {
	bind msg - $w5tslockcmd w5tsmsglocktopic
	bind msg - $w5tsrandcmd w5tsmsgrandtopic
	bind msg - $w5tstopccmd w5tsmsgtopic
} else {
  catch {unbind msg - $w5tslockcmd w5tsmsglocktopic}
  catch {unbind msg - $w5tsrandcmd w5tsmsgrandtopic}
  catch {unbind msg - $w5tstopccmd w5tsmsgtopic}
}
if {$w5tsenabledcc == 1} {
	bind dcc - $w5tslockcmd w5tsdcclocktopic
	bind dcc - $w5tsrandcmd w5tsdccrandtopic
	bind dcc - $w5tstopccmd w5tsdcctopic
} else {
  catch {unbind dcc - $w5tslockcmd w5tsdcclocktopic}
  catch {unbind dcc - $w5tsrandcmd w5tsdccrandtopic}
  catch {unbind dcc - $w5tstopccmd w5tsdcctopic}
}

bind topc - * w5tstopcproc
bind pub - $w5tscmdchar$w5tsretrcmd w5tspubretr
bind msg - $w5tsretrcmd w5tsmsgretr
bind dcc - $w5tsretrcmd w5tsdccretr

setudef flag $w5tstlflag
setudef flag $w5tsrtflag
setudef str $w5tswarnsetting
setudef str $w5tstopcsetting

#### Miscellaneous procs ####
proc w5tscheckflags {handle channel} {
  global w5tsglobalflags w5tschanflags

  set hasflags 0

  for {set i 0} {$i < [string length $w5tsglobalflags]} {incr i} {
    if {[matchattr $handle [string index $w5tsglobalflags $i]]} {set hasflags 1}
  }
  for {set i 0} {$i < [string length $w5tschanflags]} {incr i} {
    if {[matchattr $handle [string index $w5tschanflags $i] $channel]} {set hasflags 1}
  }
  return $hasflags
}

proc w5tssavetopic {channel topic} {
  global w5tstopicfile

  set topic [string trim $topic]
  set channel [string tolower $channel]
  set errno [catch {set fd [open $w5tstopicfile r]}]
  set topics {}
  if {$errno == 0} {
    while {![eof $fd]} {
      set line [gets $fd]
      if {[eof $fd]} {break}
      set chan [string tolower [lindex $line 0]]
      set topc [string trim [lrange $line 1 end]]
      if {($chan == $channel) && ($topic == $topc)} {
        close $fd
        return 1
      }
      set topics [lappend topics $line]
    }
    close $fd
  }
  set topics [lappend topics "$channel $topic"]
  set errno [catch {set fd [open $w5tstopicfile w]}]
  if {$errno == 0} {
    foreach tmp $topics {puts $fd $tmp}
    close $fd
    return 1
  }
  return 0
}

proc w5tscanchangetopic {channel} {
  if {[botisop $channel]} {return 1}
  set modes [getchanmode $channel]
  for {set i 0} {$i < [string length $modes]} {incr i} {
    if {[string index $modes $i] == "m"} {return 0}
  }
  return 1
}

proc w5tsgetrandtopic {channel} {
  global w5tstopicfile

  set channel [string tolower $channel]
  set errno [catch {set fd [open $w5tstopicfile]}]

  set topics {}
  if {$errno == 0} {
    while {![eof $fd]} {
      set line [gets $fd]
      if {[eof $fd]} {break}
      set chan [string tolower [lindex $line 0]]
      set topc [string trim [lrange $line 1 end]]
      if {$chan == $channel} {set topics [lappend topics $topc]}
    }
    close $fd
  } else {return ""}
  if {[llength $topics] == 0} {return ""}
  return [lindex $topics [rand [llength $topics]]]
}

proc w5tsrandtopic {} {
  global w5tsrtflag w5tstpcinterval w5tstimemin w5tstimemax

  foreach chan [channels] {
    if {([channel get $chan $w5tsrtflag]) && ([w5tscanchangetopic $chan]) && ([w5tsgetrandtopic $chan] != "")} {
      putserv "TOPIC $chan :[w5tsgetrandtopic $chan]"
    }
  }
  if {$w5tstpcinterval == "r"} {
    if {$w5tstimemax < $w5tstimemin} {
      set a $w5tstimemin
      set w5tstimemin $w5tstimemax
      set w5tstimemax $a
    }
    set interval [expr [rand [expr $w5tstimemax - $w5tstimemin]] + $w5tstimemin]
    if {![string match "*w5tsrandtopic*" [timers]]} {timer $interval w5tsrandtopic}
  } elseif {[string is digit $w5tstpcinterval]} {
    if {![string match "*w5tsrandtopic*" [timers]]} {timer $w5tstpcinterval w5tsrandtopic}
  }
}

#### Binded procs ####

proc w5tspublocktopic {nick uhost handle channel onoff} {
  global w5tspublockusage w5tstlflag w5tstopcsetting w5tslockcmd

  if {([validuser $handle]) && ([w5tscheckflags $handle $channel])} {
    set onoff [string trim $onoff]

    if {($onoff != 0) && ($onoff != 1)} {
      puthelp "NOTICE $nick :$w5tspublockusage"
      return 0
    }
    if {$onoff == 1} {set option "+"} else {set option "-"}
    channel set $channel $option$w5tstlflag
    if {$onoff == 0} {putcmdlog "<<$nick>> !$handle! $w5tslockcmd $channel 0"}
    if {$onoff == 1} {
      channel set $channel $w5tstopcsetting [topic $channel]
      putcmdlog "<<$nick>> !$handle! $w5tslockcmd $channel 1"
    }
  }
  return 0
}

proc w5tspubrandtopic {nick uhost handle channel onoff} {
  global w5tspubrandusage w5tsrtflag w5tsrandcmd

  if {([validuser $handle]) && ([w5tscheckflags $handle $channel])} {
    set onoff [string trim $onoff]

    if {($onoff != 0) && ($onoff != 1)} {
      puthelp "NOTICE $nick :$w5tspubrandusage"
      return 0
    }
    if {$onoff == 1} {set option "+"} else {set option "-"}
    channel set $channel $option$w5tsrtflag
    putcmdlog "<<$nick>> !$handle! $w5tsrandcmd $channel $onoff"
  }
  return 0
}

proc w5tspubtopic {nick uhost handle channel topic} {
  global w5tstlflag w5tstopcsetting w5tstopccmd w5tspubtopcusage

  if {([validuser $handle]) && ([w5tscheckflags $handle $channel])} {
    if {$topic == ""} {set topic [w5tsgetrandtopic $channel]}
    if {$topic == ""} {
      puthelp "NOTICE $nick :$w5tspubtopcusage"
      return 0
    }
    if {[channel get $channel $w5tstlflag] != 0} {channel set $channel $w5tstopcsetting $topic}
    if {[w5tscanchangetopic $channel]} {putserv "TOPIC $channel :$topic"}
    w5tssavetopic $channel $topic
    putcmdlog "<<$nick>> !$handle! $w5tstopccmd $channel $topic"
  }
  return 0
}

proc w5tsmsglocktopic {nick uhost handle txt} {
  global w5tsmsglockusage w5tstlflag w5tstopcsetting w5tslockcmd

  set pass [lindex $txt 0]
  set chan [lindex $txt 1]
  set onoff [lindex $txt 2]

  if {([validuser $handle]) && ([passwdok $handle $pass]) && ([w5tscheckflags $handle $chan]) && ([validchan $chan])} {
    if {($onoff != 0) && ($onoff != 1)} {
      puthelp "NOTICE $nick :$w5tsmsglockusage"
      return 0
    }
    if {$onoff == 1} {set option "+"} else {set option "-"}
    channel set $chan $option$w5tstlflag
    if {$onoff == 0} {putcmdlog "($nick!$uhost) !$handle! $w5tslockcmd $chan 0"}
    if {$onoff == 1} {
      channel set $chan $w5tstopcsetting [topic $chan]
      putcmdlog "($nick!$uhost) !$handle! $w5tslockcmd $chan 1"
    }
  }
  return 0
}

proc w5tsmsgrandtopic {nick uhost handle txt} {
  global w5tsmsgrandusage w5tsrtflag w5tsrandcmd

  set pass [lindex $txt 0]
  set chan [lindex $txt 1]
  set onoff [lindex $txt 2]

  if {([validuser $handle]) && ([passwdok $handle $pass]) && ([w5tscheckflags $handle $chan]) && ([validchan $chan])} {
    if {($onoff != 0) && ($onoff != 1)} {
      puthelp "NOTICE $nick :$w5tsmsgrandusage"
      return 0
    }
    if {$onoff == 1} {set option "+"} else {set option "-"}
    channel set $chan $option$w5tsrtflag
    putcmdlog "($nick!$uhost) !$handle! $w5tsrandcmd $chan $onoff"
  }
  return 0
}

proc w5tsmsgtopic {nick uhost handle txt} {
  global w5tstlflag w5tstopcsetting w5tstopccmd w5tsmsgtopcusage

  set pass [lindex $txt 0]
  set chan [lindex $txt 1]
  set topc [lrange $txt 2 end]

  if {([validuser $handle]) && ([passwdok $handle $pass]) && ([w5tscheckflags $handle $chan])} {
    if {$topc == ""} {set topc [w5tsgetrandtopic $chan]}
    if {$topc == ""} {
      puthelp "NOTICE $nick :$w5tsmsgtopcusage"
      return 0
    }
    if {[channel get $chan $w5tstlflag] != 0} {channel set $chan $w5tstopcsetting $topc}
    if {[w5tscanchangetopic $chan]} {putserv "TOPIC $chan :$topc"}
    w5tssavetopic $chan $topc
    putcmdlog "<<$nick>> !$handle! $w5tstopccmd $chan $topc"
  }
}

proc w5tsdcclocktopic {handle idx txt} {
  global w5tsdcclockusage w5tstlflag w5tstopcsetting w5tslockcmd

  set chan [lindex $txt 0]
  set onoff [lindex $txt 1]

  if {([validuser $handle]) && ([w5tscheckflags $handle $chan]) && ([validchan $chan])} {
    if {($onoff != 0) && ($onoff != 1)} {
      putdcc $idx $w5tsdcclockusage
      return 0
    }
    if {$onoff == 1} {set option "+"} else {set option "-"}
    channel set $chan $option$w5tstlflag
    if {$onoff == 0} {putcmdlog "#$handle# $w5tslockcmd $chan 0"}
    if {$onoff == 1} {
      channel set $chan $w5tstopcsetting [topic $chan]
      putcmdlog "#$handle# $w5tslockcmd $chan 1"
    }
  }
  return 0
}

proc w5tsdccrandtopic {handle idx txt} {
  global w5tsdccrandusage w5tsrtflag w5tsrandcmd

  set chan [lindex $txt 0]
  set onoff [lindex $txt 1]

  if {([validuser $handle]) && ([w5tscheckflags $handle $chan]) && ([validchan $chan])} {
    if {($onoff != 0) && ($onoff != 1)} {
      putdcc $idx $w5tsdccrandusage
      return 0
    }
    if {$onoff == 1} {set option "+"} else {set option "-"}
    channel set $chan $option$w5tsrtflag
    putcmdlog "#$handle# $w5tsrandcmd $chan $onoff"
  }
  return 0
}

proc w5tsdcctopic {handle idx txt} {
  global w5tstlflag w5tstopcsetting w5tstopccmd w5tsdcctopcusage

  set chan [lindex $txt 0]
  set topc [lrange $txt 1 end]

  if {([validuser $handle]) && ([w5tscheckflags $handle $chan])} {
    if {$topc == ""} {set topc [w5tsgetrandtopic $chan]}
    if {$topc == ""} {
      putdcc $idx $w5tsdcctopcusage
      return 0
    }
    if {[channel get $chan $w5tstlflag] != 0} {channel set $chan $w5tstopcsetting $topc}
    if {[w5tscanchangetopic $chan]} {putserv "TOPIC $chan :$topc"}
    w5tssavetopic $chan $topc
    putcmdlog "#$handle# $w5tstopccmd $chan $topc"
  }
}

proc w5tstopcproc {nick uhost handle channel topic} {
  global botnick w5tstlflag w5tstopcmsg w5tstopcsetting w5tswarnsetting w5tswarn w5tskick w5tskickreason w5tsban w5tsbantime botnet-nick

  if {[channel get $channel $w5tstlflag] != 0} {
    if {$nick != $botnick} {
      if {!(([validuser $handle]) && ([w5tscheckflags $handle $channel]))} {
        puthelp "NOTICE $nick :$w5tstopcmsg"
        putcmdlog "<<$nick>> $handle tried to change topic on a locked channel"
        if {[w5tscanchangetopic $channel]} {putserv "TOPIC $channel :[channel get $channel $w5tstopcsetting]"}
        if {$w5tskick == 1} {
          set wantkick 1
          if {$w5tswarn != 0} {
            set warns [channel get $channel $w5tswarnsetting]
            set newwarns {}
            set gotit 0
            for {set i 0} {$i < [llength $warns]} {incr i} {
              set tmp [lindex $warns $i]
              set nuh [lindex $tmp 0]
              set num [lindex $tmp 1]
              if {$nuh == "$nick!$uhost"} {
                if {$num == $w5tswarn} {
                  set wantkick 1
                } else {
                  set newwarns [lappend newwarns [list $nuh [incr num]]]
                  set wantkick 0
                }
                set gotit 1
              } else {set newwarns [lappend newwarns $tmp]}
            }
            if {$gotit == 0} {set newwarns [lappend newwarns "$nick!$uhost 1"]}
            channel set $channel $w5tswarnsetting $newwarns
          }
          if {$wantkick == 1} {
            putkick $channel $nick $w5tskickreason
            if {$w5tsban == 1} {newchanban $channel "$nick!$uhost" ${botnet-nick} $w5tskickreason $w5tsbantime}
          }
        }
      } else {
        w5tssavetopic $channel $topic
        if {[w5tscanchangetopic $channel]} {putserv "TOPIC $channel :[channel get $channel $w5tstopcsetting]"}
      }
    }
  } else {w5tssavetopic $channel $topic}
  return 0
}

proc w5tspubretr {nick uhost handle channel txt} {
  global w5tssettinginfo w5tstlflag w5tsrtflag w5tsonstr w5tsoffstr

  set chan $channel
  set l [channel get $chan $w5tstlflag]
  if {$l == 0} {set lock $w5tsoffstr} else {set lock $w5tsonstr}
  set r [channel get $chan $w5tsrtflag]
  if {$r == 0} {set rand $w5tsoffstr} else {set rand $w5tsonstr}

  puthelp "NOTICE $nick :[subst $w5tssettinginfo]"
}

proc w5tsmsgretr {nick uhost handle txt } {
  global w5tssettinginfo w5tstlflag w5tsrtflag w5tsonstr w5tsoffstr

  if {$txt == ""} {
    foreach chan [channels] {
      set l [channel get $chan $w5tstlflag]
      if {$l == 0} {set lock $w5tsoffstr} else {set lock $w5tsonstr}
      set r [channel get $chan $w5tsrtflag]
      if {$r == 0} {set rand $w5tsoffstr} else {set rand $w5tsonstr}

      puthelp "NOTICE $nick :[subst $w5tssettinginfo]"
    }
  } else {
    set chan [lindex $txt 0]

    if {[validchan $chan]} {
      set l [channel get $chan $w5tstlflag]
      if {$l == 0} {set lock $w5tsoffstr} else {set lock $w5tsonstr}
      set r [channel get $chan $w5tsrtflag]
      if {$r == 0} {set rand $w5tsoffstr} else {set rand $w5tsonstr}

      puthelp "NOTICE $nick :[subst $w5tssettinginfo]"
    }
  }
}

proc w5tsdccretr {handle idx txt} {
  global w5tssettinginfo w5tstlflag w5tsrtflag w5tsonstr w5tsoffstr

  if {$txt == ""} {
    foreach chan [channels] {
      set l [channel get $chan $w5tstlflag]
      if {$l == 0} {set lock $w5tsoffstr} else {set lock $w5tsonstr}
      set r [channel get $chan $w5tsrtflag]
      if {$r == 0} {set rand $w5tsoffstr} else {set rand $w5tsonstr}

      putdcc $idx [subst $w5tssettinginfo]
    }
  } else {
    set chan [lindex $txt 0]

    if {[validchan $chan]} {
      set l [channel get $chan $w5tstlflag]
      if {$l == 0} {set lock $w5tsoffstr} else {set lock $w5tsonstr}
      set r [channel get $chan $w5tsrtflag]
      if {$r == 0} {set rand $w5tsoffstr} else {set rand $w5tsonstr}

      putdcc $idx [subst $w5tssettinginfo]
    }
  }
}

if {$w5tstpcinterval == "r"} {
  if {$w5tstimemax < $w5tstimemin} {
    set a $w5tstimemin
    set w5tstimemin $w5tstimemax
    set w5tstimemax $a
  }
  set interval [expr [rand [expr $w5tstimemax - $w5tstimemin]] + $w5tstimemin]
  if {![string match "*w5tsrandtopic*" [timers]]} {timer $interval w5tsrandtopic}
} elseif {[string is digit $w5tstpcinterval]} {
  if {![string match "*w5tsrandtopic*" [timers]]} {timer $w5tstpcinterval w5tsrandtopic}
}

putlog "W5TopicSystem v$w5tsver loaded."

return "W5TopicSystem v$w5tsver loaded."

