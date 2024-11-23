

################################# CMD #########################################
FILE_OPTS = -f $(PROJECT_SIMTBFILE) # -f $(PROJECT_SOCFILELIST) 


ANALYSIS_OPTS = +v2k -l $(PROJECT_SIMLOG)/analysis.log -sverilog
COMPILE_OPTS  = +v2k -l $(PROJECT_SIMLOG)/compile.log  -sverilog +lint=DSFIF 
UVM_CMP   = -ntb_opts uvm-1.2 +vc  
run:
	$(ANALYSIS) &&  $(COMPILE) && $(ELABORATE) && $(SIMULATE) 

ncrun:
	$(SIMULATE) 

cmp:
	$(ANALYSIS) &&  $(COMPILE) && $(ELABORATE) 



################################# START ANALYSIS ######################################
### 分析
# verilog:vlogan命令
# VHDL:vhdlan命令
# SystemVerilog:vlogan命令 要加-sverilog选项
ANALYSIS = vlogan  $(ANALYSIS_OPTS) $(FILE_OPTS) 
vana:
	$(ANALYSIS)

################################# END ANALYSIS #########################################

################################# START COMPILE ########################################
# 主要将硬件语言编译成库的过程
# verilog:vlogan命令
# VHDL:vhdlan命令
# SystemVerilog:vlogan命令 要加-sverilog选项
# ip核或硬核：需要通过synopsys_sim.setup指定IP库
## 1. 链接xilinx ip库（在vivado中生成的）（自定义的setup需要与makefile放一起）
INCDIRS 	= 	+incdir+$(PROJECT_SRC)						
	
				# +$(UVM_HOME)/src 		\
				# +$($(UVM_HOME)/src/dpi/uvm_dpi.cc 	\
				# +$($(UVM_HOME)/src/uvm_pkg.sv		\
VERDI_CMD   =   -2001 -sveriolg -ssf $(vcs_work_path)/simv.vdb \
				+incdir+$(rtl_path)  -y $(rtl_path) -y $(glbl_path) +libext+.v -ssy
	
COMPILE = vlogan 	$(UVM_CMP) \
		  			$(INCDIRS) \
					$(COMPILE_OPTS) \
					$(FILE_OPTS) 
					# -f $(PROJECT_SIMTBFILE) # -f $(PROJECT_SOCFILELIST) 
					

vcmp:
	$(COMPILE)

# vlogan \ 命令
# +v2k \	verilog-2001
# -work Xilinx_Lib \ 指定编译库
# +incdir+$(macro_sim)\ 指定宏定义搜索路径
# -l $(SIM_PATH)/Temp/VCS/com.log \ 
# -sverilog	\ 支持sv
# +define+SIMULATION_EN \
# $(SIM_PATH)/Temp/glbl.v \
# -f $(rtl_ip_tb_soft_xdc_vfile_path)/vfile.v \ 编译filelist文件
# -f $(rtl_ip_tb_soft_xdc_vfile_path)/svfile.v \ $(v_tb_file)
################################# END COMPILE #########################################


################################# START ELABORATE #####################################
ELABORATE_CMD 	= -sverilog -R -full64    -timescale=1ns/10ps -debug_acc+all  -Mupdate -licqueue -t ps  +lint=TFIPC-L   +lint=PCWM   -CFLAGS -DVCS -DVCS $(UVM_HOME)/src/dpi/uvm_dpi.cc

# -Mupdate -licqueue   -DVCS $(UVM_HOME)/src/dpi/uvm_dpi.cc
DEBUSSY_PLI=-P $(VERDI_HOME)/share/PLI/VCS/linux64/novas.tab  $(VERDI_HOME)/share/PLI/VCS/linux64/pli.a
# code coverage command
CCC_OPTS = -cm line+cond+fsm+branch+tgl+assert # 行\翻转\状态机\分支\条件覆盖率\断言
CCC_NAME = -cm_name simv
CCC_DIR  = -cm_dir $(PROJECT_SIMEXCE)/simv.vdb

# # 将上面生成的库文件，以及可能用到的xilinx IP的库文件，生成仿真的可执行文件。
ELABORATE = vcs	-top	harness	\
			$(ELABORATE_CMD) \
			$(UVM_CMP)		\
			-l $(PROJECT_SIMLOG)/elaborate.log \
			-Mdir=$(PROJECT_SIMEXCE) \
			-o $(PROJECT_SIMEXCE)/simv \
			$(DEBUSSY_PLI) \
			$(CCC_OPTS) $(CCC_NAME)	\
			$(CCC_DIR)\
			 
