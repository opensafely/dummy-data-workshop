echo "alias update_r=./scripts/configure_r_image.sh" >> /home/rstudio/.bashrc

grep -q "Run update_r" /home/rstudio/.bashrc
if [ $? -eq 1 ]; then
    echo "cat ./scripts/update_r_instructions" >> /home/rstudio/.bashrc
fi

source /home/rstudio/.bashrc
