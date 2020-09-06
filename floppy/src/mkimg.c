#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "88dcdd.h"

int main(int argc, char** argv) {
	FILE* bootloader_fd = fopen(argv[1],"rb");

	struct stat boot_stat;
	stat(argv[1], &boot_stat);
	uint16_t bootloader_sectors = boot_stat.st_size / FLOPPY_88DCDD_PAYLOAD_LEN;
	if((boot_stat.st_size % FLOPPY_88DCDD_PAYLOAD_LEN) > 0) bootloader_sectors++;

	if(bootloader_sectors > FLOPPY_88DCDD_RESERVED_TRACKS * FLOPPY_88DCDD_SPT) {
		fprintf(stderr,"Error! bootloader too big!\n");
		return 1;
	}

	fprintf(stderr,"Will need %d sectors for bootloader of size %d\n", bootloader_sectors, boot_stat.st_size);

	floppy_img_t floppy;
	memset(&floppy,0,sizeof(floppy_img_t));

	int i=0;
	int c=0;
	int trk=0;
	for(i=0; i < FLOPPY_88DCDD_SPT; i++) {
		for(trk=0; trk < FLOPPY_88DCDD_RESERVED_TRACKS; trk++) {
			floppy.boot_tracks[trk].sectors[i].sync_byte = 0xFF;
		}
		for(trk=0; trk < FLOPPY_88DCDD_TPD - FLOPPY_88DCDD_RESERVED_TRACKS; trk++) {
			floppy.data_tracks[trk].sectors[i].sync_byte = 0xFF;
		}
	}
	trk = 0;
	int s =0;
	size_t file_size = (uint16_t)boot_stat.st_size;
	for(i=0; i<bootloader_sectors; i++) {
		//		if(i > (FLOPPY_88DCDD_MAX_BOOTLEN / 2 / 128)) trk++;
		size_t ret = fread(&(floppy.boot_tracks[trk].sectors[s].payload),1,FLOPPY_88DCDD_PAYLOAD_LEN,bootloader_fd);
		floppy.boot_tracks[trk].sectors[s].file_size = file_size;
		floppy.boot_tracks[trk].sectors[s].checksum_byte = 0x00;
		for(c=0; c<FLOPPY_88DCDD_PAYLOAD_LEN; c++) floppy.boot_tracks[trk].sectors[s].checksum_byte+=floppy.boot_tracks[trk].sectors[s].payload[c];
		s += 2;
	}

	fclose(bootloader_fd);
	write(1, &floppy, sizeof(floppy_img_t));
}
