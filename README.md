# MIPI-RX

Simple VHDL cores for receiving MIPI CSI-2 video streams and exposing them on an Avalon-ST interface.

## Files

- `rtl/csi2_pkg.vhd` – Common package definitions for the decoder.
- `rtl/csi2_decoder.vhd` – Basic CSI-2 packet decoder with Avalon-ST output.

The decoder expects byte aligned data from a D-PHY block and emits the packet payload over an Avalon streaming interface.
