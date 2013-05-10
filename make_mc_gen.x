#!/bin/bash

echo " for in some architecture, command: gcc mc_gen.c -o mc_gen.c "
echo " does not work very well, but you can still try."
echo " do not forget to try this in case all failed..."

gcc -c mc_gen.c
gcc -o mc_gen mc_gen.o -lm &
chmod +x mc_gen
echo "#!/bin/bash" > mc_gen.bash
echo "MALLOC_CHECK_=0 ./mc_gen" >> mc_gen.bash
chmod +x mc_gen
chmod +x mc_gen.bash

