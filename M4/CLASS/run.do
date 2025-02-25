if [file exists "work"] {vdel -all}


log /* -r

# Waveform Logging
if {[file exists "wave.do"]} { source wave.do }

run -all

coverage save project.ucdb
vcover report project.ucdb 
vcover report project.ucdb -cvg -details
quit
