#ifndef FINAL_H
#define FINAL_H

typedef nx_struct my_msg {
  nx_uint16_t id;
} my_msg_t;
typedef nx_struct IDsNode_t {
	nx_uint16_t id;
	IDsNode_t* next;
} struct IDsNode_t;

enum {
  AM_MY_MSG = 6,
};

#endif
