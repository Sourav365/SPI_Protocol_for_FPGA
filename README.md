# SPI_Protocol_for_FPGA

## SPI Protocol with inbuild OLED Display of ZedBoard

128 x 32 pixel
1. SCLK (Serial Clk)     --> AB12
2. SDIN/MOSI(Serial Data)--> AA12
3. D/C# (Data/Command)   --> U10 
4. CS# (Chip Select)     --> Pulled Down
5. RES# (Reset)          --> U9

### Specifications of Timing
![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/ef06b91e-bc25-488e-88a8-a55d4c45a4ac)

### Timing Diagram
![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/8231d6e8-4dc2-4377-b4da-9a2c25e628f6)

  Master Should Start data sending at the falling edge of clk

  Slave will sense data at the rising edge of clk

### Output of Verilog code
<img width="714" alt="image" src="https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/df9ed116-2f1c-4172-a9d3-4d1dd09a8b1e">

**data_sent** signal becomes _HIGH_ as long as it doesn't receive any **load_data** signal.

But here, after the **data_sent** signal is high, it continuously sends the last bit, as the **spi_clk** is running continuously.
We've to make idle the **spi_clk** after the **data_sent** signal is high. --> Using clk gatting

<img width="934" alt="image" src="https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/c83e5ac0-8eae-4d65-99db-a8d6245ca86b">



## OLED Interfacing

OLED has 4 pages.

![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/69d06da0-c56a-428a-a0c5-f2f8281124c8)

Each page has 128 segments and 8 columns. 

![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/8feefbd5-6054-4aa7-8f3b-9dcf50a1a868)

Display data is stored in Graphic Display Data RAM (GDRAM). So memory size = 32x128

The extra pin D/C# (Data/Command) tells whether we're sending commands (page no, column no, en/di display...) or data to display.

### Initializing the display
![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/49c897df-ecf3-4038-b945-52281b430805)


<img width="931" alt="image" src="https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/f46ff7f3-e65c-4491-8d04-64cc6a8e9275">

## Output at ILA Debugging tool

Setup



<img width="655" alt="image" src="https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/13888193-6e7f-4307-bdf0-9df92c7d727c">

<img width="701" alt="image" src="https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/681ab410-2cf9-4a1d-ac82-704425b6b940">

![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/55405cc7-9aa2-4095-9c56-4fbdab56ab45)
