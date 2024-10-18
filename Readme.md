# Stock firmware for Xiaomi Mi4A router
The file were extracted from `miwifi_r4av2_firmware_6bdd4_2.30.500.bin`

# Firmware content
```bash
$ binwalk miwifi_r4av2_firmware_6bdd4_2.30.500.bin

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
724           0x2D4           Flattened device tree, size: 1659688 bytes, version: 17
960           0x3C0           LZMA compressed data, properties: 0x6D, dictionary size: 8388608 bytes, uncompressed size: 5267984 bytes
1647748       0x192484        Flattened device tree, size: 11332 bytes, version: 17
1704660       0x1A02D4        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 11917206 bytes, 3162 inodes, blocksize: 262144 bytes, created: 2023-02-07 05:56:41
```

# Getting rootfs
```bash
dd if=miwifi_r4av2_firmware_6bdd4_2.30.500.bin of=rootfs.sqfs bs=1 skip=1704660
```

# Extracting rootfs
```bash
unsquashfs rootfs.sqfs
```