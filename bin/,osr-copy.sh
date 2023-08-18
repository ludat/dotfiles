#!/bin/bash

maim -us | tesseract -l eng+spa - - | xclip -selection clipboard
