#include "types.h"

#define VBUF_BASE       ((u8*)0xB8000)
#define VBUF_WIDTH      (80)
#define VBUF_HEIGHT     (25)
#define VBUF_LINE_WIDTH (VBUF_WIDTH*2)
#define VBUF_LAST_LINE  (VBUF_BASE + VBUF_LINE_WIDTH * (VBUF_HEIGHT-1))
#define VBUF_LEN        (VBUF_LINE_WIDTH * VBUF_HEIGHT)

static u8* vptr = VBUF_BASE;

u32 fk_tmp_voffset(u8* vptr) {
    return (u32)(vptr - VBUF_BASE) % VBUF_LINE_WIDTH;
}

void fk_tmp_cls() {
    u8* vptr = VBUF_BASE;
    for (int i=0; i<VBUF_LEN; ++i) {
        vptr[i] = 0;
    }
}

void fk_tmp_scroll() {
    u8* vptr = VBUF_BASE;
    for (int i=0; i<VBUF_HEIGHT-1; ++i) {
        u8* next_line = vptr + VBUF_LINE_WIDTH;
        for (int j=0; j<VBUF_LINE_WIDTH; ++j) {
            vptr[j] = next_line[j];
        }
        vptr = next_line;
    }
    for (u8* last=VBUF_LAST_LINE; last<VBUF_BASE+VBUF_LEN; ++last) {
        *last = 0;
    }
}


void fk_tmp_print(char const* str) {
    for (;*str != '\0';) {
        if (*str == '\n') {
            vptr += (VBUF_LINE_WIDTH - fk_tmp_voffset(vptr));
        }
        if ((int)(vptr-VBUF_BASE) >= VBUF_LEN) {
            fk_tmp_scroll();
            vptr = VBUF_LAST_LINE;
        }
        if (*str == '\n') {
            ++str;
            continue;
        }
        *vptr++ = *str++;
        *vptr++ = 0x07;
    }
}

void fk_tmp_println(char const* str) {
    fk_tmp_print(str);
    int line = (int)(vptr-VBUF_BASE) / VBUF_LINE_WIDTH + 1;
    if (fk_tmp_voffset(vptr) != 0) {
        vptr = VBUF_BASE + line * VBUF_LINE_WIDTH;
    }
}

void fk_entry() {
    fk_tmp_cls();
    fk_tmp_println(" _____\n|   __| _ _  ___ .?. _ _\n|   __|| | ||   || ||_\'_|\n|__|   |___||_|_||_||_,_|  v0.0.1");
}

