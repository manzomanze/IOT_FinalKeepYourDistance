#include "Timer.h"
#include "Final.h"
#include "printf.h"
#include <string.h>

module FinalC {
	uses {
		interface Boot;
		interface SplitControl;
		interface Packet;
    	interface AMSend;
    	interface Receive;
    	interface Timer<TMilli> as MilliTimer;
  	}
}

implementation {
  
	message_t packet; 
	
	void sendMsg();
  	
  	void sendMsg() {
	  	my_msg_t* mess = (my_msg_t*)(call Packet.getPayload(&packet, sizeof(my_msg_t)));
		if (mess == NULL) { return; }
		mess->data = rand()%100;
		mess->id = TOS_NODE_ID;
		if(call AMSend.send(AM_BROADCAST_ADDR, &packet,sizeof(my_msg_t)) == SUCCESS){
			dbg("radio_pack","Sending message from %u to AM_BROADCAST_ADDR\n", TOS_NODE_ID);
		}	  
	}

	event void Boot.booted() {
      	dbg("boot","Application booted on node %u.\n", TOS_NODE_ID);
      	call SplitControl.start();
      	call PrintfControl.start();
  	}

  	event void PrintfControl.startDone(error_t error) {
  		printf("Hi I am writing to you from my TinyOS application!!\n");
  		call PrintfFlush.flush();
  	}

  	event void PrintfFlush.flushDone(error_t error) {
  		
  	}

  	event void SplitControl.startDone(error_t err){
    	if(err == SUCCESS) {
    		dbg("radio", "Radio on!\n");
    	    call MilliTimer.startPeriodic(500); 
    	    
    	}
  	}
  
	event void SplitControl.stopDone(error_t err){ }

	event void MilliTimer.fired() {
		dbg("timer","Timer fired at %s.\n", sim_time_string());
		sendMsg();

  	}
  
	event void AMSend.sendDone(message_t* buf, error_t error) {
	    if(&packet == buf && error == SUCCESS){
	    	dbg("radio_send", "Packet sent at time %s \n", sim_time_string());
	    } else { 
	    	dbgerror("radio_send", "Send done error!"); 
	    }
	}
	// 	Function to receive messages from other motes we must save the ID and forward an alert to Nodered with the ID
	event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {	
		if (len != sizeof(my_msg_t)) { 
			//error in Packet reception
			return bufPtr; 
		} else {
		  my_msg_t* mess = (my_msg_t*)payload;	  
		  dbg("radio_rec", "Received packet at time %s\n", sim_time_string());
		  dbg("radio_pack", "data: %hhu \n", mess->data); 
		  dbg("radio_pack", "from node: %u \n", mess->id);
		  printfflush();
		  printf("coming from node: %u\n",mess->id);
		  printfflush();
		  return bufPtr;
		}
		{ dbgerror("radio_rec", "Receiving error \n"); }
  	}

}


