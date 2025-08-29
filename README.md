# MIPI-RX

Simple VHDL cores for receiving MIPI CSI-2 video streams and exposing them on an Avalon-ST interface.

## Files

- `rtl/csi2_pkg.vhd` – Common package definitions including an Avalon-ST record type.
- `rtl/csi2_decoder.vhd` – Basic CSI-2 packet decoder emitting video payload over Avalon-ST.

The decoder expects byte aligned data from a D-PHY block and emits the packet payload over an Avalon streaming interface using the `avst_out_t` record plus a separate `ready` signal.
