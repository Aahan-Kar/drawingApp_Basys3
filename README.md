# Drawing App for Basys3

![Drawing App Screenshot](https://github.com/Aahan-Kar/drawingApp_Basys3/blob/main/output.png)

## Features
This drawing app allows users to draw on a VGA display using the Basys3 FPGA board.  
Users can move a cursor with buttons and draw pixels in real-time, creating simple graphics.  

- **VGA Display:** 640x480 resolution, 60 Hz refresh rate
- **Cursor movement** using directional buttons (`Up`, `Down`, `Left`, `Right`), internal counters track `x` and `y` positions
- Draw pixels that **persist** on the screen
- Switch-controlled colors for the pixels
- Pixels remain on-screen while moving the cursor

## Credits & Attributions

- Master XDC file sourced from the University of Oklahoma: [Master XDC file](https://www.nhn.ou.edu/~bumm/ELAB/download/Basys3_Master.xdc)
- Implemented VGA circuit from Diligent Basys3 Reference Manual: [Basys3 Reference Manual](https://digilent.com/reference/programmable-logic/basys-3/reference-manual)
- Used lectures from Dr. Li's CE433 class from Fort Lewis College in Durango, Colorado to understand VGA: [CE433 Embedded Devices - VGA on the Basys 3 FPGA Board](https://www.youtube.com/watch?v=cVUyfFdK-ZA)
