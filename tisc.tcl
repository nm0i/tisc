#!/usr/bin/tclsh

set cookiePath "~/.local/share/qutebrowser/webengine/Cookies"

cd [file dirname [file normalize [info script]]]

package require sqlite3
sqlite db $cookiePath

if {[catch {
    set allowListFile [open allow.txt r]}
    ]} {
    puts "Could not open allow.txt."
    exit
}
set allowList [read $allowListFile]
close $allowListFile

set allowRegexp [string map {\n | . \\.} $allowList]
set allowRegexp [regsub -all {\|+$} $allowRegexp {}]

puts $allowRegexp

db eval {DELETE FROM cookies WHERE host_key NOT REGEXP :allowRegexp}
db close

