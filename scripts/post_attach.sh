#!/bin/bash

# make sure we have the ehrql image ready to go
opensafely pull ehrql

# Pull and tag replacement R images
./scripts/configure_r_image.sh

# Add an extra instruction and alias for updating the custom R images
echo "alias update_r=./scripts/configure_r_image.sh" >> /home/rstudio/.bashrc

grep -q "Run update_r" /home/rstudio/.bashrc
if [ $? -eq 1 ]; then
    echo "cat ./scripts/update_r_instructions" >> /home/rstudio/.bashrc
fi

source /home/rstudio/.bashrc

# Finally, do the usual postAttach things
/bin/bash /opt/devcontainer/postAttach.sh
