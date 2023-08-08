# SPI_Protocol_for_FPGA

## SPI Protocol with inbuild OLED Display of ZedBoard

128 x 32 pixel
1. SCLK (Serial Clk)     --> AB12
2. SDIN/MOSI(Serial Data)--> AA12
3. D/C# (Data/Command)   --> U10 ....................
4. CS# (Chip Select)     --> Pulled Down
5. RES# (Reset)          --> U9

### Specifications of Timing
![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/ef06b91e-bc25-488e-88a8-a55d4c45a4ac)

### Timing Diagram
![image](https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/8231d6e8-4dc2-4377-b4da-9a2c25e628f6)

  Master Should Start data sending at falling edge

  Slave will sense data at rizing edge of clk
