#ifndef FINAL_H
#define FINAL_H

typedef nx_struct my_msg {
  nx_uint16_t data;
  nx_uint16_t id;
} my_msg_t;

enum {
  AM_MY_MSG = 6,
};

#endif
