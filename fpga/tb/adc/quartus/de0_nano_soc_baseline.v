//--------------------------------------------------------------------------//
// Title:        de0_nano_soc_baseline.v                                       //
// Rev:          Rev 0.1                                                    //
// Last Revised: 09/14/2015                                                 //
//--------------------------------------------------------------------------//
// Description: Baseline design file contains DE0 Nano SoC    				 //
//              Board pins and I/O Standards.                               //
//--------------------------------------------------------------------------//
//Copyright 2015 Altera Corporation. All rights reserved.  Altera products
//are protected under numerous U.S. and foreign patents, maskwork rights,
//copyrights and other intellectual property laws.
//                 
//This reference design file, and your use thereof, is subject to and
//governed by the terms and conditions of the applicable Altera Reference
//Design License Agreement.  By using this reference design file, you
//indicate your acceptance of such terms and conditions between you and
//Altera Corporation.  In the event that you do not agree with such terms and
//conditions, you may not use the reference design file. Please promptly                         
//destroy any copies you have made.
//
//This reference design file being provided on an "as-is" basis and as an
//accommodation and therefore all warranties, representations or guarantees
//of any kind (whether express, implied or statutory) including, without
//limitation, warranties of merchantability, non-infringement, or fitness for
//a particular purpose, are specifically disclaimed.  By making this
//reference design file available, Altera expressly does not recommend,
//suggest or require that this reference design file be used in combination 
//with any other product not provided by Altera
//----------------------------------------------------------------------------

//Group Enable Definitions
//This lists every pinout group
//Users can enable any group by uncommenting the corresponding line below:
//`define enable_ADC
`define enable_ARDUINO
//`define enable_gpio0
//`define enable_gpio1
`define enable_HPS

module de0_nano_soc_baseline(


	//////////// CLOCK //////////
	input 		          		FPGA_CLK_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,

`ifdef enable_ADC
	//////////// ADC //////////
	/* 3.3-V LVTTL */
	output		          		ADC_CONVST,
	output		          		ADC_SCLK,
	output		          		ADC_SDI,
	input 		          		ADC_SDO,
`endif
	
`ifdef enable_ARDUINO
	//////////// ARDUINO ////////////
	/* 3.3-V LVTTL */
	inout					[15:0]	ARDUINO_IO,
	inout								ARDUINO_RESET_N,
`endif
	
`ifdef enable_GPIO0
	//////////// gpio 0 ////////////
	/* 3.3-V LVTTL */
	inout				[35:0]		GPIO_0,
`endif

`ifdef enable_GPIO1	
	//////////// gpio 1 ////////////
	/* 3.3-V LVTTL */
	inout				[35:0]		GPIO_1,
`endif

`ifdef enable_HPS
	//////////// HPS //////////
	/* 3.3-V LVTTL */
	inout 		          		HPS_CONV_USB_N,
	
	/* SSTL-15 Class I */
	output		    [14:0]		HPS_DDR3_ADDR,
	output		     [2:0]		HPS_DDR3_BA,
	output		          		HPS_DDR3_CAS_N,
	output		          		HPS_DDR3_CKE,
	output		          		HPS_DDR3_CS_N,
	output		     [3:0]		HPS_DDR3_DM,
	inout 		    [31:0]		HPS_DDR3_DQ,
	output		          		HPS_DDR3_ODT,
	output		          		HPS_DDR3_RAS_N,
	output		          		HPS_DDR3_RESET_N,
	input 		          		HPS_DDR3_RZQ,
	output		          		HPS_DDR3_WE_N,
	/* DIFFERENTIAL 1.5-V SSTL CLASS I */
	output		          		HPS_DDR3_CK_N,
	output		          		HPS_DDR3_CK_P,
	inout 		     [3:0]		HPS_DDR3_DQS_N,
	inout 		     [3:0]		HPS_DDR3_DQS_P,
	
	/* 3.3-V LVTTL */
	output		          		HPS_ENET_GTX_CLK,
	inout 		          		HPS_ENET_INT_N,
	output		          		HPS_ENET_MDC,
	inout 		          		HPS_ENET_MDIO,
	input 		          		HPS_ENET_RX_CLK,
	input 		     [3:0]		HPS_ENET_RX_DATA,
	input 		          		HPS_ENET_RX_DV,
	output		     [3:0]		HPS_ENET_TX_DATA,
	output		          		HPS_ENET_TX_EN,
	inout 		          		HPS_GSENSOR_INT,
	inout 		          		HPS_I2C0_SCLK,
	inout 		          		HPS_I2C0_SDAT,
	inout 		          		HPS_I2C1_SCLK,
	inout 		          		HPS_I2C1_SDAT,
	inout 		          		HPS_KEY,
	inout 		          		HPS_LED,
	inout 		          		HPS_LTC_GPIO,
	output		          		HPS_SD_CLK,
	inout 		          		HPS_SD_CMD,
	inout 		     [3:0]		HPS_SD_DATA,
	output		          		HPS_SPIM_CLK,
	input 		          		HPS_SPIM_MISO,
	output		          		HPS_SPIM_MOSI,
	inout 		          		HPS_SPIM_SS,
	input 		          		HPS_UART_RX,
	output		          		HPS_UART_TX,
	input 		          		HPS_USB_CLKOUT,
	inout 		     [7:0]		HPS_USB_DATA,
	input 		          		HPS_USB_DIR,
	input 		          		HPS_USB_NXT,
	output		          		HPS_USB_STP,