vela:
	$(ELABORATE)


# -debug_pp \
# -t ps \
# -licqueue \

# vcs \
# -full64 -cpp g++-4.8 -cc gcc-4.8 -LDFLAGS -Wl,-on-as-needed \
# -Mdir=Xilinx_Lib \  # 指定默认编译库
# -sverilog \
# -lca \ # 使用用户限制功能
# -debug_all \
# -P $(verdi_home)/novas.tab \
# $(verdi_home)/pli.a \ 配置verdi的PLI
# -l $(SIM_PATH)/Temp/VCS/elb.log \
# Xilinx_Lib.glbl \
# Xilinx_Lib.$(Bench_Name) \ 指定编译库中的bench和glbl
# -file $(f_c) 指定需要编译的filelist文件
# -o $(SIM_PATH)/Temp/VCS/simv 生成可执行文件

################################# END ELABORATE #####################################

################################# START SIMULATE #########################################

# 执行上面生成的simv.o可执行文件，进行仿真。
# 由于需要生成适用于verdi的fsdb文件，所以在bench中还需要添加任务语句。

SIMULATE =  $(UVM_CMP) \
			$(PROJECT_SIMEXCE)/simv \
			-l $(PROJECT_SIMLOG)/simulate.log \
			-k $(PROJECT_SIMEXCE)/ucli.key \
			${CCC_OPTS} \
			${CCC_NAME} \
			${CCC_DIR} 
sim:
	$(SIMULATE)
# simulate在verilog中的部分脚本:
# initial begin
# 	$fsdbAutoSwitchDumpfile(200, "Wavefile/FsdbFile/top.fsdb", 100);
# 	$fsdbDumpvars;
# 	$display("******************* wave dump start ***********************");
# end
################################# END SIMULATE #########################################
################################# START VERDI #########################################
VERDI = verdi 	$(FILE_OPTS) \
				-2001					\
				-sveriolg 				\
				-ssf $(PROJECT_SIMEXCE)/harness.fsdb
verdi:
	$(VERDI)
################################# VCS #########################################
#Comppile command 

VCS = vcs -R -full64											\
	+v2k														\
	 -timescale=1ns/10ps				\
	$(UVM_CMP)													\
	-debug_access												\
	$(ALL_DEFINE)												\
	-sverilog													\
    $(FILE_OPTS) 											\
	$(COMPILE_OPTS) 										\
	-Mupdate													
#VCS = vcs -sverilog  +v2k      \
	-debug_all				 \
	+notimingcheck				 \
	+nospecify				 \
	+vcs+flush+all				 \
	$(ALL_DEFINE)				 \
   	$(VPD_NAME)				 \
	-o  $(OUTPUT)				 \
	-l  compile.log                \
        -f file_list		  
vcs:
	$(VCS)
################################# VERDI  #########################################

FLASH_UPDATE = 	cp /mnt/hgfs/linux_share_file/M0Prj0/code.hex  $(software_path) \
				&& mv  $(software_path)/code.hex  $(software_path)/7_main_c_printf.hex

CDWORK  =  cd $(prj_path)
# 覆盖率检查
COVER = dve -covdir *.vdb 

################################# CLEAN #########################################
CLEAN= 		rm -rf  \
			$(PROJECT_SIMPATH)/64 		   \
			$(PROJECT_SIMPATH)/AN.DB 	   \
			$(PROJECT_SIMPATH)/csrc        \
			$(PROJECT_SIMPATH)/verdiLog    \
			$(PROJECT_SIMPATH)/*.log       \
			$(PROJECT_SIMPATH)/simv.fsdb   \
			$(PROJECT_SIMPATH)/ucli.key    \
			$(PROJECT_SIMPATH)/inter.vpd   \
			$(PROJECT_SIMPATH)/novas*      \
			$(PROJECT_SIMPATH)/DVEfiles    \
			$(PROJECT_SIMPATH)/simv        \
			$(PROJECT_SIMPATH)/simv.daidir \
			$(PROJECT_SIMPATH)/vdCovLog    \
			$(PROJECT_SIMPATH)/simv.vdb    \
			$(PROJECT_SIMPATH)/vc_hdrs.h	\
			$(PROJECT_SIMPATH)/exce	\
			$(PROJECT_SIMPATH)/log	\

#start clean 
VCLEAN= \
	rm -rf ./csrc ./log_file/*.log  ./verdiLog  ./file_list ./*.log ./vcs_lib ./novas.conf ./simv* ./ucli.key 
clean:
	$(CLEAN)
################################# ERROR #########################################
VERROR= \
	grep error  $(log_file_path)/*.log

