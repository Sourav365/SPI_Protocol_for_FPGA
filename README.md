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

  Master Should Start data sending at the falling edge of clk

  Slave will sense data at the rising edge of clk

### Output of Verilog code
<img width="714" alt="image" src="https://github.com/Sourav365/SPI_Protocol_for_FPGA/assets/49667585/df9ed116-2f1c-4172-a9d3-4d1dd09a8b1e">

**data_sent** signal becomes _HIGH_ as long as it doesn't receive any **load_data** signal.

But here, after the **data_sent** signal is high, it continuously sends the last bit, as the **spi_clk** is running continuously.
We've to make idle the **spi_clk** after the **data_sent** signal is high. --> Using clk gatting
