#!/usr/bin/sh

cp .config  .saved_pre_glar150.config
sed -i 's/.*CONFIG_TARGET_ar71xx_generic_GL_AR150.*//g' .config

echo "CONFIG_TARGET_ar71xx_generic_gl_ar150=y" >> .config