`endif
	
	//////////// KEY ////////////
	/* 3.3-V LVTTL */
	input				[1:0]			KEY,
	
	//////////// LED ////////////
	/* 3.3-V LVTTL */
	output			[7:0]			LED,
	
	//////////// SW ////////////
	/* 3.3-V LVTTL */
	input				[3:0]			SW

);


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire hps_fpga_reset_n;
wire     [1: 0]     fpga_debounced_buttons;
wire     [6: 0]     fpga_led_internal;
wire     [2: 0]     hps_reset_req;
wire                hps_cold_reset;
wire                hps_warm_reset;
wire                hps_debug_reset;
wire     [27: 0]    stm_hw_events;
wire                fpga_clk_50;
// connection of internal logics
assign LED[7: 1]     = fpga_led_internal;
assign fpga_clk_50   = FPGA_CLK1_50;
assign stm_hw_events = {{15{1'b0}}, SW, fpga_led_internal, fpga_debounced_buttons};

soc_system u0 (
    .clk_clk                               (FPGA_CLK_50),                               //                       clk.clk
    .reset_reset_n                         (hps_fpga_reset_n),                         //                     reset.reset_n

    // HPS ethernet
    .hps_0_hps_io_hps_io_emac1_inst_tx_clk(HPS_ENET_GTX_CLK),    //                   hps_0_hps_io.hps_io_emac1_inst_TX_CLK
    .hps_0_hps_io_hps_io_emac1_inst_txd0(HPS_ENET_TX_DATA[0]),   //                               .hps_io_emac1_inst_txd0
    .hps_0_hps_io_hps_io_emac1_inst_txd1(HPS_ENET_TX_DATA[1]),   //                               .hps_io_emac1_inst_txd1
    .hps_0_hps_io_hps_io_emac1_inst_txd2(HPS_ENET_TX_DATA[2]),   //                               .hps_io_emac1_inst_txd2
    .hps_0_hps_io_hps_io_emac1_inst_txd3(HPS_ENET_TX_DATA[3]),   //                               .hps_io_emac1_inst_txd3
    .hps_0_hps_io_hps_io_emac1_inst_rxd0(HPS_ENET_RX_DATA[0]),   //                               .hps_io_emac1_inst_rxd0
    .hps_0_hps_io_hps_io_emac1_inst_mdio(HPS_ENET_MDIO),         //                               .hps_io_emac1_inst_MDIO
    .hps_0_hps_io_hps_io_emac1_inst_mdc(HPS_ENET_MDC),           //                               .hps_io_emac1_inst_MDC
    .hps_0_hps_io_hps_io_emac1_inst_rx_ctl(HPS_ENET_RX_DV),      //                               .hps_io_emac1_inst_RX_CTL
    .hps_0_hps_io_hps_io_emac1_inst_tx_ctl(HPS_ENET_TX_EN),      //                               .hps_io_emac1_inst_TX_CTL
    .hps_0_hps_io_hps_io_emac1_inst_rx_clk(HPS_ENET_RX_CLK),     //                               .hps_io_emac1_inst_RX_CLK
    .hps_0_hps_io_hps_io_emac1_inst_rxd1(HPS_ENET_RX_DATA[1]),   //                               .hps_io_emac1_inst_rxd1
    .hps_0_hps_io_hps_io_emac1_inst_rxd2(HPS_ENET_RX_DATA[2]),   //                               .hps_io_emac1_inst_rxd2
    .hps_0_hps_io_hps_io_emac1_inst_rxd3(HPS_ENET_RX_DATA[3]),   //                               .hps_io_emac1_inst_rxd3
    // HPS SD card
    .hps_0_hps_io_hps_io_sdio_inst_cmd(HPS_SD_CMD),              //                               .hps_io_sdio_inst_CMD
    .hps_0_hps_io_hps_io_sdio_inst_d0(HPS_SD_DATA[0]),           //                               .hps_io_sdio_inst_D0
    .hps_0_hps_io_hps_io_sdio_inst_d1(HPS_SD_DATA[1]),           //                               .hps_io_sdio_inst_D1
    .hps_0_hps_io_hps_io_sdio_inst_clk(HPS_SD_CLK),              //                               .hps_io_sdio_inst_CLK
    .hps_0_hps_io_hps_io_sdio_inst_d2(HPS_SD_DATA[2]),           //                               .hps_io_sdio_inst_D2
    .hps_0_hps_io_hps_io_sdio_inst_d3(HPS_SD_DATA[3]),           //                               .hps_io_sdio_inst_D3
    // HPS USB
    .hps_0_hps_io_hps_io_usb1_inst_d0(HPS_USB_DATA[0]),          //                               .hps_io_usb1_inst_D0
    .hps_0_hps_io_hps_io_usb1_inst_d1(HPS_USB_DATA[1]),          //                               .hps_io_usb1_inst_D1
    .hps_0_hps_io_hps_io_usb1_inst_d2(HPS_USB_DATA[2]),          //                               .hps_io_usb1_inst_D2
    .hps_0_hps_io_hps_io_usb1_inst_d3(HPS_USB_DATA[3]),          //                               .hps_io_usb1_inst_D3
    .hps_0_hps_io_hps_io_usb1_inst_d4(HPS_USB_DATA[4]),          //                               .hps_io_usb1_inst_D4
    .hps_0_hps_io_hps_io_usb1_inst_d5(HPS_USB_DATA[5]),          //                               .hps_io_usb1_inst_D5
    .hps_0_hps_io_hps_io_usb1_inst_d6(HPS_USB_DATA[6]),          //                               .hps_io_usb1_inst_D6
    .hps_0_hps_io_hps_io_usb1_inst_d7(HPS_USB_DATA[7]),          //                               .hps_io_usb1_inst_D7
    .hps_0_hps_io_hps_io_usb1_inst_clk(HPS_USB_CLKOUT),          //                               .hps_io_usb1_inst_CLK
    .hps_0_hps_io_hps_io_usb1_inst_stp(HPS_USB_STP),             //                               .hps_io_usb1_inst_STP
    .hps_0_hps_io_hps_io_usb1_inst_dir(HPS_USB_DIR),             //                               .hps_io_usb1_inst_DIR
    .hps_0_hps_io_hps_io_usb1_inst_nxt(HPS_USB_NXT),             //                               .hps_io_usb1_inst_NXT
    // HPS SPI
    .hps_0_hps_io_hps_io_spim1_inst_clk(HPS_SPIM_CLK),           //                               .hps_io_spim1_inst_CLK
    .hps_0_hps_io_hps_io_spim1_inst_mosi(HPS_SPIM_MOSI),         //                               .hps_io_spim1_inst_MOSI
    .hps_0_hps_io_hps_io_spim1_inst_miso(HPS_SPIM_MISO),         //                               .hps_io_spim1_inst_MISO
    .hps_0_hps_io_hps_io_spim1_inst_ss0(HPS_SPIM_SS),            //                               .hps_io_spim1_inst_SS0
    // HPS UART
    .hps_0_hps_io_hps_io_uart0_inst_rx(HPS_UART_RX),             //                               .hps_io_uart0_inst_RX
    .hps_0_hps_io_hps_io_uart0_inst_tx(HPS_UART_TX),             //                               .hps_io_uart0_inst_TX
    // HPS I2C1
    .hps_0_hps_io_hps_io_i2c0_inst_sda(HPS_I2C0_SDAT),           //                               .hps_io_i2c0_inst_SDA
    .hps_0_hps_io_hps_io_i2c0_inst_scl(HPS_I2C0_SCLK),           //                               .hps_io_i2c0_inst_SCL
    // HPS I2C2
    .hps_0_hps_io_hps_io_i2c1_inst_sda(HPS_I2C1_SDAT),           //                               .hps_io_i2c1_inst_SDA
    .hps_0_hps_io_hps_io_i2c1_inst_scl(HPS_I2C1_SCLK),           //                               .hps_io_i2c1_inst_SCL

    //gpio
    .hps_0_hps_io_hps_io_gpio_inst_gpio09(HPS_CONV_USB_N),       //                               .hps_io_gpio_inst_gpio09
    .hps_0_hps_io_hps_io_gpio_inst_gpio35(HPS_ENET_INT_N),       //                               .hps_io_gpio_inst_gpio35
    .hps_0_hps_io_hps_io_gpio_inst_gpio40(HPS_LTC_GPIO),         //                               .hps_io_gpio_inst_gpio40
    .hps_0_hps_io_hps_io_gpio_inst_gpio53(HPS_LED),              //                               .hps_io_gpio_inst_gpio53
    .hps_0_hps_io_hps_io_gpio_inst_gpio54(HPS_KEY),              //                               .hps_io_gpio_inst_gpio54
    .hps_0_hps_io_hps_io_gpio_inst_gpio61(HPS_GSENSOR_INT),      //                               .hps_io_gpio_inst_gpio61

    .hps_0_h2f_reset_reset_n(hps_fpga_reset_n),                  //                hps_0_h2f_reset.reset_n
    .hps_0_f2h_cold_reset_req_reset_n(~hps_cold_reset),          //       hps_0_f2h_cold_reset_req.reset_n
    .hps_0_f2h_debug_reset_req_reset_n(~hps_debug_reset),        //      hps_0_f2h_debug_reset_req.reset_n
    .hps_0_f2h_stm_hw_events_stm_hwevents(stm_hw_events),        //        hps_0_f2h_stm_hw_events.stm_hwevents
    .hps_0_f2h_warm_reset_req_reset_n(~hps_warm_reset),          //       hps_0_f2h_warm_reset_req.reset_n
    //.ilc_irq_irq                           (<connected-to-ilc_irq_irq>),                           //                   ilc_irq.irq

    // HPS ddr3
    .memory_mem_a(HPS_DDR3_ADDR),                                //                         memory.mem_a
    .memory_mem_ba(HPS_DDR3_BA),                                 //                               .mem_ba
    .memory_mem_ck(HPS_DDR3_CK_P),                               //                               .mem_ck
    .memory_mem_ck_n(HPS_DDR3_CK_N),                             //                               .mem_ck_n
    .memory_mem_cke(HPS_DDR3_CKE),                               //                               .mem_cke
    .memory_mem_cs_n(HPS_DDR3_CS_N),                             //                               .mem_cs_n
    .memory_mem_ras_n(HPS_DDR3_RAS_N),                           //                               .mem_ras_n
    .memory_mem_cas_n(HPS_DDR3_CAS_N),                           //                               .mem_cas_n
    .memory_mem_we_n(HPS_DDR3_WE_N),                             //                               .mem_we_n
    .memory_mem_reset_n(HPS_DDR3_RESET_N),                       //                               .mem_reset_n
    .memory_mem_dq(HPS_DDR3_DQ),                                 //                               .mem_dq
    .memory_mem_dqs(HPS_DDR3_DQS_P),                             //                               .mem_dqs
    .memory_mem_dqs_n(HPS_DDR3_DQS_N),                           //                               .mem_dqs_n
    .memory_mem_odt(HPS_DDR3_ODT),                               //                               .mem_odt
    .memory_mem_dm(HPS_DDR3_DM),                                 //                               .mem_dm
    .memory_oct_rzqin(HPS_DDR3_RZQ),                             //                               .oct_rzqin

    
    .adc_ports_clkr                        (<connected-to-adc_ports_clkr>),                        //                 adc_ports.clkr
    .adc_ports_clkkx                       (<connected-to-adc_ports_clkkx>),                       //                          .clkkx
    .adc_ports_drdy_n                      (<connected-to-adc_ports_drdy_n>),                      //                          .drdy_n
    .adc_ports_drr                         (<connected-to-adc_ports_drr>),                         //                          .drr
    .adc_ports_fsr                         (<connected-to-adc_ports_fsr>),                         //                          .fsr
    .adc_ports_writeresponsevalid_n        (<connected-to-adc_ports_writeresponsevalid_n>),        //                          .writeresponsevalid_n
    .adc_ports_start                       (<connected-to-adc_ports_start>)                        //                          .start
);

// Source/Probe megawizard instance
hps_reset hps_reset_inst(
    .source_clk(fpga_clk_50),
    .source(hps_reset_req)
);

altera_edge_detector pulse_cold_reset(
    .clk(fpga_clk_50),
    .rst_n(hps_fpga_reset_n),
    .signal_in(hps_reset_req[0]),
    .pulse_out(hps_cold_reset)
);
defparam pulse_cold_reset.PULSE_EXT = 6;
defparam pulse_cold_reset.EDGE_TYPE = 1;
defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset(
    .clk(fpga_clk_50),
    .rst_n(hps_fpga_reset_n),
    .signal_in(hps_reset_req[1]),
    .pulse_out(hps_warm_reset)
);
defparam pulse_warm_reset.PULSE_EXT = 2;
defparam pulse_warm_reset.EDGE_TYPE = 1;
defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_debug_reset(
    .clk(fpga_clk_50),
    .rst_n(hps_fpga_reset_n),
    .signal_in(hps_reset_req[2]),
    .pulse_out(hps_debug_reset)
);
defparam pulse_debug_reset.PULSE_EXT = 32;
defparam pulse_debug_reset.EDGE_TYPE = 1;
defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;

endmodule
