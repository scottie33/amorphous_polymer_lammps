#!/bin/bash

cat template_readme.dat > _posts/2013-04-23-npc-system-step-by-step.md
cat /Users/scottie33/working/amorphous_polymer/tools/run.all/perfect/README.md >> _posts/2013-04-23-npc-system-step-by-step.md
git add .
git commit -m "readme renewed"
git push origin master
