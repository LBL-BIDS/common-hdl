VFLAGS_DEP += -y. -I.

TEST_BENCH = afterburner2_tb bandpass3_tb circle_buf_tb decay_buf_tb data_xdomain_tb mult_trad_tb phshift_tb rot_dds_tb rx_buffer_tb timestamp_tb half_filt_tb  piloop2_tb square_tb trip_tb slew_tb slew_array_tb pdetect_tb vectormul_tb circle_buf2_tb busbridge_tb simple_cic_tb mon_12_tb freq_count_tb serial_tb circle_buf4_tb banyan_tb banyan_mem_tb tt800_tb upconv_tb shortfifo_tb pplimit_tb crc_guts_tb cavity_tb

TGT_ := $(TEST_BENCH)

NO_CHECK = rx_buffer_check piloop2_check banyan_mem_check pplimit_check cavity_check
CHK_ = $(filter-out $(NO_CHECK), $(TEST_BENCH:%_tb=%_check)) banyan_crosscheck

BITS_ := bandpass3.bit

.PHONY: targets checks bits check_all clean_all
targets: $(TGT_)
checks: $(CHK_)
check_all: $(CHK_)
bits: $(BITS_)

bandpass3.dat: bandpass3_tb cset3.m
	$(VVP) $< `$(OCTAVE) -q cset3.m` > $@

bandpass3_check: bpp3.m bandpass3.dat
	$(OCTAVE) -q $(notdir $<)

bandpass3.bit: bandpass3.v
	$(SYNTH) bandpass3 $^
	mv _xilinx/bandpass3.bit $@

timestamp.bit: timestamp.v reg_delay.v
	$(SYNTH) timestamp $^
	mv _xilinx/timestamp.bit $@

half_filt_check: half_filt.m half_filt.dat
	$(OCTAVE) -q half_filt.m

# scattershot approach
# limited to den>=12
mon_12_check: mon_12_tb $(BUILD_DIR)/testcode.awk
	$(VVP) $< +amp=20000 +den=16  +phs=3.14 | $(AWK) -f $(filter %.awk, $^)
	$(VVP) $< +amp=32763 +den=128 +phs=-0.2 | $(AWK) -f $(filter %.awk, $^)
	$(VVP) $< +amp=99999 +den=28  +phs=1.57 | $(AWK) -f $(filter %.awk, $^)
	$(VVP) $< +amp=200   +den=12  +phs=0.70 | $(AWK) -f $(filter %.awk, $^)

banyan_crosscheck: banyan_tb banyan_ch_find.py
	$(VVP) banyan_tb +trace +squelch | python banyan_ch_find.py

tt800_ref.dat: tt800_ref
	./tt800_ref > $@

tt800_check: tt800.dat tt800_ref.dat
	cmp $^

CLEAN += $(TGT_) $(CHK_) *.bit *.in bandpass3.dat half_filt.dat piloop2.dat pdetect.dat tt800_ref tt800.dat tt800_ref.dat tt800_ref.d
CLEAN_DIRS += _xilinx

ifneq (,$(findstring bit,$(MAKECMDGOALS)))
    ifneq (,$(findstring bits,$(MAKECMDGOALS)))
	-include $(BITS_:%.bit=$(DEPDIR)/%.bit.d)
    else
	-include $(MAKECMDGOALS:%.bit=$(DEPDIR)/%.bit.d)
    endif
endif
ifneq (,$(findstring _tb,$(MAKECMDGOALS)))
    -include $(MAKECMDGOALS:%_tb=$(DEPDIR)/%_tb.d)
endif
ifneq (,$(findstring _view,$(MAKECMDGOALS)))
    -include $(MAKECMDGOALS:%_tb=$(DEPDIR)/%_tb.d)
endif
ifneq (,$(findstring _check,$(MAKECMDGOALS)))
    -include $(MAKECMDGOALS:%_tb=$(DEPDIR)/%_tb.d)
endif
ifeq (,$(MAKECMDGOALS))
    -include $(TEST_BENCH:%_tb=$(DEPDIR)/%_tb.d)
endif
