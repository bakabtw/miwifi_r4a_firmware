# Stock firmware v3.0.24 for Xiaomi Mi4A router
The file were extracted from `miwifi_r4a_all_03233_3.0.24_INT.bin`

## Firmware content
```bash
$ binwalk miwifi_r4a_all_03233_3.0.24_INT.bin

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
672           0x2A0           uImage header, header size: 64 bytes, header CRC: 0x9CDF20EC, created: 2020-08-18 11:18:42, image size: 1690519 bytes, Data Address: 0x81001000, Entry Point: 0x81387E90, data CRC: 0x6ED67599, OS: Linux, CPU: MIPS, image type: OS Kernel Image, compression type: lzma, image name: "MIPS OpenWrt Linux-3.10.14"
736           0x2E0           LZMA compressed data, properties: 0x6D, dictionary size: 8388608 bytes, uncompressed size: 4991744 bytes
1704608       0x1A02A0        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 12763178 bytes, 2345 inodes, blocksize: 262144 bytes, created: 2020-08-18 11:18:36
14778484      0xE18074        U-Boot version string, "U-Boot 1.1.3 (Aug 18 2020 - 11:10:29)"
14779036      0xE1829C        CRC32 polynomial table, little endian
14780388      0xE187E4        AES S-Box
14781168      0xE18AF0        AES Inverse S-Box
```

## Getting rootfs
```bash
dd if=miwifi_r4a_all_03233_3.0.24_INT.bin of=rootfs.sqfs bs=1 skip=1704608 count=12763178
```

## Extracting rootfs
```bash
unsquashfs rootfs.sqfs
```

## Stock firmware v2.30.500 for Xiaomi Mi4A router
The file were extracted from `miwifi_r4av2_firmware_6bdd4_2.30.500.bin`

## Firmware content
```bash
$ binwalk miwifi_r4av2_firmware_6bdd4_2.30.500.bin

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
724           0x2D4           Flattened device tree, size: 1659688 bytes, version: 17
960           0x3C0           LZMA compressed data, properties: 0x6D, dictionary size: 8388608 bytes, uncompressed size: 5267984 bytes
1647748       0x192484        Flattened device tree, size: 11332 bytes, version: 17
1704660       0x1A02D4        Squashfs filesystem, little endian, version 4.0, compression:xz, size: 11917206 bytes, 3162 inodes, blocksize: 262144 bytes, created: 2023-02-07 05:56:41
```

## Getting rootfs
```bash
dd if=miwifi_r4av2_firmware_6bdd4_2.30.500.bin of=rootfs.sqfs bs=1 skip=1704660
```

## Extracting rootfs
```bash
unsquashfs rootfs.sqfs
```