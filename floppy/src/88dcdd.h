#ifndef __88DCDD_H__
#define __88DCDD_H__

#include <stdint.h>

// sectors per track
#define FLOPPY_88DCDD_SPT         32

// tracks per disk
#define FLOPPY_88DCDD_TPD         77

// bytes per sector
#define FLOPPY_88DCDD_BPS         137

// maximum payload length
#define FLOPPY_88DCDD_PAYLOAD_LEN 128

// reserved tracks
#define FLOPPY_88DCDD_RESERVED_TRACKS 2

// maximum length of bootloader on reserved tracks
#define FLOPPY_88DCDD_MAX_BOOTLEN 8*1024

typedef struct __attribute__((__packed__)) floppy_sector_t {
	uint8_t  zero_byte;
	union {
		uint16_t file_size;
		uint16_t logical_block_num;
	};
	uint8_t  payload[FLOPPY_88DCDD_PAYLOAD_LEN];
	uint8_t  sync_byte;
	uint8_t  checksum_byte;
	uint8_t  padding[3];
} floppy_sector_t;

typedef struct __attribute__((__packed__)) floppy_track_t {
	floppy_sector_t sectors[FLOPPY_88DCDD_SPT];
} floppy_track_t;

typedef struct __attribute__((__packed__)) floppy_img_t {
	floppy_track_t boot_tracks[FLOPPY_88DCDD_RESERVED_TRACKS];
	floppy_track_t data_tracks[FLOPPY_88DCDD_TPD - FLOPPY_88DCDD_RESERVED_TRACKS];
} floppy_img_t;
#endif
