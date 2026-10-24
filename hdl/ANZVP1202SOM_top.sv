//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Sun Oct 18 00:20:01 2026
//Host        : homepc running 64-bit major release  (build 9200)
//Command     : generate_target ANZVP1202SOM_top.bd
//Design      : ANZVP1202SOM_top
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ANZVP1202SOM_top
     (Bank106_GT_REFCLK_clk_n,
    Bank106_GT_REFCLK_clk_p,
    Bank200_GT_REFCLK_clk_n,
    Bank200_GT_REFCLK_clk_p,
    LPDDR4_CLK1_clk_n,
    LPDDR4_CLK1_clk_p,
    LPDDR4_CLK2_clk_n,
    LPDDR4_CLK2_clk_p,
    LPDDR4_CLK3_clk_n,
    LPDDR4_CLK3_clk_p,
    PL_GPIO_tri_io,
    PL_UART_rxd,
    PL_UART_txd,
    TRIP1_CH0_LPDDR4_ca_a,
    TRIP1_CH0_LPDDR4_ca_b,
    TRIP1_CH0_LPDDR4_ck_c_a,
    TRIP1_CH0_LPDDR4_ck_c_b,
    TRIP1_CH0_LPDDR4_ck_t_a,
    TRIP1_CH0_LPDDR4_ck_t_b,
    TRIP1_CH0_LPDDR4_cke_a,
    TRIP1_CH0_LPDDR4_cke_b,
    TRIP1_CH0_LPDDR4_cs_a,
    TRIP1_CH0_LPDDR4_cs_b,
    TRIP1_CH0_LPDDR4_dmi_a,
    TRIP1_CH0_LPDDR4_dmi_b,
    TRIP1_CH0_LPDDR4_dq_a,
    TRIP1_CH0_LPDDR4_dq_b,
    TRIP1_CH0_LPDDR4_dqs_c_a,
    TRIP1_CH0_LPDDR4_dqs_c_b,
    TRIP1_CH0_LPDDR4_dqs_t_a,
    TRIP1_CH0_LPDDR4_dqs_t_b,
    TRIP1_CH0_LPDDR4_reset_n,
    TRIP1_CH1_LPDDR4_ca_a,
    TRIP1_CH1_LPDDR4_ca_b,
    TRIP1_CH1_LPDDR4_ck_c_a,
    TRIP1_CH1_LPDDR4_ck_c_b,
    TRIP1_CH1_LPDDR4_ck_t_a,
    TRIP1_CH1_LPDDR4_ck_t_b,
    TRIP1_CH1_LPDDR4_cke_a,
    TRIP1_CH1_LPDDR4_cke_b,
    TRIP1_CH1_LPDDR4_cs_a,
    TRIP1_CH1_LPDDR4_cs_b,
    TRIP1_CH1_LPDDR4_dmi_a,
    TRIP1_CH1_LPDDR4_dmi_b,
    TRIP1_CH1_LPDDR4_dq_a,
    TRIP1_CH1_LPDDR4_dq_b,
    TRIP1_CH1_LPDDR4_dqs_c_a,
    TRIP1_CH1_LPDDR4_dqs_c_b,
    TRIP1_CH1_LPDDR4_dqs_t_a,
    TRIP1_CH1_LPDDR4_dqs_t_b,
    TRIP1_CH1_LPDDR4_reset_n,
    TRIP2_CH0_LPDDR4_ca_a,
    TRIP2_CH0_LPDDR4_ca_b,
    TRIP2_CH0_LPDDR4_ck_c_a,
    TRIP2_CH0_LPDDR4_ck_c_b,
    TRIP2_CH0_LPDDR4_ck_t_a,
    TRIP2_CH0_LPDDR4_ck_t_b,
    TRIP2_CH0_LPDDR4_cke_a,
    TRIP2_CH0_LPDDR4_cke_b,
    TRIP2_CH0_LPDDR4_cs_a,
    TRIP2_CH0_LPDDR4_cs_b,
    TRIP2_CH0_LPDDR4_dmi_a,
    TRIP2_CH0_LPDDR4_dmi_b,
    TRIP2_CH0_LPDDR4_dq_a,
    TRIP2_CH0_LPDDR4_dq_b,
    TRIP2_CH0_LPDDR4_dqs_c_a,
    TRIP2_CH0_LPDDR4_dqs_c_b,
    TRIP2_CH0_LPDDR4_dqs_t_a,
    TRIP2_CH0_LPDDR4_dqs_t_b,
    TRIP2_CH0_LPDDR4_reset_n,
    TRIP2_CH1_LPDDR4_ca_a,
    TRIP2_CH1_LPDDR4_ca_b,
    TRIP2_CH1_LPDDR4_ck_c_a,
    TRIP2_CH1_LPDDR4_ck_c_b,
    TRIP2_CH1_LPDDR4_ck_t_a,
    TRIP2_CH1_LPDDR4_ck_t_b,
    TRIP2_CH1_LPDDR4_cke_a,
    TRIP2_CH1_LPDDR4_cke_b,
    TRIP2_CH1_LPDDR4_cs_a,
    TRIP2_CH1_LPDDR4_cs_b,
    TRIP2_CH1_LPDDR4_dmi_a,
    TRIP2_CH1_LPDDR4_dmi_b,
    TRIP2_CH1_LPDDR4_dq_a,
    TRIP2_CH1_LPDDR4_dq_b,
    TRIP2_CH1_LPDDR4_dqs_c_a,
    TRIP2_CH1_LPDDR4_dqs_c_b,
    TRIP2_CH1_LPDDR4_dqs_t_a,
    TRIP2_CH1_LPDDR4_dqs_t_b,
    TRIP2_CH1_LPDDR4_reset_n,
    TRIP3_CH0_LPDDR4_ca_a,
    TRIP3_CH0_LPDDR4_ca_b,
    TRIP3_CH0_LPDDR4_ck_c_a,
    TRIP3_CH0_LPDDR4_ck_c_b,
    TRIP3_CH0_LPDDR4_ck_t_a,
    TRIP3_CH0_LPDDR4_ck_t_b,
    TRIP3_CH0_LPDDR4_cke_a,
    TRIP3_CH0_LPDDR4_cke_b,
    TRIP3_CH0_LPDDR4_cs_a,
    TRIP3_CH0_LPDDR4_cs_b,
    TRIP3_CH0_LPDDR4_dmi_a,
    TRIP3_CH0_LPDDR4_dmi_b,
    TRIP3_CH0_LPDDR4_dq_a,
    TRIP3_CH0_LPDDR4_dq_b,
    TRIP3_CH0_LPDDR4_dqs_c_a,
    TRIP3_CH0_LPDDR4_dqs_c_b,
    TRIP3_CH0_LPDDR4_dqs_t_a,
    TRIP3_CH0_LPDDR4_dqs_t_b,
    TRIP3_CH0_LPDDR4_reset_n,
    TRIP3_CH1_LPDDR4_ca_a,
    TRIP3_CH1_LPDDR4_ca_b,
    TRIP3_CH1_LPDDR4_ck_c_a,
    TRIP3_CH1_LPDDR4_ck_c_b,
    TRIP3_CH1_LPDDR4_ck_t_a,
    TRIP3_CH1_LPDDR4_ck_t_b,
    TRIP3_CH1_LPDDR4_cke_a,
    TRIP3_CH1_LPDDR4_cke_b,
    TRIP3_CH1_LPDDR4_cs_a,
    TRIP3_CH1_LPDDR4_cs_b,
    TRIP3_CH1_LPDDR4_dmi_a,
    TRIP3_CH1_LPDDR4_dmi_b,
    TRIP3_CH1_LPDDR4_dq_a,
    TRIP3_CH1_LPDDR4_dq_b,
    TRIP3_CH1_LPDDR4_dqs_c_a,
    TRIP3_CH1_LPDDR4_dqs_c_b,
    TRIP3_CH1_LPDDR4_dqs_t_a,
    TRIP3_CH1_LPDDR4_dqs_t_b,
    TRIP3_CH1_LPDDR4_reset_n,
    bank106_GT_Serial_grx_n,
    bank106_GT_Serial_grx_p,
    bank106_GT_Serial_gtx_n,
    bank106_GT_Serial_gtx_p,
    bank200_GT_Serial_grx_n,
    bank200_GT_Serial_grx_p,
    bank200_GT_Serial_gtx_n,
    bank200_GT_Serial_gtx_p);
  input [0:0]Bank106_GT_REFCLK_clk_n;
  input [0:0]Bank106_GT_REFCLK_clk_p;
  input [0:0]Bank200_GT_REFCLK_clk_n;
  input [0:0]Bank200_GT_REFCLK_clk_p;
  input [0:0]LPDDR4_CLK1_clk_n;
  input [0:0]LPDDR4_CLK1_clk_p;
  input [0:0]LPDDR4_CLK2_clk_n;
  input [0:0]LPDDR4_CLK2_clk_p;
  input [0:0]LPDDR4_CLK3_clk_n;
  input [0:0]LPDDR4_CLK3_clk_p;
  inout [3:0]PL_GPIO_tri_io;
  input PL_UART_rxd;
  output PL_UART_txd;
  output [5:0]TRIP1_CH0_LPDDR4_ca_a;
  output [5:0]TRIP1_CH0_LPDDR4_ca_b;
  output [0:0]TRIP1_CH0_LPDDR4_ck_c_a;
  output [0:0]TRIP1_CH0_LPDDR4_ck_c_b;
  output [0:0]TRIP1_CH0_LPDDR4_ck_t_a;
  output [0:0]TRIP1_CH0_LPDDR4_ck_t_b;
  output [1:0]TRIP1_CH0_LPDDR4_cke_a;
  output [1:0]TRIP1_CH0_LPDDR4_cke_b;
  output [1:0]TRIP1_CH0_LPDDR4_cs_a;
  output [1:0]TRIP1_CH0_LPDDR4_cs_b;
  inout [1:0]TRIP1_CH0_LPDDR4_dmi_a;
  inout [1:0]TRIP1_CH0_LPDDR4_dmi_b;
  inout [15:0]TRIP1_CH0_LPDDR4_dq_a;
  inout [15:0]TRIP1_CH0_LPDDR4_dq_b;
  inout [1:0]TRIP1_CH0_LPDDR4_dqs_c_a;
  inout [1:0]TRIP1_CH0_LPDDR4_dqs_c_b;
  inout [1:0]TRIP1_CH0_LPDDR4_dqs_t_a;
  inout [1:0]TRIP1_CH0_LPDDR4_dqs_t_b;
  output [0:0]TRIP1_CH0_LPDDR4_reset_n;
  output [5:0]TRIP1_CH1_LPDDR4_ca_a;
  output [5:0]TRIP1_CH1_LPDDR4_ca_b;
  output [0:0]TRIP1_CH1_LPDDR4_ck_c_a;
  output [0:0]TRIP1_CH1_LPDDR4_ck_c_b;
  output [0:0]TRIP1_CH1_LPDDR4_ck_t_a;
  output [0:0]TRIP1_CH1_LPDDR4_ck_t_b;
  output [1:0]TRIP1_CH1_LPDDR4_cke_a;
  output [1:0]TRIP1_CH1_LPDDR4_cke_b;
  output [1:0]TRIP1_CH1_LPDDR4_cs_a;
  output [1:0]TRIP1_CH1_LPDDR4_cs_b;
  inout [1:0]TRIP1_CH1_LPDDR4_dmi_a;
  inout [1:0]TRIP1_CH1_LPDDR4_dmi_b;
  inout [15:0]TRIP1_CH1_LPDDR4_dq_a;
  inout [15:0]TRIP1_CH1_LPDDR4_dq_b;
  inout [1:0]TRIP1_CH1_LPDDR4_dqs_c_a;
  inout [1:0]TRIP1_CH1_LPDDR4_dqs_c_b;
  inout [1:0]TRIP1_CH1_LPDDR4_dqs_t_a;
  inout [1:0]TRIP1_CH1_LPDDR4_dqs_t_b;
  output [0:0]TRIP1_CH1_LPDDR4_reset_n;
  output [5:0]TRIP2_CH0_LPDDR4_ca_a;
  output [5:0]TRIP2_CH0_LPDDR4_ca_b;
  output [0:0]TRIP2_CH0_LPDDR4_ck_c_a;
  output [0:0]TRIP2_CH0_LPDDR4_ck_c_b;
  output [0:0]TRIP2_CH0_LPDDR4_ck_t_a;
  output [0:0]TRIP2_CH0_LPDDR4_ck_t_b;
  output [1:0]TRIP2_CH0_LPDDR4_cke_a;
  output [1:0]TRIP2_CH0_LPDDR4_cke_b;
  output [1:0]TRIP2_CH0_LPDDR4_cs_a;
  output [1:0]TRIP2_CH0_LPDDR4_cs_b;
  inout [1:0]TRIP2_CH0_LPDDR4_dmi_a;
  inout [1:0]TRIP2_CH0_LPDDR4_dmi_b;
  inout [15:0]TRIP2_CH0_LPDDR4_dq_a;
  inout [15:0]TRIP2_CH0_LPDDR4_dq_b;
  inout [1:0]TRIP2_CH0_LPDDR4_dqs_c_a;
  inout [1:0]TRIP2_CH0_LPDDR4_dqs_c_b;
  inout [1:0]TRIP2_CH0_LPDDR4_dqs_t_a;
  inout [1:0]TRIP2_CH0_LPDDR4_dqs_t_b;
  output [0:0]TRIP2_CH0_LPDDR4_reset_n;
  output [5:0]TRIP2_CH1_LPDDR4_ca_a;
  output [5:0]TRIP2_CH1_LPDDR4_ca_b;
  output [0:0]TRIP2_CH1_LPDDR4_ck_c_a;
  output [0:0]TRIP2_CH1_LPDDR4_ck_c_b;
  output [0:0]TRIP2_CH1_LPDDR4_ck_t_a;
  output [0:0]TRIP2_CH1_LPDDR4_ck_t_b;
  output [1:0]TRIP2_CH1_LPDDR4_cke_a;
  output [1:0]TRIP2_CH1_LPDDR4_cke_b;
  output [1:0]TRIP2_CH1_LPDDR4_cs_a;
  output [1:0]TRIP2_CH1_LPDDR4_cs_b;
  inout [1:0]TRIP2_CH1_LPDDR4_dmi_a;
  inout [1:0]TRIP2_CH1_LPDDR4_dmi_b;
  inout [15:0]TRIP2_CH1_LPDDR4_dq_a;
  inout [15:0]TRIP2_CH1_LPDDR4_dq_b;
  inout [1:0]TRIP2_CH1_LPDDR4_dqs_c_a;
  inout [1:0]TRIP2_CH1_LPDDR4_dqs_c_b;
  inout [1:0]TRIP2_CH1_LPDDR4_dqs_t_a;
  inout [1:0]TRIP2_CH1_LPDDR4_dqs_t_b;
  output [0:0]TRIP2_CH1_LPDDR4_reset_n;
  output [5:0]TRIP3_CH0_LPDDR4_ca_a;
  output [5:0]TRIP3_CH0_LPDDR4_ca_b;
  output [0:0]TRIP3_CH0_LPDDR4_ck_c_a;
  output [0:0]TRIP3_CH0_LPDDR4_ck_c_b;
  output [0:0]TRIP3_CH0_LPDDR4_ck_t_a;
  output [0:0]TRIP3_CH0_LPDDR4_ck_t_b;
  output [1:0]TRIP3_CH0_LPDDR4_cke_a;
  output [1:0]TRIP3_CH0_LPDDR4_cke_b;
  output [1:0]TRIP3_CH0_LPDDR4_cs_a;
  output [1:0]TRIP3_CH0_LPDDR4_cs_b;
  inout [1:0]TRIP3_CH0_LPDDR4_dmi_a;
  inout [1:0]TRIP3_CH0_LPDDR4_dmi_b;
  inout [15:0]TRIP3_CH0_LPDDR4_dq_a;
  inout [15:0]TRIP3_CH0_LPDDR4_dq_b;
  inout [1:0]TRIP3_CH0_LPDDR4_dqs_c_a;
  inout [1:0]TRIP3_CH0_LPDDR4_dqs_c_b;
  inout [1:0]TRIP3_CH0_LPDDR4_dqs_t_a;
  inout [1:0]TRIP3_CH0_LPDDR4_dqs_t_b;
  output [0:0]TRIP3_CH0_LPDDR4_reset_n;
  output [5:0]TRIP3_CH1_LPDDR4_ca_a;
  output [5:0]TRIP3_CH1_LPDDR4_ca_b;
  output [0:0]TRIP3_CH1_LPDDR4_ck_c_a;
  output [0:0]TRIP3_CH1_LPDDR4_ck_c_b;
  output [0:0]TRIP3_CH1_LPDDR4_ck_t_a;
  output [0:0]TRIP3_CH1_LPDDR4_ck_t_b;
  output [1:0]TRIP3_CH1_LPDDR4_cke_a;
  output [1:0]TRIP3_CH1_LPDDR4_cke_b;
  output [1:0]TRIP3_CH1_LPDDR4_cs_a;
  output [1:0]TRIP3_CH1_LPDDR4_cs_b;
  inout [1:0]TRIP3_CH1_LPDDR4_dmi_a;
  inout [1:0]TRIP3_CH1_LPDDR4_dmi_b;
  inout [15:0]TRIP3_CH1_LPDDR4_dq_a;
  inout [15:0]TRIP3_CH1_LPDDR4_dq_b;
  inout [1:0]TRIP3_CH1_LPDDR4_dqs_c_a;
  inout [1:0]TRIP3_CH1_LPDDR4_dqs_c_b;
  inout [1:0]TRIP3_CH1_LPDDR4_dqs_t_a;
  inout [1:0]TRIP3_CH1_LPDDR4_dqs_t_b;
  output [0:0]TRIP3_CH1_LPDDR4_reset_n;
  input [3:0]bank106_GT_Serial_grx_n;
  input [3:0]bank106_GT_Serial_grx_p;
  output [3:0]bank106_GT_Serial_gtx_n;
  output [3:0]bank106_GT_Serial_gtx_p;
  input [3:0]bank200_GT_Serial_grx_n;
  input [3:0]bank200_GT_Serial_grx_p;
  output [3:0]bank200_GT_Serial_gtx_n;
  output [3:0]bank200_GT_Serial_gtx_p;

  wire [0:0]Bank106_GT_REFCLK_clk_n;
  wire [0:0]Bank106_GT_REFCLK_clk_p;
  wire [0:0]Bank200_GT_REFCLK_clk_n;
  wire [0:0]Bank200_GT_REFCLK_clk_p;
  wire [0:0]LPDDR4_CLK1_clk_n;
  wire [0:0]LPDDR4_CLK1_clk_p;
  wire [0:0]LPDDR4_CLK2_clk_n;
  wire [0:0]LPDDR4_CLK2_clk_p;
  wire [0:0]LPDDR4_CLK3_clk_n;
  wire [0:0]LPDDR4_CLK3_clk_p;
  wire [0:0]PL_GPIO_tri_i_0;
  wire [1:1]PL_GPIO_tri_i_1;
  wire [2:2]PL_GPIO_tri_i_2;
  wire [3:3]PL_GPIO_tri_i_3;
  wire [0:0]PL_GPIO_tri_io_0;
  wire [1:1]PL_GPIO_tri_io_1;
  wire [2:2]PL_GPIO_tri_io_2;
  wire [3:3]PL_GPIO_tri_io_3;
  wire [0:0]PL_GPIO_tri_o_0;
  wire [1:1]PL_GPIO_tri_o_1;
  wire [2:2]PL_GPIO_tri_o_2;
  wire [3:3]PL_GPIO_tri_o_3;
  wire [0:0]PL_GPIO_tri_t_0;
  wire [1:1]PL_GPIO_tri_t_1;
  wire [2:2]PL_GPIO_tri_t_2;
  wire [3:3]PL_GPIO_tri_t_3;
  wire PL_UART_rxd;
  wire PL_UART_txd;
  wire [5:0]TRIP1_CH0_LPDDR4_ca_a;
  wire [5:0]TRIP1_CH0_LPDDR4_ca_b;
  wire [0:0]TRIP1_CH0_LPDDR4_ck_c_a;
  wire [0:0]TRIP1_CH0_LPDDR4_ck_c_b;
  wire [0:0]TRIP1_CH0_LPDDR4_ck_t_a;
  wire [0:0]TRIP1_CH0_LPDDR4_ck_t_b;
  wire [1:0]TRIP1_CH0_LPDDR4_cke_a;
  wire [1:0]TRIP1_CH0_LPDDR4_cke_b;
  wire [1:0]TRIP1_CH0_LPDDR4_cs_a;
  wire [1:0]TRIP1_CH0_LPDDR4_cs_b;
  wire [1:0]TRIP1_CH0_LPDDR4_dmi_a;
  wire [1:0]TRIP1_CH0_LPDDR4_dmi_b;
  wire [15:0]TRIP1_CH0_LPDDR4_dq_a;
  wire [15:0]TRIP1_CH0_LPDDR4_dq_b;
  wire [1:0]TRIP1_CH0_LPDDR4_dqs_c_a;
  wire [1:0]TRIP1_CH0_LPDDR4_dqs_c_b;
  wire [1:0]TRIP1_CH0_LPDDR4_dqs_t_a;
  wire [1:0]TRIP1_CH0_LPDDR4_dqs_t_b;
  wire [0:0]TRIP1_CH0_LPDDR4_reset_n;
  wire [5:0]TRIP1_CH1_LPDDR4_ca_a;
  wire [5:0]TRIP1_CH1_LPDDR4_ca_b;
  wire [0:0]TRIP1_CH1_LPDDR4_ck_c_a;
  wire [0:0]TRIP1_CH1_LPDDR4_ck_c_b;
  wire [0:0]TRIP1_CH1_LPDDR4_ck_t_a;
  wire [0:0]TRIP1_CH1_LPDDR4_ck_t_b;
  wire [1:0]TRIP1_CH1_LPDDR4_cke_a;
  wire [1:0]TRIP1_CH1_LPDDR4_cke_b;
  wire [1:0]TRIP1_CH1_LPDDR4_cs_a;
  wire [1:0]TRIP1_CH1_LPDDR4_cs_b;
  wire [1:0]TRIP1_CH1_LPDDR4_dmi_a;
  wire [1:0]TRIP1_CH1_LPDDR4_dmi_b;
  wire [15:0]TRIP1_CH1_LPDDR4_dq_a;
  wire [15:0]TRIP1_CH1_LPDDR4_dq_b;
  wire [1:0]TRIP1_CH1_LPDDR4_dqs_c_a;
  wire [1:0]TRIP1_CH1_LPDDR4_dqs_c_b;
  wire [1:0]TRIP1_CH1_LPDDR4_dqs_t_a;
  wire [1:0]TRIP1_CH1_LPDDR4_dqs_t_b;
  wire [0:0]TRIP1_CH1_LPDDR4_reset_n;
  wire [5:0]TRIP2_CH0_LPDDR4_ca_a;
  wire [5:0]TRIP2_CH0_LPDDR4_ca_b;
  wire [0:0]TRIP2_CH0_LPDDR4_ck_c_a;
  wire [0:0]TRIP2_CH0_LPDDR4_ck_c_b;
  wire [0:0]TRIP2_CH0_LPDDR4_ck_t_a;
  wire [0:0]TRIP2_CH0_LPDDR4_ck_t_b;
  wire [1:0]TRIP2_CH0_LPDDR4_cke_a;
  wire [1:0]TRIP2_CH0_LPDDR4_cke_b;
  wire [1:0]TRIP2_CH0_LPDDR4_cs_a;
  wire [1:0]TRIP2_CH0_LPDDR4_cs_b;
  wire [1:0]TRIP2_CH0_LPDDR4_dmi_a;
  wire [1:0]TRIP2_CH0_LPDDR4_dmi_b;
  wire [15:0]TRIP2_CH0_LPDDR4_dq_a;
  wire [15:0]TRIP2_CH0_LPDDR4_dq_b;
  wire [1:0]TRIP2_CH0_LPDDR4_dqs_c_a;
  wire [1:0]TRIP2_CH0_LPDDR4_dqs_c_b;
  wire [1:0]TRIP2_CH0_LPDDR4_dqs_t_a;
  wire [1:0]TRIP2_CH0_LPDDR4_dqs_t_b;
  wire [0:0]TRIP2_CH0_LPDDR4_reset_n;
  wire [5:0]TRIP2_CH1_LPDDR4_ca_a;
  wire [5:0]TRIP2_CH1_LPDDR4_ca_b;
  wire [0:0]TRIP2_CH1_LPDDR4_ck_c_a;
  wire [0:0]TRIP2_CH1_LPDDR4_ck_c_b;
  wire [0:0]TRIP2_CH1_LPDDR4_ck_t_a;
  wire [0:0]TRIP2_CH1_LPDDR4_ck_t_b;
  wire [1:0]TRIP2_CH1_LPDDR4_cke_a;
  wire [1:0]TRIP2_CH1_LPDDR4_cke_b;
  wire [1:0]TRIP2_CH1_LPDDR4_cs_a;
  wire [1:0]TRIP2_CH1_LPDDR4_cs_b;
  wire [1:0]TRIP2_CH1_LPDDR4_dmi_a;
  wire [1:0]TRIP2_CH1_LPDDR4_dmi_b;
  wire [15:0]TRIP2_CH1_LPDDR4_dq_a;
  wire [15:0]TRIP2_CH1_LPDDR4_dq_b;
  wire [1:0]TRIP2_CH1_LPDDR4_dqs_c_a;
  wire [1:0]TRIP2_CH1_LPDDR4_dqs_c_b;
  wire [1:0]TRIP2_CH1_LPDDR4_dqs_t_a;
  wire [1:0]TRIP2_CH1_LPDDR4_dqs_t_b;
  wire [0:0]TRIP2_CH1_LPDDR4_reset_n;
  wire [5:0]TRIP3_CH0_LPDDR4_ca_a;
  wire [5:0]TRIP3_CH0_LPDDR4_ca_b;
  wire [0:0]TRIP3_CH0_LPDDR4_ck_c_a;
  wire [0:0]TRIP3_CH0_LPDDR4_ck_c_b;
  wire [0:0]TRIP3_CH0_LPDDR4_ck_t_a;
  wire [0:0]TRIP3_CH0_LPDDR4_ck_t_b;
  wire [1:0]TRIP3_CH0_LPDDR4_cke_a;
  wire [1:0]TRIP3_CH0_LPDDR4_cke_b;
  wire [1:0]TRIP3_CH0_LPDDR4_cs_a;
  wire [1:0]TRIP3_CH0_LPDDR4_cs_b;
  wire [1:0]TRIP3_CH0_LPDDR4_dmi_a;
  wire [1:0]TRIP3_CH0_LPDDR4_dmi_b;
  wire [15:0]TRIP3_CH0_LPDDR4_dq_a;
  wire [15:0]TRIP3_CH0_LPDDR4_dq_b;
  wire [1:0]TRIP3_CH0_LPDDR4_dqs_c_a;
  wire [1:0]TRIP3_CH0_LPDDR4_dqs_c_b;
  wire [1:0]TRIP3_CH0_LPDDR4_dqs_t_a;
  wire [1:0]TRIP3_CH0_LPDDR4_dqs_t_b;
  wire [0:0]TRIP3_CH0_LPDDR4_reset_n;
  wire [5:0]TRIP3_CH1_LPDDR4_ca_a;
  wire [5:0]TRIP3_CH1_LPDDR4_ca_b;
  wire [0:0]TRIP3_CH1_LPDDR4_ck_c_a;
  wire [0:0]TRIP3_CH1_LPDDR4_ck_c_b;
  wire [0:0]TRIP3_CH1_LPDDR4_ck_t_a;
  wire [0:0]TRIP3_CH1_LPDDR4_ck_t_b;
  wire [1:0]TRIP3_CH1_LPDDR4_cke_a;
  wire [1:0]TRIP3_CH1_LPDDR4_cke_b;
  wire [1:0]TRIP3_CH1_LPDDR4_cs_a;
  wire [1:0]TRIP3_CH1_LPDDR4_cs_b;
  wire [1:0]TRIP3_CH1_LPDDR4_dmi_a;
  wire [1:0]TRIP3_CH1_LPDDR4_dmi_b;
  wire [15:0]TRIP3_CH1_LPDDR4_dq_a;
  wire [15:0]TRIP3_CH1_LPDDR4_dq_b;
  wire [1:0]TRIP3_CH1_LPDDR4_dqs_c_a;
  wire [1:0]TRIP3_CH1_LPDDR4_dqs_c_b;
  wire [1:0]TRIP3_CH1_LPDDR4_dqs_t_a;
  wire [1:0]TRIP3_CH1_LPDDR4_dqs_t_b;
  wire [0:0]TRIP3_CH1_LPDDR4_reset_n;
  wire [3:0]bank106_GT_Serial_grx_n;
  wire [3:0]bank106_GT_Serial_grx_p;
  wire [3:0]bank106_GT_Serial_gtx_n;
  wire [3:0]bank106_GT_Serial_gtx_p;
  wire [3:0]bank200_GT_Serial_grx_n;
  wire [3:0]bank200_GT_Serial_grx_p;
  wire [3:0]bank200_GT_Serial_gtx_n;
  wire [3:0]bank200_GT_Serial_gtx_p;

  IOBUF PL_GPIO_tri_iobuf_0
       (.I(PL_GPIO_tri_o_0),
        .IO(PL_GPIO_tri_io[0]),
        .O(PL_GPIO_tri_i_0),
        .T(PL_GPIO_tri_t_0));
  IOBUF PL_GPIO_tri_iobuf_1
       (.I(PL_GPIO_tri_o_1),
        .IO(PL_GPIO_tri_io[1]),
        .O(PL_GPIO_tri_i_1),
        .T(PL_GPIO_tri_t_1));
  IOBUF PL_GPIO_tri_iobuf_2
       (.I(PL_GPIO_tri_o_2),
        .IO(PL_GPIO_tri_io[2]),
        .O(PL_GPIO_tri_i_2),
        .T(PL_GPIO_tri_t_2));
  IOBUF PL_GPIO_tri_iobuf_3
       (.I(PL_GPIO_tri_o_3),
        .IO(PL_GPIO_tri_io[3]),
        .O(PL_GPIO_tri_i_3),
        .T(PL_GPIO_tri_t_3));
  bd_system bd_system_i
       (.Bank106_GT_REFCLK_clk_n(Bank106_GT_REFCLK_clk_n),
        .Bank106_GT_REFCLK_clk_p(Bank106_GT_REFCLK_clk_p),
        .Bank200_GT_REFCLK_clk_n(Bank200_GT_REFCLK_clk_n),
        .Bank200_GT_REFCLK_clk_p(Bank200_GT_REFCLK_clk_p),
        .LPDDR4_CLK1_clk_n(LPDDR4_CLK1_clk_n),
        .LPDDR4_CLK1_clk_p(LPDDR4_CLK1_clk_p),
        .LPDDR4_CLK2_clk_n(LPDDR4_CLK2_clk_n),
        .LPDDR4_CLK2_clk_p(LPDDR4_CLK2_clk_p),
        .LPDDR4_CLK3_clk_n(LPDDR4_CLK3_clk_n),
        .LPDDR4_CLK3_clk_p(LPDDR4_CLK3_clk_p),
        .PL_GPIO_tri_i({PL_GPIO_tri_i_3,PL_GPIO_tri_i_2,PL_GPIO_tri_i_1,PL_GPIO_tri_i_0}),
        .PL_GPIO_tri_o({PL_GPIO_tri_o_3,PL_GPIO_tri_o_2,PL_GPIO_tri_o_1,PL_GPIO_tri_o_0}),
        .PL_GPIO_tri_t({PL_GPIO_tri_t_3,PL_GPIO_tri_t_2,PL_GPIO_tri_t_1,PL_GPIO_tri_t_0}),
        .PL_UART_rxd(PL_UART_rxd),
        .PL_UART_txd(PL_UART_txd),
        .TRIP1_CH0_LPDDR4_ca_a(TRIP1_CH0_LPDDR4_ca_a),
        .TRIP1_CH0_LPDDR4_ca_b(TRIP1_CH0_LPDDR4_ca_b),
        .TRIP1_CH0_LPDDR4_ck_c_a(TRIP1_CH0_LPDDR4_ck_c_a),
        .TRIP1_CH0_LPDDR4_ck_c_b(TRIP1_CH0_LPDDR4_ck_c_b),
        .TRIP1_CH0_LPDDR4_ck_t_a(TRIP1_CH0_LPDDR4_ck_t_a),
        .TRIP1_CH0_LPDDR4_ck_t_b(TRIP1_CH0_LPDDR4_ck_t_b),
        .TRIP1_CH0_LPDDR4_cke_a(TRIP1_CH0_LPDDR4_cke_a),
        .TRIP1_CH0_LPDDR4_cke_b(TRIP1_CH0_LPDDR4_cke_b),
        .TRIP1_CH0_LPDDR4_cs_a(TRIP1_CH0_LPDDR4_cs_a),
        .TRIP1_CH0_LPDDR4_cs_b(TRIP1_CH0_LPDDR4_cs_b),
        .TRIP1_CH0_LPDDR4_dmi_a(TRIP1_CH0_LPDDR4_dmi_a),
        .TRIP1_CH0_LPDDR4_dmi_b(TRIP1_CH0_LPDDR4_dmi_b),
        .TRIP1_CH0_LPDDR4_dq_a(TRIP1_CH0_LPDDR4_dq_a),
        .TRIP1_CH0_LPDDR4_dq_b(TRIP1_CH0_LPDDR4_dq_b),
        .TRIP1_CH0_LPDDR4_dqs_c_a(TRIP1_CH0_LPDDR4_dqs_c_a),
        .TRIP1_CH0_LPDDR4_dqs_c_b(TRIP1_CH0_LPDDR4_dqs_c_b),
        .TRIP1_CH0_LPDDR4_dqs_t_a(TRIP1_CH0_LPDDR4_dqs_t_a),
        .TRIP1_CH0_LPDDR4_dqs_t_b(TRIP1_CH0_LPDDR4_dqs_t_b),
        .TRIP1_CH0_LPDDR4_reset_n(TRIP1_CH0_LPDDR4_reset_n),
        .TRIP1_CH1_LPDDR4_ca_a(TRIP1_CH1_LPDDR4_ca_a),
        .TRIP1_CH1_LPDDR4_ca_b(TRIP1_CH1_LPDDR4_ca_b),
        .TRIP1_CH1_LPDDR4_ck_c_a(TRIP1_CH1_LPDDR4_ck_c_a),
        .TRIP1_CH1_LPDDR4_ck_c_b(TRIP1_CH1_LPDDR4_ck_c_b),
        .TRIP1_CH1_LPDDR4_ck_t_a(TRIP1_CH1_LPDDR4_ck_t_a),
        .TRIP1_CH1_LPDDR4_ck_t_b(TRIP1_CH1_LPDDR4_ck_t_b),
        .TRIP1_CH1_LPDDR4_cke_a(TRIP1_CH1_LPDDR4_cke_a),
        .TRIP1_CH1_LPDDR4_cke_b(TRIP1_CH1_LPDDR4_cke_b),
        .TRIP1_CH1_LPDDR4_cs_a(TRIP1_CH1_LPDDR4_cs_a),
        .TRIP1_CH1_LPDDR4_cs_b(TRIP1_CH1_LPDDR4_cs_b),
        .TRIP1_CH1_LPDDR4_dmi_a(TRIP1_CH1_LPDDR4_dmi_a),
        .TRIP1_CH1_LPDDR4_dmi_b(TRIP1_CH1_LPDDR4_dmi_b),
        .TRIP1_CH1_LPDDR4_dq_a(TRIP1_CH1_LPDDR4_dq_a),
        .TRIP1_CH1_LPDDR4_dq_b(TRIP1_CH1_LPDDR4_dq_b),
        .TRIP1_CH1_LPDDR4_dqs_c_a(TRIP1_CH1_LPDDR4_dqs_c_a),
        .TRIP1_CH1_LPDDR4_dqs_c_b(TRIP1_CH1_LPDDR4_dqs_c_b),
        .TRIP1_CH1_LPDDR4_dqs_t_a(TRIP1_CH1_LPDDR4_dqs_t_a),
        .TRIP1_CH1_LPDDR4_dqs_t_b(TRIP1_CH1_LPDDR4_dqs_t_b),
        .TRIP1_CH1_LPDDR4_reset_n(TRIP1_CH1_LPDDR4_reset_n),
        .TRIP2_CH0_LPDDR4_ca_a(TRIP2_CH0_LPDDR4_ca_a),
        .TRIP2_CH0_LPDDR4_ca_b(TRIP2_CH0_LPDDR4_ca_b),
        .TRIP2_CH0_LPDDR4_ck_c_a(TRIP2_CH0_LPDDR4_ck_c_a),
        .TRIP2_CH0_LPDDR4_ck_c_b(TRIP2_CH0_LPDDR4_ck_c_b),
        .TRIP2_CH0_LPDDR4_ck_t_a(TRIP2_CH0_LPDDR4_ck_t_a),
        .TRIP2_CH0_LPDDR4_ck_t_b(TRIP2_CH0_LPDDR4_ck_t_b),
        .TRIP2_CH0_LPDDR4_cke_a(TRIP2_CH0_LPDDR4_cke_a),
        .TRIP2_CH0_LPDDR4_cke_b(TRIP2_CH0_LPDDR4_cke_b),
        .TRIP2_CH0_LPDDR4_cs_a(TRIP2_CH0_LPDDR4_cs_a),
        .TRIP2_CH0_LPDDR4_cs_b(TRIP2_CH0_LPDDR4_cs_b),
        .TRIP2_CH0_LPDDR4_dmi_a(TRIP2_CH0_LPDDR4_dmi_a),
        .TRIP2_CH0_LPDDR4_dmi_b(TRIP2_CH0_LPDDR4_dmi_b),
        .TRIP2_CH0_LPDDR4_dq_a(TRIP2_CH0_LPDDR4_dq_a),
        .TRIP2_CH0_LPDDR4_dq_b(TRIP2_CH0_LPDDR4_dq_b),
        .TRIP2_CH0_LPDDR4_dqs_c_a(TRIP2_CH0_LPDDR4_dqs_c_a),
        .TRIP2_CH0_LPDDR4_dqs_c_b(TRIP2_CH0_LPDDR4_dqs_c_b),
        .TRIP2_CH0_LPDDR4_dqs_t_a(TRIP2_CH0_LPDDR4_dqs_t_a),
        .TRIP2_CH0_LPDDR4_dqs_t_b(TRIP2_CH0_LPDDR4_dqs_t_b),
        .TRIP2_CH0_LPDDR4_reset_n(TRIP2_CH0_LPDDR4_reset_n),
        .TRIP2_CH1_LPDDR4_ca_a(TRIP2_CH1_LPDDR4_ca_a),
        .TRIP2_CH1_LPDDR4_ca_b(TRIP2_CH1_LPDDR4_ca_b),
        .TRIP2_CH1_LPDDR4_ck_c_a(TRIP2_CH1_LPDDR4_ck_c_a),
        .TRIP2_CH1_LPDDR4_ck_c_b(TRIP2_CH1_LPDDR4_ck_c_b),
        .TRIP2_CH1_LPDDR4_ck_t_a(TRIP2_CH1_LPDDR4_ck_t_a),
        .TRIP2_CH1_LPDDR4_ck_t_b(TRIP2_CH1_LPDDR4_ck_t_b),
        .TRIP2_CH1_LPDDR4_cke_a(TRIP2_CH1_LPDDR4_cke_a),
        .TRIP2_CH1_LPDDR4_cke_b(TRIP2_CH1_LPDDR4_cke_b),
        .TRIP2_CH1_LPDDR4_cs_a(TRIP2_CH1_LPDDR4_cs_a),
        .TRIP2_CH1_LPDDR4_cs_b(TRIP2_CH1_LPDDR4_cs_b),
        .TRIP2_CH1_LPDDR4_dmi_a(TRIP2_CH1_LPDDR4_dmi_a),
        .TRIP2_CH1_LPDDR4_dmi_b(TRIP2_CH1_LPDDR4_dmi_b),
        .TRIP2_CH1_LPDDR4_dq_a(TRIP2_CH1_LPDDR4_dq_a),
        .TRIP2_CH1_LPDDR4_dq_b(TRIP2_CH1_LPDDR4_dq_b),
        .TRIP2_CH1_LPDDR4_dqs_c_a(TRIP2_CH1_LPDDR4_dqs_c_a),
        .TRIP2_CH1_LPDDR4_dqs_c_b(TRIP2_CH1_LPDDR4_dqs_c_b),
        .TRIP2_CH1_LPDDR4_dqs_t_a(TRIP2_CH1_LPDDR4_dqs_t_a),
        .TRIP2_CH1_LPDDR4_dqs_t_b(TRIP2_CH1_LPDDR4_dqs_t_b),
        .TRIP2_CH1_LPDDR4_reset_n(TRIP2_CH1_LPDDR4_reset_n),
        .TRIP3_CH0_LPDDR4_ca_a(TRIP3_CH0_LPDDR4_ca_a),
        .TRIP3_CH0_LPDDR4_ca_b(TRIP3_CH0_LPDDR4_ca_b),
        .TRIP3_CH0_LPDDR4_ck_c_a(TRIP3_CH0_LPDDR4_ck_c_a),
        .TRIP3_CH0_LPDDR4_ck_c_b(TRIP3_CH0_LPDDR4_ck_c_b),
        .TRIP3_CH0_LPDDR4_ck_t_a(TRIP3_CH0_LPDDR4_ck_t_a),
        .TRIP3_CH0_LPDDR4_ck_t_b(TRIP3_CH0_LPDDR4_ck_t_b),
        .TRIP3_CH0_LPDDR4_cke_a(TRIP3_CH0_LPDDR4_cke_a),
        .TRIP3_CH0_LPDDR4_cke_b(TRIP3_CH0_LPDDR4_cke_b),
        .TRIP3_CH0_LPDDR4_cs_a(TRIP3_CH0_LPDDR4_cs_a),
        .TRIP3_CH0_LPDDR4_cs_b(TRIP3_CH0_LPDDR4_cs_b),
        .TRIP3_CH0_LPDDR4_dmi_a(TRIP3_CH0_LPDDR4_dmi_a),
        .TRIP3_CH0_LPDDR4_dmi_b(TRIP3_CH0_LPDDR4_dmi_b),
        .TRIP3_CH0_LPDDR4_dq_a(TRIP3_CH0_LPDDR4_dq_a),
        .TRIP3_CH0_LPDDR4_dq_b(TRIP3_CH0_LPDDR4_dq_b),
        .TRIP3_CH0_LPDDR4_dqs_c_a(TRIP3_CH0_LPDDR4_dqs_c_a),
        .TRIP3_CH0_LPDDR4_dqs_c_b(TRIP3_CH0_LPDDR4_dqs_c_b),
        .TRIP3_CH0_LPDDR4_dqs_t_a(TRIP3_CH0_LPDDR4_dqs_t_a),
        .TRIP3_CH0_LPDDR4_dqs_t_b(TRIP3_CH0_LPDDR4_dqs_t_b),
        .TRIP3_CH0_LPDDR4_reset_n(TRIP3_CH0_LPDDR4_reset_n),
        .TRIP3_CH1_LPDDR4_ca_a(TRIP3_CH1_LPDDR4_ca_a),
        .TRIP3_CH1_LPDDR4_ca_b(TRIP3_CH1_LPDDR4_ca_b),
        .TRIP3_CH1_LPDDR4_ck_c_a(TRIP3_CH1_LPDDR4_ck_c_a),
        .TRIP3_CH1_LPDDR4_ck_c_b(TRIP3_CH1_LPDDR4_ck_c_b),
        .TRIP3_CH1_LPDDR4_ck_t_a(TRIP3_CH1_LPDDR4_ck_t_a),
        .TRIP3_CH1_LPDDR4_ck_t_b(TRIP3_CH1_LPDDR4_ck_t_b),
        .TRIP3_CH1_LPDDR4_cke_a(TRIP3_CH1_LPDDR4_cke_a),
        .TRIP3_CH1_LPDDR4_cke_b(TRIP3_CH1_LPDDR4_cke_b),
        .TRIP3_CH1_LPDDR4_cs_a(TRIP3_CH1_LPDDR4_cs_a),
        .TRIP3_CH1_LPDDR4_cs_b(TRIP3_CH1_LPDDR4_cs_b),
        .TRIP3_CH1_LPDDR4_dmi_a(TRIP3_CH1_LPDDR4_dmi_a),
        .TRIP3_CH1_LPDDR4_dmi_b(TRIP3_CH1_LPDDR4_dmi_b),
        .TRIP3_CH1_LPDDR4_dq_a(TRIP3_CH1_LPDDR4_dq_a),
        .TRIP3_CH1_LPDDR4_dq_b(TRIP3_CH1_LPDDR4_dq_b),
        .TRIP3_CH1_LPDDR4_dqs_c_a(TRIP3_CH1_LPDDR4_dqs_c_a),
        .TRIP3_CH1_LPDDR4_dqs_c_b(TRIP3_CH1_LPDDR4_dqs_c_b),
        .TRIP3_CH1_LPDDR4_dqs_t_a(TRIP3_CH1_LPDDR4_dqs_t_a),
        .TRIP3_CH1_LPDDR4_dqs_t_b(TRIP3_CH1_LPDDR4_dqs_t_b),
        .TRIP3_CH1_LPDDR4_reset_n(TRIP3_CH1_LPDDR4_reset_n),
        .bank106_GT_Serial_grx_n(bank106_GT_Serial_grx_n),
        .bank106_GT_Serial_grx_p(bank106_GT_Serial_grx_p),
        .bank106_GT_Serial_gtx_n(bank106_GT_Serial_gtx_n),
        .bank106_GT_Serial_gtx_p(bank106_GT_Serial_gtx_p),
        .bank200_GT_Serial_grx_n(bank200_GT_Serial_grx_n),
        .bank200_GT_Serial_grx_p(bank200_GT_Serial_grx_p),
        .bank200_GT_Serial_gtx_n(bank200_GT_Serial_gtx_n),
        .bank200_GT_Serial_gtx_p(bank200_GT_Serial_gtx_p));
endmodule

