files=["."]
#files=['pdetect.v',
#       'FDDRRSE.v',
#       'ccfilt.v',
#       'half_filt.v',
#       'sat_add.v',
#       'rx_buffer.v',
#       'cordicg.v',
#       'dac_cells.v',
       #        'afterburner2_tb.v',
#       'phshift.v',
       #        'rot_dds_tb.v',
#       'cim_12.v',
#       'circle_buf.v',
#       'fifo2.v',
       #        'half_filt_tb.v',
       #        'mult_trad_tb.v',
       #        'decay_buf_tb.v',
       #        'piloop2_tb.v',
#       'freq_count.v',
#       'data_xdomain.v',
#       'decay_buf.v',
#       'reg_delay.v',
#       'bandpass3.v',
       #        'mon_12_tb.v',
       #        'timestamp_tb.v',
       #        'rx_buffer_tb.v',
#       'timestamp.v',
#       'doublediff.v',
       #        'phshift_tb.v',
#       'mon_chan.v',
#       'mon_2chan.v',
       #        'data_xdomain_tb.v',
#       'ccfilt_wrap.v',
       #        'circle_buf_tb.v',
       #        'bandpass3_tb.v',
#       'mixer.v',
#       'double_inte.v',
#       'serialize.v',
#       'minmax.v',
#       'rot_dds.v',
#       'mult_trad.v',
#       'piloop2.v',
#       'dpram.v',
#       'afterburner2.v',
#       'flag_xdomain.v']
#modules={"local":["../peripheral_drivers","../board_support/llrf4"]}
modules={"local":[]}
include_dirs=["../peripheral_drivers", "../board_support/llrf4"]
action="simulation"

use_compiler="iverilog"
incl_makefiles=["../preamble1.mk","../preamble2.mk","hook.mk"]
