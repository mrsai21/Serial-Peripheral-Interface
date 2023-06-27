# Serial-Peripheral-Interface
Serial Peripheral Interface (SPI): 
1.	Serial peripheral interface (SPI) is one of the most widely used interfaces between microcontroller and peripheral ICs such as sensors, ADCs, DACs, shift registers, SRAM, and others.
2.	SPI is a synchronous protocol that allows a master device to initiate communication with a slave device.
3.	SPI transfer, data is simultaneously transmitted (shifted out serially) and received (shifted in serially).

SPI Master core Architecture:
1.Top Module
Creating a fully functional SPI master core requires careful attention paid to its underlying framework - namely its combination of Wishbone Master and Slave components. 
Communication between these systems depends heavily upon two designated transmission lines: MOSI facilitates exchanges between the master and slave while MISO handles communications in the opposite direction. When utilizing a slave without a corresponding master entity MOSI is classified as Serial Data In (SDI) while MISO becomes Serial Data Out (SDO). 
 
The architecture for SPI protocol is detailed thoroughly in the diagram below highlighting how all these diverse components work together to achieve one cohesive system for both masters and slaves.
SPI top module consists of three building blocks they are:
1.	Clock Generator
2.	Shift Register Interface
3.	Wishbone Interface



2.Clock Generator:
 
It consists the inputs                                      outputs
1.	wb_clk_in                                         1. sclk_out
2.	wb_rst				                                    2. cpol_0
3.	ip				                                        3. cpol_1
4.	go
5.	last_clk
6.	divide [7:0]
The CLK synchronizes the master output with the sampling bits of a slave. For every clock cycle, a single bit of data will be transmitted where the data transmission speed is known as the clock signal frequency. Always, the communication in SPI devices is started by the master as it generates the clock signal.
Clock polarity decides the clock signal polarity. Using an inverter, the polarities can be altered. CPOL indicates that the clock signal’s base value is ‘0’ so that the idle state is ‘0’ and the active is ‘1’.
•	When the clock edge is ‘0’, data transmission happens at the time of the LOW to HIGH transition. This indicates leading and trailing edges correspond to rising and falling edges.
•	When the clock edge is ‘1’, data transmission happens at the time of the HIGH to LOW transition. This indicates leading and trailing edges correspond to falling and rising edges.
The clock phase decides the data timing corresponding to clock pulses. CPHA indicates that the clock signal’s base value is ‘1’ so that the idle state is ‘1’ and the active is ‘0’.
•	When the clock edge is ‘0’, data transmission happens at the time of the HIGH to LOW transition.
•	When the clock edge is ‘1’, data transmission happens at the time of the LOW to HIGH transition.
3.Shift Register:
 
At every clock cycle, transmission happens in a full-duplex way where transmits one-bit using the MOSI line and slave reads that bit. In the same slave transmits one bit using the MISO line and the master reads that bit. This approach is continued even for one-directional data transmission.
Data transmissions usually require two 8-bit shift registers one for the master and the other for the slave where these registers are connected in the form of the virtual ring. Data transmission from master to slave initially happens with MSB bit. On clock edge, both the slave and master send out a bit through the transmission line. On the successive clock edge, at the receiver end, the transmitted bit gets sampled from the transmission line and sets as a new LSB of the shift register.
This functionality is explained in the below SPI protocol block diagram.
 
4.Slave:
Slave Select (ss)
 
Master can select to which slave it can start communication by making slave select signal to voltage level ‘0’ on the select line. In the idle/no-transmission state, the slave selects signal moves to voltage level ‘1’. When there are multiple slaves select pins, then multiple slaves are in parallel connection. Whereas when a single slave select pin is present, then multiple slaves are connected to the master. 
MISO and MOSI:
The master transmits data to the slave in a bit-by-bit manner using the MOSI line. The slave receives information from a master at the MOSI pin. Data transmission from master to slave is initiated with MSB bit.
The slave signal can also transmit data to the master using the MISO line. Data transmission from slave to master is initiated with the LSB bit.
