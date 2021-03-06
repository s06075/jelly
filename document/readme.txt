-------------------------------------------------------------------------------
 Jelly -- ソフトコアプロセッシングシステム

                                    Copyright (C) 2008-2014 by Ryuji Fuchikami 
                                    http://ryuz.my.coocan.jp
                                    https://github.com/ryuz/jelly.git
-------------------------------------------------------------------------------


1. はじめに

  Jelly とは、FPGA向けの MIPS-I ライクな命令セットのコアを有したソフトコア
プロセッシングシステムです。
  従来マイコンで制御していた分野で、ワンチップマイコンをFPGAで置き換える
ケースが増えてきました。
  そのようなケースを想定して、組込みソフト開発の視点から使いやすいシステムを
目指して開発を行っております。


2. 構成

  +document              各種ドキュメント
  +rtl
  |  +cpu                CPUコア
  |  +cache              キャッシュメモリ
  |  +bus                バス変換などのモジュール
  |  +library            各種ライブラリ的モジュール
  |  +irc                割込みコントローラ
  |  +ddr_sdram          DDR-SDRAMコントローラ
  |  +sram               内蔵SRAM
  |  +extbus             外部バス制御
  |  +uart               UART
  |  +timer              タイマ
  |  +gpio               GPIO
  +projects
  |  +spartan3e_starter  Spartan-3E Starter Kit 用プロジェクト
  |  +spartan3_starter   Spartan-3 Starter Kit 用プロジェクト
  |  +cq-frk-s3e2        DesignWaveおまけ Spartan-3ボード用プロジェクト
  +soft                  ROM化ソフト生成用
  +tools                 ツール類



-------------------------------------------------------------------------------
 end of file
-------------------------------------------------------------------------------
