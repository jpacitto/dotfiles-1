# 9/10/20 Ben Liepert
# dev machines 
#!/bin/bash
# copy the file
echo "Copying local vimrc to dev2 . . ."
scp ~/.vimrc bliepert@dev2.evr.stratus.com:~/ 
# ssh and patch it
echo "Patching remote vimrc on dev2 with /h/bliepert/vimrc.patch . . ."
ssh bliepert@dev2.evr.stratus.com patch -u /h/bliepert/.vimrc -i /h/bliepert/vimrc.patch 

