#!/bin/bash
# Description: install https://github.com/jflesch/paperwork - paper document scanning/OCR/search/management
sudo aptitude install python3-pip python3-setuptools python3-dev python3-pil libenchant-dev python3-whoosh tesseract-ocr tesseract-ocr-fra && pip3 install paperwork && paperwork-shell chkdeps paperwork_backend && paperwork-shell chkdeps paperwork && ~/.local/bin/paperwork-shell install
echo "[INFO]: run paperwork from ~/.local/bin/paperwork"