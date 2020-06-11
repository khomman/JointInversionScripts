#!/bin/csh

# Groups Receiver functions by ray parameter
cd LF

if ( ! -e rayp45 ) mkdir rayp45
if ( ! -e rayp56 ) mkdir rayp56
if ( ! -e rayp67 ) mkdir rayp67
if ( ! -e rayp78 ) mkdir rayp78

foreach evt (*.eqr)
set rayptmp = `saclst USER8 f $evt | awk '{print $2}'`
set rayp = `echo $rayptmp | awk '{print int(100*$1)}'`

if ($rayp >= 4 && $rayp < 5) then
mv $evt ./rayp45
endif
if ($rayp >= 5 && $rayp < 6) then
mv $evt ./rayp56
endif
if ($rayp >= 6 && $rayp < 7) then
mv $evt ./rayp67
endif
if ($rayp >= 7 && $rayp < 8) then
mv $evt ./rayp78
endif
end

cd ..

############

cd HF

if ( ! -e rayp45 ) mkdir rayp45
if ( ! -e rayp56 ) mkdir rayp56
if ( ! -e rayp67 ) mkdir rayp67
if ( ! -e rayp78 ) mkdir rayp78

foreach evt (*.eqr)
set rayptmp = `saclst USER8 f $evt | awk '{print $2}'`
set rayp = `echo $rayptmp | awk '{print int(100*$1)}'`

if ($rayp >= 4 && $rayp < 5) then
mv $evt ./rayp45
endif
if ($rayp >= 5 && $rayp < 6) then
mv $evt ./rayp56
endif
if ($rayp >= 6 && $rayp < 7) then
mv $evt ./rayp67
endif
if ($rayp >= 7 && $rayp < 8) then
mv $evt ./rayp78
endif
end

cd ..

#################

cd FF

if ( ! -e rayp45 ) mkdir rayp45
if ( ! -e rayp56 ) mkdir rayp56
if ( ! -e rayp67 ) mkdir rayp67
if ( ! -e rayp78 ) mkdir rayp78

foreach evt (*.eqr)
set rayptmp = `saclst USER8 f $evt | awk '{print $2}'`
set rayp = `echo $rayptmp | awk '{print int(100*$1)}'`

if ($rayp >= 4 && $rayp < 5) then
mv $evt ./rayp45
endif
if ($rayp >= 5 && $rayp < 6) then
mv $evt ./rayp56
endif
if ($rayp >= 6 && $rayp < 7) then
mv $evt ./rayp67
endif
if ($rayp >= 7 && $rayp < 8) then
mv $evt ./rayp78
endif
end

cd ..
